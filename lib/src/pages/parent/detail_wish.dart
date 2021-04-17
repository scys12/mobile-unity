import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_unity/src/provider/child_provider.dart';
import 'package:mobile_unity/src/provider/task_provider.dart';
import 'package:mobile_unity/src/provider/wish_provider.dart';
import 'package:mobile_unity/src/shared/constants.dart';
import 'package:mobile_unity/src/widgets/app_bar.dart';
import 'package:mobile_unity/src/widgets/loading.dart';
import 'package:mobile_unity/src/widgets/sub_header.dart';
import 'package:provider/provider.dart';

class DetailWishChild extends StatefulWidget {
  final String wishId;
  DetailWishChild({this.wishId});
  @override
  _DetailWishChildState createState() => _DetailWishChildState();
}

class _DetailWishChildState extends State<DetailWishChild> {
  WishProvider _wishProvider;
  ChildProvider _childProvider;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _wishProvider = Provider.of(context, listen: false);
    _wishProvider.getWish(wishId: widget.wishId);
  }

  @override
  Widget build(BuildContext context) {
    _childProvider = Provider.of<ChildProvider>(context);
    _wishProvider =  Provider.of<WishProvider>(context);
    if (_wishProvider.selectedWish != null && _wishProvider.selectedWish.uid == widget.wishId) {
      setState(() {
        _loading = false;
      });
    }
    return _loading ? Loading() : Scaffold(
      appBar: CustomAppBar(true, "Detail Impian"),
      body: ListView(
        physics: ClampingScrollPhysics(),
        padding: EdgeInsets.all(30.0),
        children: [
          Form(
            child: Column(
              children: [
                _buildChildProfile(),
                SizedBox(height: 20.0,),
                _buildTitleField(),
                _buildDeadlineField(),
                _buildCategoryField(),
                _buildPointField(),
                SizedBox(height: 20.0,),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: LinearProgressIndicator(
                    minHeight: 5.0,
                    backgroundColor: thirdColor,
                    valueColor: AlwaysStoppedAnimation<Color>(secondaryColor),
                    value: _wishProvider.selectedWish.currentMoney/_wishProvider.selectedWish.target,
                  ),
                ),
                SizedBox(height: 8.0,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Rp ${_wishProvider.selectedWish.currentMoney}",
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Poppins',
                          fontSize: 13.0
                      ),
                    ),
                    Text(
                      "Rp ${_wishProvider.selectedWish.target}",
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
        ],
      ),
    );
  }

  Widget _buildProgress(){
    return Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Lumen sudah menyelesaikan tugas ",
              style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  fontSize: 15.0
              ),
            ),
            SizedBox(height: 10.0,),
            Row(
              children: [
                Icon(
                  Icons.schedule,
                  color: shadowColor,
                ),
                SizedBox(width: 10.0,),
                Text(
                  "20-01-2021",
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w700,
                      color: shadowColor
                  ),
                )
              ],
            ),
            SizedBox(height: 10.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        shadowColor
                    ),
                  ),
                  onPressed: () {  },
                  child: Text(
                    "Lihat Bukti",
                    style: TextStyle(
                        color: Colors.white
                    ),
                  ),
                ),
                TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        primaryColor
                    ),
                  ),

                  child: Text(
                    "Lihat Setuju",
                    style: TextStyle(
                        color: Colors.white
                    ),
                  ),
                ),
                OutlinedButton(
                  style: ButtonStyle(
                      side: MaterialStateProperty.all<BorderSide>(
                          BorderSide(
                              color: primaryColor
                          )
                      )
                  ),
                  onPressed: () {  },
                  child: Text(
                    "Tolak",
                    style: TextStyle(
                        color: primaryColor
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildChildProfile(){
    return Row(
      children: [
        Icon(
          Icons.account_circle,
          size: 30.0,
        ),
        SizedBox(width: 10.0,),
        Text(
          _childProvider.selectedChild.name,
          style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 25.0,
              fontWeight: FontWeight.w700
          ),
        )
      ],
    );
  }

  Widget _buildSubmitButton(){
    return ElevatedButton(
      onPressed: () {},
      child: Text('Buat Tugas'),
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(
              secondaryColor
          )
      ),
    );
  }

  Widget _buildPointField(){
    return Container(
      padding: EdgeInsets.all(15.0),
      child: Row(
        children: [
          Icon(Icons.card_giftcard, color: shadowColor,),
          SizedBox(width: 10.0,),
          Text(
            "${_wishProvider.selectedWish.point}pts",
            style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                fontSize: 17.0
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryField(){
    return Container(
      padding: EdgeInsets.all(15.0),
      child: Row(
        children: [
          Icon(Icons.category, color: shadowColor,),
          SizedBox(width: 10.0,),
          Container(
            padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
            decoration: BoxDecoration(
                color: secondaryColor,
                borderRadius: BorderRadius.circular(5.0)
            ),
            child: Text(
              _wishProvider.selectedWish.title,
              style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  fontSize: 17.0,
                  color: Colors.white
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitleField(){
    return TextFormField(
      style: TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.w600,
        fontFamily: 'Poppins',
      ),
      cursorColor: secondaryColor,
      decoration: InputDecoration(
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                  color: shadowColor,
                  width: 2.0
              )
          ),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                  color: secondaryColor,
                  width: 2.0
              )
          ),
          floatingLabelBehavior: FloatingLabelBehavior.never
      ),
      enabled: false,
      initialValue: _wishProvider.selectedWish.title,
      validator: (value) => value.isEmpty ? 'Name is required' : '',
    );
  }

  Widget _buildDeadlineField() {
    return Container(
      padding: EdgeInsets.all(15.0),
      child: Row(
        children: [
          Icon(Icons.schedule, color: shadowColor,),
          SizedBox(width: 10.0,),
          Text(
            DateFormat("dd MMMM yyyy").format(_wishProvider.selectedWish.deadline).toString(),
            style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                fontSize: 17.0
            ),
          ),
        ],
      ),
    );
  }
}
