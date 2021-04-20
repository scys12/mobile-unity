import 'package:flutter/material.dart';
import 'package:mobile_unity/src/pages/teenager/auth/register.dart';
import 'package:mobile_unity/src/pages/teenager/auth/sign_in.dart';

class AuthenticateTeenager extends StatefulWidget {
  @override
  _AuthenticateTeenagerState createState() => _AuthenticateTeenagerState();
}

class _AuthenticateTeenagerState extends State<AuthenticateTeenager> {
  bool showSignIn = true;

  void toggleView(){
    setState(() {
      showSignIn = !showSignIn;
    });
  }
  @override
  Widget build(BuildContext context) {
    return showSignIn ? SignInTeenager(toggleView: toggleView) : RegisterTeenager(toggleView: toggleView);
  }
}
