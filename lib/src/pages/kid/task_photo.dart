import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mobile_unity/src/widgets/app_bar.dart';
class TaskPhoto extends StatelessWidget {
  final File image;
  final String imageUrl;
  TaskPhoto({this.image, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(true, "Bukti Photo"),
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: image != null ? Image.file(image, fit: BoxFit.fill) : Image.network(imageUrl),
      ),
    );
  }
}
