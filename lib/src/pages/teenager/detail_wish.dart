import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_unity/src/models/child.dart';
import 'package:mobile_unity/src/models/teenager.dart';
import 'package:mobile_unity/src/provider/child_provider.dart';
import 'package:mobile_unity/src/provider/task_provider.dart';
import 'package:mobile_unity/src/provider/wish_provider.dart';
import 'package:mobile_unity/src/services/child_database.dart';
import 'package:mobile_unity/src/services/teenager_database.dart';
import 'package:mobile_unity/src/services/wish_database.dart';
import 'package:mobile_unity/src/shared/alert_dialog.dart';
import 'package:mobile_unity/src/shared/constants.dart';
import 'package:mobile_unity/src/widgets/app_bar.dart';
import 'package:mobile_unity/src/widgets/loading.dart';
import 'package:mobile_unity/src/widgets/sub_header.dart';
import 'package:provider/provider.dart';

class DetailWishTeenager extends StatefulWidget {
  final String wishId;
  DetailWishTeenager({this.wishId});
  @override
  _DetailWishTeenagerState createState() => _DetailWishTeenagerState();
}

class _DetailWishTeenagerState extends State<DetailWishTeenager> {
  WishProvider _wishProvider;
  Teenager _user;
  bool _loading = true;
  List<String> frekuensi = [
    'Setiap Hari',
    'Setiap Minggu',
    'Setiap Bulan',
  ];

  @override
  void initState() {
    super.initState();
    _user = Provider.of<Teenager>(context, listen: false);
    _wishProvider = Provider.of(context, listen: false);
    _wishProvider.getWish(wishId: widget.wishId);
  }

  @override
  Widget build(BuildContext context) {
    _wishProvider =  Provider.of<WishProvider>(context);
    if (_wishProvider.selectedWish != null && _wishProvider.selectedWish.uid == widget.wishId) {
      setState(() {
        _loading = false;
      });
    }
    return _loading ? Loading() : Scaffold(
      appBar: CustomAppBar(true, "Detail Impian"),
      body: ListView(
        physics: ClampingScrollPhysics(),
        padding: EdgeInsets.all(30.0),
        children: [
          Form(
            child: Column(
              children: [
                _buildChildProfile(),
                _buildTitleField(),
                SizedBox(height: 20.0,),
                _buildStatusField(),
                _buildDeadlineField(),
                _buildPointField(),
                _buildFrekuensiField(),
                SizedBox(height: 20.0,),
                _buildExpectedMoneyField(),
                SizedBox(height: 20.0,),
                Divider(color: shadowColor, thickness: 1.0,),
                SizedBox(height: 20.0,),
                SubHeader(title: "Progress", isLihatSemua: false,),
                SizedBox(height: 20.0,),
                _buildProgress(),
                SizedBox(height: 20.0,),
                _wishProvider.selectedWish.currentMoney >= _wishProvider.selectedWish.target && !_wishProvider.selectedWish.isDone ? Container(child: _buildFinishedButton(), width: double.infinity,) : Container()
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinishedButton(){
    return TextButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(primaryColor),
      ),
      onPressed: () async{
        Map<String, dynamic> wishData = {
          "is_done" : true
        };
        await WishDatabase(uid: _wishProvider.selectedWish.uid).updateWish(wishData);
        Map<String, dynamic> teenagerData = {
          "total_point" : _user.totalPoint + _wishProvider.selectedWish.point,
          "achievements" : _user.achievements,
        };
        var totalWish = await WishDatabase().countFinishedWish(_user.uid);
        if (totalWish >= 1) {
          teenagerData["achievements"][1] = true;
        }
        if (totalWish >= 5) {
          teenagerData["achievements"][3] = true;
        }
        if (totalWish >= 15) {
          teenagerData["achievements"][5] = true;
        }
        await TeenagerDatabase(uid: _user.uid).updateTeenagerData(teenagerData);
        successMessage(context, "Selamat harapan kamu sudah terkabul");
        Timer(Duration(seconds: 1), () {
          Navigator.pop(context);
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DetailWishTeenager(wishId: widget.wishId,)));
        });
      },
      child: Text("Selesaikan impian!", style: TextStyle(
        color: Colors.white,
        fontFamily: "Poppins",
        fontSize: 15.0
      ),),
    );
  }

  Widget _buildProgress(){
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: LinearProgressIndicator(
            minHeight: 5.0,
            backgroundColor: thirdColor,
            valueColor: AlwaysStoppedAnimation<Color>(secondaryColor),
            value: _wishProvider.selectedWish.currentMoney/_wishProvider.selectedWish.target,
          ),
        ),
        SizedBox(height: 8.0,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Rp ${_wishProvider.selectedWish.currentMoney}",
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                  fontSize: 13.0
              ),
            ),
            Text(
              "Rp ${_wishProvider.selectedWish.target}",
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Poppins',
                  fontSize: 13.0
              ),
            ),
          ],
        )
      ],
    );
  }

  Widget _buildStatusField(){
    var isFinished;
    if (_wishProvider.selectedWish.deadline.difference(DateTime.now()).inDays < 0 && !_wishProvider.selectedWish.isDone) isFinished = 0;
    else if (_wishProvider.selectedWish.isDone) isFinished = 1;
    else isFinished = 2;
    return Container(
      decoration: BoxDecoration(
        color: isFinished == 1 ? greenColor : isFinished == 0 ? redColor : primaryColor,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: ListTile(
        leading: Icon(Icons.star, color: Colors.white),
        title: Text(
          isFinished == 1 ? "Sudah Terkabul" : isFinished == 0 ? "Belum Terkabul" : "Masih diwujudkan",
          style: TextStyle(
              fontSize: 18.0,
              color: Colors.white,
              fontFamily: "Poppins",
              fontWeight: FontWeight.w600
          ),
        ),
      ),
    );
  }

  Widget _buildChildProfile(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          "Nama Impian",
          style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 20.0,
              color: shadowColor,
              fontWeight: FontWeight.w700
          ),
        ),
      ],
    );
  }

  Widget _buildPointField(){
    return ListTile(
      leading: Icon(Icons.card_giftcard, color: shadowColor,),
      title: Text(
        "Hadiah",
        style: TextStyle(
            fontSize: 18.0,
            color: shadowColor,
            fontFamily: "Poppins",
            fontWeight: FontWeight.w600
        ),
      ),
      trailing: Text(
        "${_wishProvider.selectedWish.point}pts",
        style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: 17.0
        ),
      ),
    );
  }

  Widget _buildFrekuensiField(){
    return ListTile(
      leading: Icon(Icons.timeline, color: shadowColor,),
      title: Text(
        "Lama Menabung",
        style: TextStyle(
            fontSize: 18.0,
            color: shadowColor,
            fontFamily: "Poppins",
            fontWeight: FontWeight.w600
        ),
      ),
      trailing: Text(
        frekuensi[_wishProvider.selectedWish.frekuensi],
        style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: 17.0
        ),
      ),
    );
  }

  Widget _buildExpectedMoneyField(){
    return ListTile(
      leading: Icon(Icons.attach_money, color: shadowColor,),
      title: Text(
        "Jumlah Yang Ingin Ditabung",
        style: TextStyle(
            fontSize: 18.0,
            color: shadowColor,
            fontFamily: "Poppins",
            fontWeight: FontWeight.w600
        ),
      ),
      trailing: Text(
        "Rp ${_wishProvider.selectedWish.expectedMoney}",
        style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: 17.0
        ),
      ),
    );
  }

  Widget _buildTitleField(){
    return TextFormField(
      style: TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.w600,
        fontFamily: 'Poppins',
      ),
      cursorColor: secondaryColor,
      decoration: InputDecoration(
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                  color: shadowColor,
                  width: 2.0
              )
          ),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                  color: secondaryColor,
                  width: 2.0
              )
          ),
          floatingLabelBehavior: FloatingLabelBehavior.never
      ),
      enabled: false,
      initialValue: _wishProvider.selectedWish.title,
      validator: (value) => value.isEmpty ? 'Name is required' : '',
    );
  }

  Widget _buildDeadlineField() {
    return ListTile(
      leading: Icon(Icons.schedule, color: shadowColor,),
      title: Text(
        "Batas Waktu Impian",
        style: TextStyle(
            fontSize: 18.0,
            color: shadowColor,
            fontFamily: "Poppins",
            fontWeight: FontWeight.w600
        ),
      ),
      trailing: Text(
        DateFormat("dd MMMM yyyy").format(_wishProvider.selectedWish.deadline).toString(),
        style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: 17.0
        ),
      ),
    );
  }
}
