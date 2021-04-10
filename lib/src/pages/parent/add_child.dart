import 'package:flutter/material.dart';
import 'package:mobile_unity/src/shared/constants.dart';
import 'package:mobile_unity/src/widgets/app_bar.dart';

class AddChildScreen extends StatefulWidget {
  @override
  _AddChildScreenState createState() => _AddChildScreenState();
}

class _AddChildScreenState extends State<AddChildScreen> {
  final _formKey = GlobalKey<FormState>();
  String name = '';
  String phone_number = '';
  String born_date = '';
  int gender = 0;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(true, "Tambahkan Anak"),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            _buildChildName(),
            SizedBox(height: 16.0,),
            _buildPhoneNumber(),
            SizedBox(height: 16.0,),
            Row(
              children: [
                _buildBornDate(),
                SizedBox(width: 16.0,),
                _buildGender(),
              ],
            ),
            SizedBox(height: 16.0,),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildGender() => Expanded(
    child: TextFormField(
      decoration: InputDecoration(
        labelText: 'Jenis Kelamin',
        labelStyle: TextStyle(
          color: Colors.black,
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
      onChanged: (value) => setState(() => born_date = value),
    ),
  );

  Widget _buildBornDate() => Expanded(
    child: TextFormField(
      decoration: InputDecoration(
        labelText: 'Tanggal Lahir',
        labelStyle: TextStyle(
          color: Colors.black,
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
      validator: (value) {
        if (value.length < 12) {
          return 'Masukkan nomor hp yang valid';
        }else{
          return null;
        }
      },
      onChanged: (value) => setState(() => born_date = value),
    ),
  );

  Widget _buildPhoneNumber() => TextFormField(
    decoration: InputDecoration(
      labelText: 'Nomor HP',
      labelStyle: TextStyle(
        color: Colors.black,
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
    validator: (value) {
      if (value.length < 12) {
        return 'Masukkan nomor hp yang valid';
      }else{
        return null;
      }
    },
    onChanged: (value) => setState(() => phone_number = value),
  );

  Widget _buildChildName() => TextFormField(
    decoration: InputDecoration(
      labelText: 'Nama anak',
      labelStyle: TextStyle(
        color: Colors.black,
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
    validator: (value) {
      if (value.length < 4) {
        return 'Masukkan minimal 4 karakter';
      }else{
        return null;
      }
    },
    onChanged: (value) => setState(() => name = value),
  );

  Widget _buildSubmitButton() => ElevatedButton(
    onPressed: () {},
    child: Text('Simpan Profile Anak'),
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(
        secondaryColor
      )
    ),
  );
}
