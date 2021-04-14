import 'package:flutter/material.dart';

const textInputDecoration =  InputDecoration(
    fillColor: Colors.white,
    filled: true,
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white, width: 2.0),
    ),
    focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.pink, width: 2.0)
    )
);

const primaryColor = Color.fromRGBO(252, 162, 17, 1.0);
const secondaryColor = Color.fromRGBO(50, 83, 154, 1.0);
const thirdColor = Color.fromRGBO(229, 229, 229, 1.0);
const redColor = Color.fromRGBO(223, 111, 111, 1.0);
const greenColor = Color.fromRGBO(126, 223, 111, 1.0);
const shadowColor = Color.fromRGBO(0, 0, 0, 0.2);
const whiteOpColor = Color.fromRGBO(244, 248, 255, 0.13);