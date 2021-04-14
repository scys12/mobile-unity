import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_unity/src/models/user.dart';
import 'package:mobile_unity/src/services/auth.dart';
import 'package:mobile_unity/src/shared/constants.dart';
import 'package:mobile_unity/src/widgets/sub_header.dart';
import 'package:provider/provider.dart';

class DashboardKid extends StatefulWidget {

  @override
  _DashboardKidState createState() => _DashboardKidState();
}

class _DashboardKidState extends State<DashboardKid> {
  final AuthService _authService = AuthService();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: ListView(
        physics: ClampingScrollPhysics(),
        children: [
          _buildHeader(),
          Container(
            margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Column(
              children: [
                SubHeader(title: 'Catat Keuanganku',isLihatSemua: false,),
                SizedBox(height: 15.0,),
                _buildCatatanKeuangan(),
                SizedBox(height: 15.0,),
                SubHeader(title: 'Tugasku',isLihatSemua: false,),
                SizedBox(height: 15.0,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: _buildCard()
                    ),
                    SizedBox(width: 15.0,),
                    Expanded(
                      child: _buildCard(),
                    ),
                  ],
                ),
                SizedBox(height: 25.0,),
                _buildButtonAllTask(),
              ],
            ),
          )
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        items: [Icons.home, Icons.subject_outlined, Icons.emoji_events, Icons.settings]
            .asMap()
            .map((key, value) => MapEntry(
          key,
          BottomNavigationBarItem(
            label: '',
            tooltip: '',
            icon: Container(
              padding: EdgeInsets.symmetric(
                  vertical: 6.0,
                  horizontal: 16.0
              ),
              decoration: BoxDecoration(color: _currentIndex == key
                  ? primaryColor
                  : thirdColor,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Icon(value),
            ),
          ),
        ))
            .values
            .toList(),
      ),
    );
  }

  Widget _buildHeader(){
    return Stack(
      children: [
        _buildWelcomeInformation(),
        _buildTransactionInformation(),
      ],
    );
  }

  Widget _buildButtonAllTask(){
    return ElevatedButton(
      onPressed: (){
        Navigator.pushNamed(context, '/parent/add_child');
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
            secondaryColor
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Lihat semua tugasku",
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              fontSize: 17.0,
            ),
          ),
          SizedBox(width: 15.0,),
          Icon(
            Icons.arrow_forward,
          ),
        ],
      ),
    );
  }

  Widget _buildWelcomeInformation(){
    return Container(
      decoration: BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(60.0),bottomRight: Radius.circular(60.0)),
      ),
      margin: EdgeInsets.only(bottom: 100),
      child: Padding(
        padding: const EdgeInsets.only(top: 30.0, bottom: 50.0, left: 20.0, right: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
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
                    Text(
                      'Halo Lumen,',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1.0,
                        fontSize: 20.0,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'Selamat Menabung',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                        fontSize: 18.0,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }

  Widget _buildTransactionInformation(){
    return Positioned(
      top: 100 ,
      left: 0,
      right: 0,
      child:  Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: secondaryColor,
          ),
          padding: EdgeInsets.symmetric(vertical:25.0, horizontal: 25.0),

          margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text(
                    "Total Uang",
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w400,
                      fontSize: 18.0,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8.0,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Rp",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(width: 3.0,),
                      Text(
                        "15000",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
                          fontSize: 28.0,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Total Pointku",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                          fontSize: 13.0,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 15.0,),
                      Text(
                        "500 pts",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w700,
                          fontSize: 25.0,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          whiteOpColor
                      ),
                      padding: MaterialStateProperty.all(
                          EdgeInsets.symmetric(horizontal: 10.0)
                      ),
                    ),
                    onPressed: (){},
                    child: Row(
                      children: [
                        Icon(
                          Icons.history,
                          color: Colors.white,
                        ),
                        SizedBox(width: 10.0,),
                        Text(
                          "Riwayat",
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              )
            ],
          )
      ),
    );
  }

  void _addChildButtonPressed(){
    showModalBottomSheet(context: context, builder: (context) {
      return Container(
        color: Color(0XFF737373),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(20),
                topRight: const Radius.circular(20)
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: Icon(Icons.account_circle),
                  title: Text(
                    'Nama anak',
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w600,
                      fontSize: 18.0,
                    ),
                  ),
                  trailing: Icon(
                    Icons.check_box,
                    color: primaryColor,
                  ),
                  onTap: () {},
                ),
                ElevatedButton(
                  onPressed: (){
                    Navigator.pushNamed(context, '/parent/add_child');
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
                        "Tambahkan anak",
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          fontSize: 17.0,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _buildCatatanKeuangan(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              blurRadius: 2.0,
              spreadRadius: 1.0,
            ),
          ],
          color: Colors.white
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildCatatanIcon(Icons.add_circle_outline, greenColor, "Pemasukan"),
          Divider(thickness: 1.0,color: shadowColor,),
          _buildCatatanIcon(Icons.remove_circle_outline, redColor, "Pengeluaran"),
          VerticalDivider(thickness: 1.0,color: shadowColor,),
          _buildCatatanIcon(Icons.analytics_outlined, secondaryColor, "Ringkasan"),
        ],
      ),
    );
  }

  Widget _buildCatatanIcon(IconData iconData, Color iconColor, String content){
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            iconData,
            color: iconColor,
            size: 40.0,
          ),
          SizedBox(height: 5.0,),
          Text(
            content,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
              fontSize: 14.0
            ),
          )
        ],
      ),
    );
  }
  Widget _buildCard(){
    return Container(
      padding: EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
        border: Border.all(color: Colors.white),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            offset: Offset(1,2),
            spreadRadius: 1,
            blurRadius: 3,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(7)),
                  color: redColor,
                ),
                child: Text(
                  "1 hari lagi",
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Poppins',
                      fontSize: 15.0,
                      fontWeight: FontWeight.w600
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(7)),
                  color: redColor,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '+10',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        fontFamily: 'Poppins',
                        fontSize: 15.0,
                      ),
                    ),
                    Text(
                      'pts',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        fontFamily: 'Poppins',
                        fontSize: 10.0,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 10.0,),
          Text(
            "Berhasil menyelesaikan 1 tugas",
            style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
                fontSize: 15.0
            ),
          ),
          SizedBox(height: 10.0,),
          Text(
            '05-04-2021',
            style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                color: thirdColor,
                fontSize: 15.0
            ),
          ),
          SizedBox(height: 10.0,),
          Container(
            padding: EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(7)),
              color: greenColor,
            ),
            child: Text(
              "Pendidikan",
              style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Poppins',
                  fontSize: 15.0,
                  fontWeight: FontWeight.w600
              ),
            ),
          ),
        ],
      ),
    );
  }

}
