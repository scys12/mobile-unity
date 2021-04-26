import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:mobile_unity/src/models/child.dart';
import 'package:mobile_unity/src/models/teenager.dart';
import 'package:mobile_unity/src/services/child_database.dart';
import 'package:mobile_unity/src/services/financial_database.dart';
import 'package:mobile_unity/src/services/wish_database.dart';
import 'package:mobile_unity/src/shared/alert_dialog.dart';
import 'package:mobile_unity/src/shared/constants.dart';
import 'package:mobile_unity/src/widgets/app_bar.dart';
import 'package:mobile_unity/src/widgets/custom_picker.dart';
import 'package:provider/provider.dart';

class AddWishTeenager extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _State();
  }
}

class _State extends State<AddWishTeenager> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int _value = 0;
  DateTime _date;
  final _deadlineController = TextEditingController();
  final _pointController = TextEditingController();
  final _amountController = TextEditingController();
  final _titleController = TextEditingController();

  var _amount = "";
  var _title = "";
  var _dropDownValue;
  var _dropDownState = "";
  var _expectedMoney = "";
  bool _loading = false;

  Map<String, String> choices = {
    "hari": "Menabung tiap hari",
    "minggu": "Menabung tiap minggu",
    "bulan": "Menabung tiap bulan",
  };

  @override
  Widget build(BuildContext context) {
    Teenager user = Provider.of<Teenager>(context);
    return Scaffold(
      appBar: CustomAppBar(true, "Impian Baru"),
      body: ListView(
        children: [
          Container(
            margin: EdgeInsets.only(left: 30, right: 30, top: 20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Bubble(
                    margin: BubbleEdges.only(top: 20),
                    padding: BubbleEdges.only(left: 20.0, right: 25.0, top: 20.0, bottom: 20.0),

                    alignment: Alignment.topLeft,
                    nip: BubbleNip.leftTop,
                    child: Text(
                      'Impian apa yang kamu inginkan sekarang?',
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
                          _title = text;
                        });
                      },
                      controller: _titleController,
                      decoration: InputDecoration(
                        hintText: "Tulis impian kamu disini",
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
                  (_title != "")
                      ? Bubble(
                    margin: BubbleEdges.only(top: 20),
                    padding: BubbleEdges.only(left: 20.0, right: 25.0, top: 20.0, bottom: 20.0),

                    alignment: Alignment.topLeft,
                    nip: BubbleNip.leftTop,
                    child: Text(
                      'Berapa harga impianmu?',
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          fontSize: 18.0,
                          color: Colors.white),
                    ),
                    color: secondaryColor,
                  ) : Container(),
                  (_title != "") ? Bubble(
                    margin: BubbleEdges.only(top: 20),
                    color: textFieldColor,
                    nip: BubbleNip.rightTop,
                    child: TextField(
                      onChanged: (text) {
                        setState(() {
                          _amount = text;
                          _value = 0;
                        });
                      },
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      ],
                      controller: _amountController,
                      decoration: InputDecoration(
                        hintText: "Rp. Masukkan harga impianmu",
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
                  ) : Container(),
                  (_amount != "")
                      ? Bubble(
                    margin: BubbleEdges.only(top: 20),
                    padding: BubbleEdges.only(left: 20.0, right: 25.0, top: 20.0, bottom: 20.0),

                    alignment: Alignment.topLeft,
                    nip: BubbleNip.leftTop,
                    child: Text(
                      'Sesering apakah kamu ingin menabung?',
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
                          items: choices.map((key, value) {
                            return MapEntry(key, DropdownMenuItem<String>(
                              value: value,
                              child: new Text(value),
                            ));
                          }).values.toList(),
                          value: _dropDownValue,
                          onChanged: (value) {
                            setState(() {
                              _dropDownValue = value;
                              _dropDownState = choices.keys.firstWhere((element) => choices[element] == _dropDownValue, orElse: null);
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
                  (_dropDownValue != null && _dropDownValue != "")
                      ? Bubble(
                    margin: BubbleEdges.only(top: 20),
                    padding: BubbleEdges.only(left: 20.0, right: 25.0, top: 20.0, bottom: 20.0),

                    alignment: Alignment.topLeft,
                    nip: BubbleNip.leftTop,
                    child: Text(
                      'Berapa uang yang akan kamu tabung setiap ${_dropDownState}',
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          fontSize: 18.0,
                          color: Colors.white),
                    ),
                    color: secondaryColor,
                  )
                      : Container(),
                  SizedBox(height: 40.0,),
                  (_amount != "" && (_dropDownValue != null && _dropDownValue != "")) ? _buildPointField() : Container(),
                  SizedBox(height: 5.0,),
                  (_amount != "" && (_dropDownValue != null && _dropDownValue != "")) ? _buildSliderPoint() : Container(),
                  SizedBox(height: 25.0,),
                  (_value > 0)
                      ? Bubble(
                    margin: BubbleEdges.only(top: 20),
                    padding: BubbleEdges.only(left: 20.0, right: 25.0, top: 20.0, bottom: 20.0),

                    alignment: Alignment.topLeft,
                    nip: BubbleNip.leftTop,
                    child: Text(
                      'Sampai kapan kamu ingin menabung?',
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          fontSize: 18.0,
                          color: Colors.white),
                    ),
                    color: secondaryColor,
                  )
                      : Container(),
                  SizedBox(height: 25.0,),
                  (_value > 0 )
                      ? _buildDeadlineField()
                      : Container(),
                  SizedBox(height: 35.0,),
                  (_deadlineController.text != "")
                      ? ElevatedButton(
                    onPressed: () async {
                      setState(() {
                        _loading = true;
                      });
                      if(_loading) createLoadingAlertDialog(context);
                      var frekuensi = _dropDownState == "hari" ? 0 : _dropDownState == "bulan" ? 1 : 2;
                      var data = {
                        "frekuensi" : frekuensi,
                        "child_id" : user.uid,
                        "created_at" : DateTime.now(),
                        "current_money" : 0,
                        "is_done" : false,
                        "title" : _title,
                        "target" : int.parse(_amount),
                        "point" : 5,
                        "expected_money" : _value,
                        "deadline" : DateTime(_date.year, _date.month, _date.day, 23, 59, 59),
                      };
                      await WishDatabase().createWish(data);
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
                      : Container(),
                  SizedBox(height: 25.0,),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPointField(){
    return TextFormField(
      textInputAction: TextInputAction.search,
      style: TextStyle(
        fontSize: 18.0,
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
        hintText: 'Hadiah',
        hintStyle: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.w500,
          color: shadowColor,
          fontFamily: 'Poppins',
        ),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        prefixIcon: Icon(Icons.card_giftcard, color: shadowColor,),
      ),
      enabled: false,
      controller: _pointController..text="Rp ${_value.toString()}",
      validator:  (value) {
        if (value == null || value.isEmpty) {
          return 'Point masih kosong';
        }
        return null;
      },
    );
  }
  Widget _buildSliderPoint(){
    return Slider(
      activeColor: secondaryColor,
      inactiveColor: thirdColor,
      min: 0.0,
      divisions: updateDiv(),
      max: int.parse(_amount).toDouble(),
      value: _value.toDouble(),
      onChanged: (val) {
        setState(() => _value = val.toInt());
        _pointController.text = _value.toString();
      },
    );
  }

  int updateDiv(){
    var res = (int.parse(_amount)/500).round();
    if (res == 0) {
      res = 1;
    }
    return res;
  }

  Widget _buildDeadlineField() {
    return TextFormField(
      onTap: (){
        DatePicker.showPicker(context, showTitleActions: true, onChanged: (date) {
          setState(() {
            _date = date;
            _deadlineController.text = DateFormat("dd-MM-yyyy").format(_date).toString();
          });
        }, onConfirm: (date) {
          setState(() {
            _date = date;
            _deadlineController.text = DateFormat("dd-MM-yyyy").format(_date).toString();
          });
        }, pickerModel: CustomPicker(currentTime: DateTime.now()), locale: LocaleType.en);
      },
      readOnly: true,
      style: TextStyle(
        fontSize: 18.0,
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
        hintText: 'Batas',
        hintStyle: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.w500,
          color: shadowColor,
          fontFamily: 'Poppins',
        ),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        prefixIcon: Icon(Icons.schedule, color: shadowColor,),
        suffixIcon: Icon(Icons.arrow_drop_down, color: shadowColor,),
      ),
      validator: (value) => value.isEmpty || value == null ? 'Deadline masih kosong' : null,
      controller: _deadlineController,
    );
  }
}
