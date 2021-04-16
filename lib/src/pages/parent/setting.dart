import 'package:flutter/material.dart';
import 'package:mobile_unity/src/models/parent.dart';
import 'package:mobile_unity/src/pages/wrapper.dart';
import 'package:mobile_unity/src/services/auth.dart';
import 'package:mobile_unity/src/shared/constants.dart';
import 'package:mobile_unity/src/widgets/app_bar.dart';
import 'package:mobile_unity/src/widgets/loading.dart';
import 'package:mobile_unity/src/widgets/sub_header.dart';
import 'package:provider/provider.dart';

class ParentSetting extends StatefulWidget {
  @override
  _ParentSettingState createState() => _ParentSettingState();
}

class _ParentSettingState extends State<ParentSetting> {
  @override
  Widget build(BuildContext context) {
    final Parent user = Provider.of<Parent>(context);
    return user == null ? Loading() :  Scaffold(
      appBar: CustomAppBar(false, "Akun"),
      body: ListView(
        padding: EdgeInsets.all(20.0),
        physics: ClampingScrollPhysics(),
        children: [
          SubHeader(title: "Profile Anda", isLihatSemua: false,),
          SizedBox(height: 10.0,),
          _buildProfile(user),
          SizedBox(height: 10.0,),
          Divider(color: thirdColor,thickness: 2.0,),
          SizedBox(height: 10.0,),
          SubHeader(title: "Akun", isLihatSemua: false,),
          SizedBox(height: 10.0,),
          _buildAccountButton(),
          SizedBox(height: 10.0,),
          Divider(color: thirdColor,thickness: 2.0,),
          SizedBox(height: 10.0,),
          _buildSignOutButton(),
        ],
      ),
    );
  }

  Widget _buildProfile(Parent user){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
                color: shadowColor,
                blurRadius: 8,
                spreadRadius: 0,
                offset: Offset(1.0, 3.0)
            )
          ]
      ),
      child: Row(
        children: [
          Icon(
            Icons.account_circle,
            color: shadowColor,
            size: 60.0,
          ),
          SizedBox(width: 10,),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.email,
                    color: Colors.black,
                    size: 20.0,
                  ),
                  SizedBox(width: 10.0,),
                  Text(
                    user.email,
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        fontSize: 15.0,
                        color: Colors.black
                    ),
                  ),
                ],
              ),
              user.isProfileFilled ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.face,
                        color: Colors.black,
                        size: 20.0,
                      ),
                      SizedBox(width: 10.0,),
                      Container(
                        width:200,
                        child: Text(
                          user.name,
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                              fontSize: 15.0,
                              color: Colors.black
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5.0,),
                  Row(
                    children: [
                      Icon(
                        Icons.phone,
                        color: Colors.black,
                        size: 20.0,
                      ),
                      Text(
                        user.phoneNumber,
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                            fontSize: 15.0,
                            color: Colors.black
                        ),
                      ),
                    ],
                  ),
                ],
              ) : TextButton(
                child: Text(
                  'Lengkapi Profile',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                style: TextButton.styleFrom(
                    backgroundColor: shadowColor,
                    primary: Colors.white,
                    padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0)
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/parent/change_profile');
                },
              )
            ],
          )

        ],
      ),
    );
  }

  Widget _buildAccountButton(){
    return ElevatedButton(
      onPressed: (){
        Navigator.pushNamed(context, '/parent/change_profile');
      },
      style: ButtonStyle(

        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
          EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        shadowColor: MaterialStateProperty.all(thirdColor),
        overlayColor: MaterialStateProperty.all(thirdColor),
        elevation: MaterialStateProperty.all<double>(
            2.0
        ),
        backgroundColor: MaterialStateProperty.all<Color>(
            Colors.white
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                Icons.add,
                color: shadowColor
              ),
              SizedBox(width: 20.0,),
              Text(
                "Ubah Profile",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  fontSize: 17.0,
                  color: shadowColor
                ),
              ),
            ],
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: shadowColor
          )
        ],
      ),
    );
  }

  Widget _buildSignOutButton(){
    return ElevatedButton(
      onPressed: () async{
        Navigator.of(context).pushNamedAndRemoveUntil('/welcome', (Route<dynamic> route) => false);
        await AuthService().signOut();

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
      child: Text(
        "Keluar",
        style: TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w600,
          fontSize: 17.0,
        ),
      )
    );
  }
}
