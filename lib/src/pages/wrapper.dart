
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
import 'package:mobile_unity/src/pages/teenager/wrapper.dart';
import 'package:mobile_unity/src/pages/welcome.dart';
import 'package:mobile_unity/src/provider/child_provider.dart';
import 'package:mobile_unity/src/services/auth.dart';
import 'package:mobile_unity/src/services/child_database.dart';
import 'package:mobile_unity/src/widgets/loading.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Parent parent = Provider.of<Parent>(context);
    final Teenager teenager = Provider.of<Teenager>(context);
    final Child child = Provider.of<Child>(context);
    var _authUser = Provider.of<AuthUser>(context);
    print("auth user ${_authUser.uid}");
    if(_authUser == null)
      return Welcome();
    if (parent != null) {
      return WrapperParent();
    }
    if (child != null) {
      if (child.parentId == "") return NotAssigned();
      else return WrapperChildren();
    }
    if (teenager != null) {
      return WrapperTeenager();
    }
    else
      return Loading();
  }
}