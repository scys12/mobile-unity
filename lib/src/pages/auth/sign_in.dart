import 'package:flutter/material.dart';
import 'package:mobile_unity/src/models/child.dart';
import 'package:mobile_unity/src/services/auth.dart';
import 'package:mobile_unity/src/shared/alert_dialog.dart';
import 'package:mobile_unity/src/shared/constants.dart';
import 'package:mobile_unity/src/widgets/loading.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;
  String _error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: thirdColor,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildHeader(),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      SizedBox(height: 20.0,),
                      TextFormField(
                        validator: (val){
                          if(val.isEmpty)
                            return 'Email masih kosong';
                          else if(!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val)) {
                            return 'Tolong masukkan alamat email yang valid';
                          }
                          return null;
                        },
                        controller: _emailController,
                        decoration: textInputDecoration.copyWith(
                          hintText: 'Email',
                          prefixIcon: Icon(
                            Icons.email,
                            color: thirdColor,
                          ),
                        )
                      ),
                      SizedBox(height: 20.0,),
                      TextFormField(
                        validator: (val) => val.length < 6 ? 'Password minimal 6 karakter' : null,
                        controller: _passwordController,
                        obscureText: true,
                        decoration: textInputDecoration.copyWith(
                          hintText: 'Password',
                          prefixIcon: Icon(
                            Icons.vpn_key,
                            color: thirdColor,
                          ),
                        )
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20.0,),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 50.0),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          primaryColor
                      ),
                      padding: MaterialStateProperty.all(
                          EdgeInsets.symmetric(vertical: 15.0)
                      ),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0)
                        )
                      )
                    ),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        setState(() {
                          _loading = true;
                          _error = '';
                        });
                        if (_loading) {
                          createLoadingAlertDialog(context);
                        }
                        var _email = _emailController.text;
                        var _password = _passwordController.text;
                        var result = await _authService.signInWithEmailAndPassword(_email, _password);
                        if (result == null) {
                          setState(() {
                            _loading = false;
                            _error = 'Email/Password salah';
                            _passwordController.text = '';
                          });
                          if (!_loading) {
                            Navigator.pop(context);
                          }
                        }else{
                          Navigator.pushNamedAndRemoveUntil(context, '/welcome', (route)=> false);
                        }
                      }
                    },
                    child: Text(
                      'Masuk',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Poppins',
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10.0,),
                Text(
                  _error.length > 0 ? _error : '',
                  style: TextStyle(
                    color: Colors.red
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Belum punya akun AturUang?',
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontSize: 14.0,
                          fontWeight: FontWeight.w500
                      ),
                    ),
                    TextButton(
                      onPressed: ()=> widget.toggleView(),
                      child: Text(
                        'Daftar',
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
        ),
      ),
    );
  }

  Widget _buildHeader(){
    return Column(
      children: [
        Image(
          image: AssetImage("assets/images/logo.png"),
        ),
        SizedBox(height: 30.0,),
        Text(
          "Selamat Datang di AturUang!",
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 25.0,
            fontWeight: FontWeight.w600
          ),
        ),
      ],
    );
  }
}
