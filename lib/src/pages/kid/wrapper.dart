import 'package:flutter/material.dart';
import 'package:mobile_unity/src/models/child.dart';
import 'package:mobile_unity/src/models/tab_index.dart';
import 'package:mobile_unity/src/models/task.dart';
import 'package:mobile_unity/src/models/wish.dart';
import 'package:mobile_unity/src/pages/kid/achievement.dart';
import 'package:mobile_unity/src/pages/kid/dashboard.dart';
import 'package:mobile_unity/src/pages/kid/inner_income.dart';
import 'package:mobile_unity/src/pages/kid/kid_task.dart';
import 'package:mobile_unity/src/services/task_database.dart';
import 'package:mobile_unity/src/services/wish_database.dart';
import 'package:mobile_unity/src/shared/constants.dart';
import 'package:provider/provider.dart';

class WrapperChildren extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<WrapperChildren> {
  final tabs = [
    KidTask(),
    DashboardKid(),
    KidAchievement(),
  ];

  TabIndex _tabIndex;
  @override
  void initState() {
    super.initState();
    _tabIndex = Provider.of<TabIndex>(context, listen: false);
    _tabIndex.currentIndex = 1;
  }

  @override
  Widget build(BuildContext context) {
    _tabIndex = Provider.of<TabIndex>(context);
    final Child user = Provider.of<Child>(context);

    return MultiProvider(
      providers: [
        StreamProvider<List<Task>>.value(
          value: TaskDatabase().getTasks(user.parentId, user.uid),
          initialData: [],
        ),
        StreamProvider<Wish>.value(
          value: WishDatabase().getActiveWish(user.uid),
          initialData: null,
        ),
      ],
      child: Scaffold(
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
            Icons.emoji_events,
            Icons.home,
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
      ),
    );
  }
}
