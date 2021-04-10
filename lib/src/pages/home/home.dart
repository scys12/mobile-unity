import 'package:flutter/material.dart';
import 'package:mobile_unity/src/services/auth.dart';

class Home extends StatelessWidget {
  final AuthService _authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ElevatedButton(
        child: Text('Log out'),
        onPressed: () async {
          await _authService.signOut();
        },
      ),
    );
  }
}
