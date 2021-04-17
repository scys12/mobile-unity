import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mobile_unity/src/models/child.dart';
import 'package:mobile_unity/src/models/parent.dart';
import 'package:mobile_unity/src/pages/parent/child_task.dart';
import 'package:mobile_unity/src/provider/child_provider.dart';
import 'package:mobile_unity/src/services/auth.dart';
import 'package:mobile_unity/src/shared/constants.dart';
import 'package:provider/provider.dart';

class DashboardParent extends StatefulWidget {
  @override
  _DashboardParentState createState() => _DashboardParentState();
}

class _DashboardParentState extends State<DashboardParent> {
  List<Child> childrens;
  final AuthService _authService = AuthService();
  int _currentIndex = 0;
  ChildProvider _childProvider;

  @override
  Widget build(BuildContext context) {
    final Parent user = Provider.of<Parent>(context);
    childrens = Provider.of<List<Child>>(context);
    _childProvider = Provider.of<ChildProvider>(context);
    return Scaffold(
      body: ListView(
        physics: ClampingScrollPhysics(),
        children: [
          Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(60.0),
                      bottomRight: Radius.circular(60.0)),
                ),
                margin: EdgeInsets.only(bottom: 50),
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 30.0, bottom: 50.0, left: 20.0, right: 20.0),
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
                          SizedBox(
                            width: 15,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Selamat Datang,',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 1.0,
                                  fontSize: 20.0,
                                  color: Colors.white,
                                ),
                              ),
                              user.isProfileFilled
                                  ? Text(
                                      user.name,
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w500,
                                        fontSize: 18.0,
                                        color: Colors.white,
                                      ),
                                    )
                                  : TextButton(
                                      child: Text(
                                        'Lengkapi Profile',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700),
                                      ),
                                      style: TextButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          primary: primaryColor,
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10.0,
                                              horizontal: 15.0)),
                                      onPressed: () {
                                        Navigator.pushNamed(
                                            context, '/parent/change_profile');
                                      },
                                    ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 120,
                left: 0,
                right: 0,
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 20.0),
                  child: TextButton(
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      backgroundColor: MaterialStateProperty.all<Color>(
                        thirdColor,
                      ),
                      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 15.0)),
                    ),
                    onPressed: () {
                      _addChildButtonPressed(_childProvider.selectedChild);
                    },
                    child: Column(children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Row(
                              children: [
                                Icon(
                                  Icons.account_box_outlined,
                                  color: Colors.black,
                                ),
                                SizedBox(
                                  width: 10.0,
                                ),
                                Text(
                                  _childProvider.selectedChild.name,
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: .5,
                                    fontSize: 17.0,
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
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 15.0,
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: secondaryColor,
            ),
            padding: EdgeInsets.symmetric(vertical: 25.0, horizontal: 35.0),
            margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Text(
              "Anda belum menambahkan si kecil",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 15.0,
                fontFamily: 'Poppins',
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 20.0, left: 20.0, top: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Aktivitas',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w700,
                    fontSize: 20.0,
                    color: Colors.black,
                  ),
                ),
                TextButton(
                  child: Text(
                    'LIHAT SEMUA',
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w700,
                        fontSize: 15.0,
                        color: secondaryColor),
                  ),
                )
              ],
            ),
          ),
          ListView.builder(
            itemCount: 3,
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemBuilder: (context, index) {
              return Container(
                margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                          color: shadowColor,
                          blurRadius: 8,
                          spreadRadius: 0,
                          offset: Offset(1.0, 3.0))
                    ]),
                child: Row(
                  children: [
                    Icon(
                      Icons.my_library_books_outlined,
                      color: primaryColor,
                      size: 60.0,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 200,
                          child: Text(
                            'Berhasil menyelesaikan tugas',
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w500,
                                fontSize: 15.0,
                                color: Colors.black),
                          ),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
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
                                color: Colors.white),
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

  void _addChildButtonPressed(Child child) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            color: Color(0XFF737373),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(20),
                    topRight: const Radius.circular(20)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    childrens.length > 0
                        ? Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              ...childrens
                                  .asMap()
                                  .map((idx, val) => MapEntry(
                                      idx, _buildChildTile(idx, val, child)))
                                  .values
                                  .toList()
                            ],
                          )
                        : ListTile(
                            title: Text(
                              'Belum menambahkan si kecil',
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w600,
                                fontSize: 18.0,
                              ),
                            ),
                            trailing: Icon(
                              Icons.indeterminate_check_box,
                              color: primaryColor,
                            ),
                            onTap: () {},
                          ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/parent/add_child');
                      },
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                          EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 10.0),
                        ),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0)),
                        ),
                        elevation: MaterialStateProperty.all<double>(0.0),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(primaryColor),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add,
                          ),
                          SizedBox(
                            width: 15.0,
                          ),
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

  Widget _buildChildTile(int idx, Child childIndex, Child currentChild) {
    List<Color> colors = [primaryColor, Colors.black];
    List<IconData> icons = [
      Icons.check_box,
      Icons.check_box_outline_blank,
    ];
    Color color =
        childrens[_currentIndex].uid == childIndex.uid ? colors[0] : colors[1];
    return ListTile(
      leading: Icon(Icons.account_circle),
      title: Text(
        childIndex.name,
        style: TextStyle(
          fontFamily: "Poppins",
          fontWeight: FontWeight.w600,
          fontSize: 18.0,
        ),
      ),
      trailing: Icon(
        childrens[_currentIndex].uid == childIndex.uid ? icons[0] : icons[1],
        color: color,
      ),
      onTap: () {
        print("1 ${currentChild.name}");
        print("11 ${childIndex.name}");
        setState(() {
          _currentIndex = idx;
        });
        _childProvider.updateCurrentChild(child: childIndex);
        print("2 ${currentChild.name}");
        print("22 ${childIndex.name}");
      },
    );
  }
}
