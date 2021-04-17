import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mobile_unity/src/models/child.dart';
import 'package:mobile_unity/src/models/parent.dart';
import 'package:mobile_unity/src/services/child_database.dart';
import 'package:mobile_unity/src/services/storage.dart';
import 'package:mobile_unity/src/shared/alert_dialog.dart';
import 'package:mobile_unity/src/shared/constants.dart';
import 'package:mobile_unity/src/widgets/app_bar.dart';
import 'package:mobile_unity/src/widgets/custom_picker.dart';
import 'package:provider/provider.dart';

class AddChildScreen extends StatefulWidget {
  @override
  _AddChildScreenState createState() => _AddChildScreenState();
}

class _AddChildScreenState extends State<AddChildScreen> {

  File _image;
  final ImagePicker _picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  DateTime _date;
  final _dateController = TextEditingController();
  final _phoneController = TextEditingController();
  final _nameController = TextEditingController();
  String _selectedGender;
  String _error ='';
  bool _loading = false;
  String _fileError = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(true, "Tambahkan Anak"),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        physics: ClampingScrollPhysics(),
        children: [
          Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(height: 15.0,),
                _buildUploadImage(),
                SizedBox(height: 15.0,),
                _buildUploadButton(),
                _buildChildName(),
                SizedBox(height: 15.0,),
                _buildPhoneNumber(),
                SizedBox(height: 15.0,),
                _buildBornDate(),
                SizedBox(height: 15.0,),
                _buildGender(),
                SizedBox(height: 15.0,),
                _buildSubmitButton(context),
                SizedBox(height: 10.0,),
                Text(
                  _error,
                  style: TextStyle(
                    color: redColor
                  ),
                )
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
    return DropdownButtonHideUnderline(
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
          labelText: "Pilih Jenis Kelamin",
          labelStyle: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              color: shadowColor
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
        value:  _selectedGender,
        validator: (value) => value == null ? 'Harap memilih salah satu' : null,
      ),
    );
  }

  Widget _buildBornDate() => TextFormField(
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
  );

  Widget _buildPhoneNumber() => TextFormField(
    keyboardType: TextInputType.phone,
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
            backgroundImage: AssetImage("assets/images/indonesia.png"),
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
      if (value.length < 10) {
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
      prefixIcon: Icon(Icons.face, color: shadowColor,)
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

  Widget _buildSubmitButton(BuildContext context) {
    final Parent user = Provider.of<Parent>(context);
    return ElevatedButton(
      onPressed: () async {
        if (_image == null) {
          setState(() => _fileError = 'Harap mengupload foto');
        }else
          setState(() => _fileError = '');
        if (_formKey.currentState.validate() && _image != null) {
          var phoneNumber = "+62${_phoneController.text}";
          setState(() => _loading = true);
          if (_loading) {
            createLoadingAlertDialog(context);
          }
          var children = await ChildDatabase().checkPhoneNumber(phoneNumber);
          setState(() => _loading = false);
          if (children.length == 0) {
            Navigator.pop(context);
            setState(() => _error = 'Periksa kembali nomor HP anak');
          }else {
            var imageUrl = await Storage(image: _image, filename: children[0].uid, folderName: "child").uploadPicture();
            setState(() => _error = '');
            var answers = {
              'name' : _nameController.text,
              'born_date' : _date,
              'created_at' : DateTime.now(),
              'gender' : _selectedGender,
              'parent_id' : user.uid,
              'is_profile_filled' : true,
              "image_url" : imageUrl,
            };
            var document = ChildDatabase(uid: children[0].uid).updateChildData(answers);
            Navigator.popUntil(context, (route) => route.isFirst);
          }
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

  Widget _buildUploadImage(){
    return CircleAvatar(
      radius: 50,
      backgroundColor: shadowColor,
      child: ClipOval(
        child: SizedBox(
          width: 150,
          height: 150,
          child: _image != null
              ? Image.file(_image, fit: BoxFit.fill,)
              : Center(
            child: Icon(
              Icons.image,
              color: secondaryColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUploadButton(){
    return TextButton.icon(
      label: Text(
        'Unggah Foto Anak',
        style: TextStyle(
            color: secondaryColor
        ),
      ),
      onPressed: (){
        showModalUploadImageBottom(context, _getImageFromCamera, _getImageFromGallery);
      },
      icon: Icon(
        Icons.camera_alt,
        color: secondaryColor,
      ),
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.all(thirdColor),
        side: MaterialStateProperty.all(
          BorderSide(
            color: secondaryColor,
          ),
        ),

      ),
    );
  }

  Future _getImageFromCamera() async{
    final pickedFile = await _picker.getImage(source: ImageSource.camera, imageQuality: 50);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        Navigator.pop(context);
      });
    }
  }

  Future _getImageFromGallery() async{
    final pickedFile = await _picker.getImage(source: ImageSource.gallery, imageQuality: 50);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        Navigator.pop(context);
      });
    }
  }
}
