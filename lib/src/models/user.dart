import 'package:flutter/cupertino.dart';

class AuthUser extends ChangeNotifier{
  final String uid;
  final String providerId;
  final String authId;

  AuthUser({this.uid, this.providerId, this.authId});
}