import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:mobile_unity/src/services/task_database.dart';
import 'package:mobile_unity/src/shared/constants.dart';
import 'package:mobile_unity/src/widgets/app_bar.dart';
import 'package:mobile_unity/src/widgets/custom_picker.dart';

class NewTaskChild extends StatefulWidget {
  @override
  _NewTaskChildState createState() => _NewTaskChildState();
}

class _NewTaskChildState extends State<NewTaskChild> {

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  int _value = 1;
  bool _loading = false;
  DateTime _date;
  final _pointController = TextEditingController();
  final _categoryController = TextEditingController();
  final _titleController = TextEditingController();
  final _deadlineController = TextEditingController();
  final _taskDatabase = TaskDatabase();

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
                  SizedBox(height: 10.0,),
                  _buildDeadlineField(),
                  SizedBox(height: 10.0,),
                  _buildCategoryField(),
                  SizedBox(height: 10.0,),
                  _buildPointField(),
                  SizedBox(height: 5.0,),
                  _buildSliderPoint(),
                  SizedBox(height: 20.0,),
                  Container(
                    alignment: Alignment.centerRight,
                    child: _buildSubmitButton(),
                  ),
                ],
              ),
            ),
          ],
        )
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
      onPressed: () async {
        if (_formKey.currentState.validate()) {
          var answers = {
            'title' : _titleController.text,
            'point' : _value,
            'category' : _categoryController.text,
            'deadline': _date,
            'created_at' : DateTime.now(),
            'is_done' : false
          };
          setState(() => _loading = true);
          print(answers);
          var document = _taskDatabase.createTask(answers);
          Navigator.popUntil(context, (route) => route.isFirst);
        }
      },
      child: _loading ? CircularProgressIndicator() : Text('Buat Tugas'),
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
      controller: _pointController..text="${_value.toString()} pts",
      validator:  (value) {
        if (value == null || value.isEmpty) {
          return 'Point masih kosong';
        }
        return null;
      },
    );
  }
  Widget _buildSliderPoint(){
    return Slider(
      activeColor: secondaryColor,
      inactiveColor: thirdColor,
      min: 1.0,
      max: 10.0,
      value: _value.toDouble(),
      onChanged: (val) {
        setState(() => _value = val.toInt());
        _pointController.text = _value.toString();
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
      controller: _categoryController,
      validator:  (value) {
        if (value == null || value.isEmpty) {
          return 'Kategori masih kosong';
        }
        return null;
      },
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
          hintText: 'Judul Tugas',
          hintStyle: TextStyle(
            fontSize: 20.0,
            fontWeight: FontWeight.w600,
            color: shadowColor,
            fontFamily: 'Poppins',
          ),

          floatingLabelBehavior: FloatingLabelBehavior.never
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Judul masih kosong';
        }
        return null;
      },
      controller: _titleController,
    );
  }

  Widget _buildDeadlineField() {
    return TextFormField(

      onTap: (){
        DatePicker.showPicker(context, showTitleActions: true, onChanged: (date) {
          setState(() {
            _date = date;
            _deadlineController.text = DateFormat("dd-MM-yyyy").format(_date).toString();
          });
        }, onConfirm: (date) {
          setState(() {
            _date = date;
            _deadlineController.text = DateFormat("dd-MM-yyyy").format(_date).toString();
          });
        }, pickerModel: CustomPicker(currentTime: DateTime.now()), locale: LocaleType.en);
      },
      readOnly: true,
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
        suffixIcon: Icon(Icons.arrow_drop_down, color: shadowColor,),
      ),
      validator: (value) => value.isEmpty || value == null ? 'Deadline masih kosong' : null,
      controller: _deadlineController,
    );
  }
}
