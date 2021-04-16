import 'package:flutter/material.dart';
import 'package:mobile_unity/src/models/child.dart';
import 'package:mobile_unity/src/models/parent.dart';
import 'package:mobile_unity/src/pages/auth/authenticate.dart';
import 'package:mobile_unity/src/pages/auth/sign_phone.dart';
import 'package:mobile_unity/src/pages/kid/dashboard.dart';
import 'package:mobile_unity/src/pages/parent/wrapper.dart';
import 'package:mobile_unity/src/provider/child_provider.dart';
import 'package:mobile_unity/src/services/auth.dart';
import 'package:mobile_unity/src/services/child_database.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Parent parent = Provider.of<Parent>(context);
    final Child child = Provider.of<Child>(context);
    if (parent != null) {
      return MultiProvider(
        providers: [
          StreamProvider<List<Child>>.value(
            value: ChildDatabase().getChildrenFromParent(parent.uid),
            initialData: [],
          ),
        ],
        child: WrapperParent(),
      );
    }
    else if (child != null) {
      return DashboardKid();
    }
    else return Scaffold(
      body: ListView(
        children: [
          Image(image: AssetImage("assets/images/splash.png"),),
          Text(
            "Daftar Sebagai",
            style: TextStyle(
                color: Colors.black,
                fontFamily: 'Poppins',
                fontSize: 40.0,
                fontWeight: FontWeight.w600,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/auth/sign_phone');
            },
            child: Text("Anak"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, '/authenticate');
            },
            child: Text("Orang Tua"),
          )
        ],
      ),
    );
  }
}

