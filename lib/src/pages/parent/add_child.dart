import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:mobile_unity/src/models/child.dart';
import 'package:mobile_unity/src/services/child_database.dart';
import 'package:mobile_unity/src/shared/constants.dart';
import 'package:mobile_unity/src/widgets/app_bar.dart';
import 'package:mobile_unity/src/widgets/custom_picker.dart';
import 'package:provider/provider.dart';

class AddChildScreen extends StatefulWidget {
  @override
  _AddChildScreenState createState() => _AddChildScreenState();
}

class _AddChildScreenState extends State<AddChildScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime _date;
  final _dateController = TextEditingController();
  final _phoneController = TextEditingController();
  final _nameController = TextEditingController();
  final _genderController = TextEditingController();
  final _childDatabase = ChildDatabase();
  String _selectedGender;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(true, "Tambahkan Anak"),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                _buildChildName(),
                SizedBox(height: 15.0,),
                _buildPhoneNumber(),
                SizedBox(height: 15.0,),
                Row(
                  children: [
                    _buildBornDate(),
                    SizedBox(width: 15.0,),
                    _buildGender(),
                  ],
                ),
                SizedBox(height: 15.0,),
                _buildSubmitButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGender() {
    final List<String> genders = [
      'Laki-laki',
      'Perempuan'
    ];
    return Expanded(
      child: DropdownButtonHideUnderline(
        child: DropdownButtonFormField(
          decoration: InputDecoration(
            alignLabelWithHint: true,
            enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: shadowColor, width: 2.0),
                borderRadius: BorderRadius.circular(20.0)
            ),
            focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: secondaryColor, width: 2.0),
                borderRadius: BorderRadius.circular(20.0)
            ),
          ),
          items: genders.map((e) => DropdownMenuItem(
            child: Text(e),
            value: e,
          )).toList(),
          onChanged: (value){
            setState(() {
              _selectedGender = value;
            });
          },
          hint: Text(
            'Pilih Jenis Kelamin',
            style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                color: shadowColor
            ),
          ),
          value:  _selectedGender,
          validator: (value) => value.isEmpty || value == null ? 'Harap memilih salah satu' : null,
        ),
      ),
    );
  }

  Widget _buildBornDate() => Expanded(
    child: TextFormField(
      onTap: (){
        DatePicker.showPicker(context, showTitleActions: true, onChanged: (date) {
          setState(() {
            _date = date;
            _dateController.text = DateFormat("dd-MM-yyyy").format(_date).toString();
          });
        }, onConfirm: (date) {
          setState(() {
            _date = date;
            _dateController.text = DateFormat("dd-MM-yyyy").format(_date).toString();
          });
        }, pickerModel: CustomPicker(currentTime: DateTime.now()), locale: LocaleType.en);
      },
      readOnly: true,
      style: TextStyle(
        fontWeight: FontWeight.w500,
        fontFamily: 'Poppins',
      ),
      cursorColor: secondaryColor,
      decoration: InputDecoration(
        alignLabelWithHint: true,
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: shadowColor, width: 2.0),
            borderRadius: BorderRadius.circular(20.0)
        ),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: secondaryColor, width: 2.0),
            borderRadius: BorderRadius.circular(20.0)
        ),
        hintText: 'Tanggal Lahir',
        hintStyle: TextStyle(
          fontWeight: FontWeight.w600,
          color: shadowColor,
          fontFamily: 'Poppins',
        ),
        prefixIcon: Icon(Icons.date_range, color: shadowColor,),
        suffixIcon: Icon(Icons.arrow_drop_down, color: shadowColor,),
      ),
      validator: (value) => value.isEmpty || value == null ? 'Deadline masih kosong' : null,
      controller: _dateController,
    ),
  );

  Widget _buildPhoneNumber() => TextFormField(
    decoration: InputDecoration(
      labelText: 'Nomor HP',
      labelStyle: TextStyle(
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w600,
        color: shadowColor,
      ),
      alignLabelWithHint: true,
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: shadowColor, width: 2.0),
          borderRadius: BorderRadius.circular(20.0)
      ),
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: secondaryColor, width: 2.0),
          borderRadius: BorderRadius.circular(20.0)
      ),
      prefix: Row(
        mainAxisSize: MainAxisSize.min,

        children: [
          CircleAvatar(
            backgroundImage: AssetImage("images/indonesia.png"),
            radius: 10.0,
          ),
          SizedBox(width: 5.0,),
          Text(
            "+62",
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600
            ),
          ),
          SizedBox(width: 10.0,),
        ],
      )
    ),
    validator: (value) {
      if (value.length < 12) {
        return 'Masukkan nomor hp yang valid';
      }else{
        return null;
      }
    },
    controller: _phoneController,
  );

  Widget _buildChildName() => TextFormField(
    decoration: InputDecoration(
      labelText: 'Nama Anak',
      labelStyle: TextStyle(
        fontWeight: FontWeight.w600,
        fontFamily: 'Poppins',
        color: shadowColor,
      ),
      alignLabelWithHint: true,
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: shadowColor, width: 2.0),
          borderRadius: BorderRadius.circular(20.0)
      ),
      focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: secondaryColor, width: 2.0),
          borderRadius: BorderRadius.circular(20.0)
      ),
    ),
    controller: _nameController,
    validator: (value) {
      if (value.isEmpty) {
        return 'Nama masih kosong';
      }else{
        return null;
      }
    },
  );

  Widget _buildSubmitButton() {
    final Parent user = Provider.of<Parent>(context);
    final _childDatabase = ChildDatabase();

    return ElevatedButton(
      onPressed: () {
        if (_formKey.currentState.validate()) {
          var answers = {
            'name' : _nameController.text,
            'phone_number' : _phoneController.text,
            'born_date' : _date,
            'created_at' : DateTime.now(),
            'gender' : _genderController.text,
            'parent_id' : user.uid
          };
          // var document = _childDatabase.createTask(answers);
          Navigator.popUntil(context, (route) => route.isFirst);
        }
      },
      child: Text('Simpan Profile Anak'),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(
          secondaryColor
        )
      ),
    );
  }
}
