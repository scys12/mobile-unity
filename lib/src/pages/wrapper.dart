import 'package:flutter/material.dart';
import 'package:mobile_unity/src/models/child.dart';
import 'package:mobile_unity/src/models/parent.dart';
import 'package:mobile_unity/src/models/teenager.dart';
import 'package:mobile_unity/src/models/user.dart';
import 'package:mobile_unity/src/pages/auth/authenticate.dart';
import 'package:mobile_unity/src/pages/auth/sign_phone.dart';
import 'package:mobile_unity/src/pages/kid/dashboard.dart';
import 'package:mobile_unity/src/pages/kid/not_assigned.dart';
import 'package:mobile_unity/src/pages/kid/wrapper.dart';
import 'package:mobile_unity/src/pages/parent/wrapper.dart';
import 'package:mobile_unity/src/pages/teenager/dashboard.dart';
import 'package:mobile_unity/src/pages/welcome.dart';
import 'package:mobile_unity/src/provider/child_provider.dart';
import 'package:mobile_unity/src/services/auth.dart';
import 'package:mobile_unity/src/services/child_database.dart';
import 'package:mobile_unity/src/services/parent_database.dart';
import 'package:mobile_unity/src/services/teenager_database.dart';
import 'package:mobile_unity/src/widgets/loading.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  Parent _parent;
  Child _child;
  Teenager _teenager;
  AuthUser _authUser;

  @override
  Widget build(BuildContext context) {
    _authUser = Provider.of<AuthUser>(context);
    if (_authUser != null ) {
      if (_authUser.providerId == 'password') {
        return MultiProvider(
          providers: [
            StreamProvider<Parent>.value(
              value: ParentDatabase(uid: _authUser.uid).getParentData(),
              initialData: null,
            ),
            StreamProvider<Teenager>.value(
              value: TeenagerDatabase(uid: _authUser.uid).getTeenagerData(),
              initialData: null,
            ),
          ],
          child: Builder(
            builder:(context){
              _parent = Provider.of<Parent>(context);
              _teenager = Provider.of<Teenager>(context);
              if (_parent != null) {
                return WrapperParent();
              }
              else if (_teenager != null) return DashboardTeenager();
              else return Loading();
            }
          )
        );
      }
      else{
        return MultiProvider(
            providers: [
              StreamProvider<Child>.value(
                value: ChildDatabase(uid: _authUser.uid).getChildData(),
                initialData: null,
              ),
            ],
            child: Builder(
              builder: (context){
                _child = Provider.of<Child>(context);
                if(_child != null){
                  if(_child.parentId.length == 0) {
                    return NotAssigned();
                  }
                  else return WrapperChildren();
                }
                return Loading();
              },
            )
        );
      }
    }
    else {
      return Welcome();
    }
  }
}


