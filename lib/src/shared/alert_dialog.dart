import 'package:flutter/material.dart';
import 'package:mobile_unity/src/widgets/loading.dart';

import 'constants.dart';

Future successMessage(BuildContext context, String message){
  return showDialog(context: context, builder: (context) {
    return AlertDialog(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      content: Container(
        margin: EdgeInsets.all(40.0),
        
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0)
        ),
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.check_box,
              color: greenColor,
            ),
            SizedBox(height: 10.0,),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  });
}

Future createLoadingAlertDialog(BuildContext context){
  return showDialog(barrierDismissible: false,context: context, builder: (context) {
    return Container(
      child: Center(
          child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0)
              ),
              child: Loading()
          )
      ),
    );
  });
}

Future createAlertDialog(BuildContext context){
  return showDialog(context: context, builder: (context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Tambahkan",
            style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 17.0
            ),
          ),
          SizedBox(height: 20.0,),
          ElevatedButton(
            onPressed: (){
              Navigator.pushNamed(context, '/parent/new_education');
            },
            style: ButtonStyle(
              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              ),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0)
                ),
              ),
              elevation: MaterialStateProperty.all<double>(
                  0.0
              ),
              backgroundColor: MaterialStateProperty.all<Color>(
                  primaryColor
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add,
                ),
                SizedBox(width: 15.0,),
                Text(
                  "Edukasi Baru",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    fontSize: 17.0,
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 10.0,),
          ElevatedButton(
            onPressed: (){
              Navigator.pushNamed(context, '/parent/new_task');
            },
            style: ButtonStyle(
              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              ),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0)
                ),
              ),
              elevation: MaterialStateProperty.all<double>(
                  0.0
              ),
              backgroundColor: MaterialStateProperty.all<Color>(
                  primaryColor
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.add,
                ),
                SizedBox(width: 15.0,),
                Text(
                  "Tugas Baru",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    fontSize: 17.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  });
}