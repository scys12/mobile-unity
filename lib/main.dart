
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mobile_unity/src/models/child.dart';
import 'package:mobile_unity/src/models/parent.dart';
import 'package:mobile_unity/src/models/tab_index.dart';
import 'package:mobile_unity/src/pages/auth/authenticate.dart';
import 'package:mobile_unity/src/pages/auth/sign_phone.dart';
import 'file:///D:/FlutterProject/mobile_unity/lib/src/pages/kid/transactions.dart';
import 'package:mobile_unity/src/pages/kid/dashboard.dart';
import 'package:mobile_unity/src/pages/kid/add_wish.dart';
import 'package:mobile_unity/src/pages/kid/detail_task.dart';
import 'package:mobile_unity/src/pages/kid/inner_income.dart';
import 'package:mobile_unity/src/pages/kid/inner_outcome.dart';
import 'package:mobile_unity/src/pages/kid/kid_task.dart';
import 'package:mobile_unity/src/pages/kid/kid_wishes.dart';
import 'package:mobile_unity/src/pages/parent/add_child.dart';
import 'package:mobile_unity/src/pages/parent/change_profile.dart';
import 'package:mobile_unity/src/pages/parent/detail_task.dart';
import 'package:mobile_unity/src/pages/parent/list_all_educations.dart';
import 'package:mobile_unity/src/pages/parent/list_all_tasks.dart';
import 'package:mobile_unity/src/pages/parent/list_all_wishes.dart';
import 'package:mobile_unity/src/pages/parent/new_education.dart';
import 'package:mobile_unity/src/pages/parent/new_task.dart';
import 'package:mobile_unity/src/pages/parent/transactions.dart';
import 'package:mobile_unity/src/pages/parent/wrapper.dart';
import 'package:mobile_unity/src/pages/welcome_parent_child.dart';
import 'package:mobile_unity/src/pages/wrapper.dart';
import 'package:mobile_unity/src/provider/child_provider.dart';
import 'package:mobile_unity/src/provider/finance_provider.dart';
import 'package:mobile_unity/src/provider/task_provider.dart';
import 'package:mobile_unity/src/provider/wish_provider.dart';
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
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print('You have an error! ${snapshot.error.toString()}');
          return Text('Something went wrong');
        } else if (snapshot.hasData) {
          return MultiProvider(
              providers: [
                StreamProvider<Parent>.value(
                  value: AuthService().parent,
                  initialData: Parent(),
                ),
                StreamProvider<Child>.value(
                  value: AuthService().child,
                  initialData: Child(),
                ),
                ChangeNotifierProvider(create: (e) => TabIndex()),
                ChangeNotifierProvider(
                  create: (c) => ChildProvider(),
                ),
                ChangeNotifierProvider(
                  create: (c) => TaskProvider(),
                ),
                ChangeNotifierProvider(
                  create: (c) => WishProvider(),
                ),
                ChangeNotifierProvider(
                  create: (c) => FinancialProvider(),
                ),
              ],
              child: MaterialApp(
                home: Wrapper(),
                routes: {
                  '/authenticate': (context) => Authenticate(),
                  '/welcome': (context) => Wrapper(),
                  '/welcome/child_parent': (context) => WelcomeParentChild(),
                  '/parent/add_child': (context) => AddChildScreen(),
                  '/parent/new_task': (context) => NewTaskChild(),
                  '/parent/wrapper': (context) => WrapperParent(),
                  '/parent/new_education': (context) => NewEducationChild(),
                  '/parent/all_tasks': (context) => ListChildTasks(),
                  '/parent/all_educations': (context) => ListChildEducations(),
                  '/parent/detail_task': (context) => DetailTaskChild(),
                  '/auth/sign_phone': (context) => SignPhone(),
                  '/parent/change_profile': (context) => ChangeProfileScreen(),
                  '/parent/all_wishes': (context) => ListChildWishes(),
                  '/parent/transactions': (context) => ChildTransactions(),
                  '/child/dashboard': (context) => DashboardKid(),
                  '/child/tasks': (context) => KidTask(),
                  '/child/new_income': (context) => InnerIncome(),
                  '/child/new_outcome': (context) => InnerOutcome(),
                  '/child/transactions': (context) => KidTransactions(),
                  '/child/all_wishes': (context) => AllKidWishes(),
                  '/child/add_wish': (context) => AddWish(),
                  '/child/detail_task': (context) => DetailTaskKid(),
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