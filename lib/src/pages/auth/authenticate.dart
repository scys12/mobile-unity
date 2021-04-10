import 'package:flutter/material.dart';
import 'package:mobile_unity/src/pages/auth/register.dart';
import 'package:mobile_unity/src/pages/auth/sign_in.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignIn = true;

  void toggleView(){
    setState(() {
      showSignIn = !showSignIn;
    });
  }
  @override
  Widget build(BuildContext context) {
    return showSignIn ? SignIn(toggleView: toggleView) : Register(toggleView: toggleView);
  }
}
