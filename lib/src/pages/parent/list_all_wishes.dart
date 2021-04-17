import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:mobile_unity/src/models/parent.dart';
import 'package:mobile_unity/src/models/wish.dart';
import 'package:mobile_unity/src/provider/child_provider.dart';
import 'package:mobile_unity/src/provider/task_provider.dart';
import 'package:mobile_unity/src/provider/wish_provider.dart';
import 'package:mobile_unity/src/shared/alert_dialog.dart';
import 'package:mobile_unity/src/shared/constants.dart';
import 'package:mobile_unity/src/widgets/app_bar.dart';
import 'package:mobile_unity/src/widgets/loading.dart';
import 'package:mobile_unity/src/widgets/sub_header.dart';
import 'package:provider/provider.dart';

import 'detail_task.dart';
import 'detail_wish.dart';

class ListChildWishes extends StatefulWidget {
  @override
  _ListChildWishesState createState() => _ListChildWishesState();
}

class _ListChildWishesState extends State<ListChildWishes> {
  WishProvider _wishProvider;
  ChildProvider _childProvider;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _childProvider = Provider.of<ChildProvider>(context, listen: false);
    _wishProvider =  Provider.of<WishProvider>(context, listen: false);
    _wishProvider.getWishes(childId: _childProvider.selectedChild.uid);
  }

  @override
  Widget build(BuildContext context) {
    _wishProvider =  Provider.of<WishProvider>(context);
    if (_wishProvider.wishes != null) {
      setState(() {
        _loading = false;
      });
    }
    return _loading ? Loading() : Scaffold(
      appBar: CustomAppBar(true, "Semua Impian"),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 25.0),
        physics: ScrollPhysics(),
        child: Column(
          children: [
            _buildHeader(context),
            SizedBox(height: 25.0,),
            Divider(
              color: shadowColor,
              thickness: 2.0,
            ),
            SizedBox(height: 25.0,),
            ListView.builder(
              itemCount: _wishProvider.wishes.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index){
                return InkWell(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DetailWishChild(wishId: _wishProvider.wishes[index].uid,)),
                  ),
                  splashFactory: InkRipple.splashFactory,
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
                                _wishProvider.wishes[index].title,
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15.0,
                                    color: Colors.black
                                ),
                              ),
                            ),
                            Text(
                              DateFormat("dd MMMM yyyy").format(_wishProvider.wishes[index].deadline).toString(),
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
                            value: _wishProvider.wishes[index].currentMoney/_wishProvider.wishes[index].target,
                          ),
                        ),
                        SizedBox(height: 8.0,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Rp ${_wishProvider.wishes[index].currentMoney}",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Poppins',
                                  fontSize: 13.0
                              ),
                            ),
                            Text(
                              "Rp ${_wishProvider.wishes[index].target}",
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
                );
              },
            )
          ],
        ),
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
                  "Impian ${_childProvider.selectedChild.name}",
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 23.0
                  ),
                ),
                SizedBox(height: 8.0,),
                Text(
                  "Daftar Impian yang diinginkan anak",
                  style: TextStyle(
                      color: shadowColor,
                      fontSize: 16.0,
                      letterSpacing: 0.5
                  ),
                )
              ],
            ),
          ],
        )
    );
  }
}