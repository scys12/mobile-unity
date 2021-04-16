import 'package:flutter/material.dart';
import 'package:mobile_unity/src/services/auth.dart';
import 'package:mobile_unity/src/shared/constants.dart';
import 'package:mobile_unity/src/widgets/loading.dart';

import 'otp.dart';

class SignPhone extends StatefulWidget {
  final Function toggleView;
  SignPhone({this.toggleView});

  @override
  _SignPhoneState createState() => _SignPhoneState();
}

class _SignPhoneState extends State<SignPhone> {

  final _formKey = GlobalKey<FormState>();
  final _phoneController = TextEditingController();
  String _error = '';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: thirdColor,
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildHeader(),
                    SizedBox(height: 20.0,),
                    TextFormField(
                      decoration: textInputDecoration.copyWith(
                        prefix: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircleAvatar(
                              backgroundImage: AssetImage("assets/images/indonesia.png"),
                              radius: 10.0,
                            ),
                            SizedBox(width: 5.0,),
                            Text(
                              "+62",
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600
                              ),
                            ),
                            SizedBox(width: 10.0,),
                          ],
                        ),
                        labelText: 'Nomor HP',
                        labelStyle: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          color: shadowColor,
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value.length < 10) {
                          return 'Masukkan nomor hp yang valid';
                        }else{
                          return null;
                        }
                      },
                      controller: _phoneController,
                    ),
                    SizedBox(height: 15.0,),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        primaryColor
                    ),
                  ),
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      var phoneNumber = "+62${_phoneController.text}";
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => OTPScreen(phoneNumber:phoneNumber)));
                    }
                  },
                  child: Text(
                    'Lanjutkan',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Poppins',
                        fontSize: 15.0
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Masuk atu Daftar",
          style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              fontSize: 23.0
          ),
        ),
        SizedBox(height: 8.0,),
        Text(
          "Masuk atau daftar dengan menggunakan telepon kamu",
          style: TextStyle(
              color: shadowColor,
              fontSize: 16.0,
          ),
        )
      ],
    );
  }
}
