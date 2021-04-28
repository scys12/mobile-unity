import 'dart:async';

import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mobile_unity/src/models/child.dart';
import 'package:mobile_unity/src/models/teenager.dart';
import 'package:mobile_unity/src/provider/wish_provider.dart';
import 'package:mobile_unity/src/services/child_database.dart';
import 'package:mobile_unity/src/services/financial_database.dart';
import 'package:mobile_unity/src/services/teenager_database.dart';
import 'package:mobile_unity/src/services/wish_database.dart';
import 'package:mobile_unity/src/shared/alert_dialog.dart';
import 'package:mobile_unity/src/shared/constants.dart';
import 'package:mobile_unity/src/widgets/app_bar.dart';
import 'package:mobile_unity/src/widgets/loading.dart';
import 'package:provider/provider.dart';

class ReminderTeenager extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _State();
  }
}

class _State extends State<ReminderTeenager> {
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _lainnyaController = TextEditingController();
  WishProvider _wishProvider;

  var _amount = "";
  var _dropDownReminderValue;
  var _dropDownReminderState = "";
  var _dropDownFrequencyValue;
  var _dropDownFrequencyState = "";
  var _detail = "";
  bool _loading = false;
  Teenager _user;
  bool _loadingWish = true;
  List<String> choicesText = [
    "Berapa pemasukan yang kamu ingin targetkan ? ",
    "Berapa pengeluaran yang kamu ingin batasi ?"
  ];

  Map<String, String> choicesFrequency = {
    "hari": "Diingatkan tiap hari",
    "minggu": "Diingatkan tiap minggu",
    "bulan": "Diingatkan tiap bulan",
  };

  List<String> choicesReminder = [
    "Pemasukan",
    "Pengeluaran"
  ];

  @override
  void initState() {
    super.initState();
    _user = Provider.of<Teenager>(context, listen: false);
    _wishProvider = Provider.of<WishProvider>(context, listen: false);
    _wishProvider.getWishes(childId: _user.uid);
  }

  @override
  Widget build(BuildContext context) {
    _wishProvider = Provider.of<WishProvider>(context);
    _loadingWish = _wishProvider.wishes != null ? false : true;
    return _loadingWish ? Loading() : Scaffold(
      appBar: CustomAppBar(true, "Reminder Baru"),
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
                      'Kamu ingin diingatkan apa?',
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
                          items: choicesReminder.map((String value) {
                            return new DropdownMenuItem<String>(
                              value: value,
                              child: new Text(value),
                            );
                          }).toList(),
                          value: _dropDownReminderValue,
                          onChanged: (value) {
                            setState(() {
                              _dropDownReminderState = value;
                              _dropDownReminderValue = value;
                            });
                          },
                          hint: Text("Pilih salah satu", style: TextStyle(
                              color: shadowColor,
                              fontWeight: FontWeight.w700
                          ),),
                        ),
                      ),
                    ),
                  ),
                  (_dropDownReminderState != "")
                      ? Bubble(
                    margin: BubbleEdges.only(top: 20),
                    padding: BubbleEdges.only(left: 20.0, right: 25.0, top: 20.0, bottom: 20.0),

                    alignment: Alignment.topLeft,
                    nip: BubbleNip.leftTop,
                    child: Text(
                      _dropDownReminderState == "Pemasukan" ? choicesText[0] : choicesText[1],
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          fontSize: 18.0,
                          color: Colors.white),
                    ),
                    color: secondaryColor,
                  )
                      : Container(),
                  (_dropDownReminderState != "")
                      ? Bubble(
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
                  )
                      : Container(),
                  (_amount != "")
                      ? Bubble(
                    margin: BubbleEdges.only(top: 20),
                    padding: BubbleEdges.only(left: 20.0, right: 25.0, top: 20.0, bottom: 20.0),

                    alignment: Alignment.topLeft,
                    nip: BubbleNip.leftTop,
                    child: Text(
                      'Seberapa sering kamu ingin diingatkan',
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
                          items: choicesFrequency.map((key, value) {
                            return MapEntry(key, DropdownMenuItem<String>(
                              value: value,
                              child: new Text(value),
                            ));
                          }).values.toList(),
                          value: _dropDownFrequencyValue,
                          onChanged: (value) {
                            setState(() {
                              _dropDownFrequencyValue = value;
                              _dropDownFrequencyState = choicesFrequency.keys.firstWhere((element) => choicesFrequency[element] == _dropDownFrequencyValue, orElse: null);
                            });
                          },
                          hint: Text("Pilih salah satu", style: TextStyle(
                              color: shadowColor,
                              fontWeight: FontWeight.w700
                          ),),
                        ),
                      ),
                    ),
                  ) : Container(),
                  SizedBox(height: 40.0,),
                  (_dropDownFrequencyState != "")
                      ? ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        _loading = true;
                      });
                      if(_loading) createLoadingAlertDialog(context);

                      Map<String, dynamic> childData = {
                      };
                      if (_dropDownReminderState == "Pemasukan") {
                        childData["income_money"] = int.parse(_amount);
                        childData["income_date"] = DateTime.now();
                        if (_dropDownFrequencyState == "hari") {
                          childData["income_frekuensi"] = 1;
                        }else if (_dropDownFrequencyState == "minggu") {
                          childData["income_frekuensi"] = 2;
                        }else {
                          childData["income_frekuensi"] = 3;
                        }
                      }else{
                        childData["outcome_money"] = int.parse(_amount);
                        childData["outcome_date"] = DateTime.now();
                        if (_dropDownFrequencyState == "hari") {
                          childData["outcome_frekuensi"] = 1;
                        }else if (_dropDownFrequencyState == "minggu") {
                          childData["outcome_frekuensi"] = 2;
                        }else {
                          childData["outcome_frekuensi"] = 3;
                        }
                      }
                      await TeenagerDatabase(uid: _user.uid).updateTeenagerData(childData);
                      Navigator.pop(context);
                      Navigator.pushReplacementNamed(context, '/teenager/wrapper');
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
