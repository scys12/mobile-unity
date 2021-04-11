import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mobile_unity/src/models/user.dart';
import 'package:mobile_unity/src/pages/auth/authenticate.dart';
import 'package:mobile_unity/src/pages/parent/add_child.dart';
import 'package:mobile_unity/src/pages/parent/child_task.dart';
import 'package:mobile_unity/src/pages/parent/dashboard.dart';
import 'package:mobile_unity/src/pages/parent/new_task.dart';
import 'package:mobile_unity/src/pages/wrapper.dart';
import 'package:mobile_unity/src/services/auth.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final Future<FirebaseApp> _fbApp = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _fbApp,
      builder: (context, snapshot){
        if(snapshot.hasError) {
          print('You have an error! ${snapshot.error.toString()}');
          return Text('Something went wrong');
        }else if(snapshot.hasData) {
          return StreamProvider<User>.value(
            value: AuthService().user,
            initialData: User(name: '', uid: ''),
            child: MaterialApp(
              home: Wrapper(),
              routes: {
                '/authenticate' : (context) => Authenticate(),
                '/parent/dashboard' : (context) => DashboardParent(),
                '/parent/task' : (context) => ChildTask(),
                '/parent/add_child' : (context) => AddChildScreen(),
                '/parent/new_task' : (context) => NewTaskChild()
              },
            ),
          );
        }else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
