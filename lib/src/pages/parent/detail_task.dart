import 'package:flutter/material.dart';
import 'package:mobile_unity/src/shared/constants.dart';
import 'package:mobile_unity/src/widgets/app_bar.dart';
import 'package:mobile_unity/src/widgets/sub_header.dart';

class DetailTaskChild extends StatefulWidget {
  @override
  _DetailTaskChildState createState() => _DetailTaskChildState();
}

class _DetailTaskChildState extends State<DetailTaskChild> {
  String _title;
  String _deadline;
  String _category;
  int _points;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(true, "Tugas Baru"),
      body: ListView(
        physics: ClampingScrollPhysics(),
        padding: EdgeInsets.all(30.0),
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                _buildChildProfile(),
                SizedBox(height: 20.0,),
                _buildTitleField(),
                _buildDeadlineField(),
                _buildCategoryField(),
                _buildPointField(),
                SizedBox(height: 20.0,),
                SubHeader(title: "Progress", isLihatSemua: false,),
                SizedBox(height: 10.0,),
                _buildProgress()
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
          "Lumen",
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
    return TextFormField(
      textInputAction: TextInputAction.search,
      style: TextStyle(
        fontSize: 18.0,
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
        floatingLabelBehavior: FloatingLabelBehavior.never,
        prefixIcon: Icon(Icons.card_giftcard, color: shadowColor,),
      ),
      enabled: false,
      initialValue: "5pts",
      validator: (value) => value.isEmpty ? 'Name is required' : '',
      onSaved: (value) => setState(() => _title = value),
    );
  }

  Widget _buildCategoryField(){
    return TextFormField(
      textInputAction: TextInputAction.search,
      style: TextStyle(
        fontSize: 18.0,
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
        floatingLabelBehavior: FloatingLabelBehavior.never,
        prefixIcon: Icon(Icons.category, color: shadowColor,),
      ),
      enabled: false,
      initialValue: "Pendidikan",
      validator: (value) => value.isEmpty ? 'Name is required' : '',
      onSaved: (value) => setState(() => _title = value),
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
      initialValue: "Berhasil",
      validator: (value) => value.isEmpty ? 'Name is required' : '',
      onSaved: (value) => setState(() => _title = value),
    );
  }

  Widget _buildDeadlineField() {
    return TextFormField(
      textInputAction: TextInputAction.search,
      style: TextStyle(
        fontSize: 18.0,
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
        floatingLabelBehavior: FloatingLabelBehavior.never,
        prefixIcon: Icon(Icons.schedule, color: shadowColor,),
      ),
      enabled: false,
      initialValue: "24-04-2021",
      validator: (value) => value.isEmpty ? 'Name is required' : '',
      onSaved: (value) => setState(() => _title = value),
    );
  }
}
