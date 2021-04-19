import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_unity/src/models/child.dart';
import 'package:mobile_unity/src/models/wish.dart';
import 'package:mobile_unity/src/pages/kid/detail_wish.dart';
import 'package:mobile_unity/src/provider/wish_provider.dart';
import 'package:mobile_unity/src/shared/alert_dialog.dart';
import 'package:mobile_unity/src/shared/constants.dart';
import 'package:mobile_unity/src/widgets/app_bar.dart';
import 'package:mobile_unity/src/widgets/loading.dart';
import 'package:mobile_unity/src/widgets/sub_header.dart';
import 'package:provider/provider.dart';

class AllKidWishes extends StatefulWidget {
  @override
  _AllKidWishesState createState() => _AllKidWishesState();
}

class _AllKidWishesState extends State<AllKidWishes> {
  WishProvider _wishProvider;
  Child _user;
  Wish _wish;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _user = Provider.of<Child>(context, listen: false);
    _wishProvider = Provider.of<WishProvider>(context, listen: false);
    _wishProvider.getWishes(childId: _user.uid);
  }

  @override
  Widget build(BuildContext context) {
    _wishProvider = Provider.of<WishProvider>(context);
    List<Wish> _pastWish = [];
    if(_wishProvider.wishes != null) {
      setState(() {
        _loading=false;
      });
      var _activeWish = _wishProvider.wishes.where((element) => !element.isDone && element.deadline.difference(DateTime.now()).inDays >= 0).toList();
      _wish = _activeWish.length > 0 ? _activeWish[0] : null;
      _pastWish = _wishProvider.wishes.where((element) => element.deadline.difference(DateTime.now()).inDays < 0 || element.isDone).toList();
    }
    return _loading ? Loading() : Scaffold(
      appBar: CustomAppBar(true, "Semua Impianku"),
      body: ListView(
        padding: EdgeInsets.all(20.0),
        children: [
          _buildHeader(context),
          SizedBox(height: 20.0,),
          SubHeader(isLihatSemua: false,title: "Sedang Diwujudkan",),
          SizedBox(height: 20.0,),
          _buildImpian(),
          SizedBox(height: 20.0,),
          SubHeader(isLihatSemua: false,title: "Impian Yang Telah Selesai",),
          SizedBox(height: 20.0,),
          _buildAnotherWish(_pastWish),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context){
    return Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Impianku",
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 23.0
                  ),
                ),
                SizedBox(height: 8.0,),
                Text(
                  "Tambahkan tugas atau \n edukasi finansial untuk anak",
                  style: TextStyle(
                      color: shadowColor,
                      fontSize: 16.0,
                      letterSpacing: 0.5
                  ),
                )
              ],
            ),
            _wish == null ?IconButton(
              icon: Icon(
                Icons.add_circle_outlined,
              ),
              color: secondaryColor,
              splashRadius: 30.0,
              iconSize: 50.0,
              onPressed: () => Navigator.pushNamed(context, '/child/add_wish'),
            ) : Container()
          ],
        )
    );
  }

  Widget _buildImpian(){
    return _wish != null ? InkWell(
      splashFactory: InkRipple.splashFactory,
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => DetailWishKid(wishId: _wish.uid,)));
      },
      child: Container(
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
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.nights_stay_rounded,
                  color: primaryColor,
                  size: 30.0,
                ),
                SizedBox(width: 10,),
                Expanded(
                  child: Text(
                    _wish.title,
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        fontSize: 15.0,
                        color: Colors.black
                    ),
                  ),
                ),
                Text(
                  DateFormat("dd MMMM yyyy").format(_wish.deadline).toString(),
                  style: TextStyle(
                      color: shadowColor,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w600
                  ),
                )
              ],
            ),
            SizedBox(height: 12.0,),
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: LinearProgressIndicator(
                minHeight: 5.0,
                backgroundColor: thirdColor,
                valueColor: AlwaysStoppedAnimation<Color>(secondaryColor),
                value: _wish.currentMoney/_wish.target,
              ),
            ),
            SizedBox(height: 8.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Rp ${_wish.currentMoney}",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                      fontSize: 13.0
                  ),
                ),
                Text(
                  "Rp ${_wish.target}",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                      fontSize: 13.0
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ) : Text(
      'Tidak ada impian yang sedang diwujudkan si kecil',
      style: TextStyle(
          fontSize: 15.0,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w500
      ),
    );
  }

  Widget _buildAnotherWish(List<Wish> pastWish){
    return pastWish.length > 0 ? ListView.builder(
      itemCount: pastWish.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) => InkWell(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => DetailWishKid(wishId: pastWish[index].uid,)));
        },
        splashFactory: InkRipple.splashFactory,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          margin: EdgeInsets.only(bottom: 10.0),
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
          child: Column(
            children: [
              ListTile(
                dense: true,
                contentPadding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,

                leading: Icon(
                  Icons.nights_stay_rounded,
                  color: primaryColor,
                  size: 30.0,
                ),
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pastWish[index].title,
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          fontSize: 15.0,
                          color: Colors.black
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(vertical:3.0, horizontal: 15.0),
                      decoration: BoxDecoration(
                          color: pastWish[index].isDone ? greenColor : redColor,
                          borderRadius: BorderRadius.circular(10.0)
                      ),
                      child: Text(
                        pastWish[index].isDone ? "Sudah Terkabul" : "Belum Terkabul",
                        style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                            fontSize: 15.0,
                            color: Colors.white
                        ),
                      ),
                    ),
                  ],
                ),
                trailing: Text(
                  DateFormat("dd MMMM yyyy").format(pastWish[index].deadline).toString(),
                  style: TextStyle(
                      color: shadowColor,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w600
                  ),
                )
              ),
              SizedBox(height: 12.0,),
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: LinearProgressIndicator(
                  minHeight: 5.0,
                  backgroundColor: thirdColor,
                  valueColor: AlwaysStoppedAnimation<Color>(secondaryColor),
                  value: pastWish[index].currentMoney/pastWish[index].target,
                ),
              ),
              SizedBox(height: 8.0,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Rp ${pastWish[index].currentMoney}",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                        fontSize: 13.0
                    ),
                  ),
                  Text(
                    "Rp ${pastWish[index].target}",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                        fontSize: 13.0
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      )
    ) : Text(
      'Tidak ada impian yang sudah selesai',
      style: TextStyle(
          fontSize: 15.0,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w500
      ),
    );
  }
}
