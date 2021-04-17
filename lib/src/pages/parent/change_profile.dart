import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_unity/src/models/parent.dart';
import 'package:mobile_unity/src/services/parent_database.dart';
import 'package:mobile_unity/src/shared/alert_dialog.dart';
import 'package:mobile_unity/src/shared/constants.dart';
import 'package:mobile_unity/src/widgets/app_bar.dart';
import 'package:provider/provider.dart';

class ChangeProfileScreen extends StatefulWidget {
  @override
  _ChangeProfileScreenState createState() => _ChangeProfileScreenState();
}

class _ChangeProfileScreenState extends State<ChangeProfileScreen> {

  File _image;
  final ImagePicker _picker = ImagePicker();
  final _formKey = GlobalKey<FormState>();
  bool _loading = false;
  final _phoneController = TextEditingController();
  final _nameController = TextEditingController();
  String _selectedGender;

  @override
  Widget build(BuildContext context) {
    final Parent user = Provider.of<Parent>(context);

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
                _buildUploadImage(),
                SizedBox(height: 15.0,),
                _buildUploadButton(),
                SizedBox(height: 15.0,),
                _buildName(user.name),
                SizedBox(height: 15.0,),
                _buildPhoneNumber(user.phoneNumber),
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

  Widget _buildGender(String gender) {
    final List<String> genders = [
      'Laki-laki',
      'Perempuan'
    ];
    setState(() => _selectedGender = gender);
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
    controller: _phoneController..text = phoneNumber.substring(3),
  );

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
    controller: _nameController..text = name,
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
        if (_formKey.currentState.validate()) {
          var answers = {
            'name' : _nameController.text,
            'phone_number' : "+62${_phoneController.text}",
            'gender' : _selectedGender,
            'is_profile_filled' : true,
          };
          setState(() => _loading = true);
          if (_loading) {
            createLoadingAlertDialog(context);
          }
          var resp = await ParentDatabase(uid: uid).updateParentData(answers);
          Navigator.pop(context);
          Navigator.popUntil(context, (route) => route.isFirst);
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

  Widget _buildUploadImage(){
    return Container(
      height: 200.0,
      width: 200.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: shadowColor,
        border: Border.all(
          color: secondaryColor,
          width: 2.0,
        )
      ),
      child: Center(
        child: Icon(
          Icons.image,
          color: secondaryColor,
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
        _showModalBottom();
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
    final pickedFile = await _picker.getImage(source: ImageSource.camera);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future _getImageFromGallery() async{
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _showModalBottom(){
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: Text(
                        'Unggah foto melalui',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 18.0,
                          fontWeight: FontWeight.w500
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          TextButton.icon(
                            label: Text(
                              'Camera',
                              style: TextStyle(
                                color: secondaryColor
                              ),
                            ),
                            icon: Icon(Icons.camera,color: secondaryColor),
                            onPressed: (){
                              _getImageFromCamera();
                            },
                            style: ButtonStyle(
                              overlayColor: MaterialStateProperty.all(thirdColor),
                              side: MaterialStateProperty.all(
                                BorderSide(
                                  color: secondaryColor,
                                ),
                              ),

                            ),
                          ),
                          TextButton.icon(
                            label: Text(
                              'Gallery',
                              style: TextStyle(
                                  color: secondaryColor
                              ),
                            ),
                            icon: Icon(Icons.image,color: secondaryColor),
                            onPressed: (){
                              _getImageFromGallery();
                            },
                            style: ButtonStyle(
                              overlayColor: MaterialStateProperty.all(thirdColor),
                              side: MaterialStateProperty.all(
                                BorderSide(
                                  color: secondaryColor,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              )
            )
          );
        }
    );
  }
}
