import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';
import 'package:mobile_unity/src/models/parent.dart';
import 'package:mobile_unity/src/provider/child_provider.dart';
import 'package:mobile_unity/src/provider/task_provider.dart';
import 'package:mobile_unity/src/shared/alert_dialog.dart';
import 'package:mobile_unity/src/shared/constants.dart';
import 'package:mobile_unity/src/widgets/app_bar.dart';
import 'package:mobile_unity/src/widgets/loading.dart';
import 'package:mobile_unity/src/widgets/sub_header.dart';
import 'package:provider/provider.dart';

import 'detail_task.dart';

class ListChildTasks extends StatefulWidget {
  @override
  _ListChildTasksState createState() => _ListChildTasksState();
}

class _ListChildTasksState extends State<ListChildTasks> {
  TaskProvider _taskProvider;
  ChildProvider _childProvider;
  bool _loading = true;
  @override
  void initState() {

    super.initState();
    _childProvider = Provider.of<ChildProvider>(context, listen: false);
    _taskProvider = Provider.of(context, listen: false);
    _taskProvider.getChildTaskFromParent(childId: _childProvider.selectedChild.uid, parentId: _childProvider.selectedChild.parentId);
  }
  @override
  Widget build(BuildContext context) {
    _taskProvider =  Provider.of<TaskProvider>(context);
    if (_taskProvider.tasks != null) {
      setState(() {
        _loading = false;
      });
    }
    return _loading ? Loading() : Scaffold(
      appBar: CustomAppBar(true, "Semua Tugas"),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 25.0),
        physics: ScrollPhysics(),
        child: Column(
          children: [
            _buildHeader(context),
            SizedBox(height: 25.0,),
            SubHeader(title: 'Tugas',isLihatSemua: false,),
            SizedBox(height: 15.0,),
            ListView.builder(
              itemCount: _taskProvider.tasks.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index){
                return InkWell(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DetailTaskChild(taskId: _taskProvider.tasks[index].uid,)),
                  ),
                  splashFactory: InkRipple.splashFactory,
                  child: Card(
                    elevation: 7.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    margin: EdgeInsets.symmetric(vertical: 5.0),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            _taskProvider.tasks[index].title,
                            style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                fontSize: 16.0,
                                color: Colors.black
                            ),
                          ),
                          ListTile(
                              dense: true,
                              leading: Icon(
                                Icons.schedule,
                                color: shadowColor,
                                size: 23.0,
                              ),
                              visualDensity: VisualDensity.compact,
                              contentPadding: EdgeInsets.zero,
                              minLeadingWidth: 0.0,
                              title: Text(
                                DateFormat("dd-MM-yyyy").format(_taskProvider.tasks[index].deadline).toString(),
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 15.0,
                                    color: shadowColor
                                ),
                              ),
                              trailing: Container(
                                padding: EdgeInsets.symmetric(vertical:3.0, horizontal: 15.0),
                                decoration: BoxDecoration(
                                    color: _taskProvider.tasks[index].isDone ? greenColor : redColor,
                                    borderRadius: BorderRadius.circular(10.0)
                                ),
                                child: Text(
                                  DateTime.now().difference(_taskProvider.tasks[index].deadline).inDays <= 0 ? "Sedang Berjuang" : "Sudah selesai",
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 15.0,
                                      color: Colors.white
                                  ),
                                ),
                              )
                          ),
                          ListTile(
                              dense: true,
                              visualDensity: VisualDensity.compact,
                              leading: Icon(
                                Icons.card_giftcard,
                                color: shadowColor,
                                size: 23.0,
                              ),
                              contentPadding: EdgeInsets.zero,
                              minLeadingWidth: 0.0,
                              title: Text(
                                '${_taskProvider.tasks[index].point}pts',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20.0,
                                ),
                              )
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context){
    return Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Tugas Lumen",
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 23.0
                  ),
                ),
                SizedBox(height: 8.0,),
                Text(
                  "Tambahkan tugas atau \n edukasi finansial untuk anak",
                  style: TextStyle(
                      color: shadowColor,
                      fontSize: 16.0,
                      letterSpacing: 0.5
                  ),
                )
              ],
            ),
            IconButton(
              icon: Icon(
                Icons.add_circle_outlined,
              ),
              splashRadius: 30.0,
              color: secondaryColor,
              iconSize: 50.0,
              onPressed: () => createAlertDialog(context),
            )
          ],
        )
    );
  }
}
