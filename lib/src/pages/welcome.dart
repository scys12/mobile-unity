import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:mobile_unity/src/shared/constants.dart';

class Welcome extends StatefulWidget {
  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
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
          "Halo Berapa Umurmu ?",
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
          Navigator.pushNamed(context, '/welcome/child_parent');
        },
        child: Column(
          children: [
            Text(
              "Kurang dari 15 tahun",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600
              ),
            ),
            Text(
              "*mendaftar sebagai anak dan orang tua",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 13.0,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600
              ),
            ),
          ],
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
          Navigator.pushNamed(context, '/auth/teenager');
        },
        child: Text(
          "Lebih dari 15 tahun",
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
