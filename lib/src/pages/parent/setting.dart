import 'package:flutter/material.dart';
import 'package:mobile_unity/src/widgets/app_bar.dart';

class ParentSetting extends StatefulWidget {
  @override
  _ParentSettingState createState() => _ParentSettingState();
}

class _ParentSettingState extends State<ParentSetting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(false, "Akun"),
      body: Container(),
    );
  }
}
