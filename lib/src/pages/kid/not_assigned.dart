import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:mobile_unity/src/shared/constants.dart';

class NotAssigned extends StatefulWidget {
  @override
  _NotAssignedState createState() => _NotAssignedState();
}

class _NotAssignedState extends State<NotAssigned> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(30.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildHeader(),
              _buildBoxPersetujuan(),
            ],
          ),
        )
      ),
    );
  }

  Widget _buildHeader(){
    return Column(
      children: [
        Image(
          image: AssetImage("assets/images/logo.png"),
        ),
        SizedBox(height: 30.0,),
        Text(
          "Halo!",
          style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 25.0,
              fontWeight: FontWeight.w600
          ),
        ),
      ],
    );
  }

  Widget _buildBoxPersetujuan(){
    return Bubble(
      nip: BubbleNip.leftTop,
      padding: BubbleEdges.all(20.0),
      margin: BubbleEdges.only(top: 20.0),
      color: primaryColor,
      child: Text(
        "Minta orang tua mu untuk menambahkan nomor HP kamu lewat akun mereka !",
        style: TextStyle(
          color: Colors.white,
          fontSize: 18.0,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600
        ),
      ),
    );
  }
}
