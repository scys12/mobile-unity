import 'package:flutter/material.dart';
import 'package:mobile_unity/src/models/challenge.dart';
import 'package:mobile_unity/src/models/child.dart';
import 'package:mobile_unity/src/models/tab_index.dart';
import 'package:mobile_unity/src/models/task.dart';
import 'package:mobile_unity/src/models/teenager.dart';
import 'package:mobile_unity/src/models/wish.dart';
import 'package:mobile_unity/src/pages/kid/achievement.dart';
import 'package:mobile_unity/src/pages/kid/dashboard.dart';
import 'package:mobile_unity/src/pages/kid/inner_income.dart';
import 'package:mobile_unity/src/pages/kid/kid_task.dart';
import 'package:mobile_unity/src/pages/kid/setting.dart';
import 'package:mobile_unity/src/pages/teenager/achievement.dart';
import 'package:mobile_unity/src/pages/teenager/challenges.dart';
import 'package:mobile_unity/src/pages/teenager/dashboard.dart';
import 'package:mobile_unity/src/pages/teenager/setting.dart';
import 'package:mobile_unity/src/services/challenge_database.dart';
import 'package:mobile_unity/src/services/task_database.dart';
import 'package:mobile_unity/src/services/teenager_database.dart';
import 'package:mobile_unity/src/services/wish_database.dart';
import 'package:mobile_unity/src/shared/constants.dart';
import 'package:provider/provider.dart';

class WrapperTeenager extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<WrapperTeenager> {
  final tabs = [
    DashboardTeenager(),
    Challenges(),
    TeenagerAchivement(),
    TeenagerSetting(),
  ];

  TabIndex _tabIndex;
  @override
  void initState() {
    super.initState();
    _tabIndex = Provider.of<TabIndex>(context, listen: false);
    _tabIndex.currentIndex = 0;
  }

  initData(BuildContext context) async{
    final Teenager user = Provider.of<Teenager>(context, listen: false);
    final List<Challenge> challenges = Provider.of<List<Challenge>>(context);
    Map<String, dynamic> data = {};
    if (user.lastLogin.difference(DateTime.now()).inDays != 0) {
      data["last_login"] = DateTime.now();
      if (user.totalLogin<=6) {
        data["total_login"] = user.totalLogin + 1;
      }
      if (data["total_login"] == 7) {
        var loginChallenges = challenges.where((element) => element.key == "login").toList();
        if (loginChallenges.length > 0) {
          Map<String, dynamic> challenge = {
            "isDone" : true,
          };
          await ChallengeDatabase(uid: loginChallenges[0].uid).updateChallenge(challenge);
          int countFinishedChallenge = await ChallengeDatabase().countFinishedChallenge(user.uid);
          data["achievements"] = user.achievements;
          countFinishedChallenge == 1
              ? data["achievements"][0] = true
              : countFinishedChallenge == 2
              ? data["achievements"][2] = true
              : countFinishedChallenge >= 3
              ? data["achievements"][4] = true
              : data["achievements"] = user.achievements;
        }
      }
      await TeenagerDatabase(uid: user.uid).updateTeenagerData(data);
    }
  }

  @override
  Widget build(BuildContext context) {
    _tabIndex = Provider.of<TabIndex>(context);
    final Teenager user = Provider.of<Teenager>(context);

    return MultiProvider(
      providers: [
        StreamProvider<List<Task>>.value(
          value: TaskDatabase().getTeenagerTasks(user.uid),
          initialData: [],
        ),
        StreamProvider<Wish>.value(
          value: WishDatabase().getActiveWish(user.uid),
          initialData: null,
        ),
        StreamProvider<List<Challenge>>.value(
          value: ChallengeDatabase().getChallenge(user),
          initialData: [],
        ),
      ],
      builder: (context, child) {
        initData(context);
        return Scaffold(
          body: tabs[_tabIndex.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _tabIndex.currentIndex,
            onTap: (index) {
              _tabIndex.updateIndex(index);
            },
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.grey,
            items: [
              Icons.home,
              Icons.subject_outlined,
              Icons.emoji_events,
              Icons.settings
            ]
                .asMap()
                .map((key, value) => MapEntry(
              key,
              BottomNavigationBarItem(
                label: '',
                tooltip: '',
                icon: Container(
                  padding:
                  EdgeInsets.symmetric(vertical: 6.0, horizontal: 16.0),
                  decoration: BoxDecoration(
                    color: _tabIndex.currentIndex == key
                        ? primaryColor
                        : thirdColor,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Icon(value),
                ),
              ),
            ))
                .values
                .toList(),
          ),
        );
      },
    );
  }
}
