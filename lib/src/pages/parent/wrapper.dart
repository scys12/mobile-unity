import 'package:flutter/material.dart';
import 'package:mobile_unity/src/models/child.dart';
import 'package:mobile_unity/src/models/financial.dart';
import 'package:mobile_unity/src/models/parent.dart';
import 'package:mobile_unity/src/models/tab_index.dart';
import 'package:mobile_unity/src/models/task.dart';
import 'package:mobile_unity/src/models/wish.dart';
import 'package:mobile_unity/src/pages/parent/child_achievement.dart';
import 'package:mobile_unity/src/pages/parent/child_task.dart';
import 'package:mobile_unity/src/pages/parent/dashboard.dart';
import 'package:mobile_unity/src/pages/parent/setting.dart';
import 'package:mobile_unity/src/provider/child_provider.dart';
import 'package:mobile_unity/src/services/child_database.dart';
import 'package:mobile_unity/src/services/financial_database.dart';
import 'package:mobile_unity/src/services/task_database.dart';
import 'package:mobile_unity/src/services/wish_database.dart';
import 'package:mobile_unity/src/shared/constants.dart';
import 'package:mobile_unity/src/widgets/loading.dart';
import 'package:provider/provider.dart';

class WrapperParent extends StatefulWidget {
  @override
  _WrapperParentState createState() => _WrapperParentState();
}

class _WrapperParentState extends State<WrapperParent> {
  final tabs = [
    DashboardParent(),
    ChildTask(),
    ChildAchievement(),
    ParentSetting(),
  ];

  ChildProvider childProvider;
  Parent parent;
  TabIndex _tabIndex;
  bool _loading = true;
  @override
  void initState() {
    super.initState();
    childProvider = Provider.of<ChildProvider>(context, listen: false);
    parent = Provider.of<Parent>(context, listen: false);
    childProvider.getCurrentChild(parentId: parent.uid);
  }

  @override
  Widget build(BuildContext context) {
    _tabIndex = Provider.of<TabIndex>(context);
    childProvider =  Provider.of<ChildProvider>(context);
    if (childProvider.selectedChild != null) {
      setState(() {
        _loading = false;
      });
    }

    return _loading ? Loading() : MultiProvider(
      providers: [
        StreamProvider<List<Child>>.value(
          value: ChildDatabase().getChildrenFromParent(parent.uid),
          initialData: [],
        ),
        StreamProvider<List<Task>>.value(
          value: TaskDatabase().getTasks(parent.uid, childProvider.selectedChild.uid),
          initialData: [],
        ),
        StreamProvider<List<Wish>>.value(
          value: WishDatabase().getWish(childProvider.selectedChild.uid),
          initialData: [],
        ),
        StreamProvider<List<Financial>>.value(
          value: FinancialDatabase().getFinancials(childProvider.selectedChild.uid),
          initialData: [],
        ),
      ],
      child: Scaffold(
        body: tabs[_tabIndex.currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _tabIndex.currentIndex,
          onTap: (index) {_tabIndex.updateIndex(index);},
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey,
          items: [Icons.home, Icons.subject_outlined, Icons.emoji_events, Icons.settings]
              .asMap()
              .map((key, value) => MapEntry(
            key,
            BottomNavigationBarItem(
              label: '',
              tooltip: '',
              icon: Container(
                padding: EdgeInsets.symmetric(
                    vertical: 6.0,
                    horizontal: 16.0
                ),
                decoration: BoxDecoration(color: _tabIndex.currentIndex == key
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
