import 'package:flutter/material.dart';
import 'package:mobile_unity/src/shared/constants.dart';

class Form extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SizedBox(
            height: 15.0,
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: thirdColor,
            ),
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 35.0),
            margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Stack(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    child: Row(
                      children: [
                        Icon(Icons.account_box_outlined),
                        SizedBox(
                          width: 10.0,
                        ),
                        Text(
                          'Tambahkan Anak',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1.0,
                            fontSize: 15.0,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_down,
                    size: 30.0,
                    color: Colors.black,
                  )
                ],
              ),
            ]),
          )
        ],
      ),
    );
  }
}
