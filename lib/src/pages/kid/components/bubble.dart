import 'package:flutter/material.dart';
import 'package:mobile_unity/src/shared/constants.dart';

class BubbleD extends StatelessWidget {
  BubbleD({this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    // final bg = MaterialStateProperty.all<Color>(secondaryColor);
    final align = CrossAxisAlignment.start;
    final radius = BorderRadius.only(
      topRight: Radius.circular(5.0),
      bottomLeft: Radius.circular(5.0),
      bottomRight: Radius.circular(5.0),
    );
    return Column(
      crossAxisAlignment: align,
      children: <Widget>[
        Container(
          width: double.infinity,
          margin: const EdgeInsets.all(3.0),
          padding: const EdgeInsets.all(15.0),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                  blurRadius: .5,
                  spreadRadius: 1.0,
                  color: Colors.black.withOpacity(.12))
            ],
            color: secondaryColor,
            borderRadius: radius,
          ),
          child: Stack(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(right: 48.0),
                child: Text(
                  message,
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      fontSize: 15.0,
                      color: Colors.white),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
