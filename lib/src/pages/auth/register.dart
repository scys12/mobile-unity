import 'package:flutter/material.dart';
import 'package:mobile_unity/src/services/auth.dart';
import 'package:mobile_unity/src/shared/constants.dart';
import 'package:mobile_unity/src/widgets/loading.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  Register({this.toggleView});
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();

  String _email = '';
  String _password = '';
  String _error = '';
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      backgroundColor: Colors.brown[100],
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 20.0,),
              TextFormField(
                validator: (val) => val.isEmpty ? 'Enter an email' : null,
                onChanged: (val){
                  setState(() => _email = val);
                },
                decoration: textInputDecoration.copyWith(hintText: 'Email')
              ),
              SizedBox(height: 20.0,),
              TextFormField(
                validator: (val) => val.length < 6 ? 'Enter password with minimal 6 length' : null,
                onChanged: (val){
                  setState(() => _password = val);
                },
                obscureText: true,
                decoration: textInputDecoration.copyWith(hintText: 'Password')
              ),
              SizedBox(height: 20.0,),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    setState(() => loading = true);
                    dynamic result  = await _authService.registerEmailAndPassword(_email, _password);
                    if (result == null)
                      setState(() => {
                        _error = 'Email/Password wrong',
                        loading=false,
                      });
                  }
                },
                child: Text(
                  'Register',
                  style: TextStyle(
                      color: Colors.white
                  ),
                ),
              ),
              SizedBox(height: 15.0,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                      'Sudah Punya Akun FinApp?'
                  ),
                  TextButton(
                    onPressed: ()=>widget.toggleView(),
                    child: Text('Masuk'),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
