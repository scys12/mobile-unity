import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mobile_unity/src/models/child.dart';
import 'package:mobile_unity/src/models/parent.dart';
import 'package:mobile_unity/src/models/teenager.dart';
import 'package:mobile_unity/src/services/child_database.dart';
import 'package:mobile_unity/src/services/parent_database.dart';
import 'package:mobile_unity/src/services/storage.dart';
import 'package:mobile_unity/src/services/teenager_database.dart';
import 'package:mobile_unity/src/shared/alert_dialog.dart';
import 'package:mobile_unity/src/shared/constants.dart';
import 'package:mobile_unity/src/widgets/app_bar.dart';
import 'package:mobile_unity/src/widgets/custom_picker.dart';
import 'package:provider/provider.dart';

class ChangeProfileTeenager extends StatefulWidget {
  @override
  _ChangeProfileTeenagerState createState() => _ChangeProfileTeenagerState();
}

class _ChangeProfileTeenagerState extends State<ChangeProfileTeenager> {

  File _image;
  final ImagePicker _picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  TextEditingController _phoneController;
  TextEditingController _nameController;
  String _selectedGender;
  String _fileError = '';
  Teenager user;
  DateTime _date;
  TextEditingController _dateController;
  @override
  void initState() {
    super.initState();
    user = Provider.of<Teenager>(context, listen: false);
    _phoneController = TextEditingController(text: user.phoneNumber.length > 0 ? user.phoneNumber.substring(3) : "");
    _nameController = TextEditingController(text: user.name);
    _dateController = TextEditingController(text: DateFormat("dd-MM-yyyy").format(user.bornDate).toString());
    _date = user.bornDate;
    _selectedGender = user.gender.length == 0 ? "Laki-laki" : user.gender;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(true, "Ganti Profile"),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: 15.0,),
                _buildUploadImage(user.imageUrl),
                SizedBox(height: 15.0,),
                _buildUploadButton(),
                Text(
                  _fileError,
                  style: TextStyle(
                    color: redColor
                  ),
                ),
                SizedBox(height: 15.0,),
                _buildName(user.name),
                SizedBox(height: 15.0,),
                _buildPhoneNumber(user.phoneNumber),
                SizedBox(height: 15.0,),
                SizedBox(height: 15.0,),
                _buildBornDate(),
                SizedBox(height: 15.0,),
                _buildGender(user.gender),
                SizedBox(height: 15.0,),
                _buildSubmitButton(user.uid),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhoneNumber(String phoneNumber) => TextFormField(
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
    keyboardType: TextInputType.phone,
    controller: _phoneController,
  );

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
      labelText: "Tanggal Lahir",
      labelStyle: TextStyle(
        fontFamily: 'Poppins',
        color: shadowColor
      ),
      prefixIcon: Icon(Icons.date_range, color: shadowColor,),
      suffixIcon: Icon(Icons.arrow_drop_down, color: shadowColor,),
    ),
    validator: (value) => value.isEmpty || value == null ? 'Deadline masih kosong' : null,
    controller: _dateController,
  );

  Widget _buildGender(String gender) {
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


  Widget _buildName(String name) => TextFormField(
    decoration: InputDecoration(
      labelText: 'Nama',
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

  Widget _buildSubmitButton(String uid) {
    return ElevatedButton(
      onPressed: () async {
        if (_image == null && user.imageUrl.length == 0) {
          setState(() => _fileError = 'Harap mengupload foto');
        }else
          setState(() => _fileError = '');
        if (_formKey.currentState.validate() && (_image != null || user.imageUrl.length > 0)) {
          setState(() => _loading = true);
          if (_loading) {
            createLoadingAlertDialog(context);
          }
          var imageUrl = _image != null ? await Storage(image: _image, filename: uid, folderName: "teenager").uploadPicture() : user.imageUrl;
          var answers = {
            'born_date' : _date,
            'name' : _nameController.text,
            'gender' : _selectedGender,
            'is_profile_filled' : true,
            'phone_number' : "+62${_phoneController.text}",
            'image_url' : imageUrl
          };
          var resp = await TeenagerDatabase(uid: uid).updateTeenagerData(answers);
          Navigator.pop(context);
          Navigator.pushReplacementNamed(context, '/teenager/wrapper');
        }
      },
      child: Text('Simpan Profile'),
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(
              secondaryColor
          )
      ),
    );
  }

  Widget _buildUploadImage(String imageUrl){
    return CircleAvatar(
      radius: 50,
      backgroundColor: shadowColor,
      child: ClipOval(
        child: SizedBox(
          width: 150,
          height: 150,
          child: (_image != null)
              ? Image.file(_image, fit: BoxFit.fill,)
              : imageUrl.length > 0
              ? ClipRRect(
              child: Image.network(
                imageUrl,
                fit: BoxFit.fill,
                height: 50,
                width: 50,
              )) : Center(
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
        'Unggah Foto',
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
