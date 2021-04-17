import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mobile_unity/src/pages/kid/components/bubble.dart';
import 'package:mobile_unity/src/shared/constants.dart';

class PengeluaranKid extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _State();
  }
}

class _State extends State<PengeluaranKid> {
  final _amountController = TextEditingController();
  final _descriptionController = TextEditingController();

  var _amount = "";
  var _dropDownValue;
  var _dropDownState = "";
  var _detail = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(left: 30, right: 30, top: 20),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Bubble(
                message: "Berapa uang yang kamu keluarkan hari ini?",
              ),
              Container(
                margin: EdgeInsets.fromLTRB(3, 15, 3, 15),
                child: TextField(
                  onChanged: (text) {
                    setState(() {
                      _amount = text;
                    });
                  },
                  keyboardType: TextInputType.number,
                  controller: _amountController,
                  decoration: InputDecoration(
                      filled: true,
                      fillColor: filledTextField,
                      hintText: "Rp. Masukkan Jumlah Uang",
                      hintStyle: TextStyle(
                        color: textFieldColor,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.red, //this has no effect
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      )),
                ),
              ),
              (_amount != "")
                  ? Bubble(
                      message: "Untuk apa uangnya?",
                    )
                  : Container(),
              (_amount != "")
                  ? Container(
                      margin: EdgeInsets.only(top: 15, bottom: 15),
                      child: InputDecorator(
                        decoration: InputDecoration(
                            border: OutlineInputBorder(gapPadding: 0)),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            isExpanded: true,
                            items: <String>['A', 'B', 'C', 'D']
                                .map((String value) {
                              return new DropdownMenuItem<String>(
                                value: value,
                                child: new Text(value),
                              );
                            }).toList(),
                            value: _dropDownValue,
                            onChanged: (value) {
                              setState(() {
                                _dropDownState = value;
                              });
                            },
                            hint: Text("Pilih salah satu"),
                          ),
                        ),
                      ),
                    )
                  : Container(),
              (_dropDownState != "")
                  ? Bubble(
                      message: "Yuk beritahu lebih detail",
                    )
                  : Container(),
              (_dropDownState != "")
                  ? Container(
                      margin: EdgeInsets.fromLTRB(3, 15, 3, 15),
                      child: TextField(
                        controller: _descriptionController,
                        onChanged: (text) {
                          setState(() {
                            _detail = text;
                          });
                        },
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: filledTextField,
                            hintText: "Masukkan detail",
                            hintStyle: TextStyle(
                              color: textFieldColor,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.red, //this has no effect
                              ),
                              borderRadius: BorderRadius.circular(10.0),
                            )),
                      ),
                    )
                  : Container(),
              (_detail != "")
                  ? ElevatedButton(
                      onPressed: () {},
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
    );
  }
}
