import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mobile_unity/src/models/child.dart';
import 'package:mobile_unity/src/models/parent.dart';
import 'package:mobile_unity/src/models/tab_index.dart';
import 'package:mobile_unity/src/models/task.dart';
import 'package:mobile_unity/src/pages/auth/authenticate.dart';
import 'package:mobile_unity/src/pages/auth/otp.dart';
import 'package:mobile_unity/src/pages/auth/sign_phone.dart';
import 'package:mobile_unity/src/pages/kid/dashboard.dart';
import 'package:mobile_unity/src/pages/kid/kid_task.dart';
import 'package:mobile_unity/src/pages/kid/wrapper.dart';
import 'package:mobile_unity/src/pages/parent/add_child.dart';
import 'package:mobile_unity/src/pages/parent/change_profile.dart';
import 'package:mobile_unity/src/pages/parent/detail_task.dart';
import 'package:mobile_unity/src/pages/parent/list_all_educations.dart';
import 'package:mobile_unity/src/pages/parent/list_all_tasks.dart';
import 'package:mobile_unity/src/pages/parent/new_education.dart';
import 'package:mobile_unity/src/pages/parent/new_task.dart';
import 'package:mobile_unity/src/pages/parent/wrapper.dart';
import 'package:mobile_unity/src/pages/wrapper.dart';
import 'package:mobile_unity/src/provider/child_provider.dart';
import 'package:mobile_unity/src/services/auth.dart';
import 'package:mobile_unity/src/services/child_database.dart';
import 'package:mobile_unity/src/services/task_database.dart';
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
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print('You have an error! ${snapshot.error.toString()}');
          return Text('Something went wrong');
        } else if (snapshot.hasData) {
          return MultiProvider(
              providers: [
                StreamProvider<Parent>.value(
                  value: AuthService().parent,
                  initialData: null,
                ),
                StreamProvider<Child>.value(
                  value: AuthService().child,
                  initialData: null,
                ),
                StreamProvider<List<Task>>.value(
                  value: TaskDatabase().getTasks(2),
                  initialData: [],
                ),
                ChangeNotifierProvider(create: (e) => TabIndex()),
                ChangeNotifierProvider(
                  create: (c) => ChildProvider(),
                ),
              ],
              child: MaterialApp(
                home: WrapperChildren(),
                routes: {
                  '/authenticate': (context) => Authenticate(),
                  '/welcome': (context) => Wrapper(),
                  '/parent/add_child': (context) => AddChildScreen(),
                  '/parent/new_task': (context) => NewTaskChild(),
                  '/parent/wrapper': (context) => WrapperParent(),
                  '/parent/new_education': (context) => NewEducationChild(),
                  '/parent/all_tasks': (context) => ListChildTasks(),
                  '/parent/all_educations': (context) => ListChildEducations(),
                  '/parent/detail_task': (context) => DetailTaskChild(),
                  '/child/dashboard': (context) => DashboardKid(),
                  '/auth/sign_phone': (context) => SignPhone(),
                  '/parent/change_profile': (context) => ChangeProfileScreen(),
                },
              ));
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
