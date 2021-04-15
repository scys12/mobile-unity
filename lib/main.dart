import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mobile_unity/src/models/parent.dart';
import 'package:mobile_unity/src/models/tab_index.dart';
import 'package:mobile_unity/src/models/task.dart';
import 'package:mobile_unity/src/pages/auth/authenticate.dart';
import 'package:mobile_unity/src/pages/child/dashboard.dart';
import 'package:mobile_unity/src/pages/parent/add_child.dart';
import 'package:mobile_unity/src/pages/parent/child_achievement.dart';
import 'package:mobile_unity/src/pages/parent/child_task.dart';
import 'package:mobile_unity/src/pages/parent/dashboard.dart';
import 'package:mobile_unity/src/pages/parent/detail_task.dart';
import 'package:mobile_unity/src/pages/parent/list_all_educations.dart';
import 'package:mobile_unity/src/pages/parent/list_all_tasks.dart';
import 'package:mobile_unity/src/pages/parent/new_education.dart';
import 'package:mobile_unity/src/pages/parent/new_task.dart';
import 'package:mobile_unity/src/pages/splashscreen.dart';
import 'package:mobile_unity/src/pages/wrapper.dart';
import 'package:mobile_unity/src/services/auth.dart';
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
        future: Future.delayed(Duration(seconds: 2)),
        builder: (contextSplash, snapshotSplash) {
          if (snapshotSplash.connectionState == ConnectionState.waiting) {
            return MaterialApp(home: SplashScreen());
          } else {
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
                          value: AuthService().user,
                          initialData: Parent(name: '', uid: ''),
                        ),
                        StreamProvider<List<Task>>.value(
                          value: TaskDatabase().getTasks(2),
                          initialData: [],
                        ),
                        ChangeNotifierProvider(create: (e) => TabIndex())
                      ],
                      child: MaterialApp(
                        home: Wrapper(),
                        routes: {
                          '/authenticate': (context) => Authenticate(),
                          '/parent/dashboard': (context) => DashboardParent(),
                          '/parent/task': (context) => ChildTask(),
                          '/parent/add_child': (context) => AddChildScreen(),
                          '/parent/new_task': (context) => NewTaskChild(),
                          '/parent/new_education': (context) => NewEducationChild(),
                          '/parent/all_tasks': (context) => ListChildTasks(),
                          '/parent/all_educations': (context) =>
                              ListChildEducations(),
                          '/parent/detail_task': (context) => DetailTaskChild(),
                          '/child/dashboard': (context) => DashboardChild()
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
        });
  }
}
