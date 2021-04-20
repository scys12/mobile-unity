import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mobile_unity/src/models/child.dart';
import 'package:mobile_unity/src/provider/wish_provider.dart';
import 'package:mobile_unity/src/services/child_database.dart';
import 'package:mobile_unity/src/services/financial_database.dart';
import 'package:mobile_unity/src/services/wish_database.dart';
import 'package:mobile_unity/src/shared/alert_dialog.dart';
import 'package:mobile_unity/src/shared/constants.dart';
import 'package:mobile_unity/src/widgets/app_bar.dart';
import 'package:mobile_unity/src/widgets/loading.dart';
import 'package:provider/provider.dart';

class InnerOutcome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _State();
  }
}

class _State extends State<InnerOutcome> {
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _lainnyaController = TextEditingController();
  WishProvider _wishProvider;
  Child _user;
  bool _loadingWish = true;
  var _amount = "";
  var _dropDownValue;
  var _dropDownState = "";
  var _dropDownLainnyaState = "";
  var _detail = "";
  bool _loading = false;

  List<String> choices = [
    "Makanan & Minuman",
    "Belanja",
    "Berkendara",
    "Lainnya"
  ];

  @override
  void initState() {
    super.initState();
    _user = Provider.of<Child>(context, listen: false);
    _wishProvider = Provider.of<WishProvider>(context, listen: false);
    _wishProvider.getWishes(childId: _user.uid);
  }

  @override
  Widget build(BuildContext context) {
    _wishProvider = Provider.of<WishProvider>(context);
    _loadingWish = _wishProvider.wishes != null ? false : true;
    return _loadingWish ? Loading() : Scaffold(
      appBar: CustomAppBar(true, "Pemasukan Baru"),
      body: ListView(
        children: [
          Container(
            margin: EdgeInsets.only(left: 30, right: 30, top: 20),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Bubble(
                    margin: BubbleEdges.only(top: 20),
                    padding: BubbleEdges.only(left: 20.0, right: 25.0, top: 20.0, bottom: 20.0),

                    alignment: Alignment.topLeft,
                    nip: BubbleNip.leftTop,
                    child: Text(
                      'Berapa uang yang kamu keluarkan hari ini ?',
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          fontSize: 18.0,
                          color: Colors.white),
                    ),
                    color: secondaryColor,
                  ),
                  Bubble(
                    margin: BubbleEdges.only(top: 20),
                    color: textFieldColor,
                    nip: BubbleNip.rightTop,
                    child: TextField(
                      onChanged: (text) {
                        setState(() {
                          _amount = text;
                        });
                      },
                      keyboardType: TextInputType.number,
                      controller: _amountController,
                      decoration: InputDecoration(
                        hintText: "Rp. Masukkan Jumlah Uang",
                        hintStyle: TextStyle(
                          color: shadowColor,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                        ),
                        focusColor: Colors.transparent,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.transparent,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.transparent,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.transparent,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                    ),
                  ),
                  (_amount != "")
                      ? Bubble(
                    margin: BubbleEdges.only(top: 20),
                    padding: BubbleEdges.only(left: 20.0, right: 25.0, top: 20.0, bottom: 20.0),

                    alignment: Alignment.topLeft,
                    nip: BubbleNip.leftTop,
                    child: Text(
                      'Untuk apa uangnya?',
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          fontSize: 18.0,
                          color: Colors.white),
                    ),
                    color: secondaryColor,
                  )
                      : Container(),
                  (_amount != "")
                      ? Bubble(
                    margin: BubbleEdges.only(top: 20),
                    padding: BubbleEdges.symmetric(horizontal: 20.0),
                    color: textFieldColor,
                    nip: BubbleNip.rightTop,
                    child: InputDecorator(
                      decoration: InputDecoration(
                        focusColor: Colors.transparent,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.transparent,
                          ),
                        ),
                        contentPadding: EdgeInsets.zero,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.transparent,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.transparent,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton(
                          isExpanded: true,
                          items: choices.map((String value) {
                            return new DropdownMenuItem<String>(
                              value: value,
                              child: new Text(value),
                            );
                          }).toList(),
                          value: _dropDownValue,
                          onChanged: (value) {
                            setState(() {
                              _dropDownState = value;
                              _dropDownValue = value;
                              if (_dropDownState != "Lainnya") {
                                _dropDownLainnyaState = "";
                                _lainnyaController.text = "";
                              }
                            });
                          },
                          hint: Text("Pilih salah satu", style: TextStyle(
                              color: shadowColor,
                              fontWeight: FontWeight.w700
                          ),),
                        ),
                      ),
                    ),
                  )
                      : Container(),
                  (_dropDownState == "Lainnya")
                      ? Bubble(
                    margin: BubbleEdges.only(top: 20),
                    padding: BubbleEdges.symmetric(horizontal: 20.0),
                    color: textFieldColor,
                    nip: BubbleNip.rightTop,
                    child: TextField(
                      controller: _lainnyaController,
                      onChanged: (text) {
                        setState(() {
                          _dropDownLainnyaState = text;
                        });
                      },
                      decoration: InputDecoration(
                        focusColor: Colors.transparent,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.transparent,
                          ),
                        ),
                        contentPadding: EdgeInsets.zero,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.transparent,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.transparent,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        hintText: "Yuk sebutkan alasan lainnya",
                        hintStyle: TextStyle(
                          color: shadowColor,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  )
                      : Container(),
                  ((_dropDownState != "Lainnya" && _dropDownState != "") || (_dropDownState == "Lainnya" && _dropDownLainnyaState != ""))
                      ? Bubble(
                    margin: BubbleEdges.only(top: 20),
                    padding: BubbleEdges.only(left: 20.0, right: 25.0, top: 20.0, bottom: 20.0),

                    alignment: Alignment.topLeft,
                    nip: BubbleNip.leftTop,
                    child: Text(
                      'Yuk beritahu lebih detail',
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          fontSize: 18.0,
                          color: Colors.white),
                    ),
                    color: secondaryColor,
                  )
                      : Container(),
                  ((_dropDownState != "Lainnya" && _dropDownState != "") || (_dropDownState == "Lainnya" && _dropDownLainnyaState != ""))
                      ? Bubble(
                    margin: BubbleEdges.only(top: 20),
                    padding: BubbleEdges.symmetric(horizontal: 20.0),
                    color: textFieldColor,
                    nip: BubbleNip.rightTop,
                    child: TextField(
                      controller: _descriptionController,
                      onChanged: (text) {
                        setState(() {
                          _detail = text;
                        });
                      },
                      decoration: InputDecoration(
                        focusColor: Colors.transparent,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.transparent,
                          ),
                        ),
                        contentPadding: EdgeInsets.zero,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.transparent,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.transparent,
                          ),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        hintText: "Masukkan detail",
                        hintStyle: TextStyle(
                          color: shadowColor,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  )
                      : Container(),
                  SizedBox(height: 40.0,),
                  (_detail != "")
                      ? ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        _loading = true;
                      });
                      if(_loading) createLoadingAlertDialog(context);

                      var _title = _dropDownState;
                      if (_dropDownState == "Lainnya") {
                        _title = _dropDownLainnyaState;
                      }
                      var data = {
                        "child_id" : _user.uid,
                        "created_at" : DateTime.now(),
                        "description" : _detail,
                        "money" : int.parse(_amount),
                        "type" : "outcome",
                        "title" : _title,
                      };
                      await FinancialDatabase().createFinancial(data);

                      var childData = {
                        "outcome" : _user.outcome + int.parse(_amount),
                      };
                      await ChildDatabase(uid: _user.uid).updateChildData(childData);
                      var wishes = _wishProvider.wishes.where((element) => !element.isDone && element.deadline.difference(DateTime.now()).inDays >= 0);
                      if(wishes.length > 0) {
                        var wish = wishes.first;
                        Map<String, dynamic> wishData = {
                          "current_money" : wish.currentMoney - int.parse(_amount)
                        };
                        wishData["current_money"] = wishData["current_money"] < 0 ? 0 : wishData["current_money"];
                        await WishDatabase(uid: wish.uid).updateWish(wishData);
                      }
                      Navigator.pop(context);
                      Navigator.pop(context, (route) => route.isFirst);
                    },
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                        EdgeInsets.symmetric(
                            horizontal: 20.0, vertical: 10.0),
                      ),
                      shape:
                      MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0)),
                      ),
                      elevation: MaterialStateProperty.all<double>(0.0),
                      backgroundColor:
                      MaterialStateProperty.all<Color>(secondaryColor),
                    ),
                    child: Container(
                      margin: EdgeInsets.all(10),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Simpan",
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                              fontSize: 15.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                      : Container()
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
