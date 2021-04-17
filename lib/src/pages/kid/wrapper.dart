import 'package:flutter/material.dart';
import 'package:mobile_unity/src/models/child.dart';
import 'package:mobile_unity/src/models/parent.dart';
import 'package:mobile_unity/src/models/tab_index.dart';
import 'package:mobile_unity/src/pages/kid/dashboard.dart';
import 'package:mobile_unity/src/pages/kid/pengeluaran.dart';
import 'package:mobile_unity/src/pages/parent/child_achievement.dart';
import 'package:mobile_unity/src/pages/parent/child_task.dart';
import 'package:mobile_unity/src/pages/parent/dashboard.dart';
import 'package:mobile_unity/src/pages/parent/setting.dart';
import 'package:mobile_unity/src/provider/child_provider.dart';
import 'package:mobile_unity/src/services/child_database.dart';
import 'package:mobile_unity/src/shared/constants.dart';
import 'package:mobile_unity/src/widgets/loading.dart';
import 'package:provider/provider.dart';

class WrapperChildren extends StatefulWidget {
  @override
  _State createState() => _State();
}

class _State extends State<WrapperChildren> {
  final tabs = [
    PengeluaranKid(),
    DashboardKid(),
  ];

  TabIndex _tabIndex;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _tabIndex = Provider.of<TabIndex>(context);

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
  }
}
