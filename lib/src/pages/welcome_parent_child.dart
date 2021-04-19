import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:mobile_unity/src/shared/constants.dart';

class WelcomeParentChild extends StatefulWidget {
  @override
  _WelcomeParentChildState createState() => _WelcomeParentChildState();
}

class _WelcomeParentChildState extends State<WelcomeParentChild> {
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
                _buildBoxLessFiveTeen(),
                SizedBox(height: 20.0,),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(child: Divider(color: Colors.black,thickness: 1.0,)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        "atau",
                        style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 15
                        ),
                      ),
                    ),
                    Expanded(child: Divider(color: Colors.black,thickness: 1.0,)),
                  ],
                ),
                _buildBoxMoreFiveTeen(),
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
          "Kamu ingin mendaftar sebagai ?",
          style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 25.0,
              fontWeight: FontWeight.w600
          ),
        ),
      ],
    );
  }

  Widget _buildBoxLessFiveTeen(){
    return Bubble(
      nip: BubbleNip.leftTop,
      padding: BubbleEdges.all(10.0),
      margin: BubbleEdges.only(top: 20.0),
      color: primaryColor,
      child: TextButton(
        onPressed: () {
          Navigator.pushNamed(context, '/authenticate');
        },
        child: Text(
          "Orang Tua",
          style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600
          ),
        ),
      ),
    );
  }

  Widget _buildBoxMoreFiveTeen(){
    return Bubble(
      nip: BubbleNip.rightTop,
      padding: BubbleEdges.all(10.0),
      margin: BubbleEdges.only(top: 20.0),
      color: primaryColor,
      child: TextButton(
        onPressed: () {
          Navigator.pushNamed(context, '/auth/sign_phone');
        },
        child: Text(
          "Anak",
          style: TextStyle(
              color: Colors.white,
              fontSize: 18.0,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600
          ),
        ),
      ),
    );
  }
}
