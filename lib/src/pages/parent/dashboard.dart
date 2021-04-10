import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_unity/src/models/user.dart';
import 'package:mobile_unity/src/services/auth.dart';
import 'package:mobile_unity/src/shared/constants.dart';
import 'package:provider/provider.dart';

class DashboardParent extends StatefulWidget {

  @override
  _DashboardParentState createState() => _DashboardParentState();
}

class _DashboardParentState extends State<DashboardParent> {
  final AuthService _authService = AuthService();
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: ListView(
        children: [
          Container(
            child: Stack(
              children: [
                Image.asset('assets/images/header.png'),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Row(
                            children: [
                              Icon(
                                Icons.account_circle,
                                size: 50.0,
                                color: Colors.white,
                              ),
                              SizedBox(width: 15,),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(5.0),
                                    child: Text(
                                      'Selamat Datang,',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w500,
                                        letterSpacing: 1.0,
                                        fontSize: 20.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  user.name == null ? TextButton(
                                    child: Text('Lengkapi Profil'),
                                    style: TextButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        primary: primaryColor,
                                        padding: EdgeInsets.all(20.0)
                                    ),
                                    onPressed: () async {
                                    },
                                  ) : Text(user.name)
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 45.0,),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: thirdColor,
                          ),
                          padding: EdgeInsets.symmetric(vertical:25.0, horizontal: 35.0),
                          margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child:  Stack(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      child: Row(
                                        children: [
                                          Icon(
                                              Icons.account_box_outlined
                                          ),
                                          SizedBox(width: 10.0,),
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
                              ]
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: secondaryColor,
            ),
            padding: EdgeInsets.symmetric(vertical:25.0, horizontal: 35.0),

            margin: EdgeInsets.fromLTRB(40, 0, 40, 0),
            child: Text(
              "Anda belum menambahkan si kecil",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(40, 40, 40, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Aktivitas',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    fontSize: 25.0,
                    color: Colors.black,
                  ),
                ),
                TextButton(
                  child: Text(
                    'LIHAT SEMUA',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w700,
                      fontSize: 17.0,
                      color: secondaryColor
                    ),
                  ),
                )
              ],
            ),
          ),
          ListView.builder(
            itemCount: 3,
            padding: EdgeInsets.only(top: 10.0),
            shrinkWrap: true,
            itemBuilder: (context, index){
              return Container(
                margin: EdgeInsets.fromLTRB(40, 20, 40, 0),
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
                      Icons.my_library_books_outlined,
                      color: primaryColor,
                      size: 60.0,
                    ),
                    SizedBox(width: 10,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Berhasil menyelesaikan tugas',
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                              fontSize: 18.0,
                              color: Colors.black
                          ),
                        ),
                        SizedBox(height: 5.0,),
                        Container(
                          padding: EdgeInsets.all(6.0),
                          decoration: BoxDecoration(
                            color: greenColor,
                          ),
                          child: Text(
                            "Pendidikan",
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                                fontSize: 15.0,
                                color: Colors.white
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
