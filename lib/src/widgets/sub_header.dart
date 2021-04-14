import 'package:flutter/material.dart';
import 'package:mobile_unity/src/shared/constants.dart';

class SubHeader extends StatelessWidget {
  String title ='';
  bool isLihatSemua = false;
  String path = '';

  SubHeader({this.title, this.isLihatSemua, this.path});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              fontSize: 20.0,
              color: Colors.black,
            ),
          ),
          isLihatSemua ? TextButton(
            onPressed: () { 
              Navigator.pushNamed(context, path);
            },
            child: Text(
              'LIHAT SEMUA',
              style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                  fontSize: 15.0,
                  letterSpacing: 0.8,
                  color: secondaryColor
              ),
            ),
          ) : Container()
        ],
      ),
    );
  }
}
