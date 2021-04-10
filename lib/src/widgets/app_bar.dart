import 'package:flutter/material.dart';
import 'package:mobile_unity/src/shared/constants.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget{
  bool showBackIcon;
  String title;

  @override
  final Size preferredSize;

  CustomAppBar(
      this.showBackIcon,
      this.title,
      { Key key,}) : preferredSize = Size.fromHeight(50.0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      centerTitle: true,
      backgroundColor: primaryColor,
      leading: showBackIcon ?
      IconButton(
        icon: Icon(Icons.arrow_back_ios),
        onPressed: () => print("clicked"),
      ) : null
    );
  }
}
