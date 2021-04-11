import 'package:flutter/material.dart';
import 'package:mobile_unity/src/shared/constants.dart';
import 'package:mobile_unity/src/widgets/app_bar.dart';

class NewEducationChild extends StatefulWidget {
  @override
  _NewEducationChildState createState() => _NewEducationChildState();
}

class _NewEducationChildState extends State<NewEducationChild> {
  String _title;
  String _deadline;
  String _category;
  int _points;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int value = 1;
  final _pointController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(true, "Edukasi Baru"),
      body: Container(
        margin: EdgeInsets.all(25.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildChildProfile(),
              SizedBox(height: 20.0,),
              _buildTitleField(),
              _buildDeadlineField(),
              _buildCategoryField(),
              _buildPointField(),
              _buildSliderPoint(),
              SizedBox(height: 20.0,),
              Container(
                alignment: Alignment.centerRight,
                child: _buildSubmitButton(),
              ),
            ],
          ),
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
      child: Text('Buat Edukasi'),
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
        hintText: 'Hadiah',
        hintStyle: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.w500,
          color: shadowColor,
          fontFamily: 'Poppins',
        ),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        prefixIcon: Icon(Icons.card_giftcard, color: shadowColor,),
      ),
      enabled: false,
      controller: _pointController..text="${value.toString()} pts",
      validator: (value) => value.isEmpty ? 'Name is required' : '',
      onSaved: (value) => setState(() => _title = value),
    );
  }
  Widget _buildSliderPoint(){
    return Slider(
      activeColor: secondaryColor,
      inactiveColor: thirdColor,
      min: 1.0,
      max: 10.0,
      value: value.toDouble(),
      onChanged: (val) {
        setState(() => value = val.toInt());
        _pointController.text = value.toString();
      },
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
        hintText: 'Kategori',
        hintStyle: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.w500,
          color: shadowColor,
          fontFamily: 'Poppins',
        ),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        prefixIcon: Icon(Icons.category, color: shadowColor,),
      ),
      enabled: false,
      initialValue: 'Edukasi Finansial',
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
          hintText: 'Judul Edukasi',
          hintStyle: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w600,
            color: shadowColor,
            fontFamily: 'Poppins',
          ),

          floatingLabelBehavior: FloatingLabelBehavior.never
      ),
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
        hintText: 'Batas',
        hintStyle: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.w500,
          color: shadowColor,
          fontFamily: 'Poppins',
        ),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        prefixIcon: Icon(Icons.schedule, color: shadowColor,),
      ),
      validator: (value) => value.isEmpty ? 'Name is required' : '',
      onSaved: (value) => setState(() => _title = value),
    );
  }
}
