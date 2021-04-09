import 'package:flutter/material.dart';
import 'package:mobile_unity/src/services/auth.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _authService = AuthService();
  String _email = '';
  String _password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[100],
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
        child: Form(
          child: Column(
            children: [
              SizedBox(height: 20.0,),
              TextFormField(
                  onChanged: (val){
                    setState(() => _email = val);
                  }
              ),
              SizedBox(height: 20.0,),
              TextFormField(
                onChanged: (val){
                  setState(() => _password = val);
                },
                obscureText: true,
              ),
              SizedBox(height: 20.0,),
              ElevatedButton(
                onPressed: () async {

                },
                child: Text(
                  'Sign in',
                  style: TextStyle(
                      color: Colors.white
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
