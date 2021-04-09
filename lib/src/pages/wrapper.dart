import 'package:flutter/material.dart';
import 'package:mobile_unity/src/models/user.dart';
import 'package:mobile_unity/src/pages/auth/login.dart';
import 'package:mobile_unity/src/pages/home/home.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    if (user == null) {
      return Authenticate();
    }
    else{
      return Home();
    }
  }
}