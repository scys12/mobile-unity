import 'dart:async';

import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mobile_unity/src/models/challenge.dart';
import 'package:mobile_unity/src/models/child.dart';
import 'package:mobile_unity/src/models/financial.dart';
import 'package:mobile_unity/src/models/teenager.dart';
import 'package:mobile_unity/src/provider/challenge_provider.dart';
import 'package:mobile_unity/src/provider/finance_provider.dart';
import 'package:mobile_unity/src/provider/wish_provider.dart';
import 'package:mobile_unity/src/services/challenge_database.dart';
import 'package:mobile_unity/src/services/child_database.dart';
import 'package:mobile_unity/src/services/financial_database.dart';
import 'package:mobile_unity/src/services/teenager_database.dart';
import 'package:mobile_unity/src/services/wish_database.dart';
import 'package:mobile_unity/src/shared/alert_dialog.dart';
import 'package:mobile_unity/src/shared/constants.dart';
import 'package:mobile_unity/src/widgets/app_bar.dart';
import 'package:mobile_unity/src/widgets/loading.dart';
import 'package:provider/provider.dart';

class InnerIncomeTeenager extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _State();
  }
}

class _State extends State<InnerIncomeTeenager> {
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _lainnyaController = TextEditingController();
  WishProvider _wishProvider;

  var _amount = "";
  var _dropDownValue;
  var _dropDownState = "";
  var _dropDownLainnyaState = "";
  var _detail = "";
  bool _loading = false;
  Teenager _user;
  bool _loadingWish = true;
  List<String> choices = [
    "Uang saku",
    "Lainnya"
  ];

  FinancialProvider _financialProvider;
  List<Financial> financials = [];
  List<Financial> _filteredFinancials = [];
  int _income = 0;
  int _outcome = 0;
  ChallengeProvider _challengeProvider;

  List<Financial> filterFinancial(){
    List<Financial> filtered = [];
    var now = DateTime.now();
    var startDate = now.subtract(Duration(days: 6));
    filtered = financials.where((element) => (startDate.difference(element.createdAt).inDays <=0 && startDate.difference(element.createdAt).inDays >=-5)).toList();
    return filtered;
  }

  @override
  void initState() {
    super.initState();
    initData();
  }

  initData() async {
    _user = Provider.of<Teenager>(context, listen: false);
    _wishProvider = Provider.of<WishProvider>(context, listen: false);
    _wishProvider.getWishes(childId: _user.uid);
    _challengeProvider = Provider.of<ChallengeProvider>(context, listen: false);
    await _challengeProvider.getUserChallenge(userId: _user.uid);
  }

  @override
  Widget build(BuildContext context) {
    _challengeProvider = Provider.of<ChallengeProvider>(context);
    _wishProvider = Provider.of<WishProvider>(context);
    _financialProvider = Provider.of<FinancialProvider>(context);
    _loadingWish = _wishProvider.wishes != null && _challengeProvider.challenges != null ? false : true;
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
                      'Berapa uang yang kamu dapat hari ini?',
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
                      'Darimana uangnya?',
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
                        "type" : "income",
                        "title" : _title,
                      };
                      await FinancialDatabase().createFinancial(data);

                      Map<String, dynamic> childData = {
                        "income" : _user.income + int.parse(_amount),
                      };
                      int countFinishedChallenge = await ChallengeDatabase().countFinishedChallenge(_user.uid);
                      if (countFinishedChallenge <= 3) {
                        await _financialProvider.getFinancialBasedChildId(childId: _user.uid);
                        financials = _financialProvider.financials;
                        financials.forEach((element) {print(element.createdAt.day);});
                        _filteredFinancials = filterFinancial();
                        Set<int> date = {};
                        _filteredFinancials.forEach((element) {
                          date.add(element.createdAt.day);
                        });
                        print(date);
                        if (date.length == 7) {
                          var tabungChallenges = _challengeProvider.challenges.where((element) => element.key == "tabung").toList();
                          var kumpulChallenges = _challengeProvider.challenges.where((element) => element.key == "kumpul").toList();

                          _outcome = _countIncomeOutcome("outcome", _filteredFinancials);
                          _income = _countIncomeOutcome("income", _filteredFinancials);

                          Map<String, dynamic> challenge = {
                            "isDone": true,
                          };

                          if (tabungChallenges.length > 0) {
                            await ChallengeDatabase(uid: tabungChallenges[0].uid).updateChallenge(challenge);
                          }
                          if (_income - _outcome >= 100000 && kumpulChallenges.length > 0) {
                            await ChallengeDatabase(uid: kumpulChallenges[0].uid).updateChallenge(challenge);
                          }
                        }
                        childData["achievements"] = _user.achievements;
                        countFinishedChallenge == 1
                            ? childData["achievements"][0] = true
                            : countFinishedChallenge == 2
                            ? childData["achievements"][2] = true
                            : countFinishedChallenge >= 3
                            ? childData["achievements"][4] = true
                            : childData["achievements"] = _user.achievements;
                      }
                      var wishes = _wishProvider.wishes.where((element) => !element.isDone && element.deadline.difference(DateTime.now()).inDays >= 0);
                      var returnContext = false;
                      if(wishes.length > 0) {
                        var wish = wishes.first;
                        Map<String, dynamic> wishData = {
                          "current_money" : wish.currentMoney + int.parse(_amount)
                        };
                        await WishDatabase(uid: wish.uid).updateWish(wishData);
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

  int _countIncomeOutcome(String type, List<Financial> finances){
    return finances.where((element) => element.type == type).toList().fold(0, (previous, current) => previous + current.money);
  }
}
