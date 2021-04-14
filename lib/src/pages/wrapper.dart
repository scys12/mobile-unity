import 'package:flutter/material.dart';
import 'package:mobile_unity/src/models/parent.dart';
import 'package:mobile_unity/src/pages/auth/authenticate.dart';
import 'package:mobile_unity/src/pages/parent/wrapper.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<Parent>(context);
    return user == null ? Authenticate() : WrapperParent();
  }
}

