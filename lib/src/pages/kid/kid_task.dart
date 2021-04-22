import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_unity/src/models/child.dart';
import 'package:mobile_unity/src/models/task.dart';
import 'package:mobile_unity/src/pages/kid/detail_task.dart';
import 'package:mobile_unity/src/provider/task_provider.dart';
import 'package:mobile_unity/src/shared/constants.dart';
import 'package:mobile_unity/src/widgets/app_bar.dart';
import 'package:mobile_unity/src/widgets/loading.dart';
import 'package:mobile_unity/src/widgets/sub_header.dart';
import 'package:provider/provider.dart';

class KidTask extends StatefulWidget {
  @override
  _KidTaskState createState() => _KidTaskState();
}

class _KidTaskState extends State<KidTask> {
  TaskProvider _taskProvider;
  Child _child;
  bool _loading = true;
  int _tabIndex = 0;

  @override
  void initState() {
    super.initState();
    _child = Provider.of<Child>(context, listen: false);
    _taskProvider = Provider.of(context, listen: false);
    _taskProvider.getTwoChildTasksNearDeadline(childId: _child.uid, parentId: _child.parentId);
    _taskProvider.getTasksNearDeadlineAndNotDone(childId: _child.uid, parentId: _child.parentId);
  }
  @override
  Widget build(BuildContext context) {
    List<Task> reducedTask;
    _taskProvider = Provider.of<TaskProvider>(context);
    if (_taskProvider.twoTasks != null && _taskProvider.tasks != null ) {
      setState(() {
        _loading = false;
      });
      var setTwoTasks = Set.from(_taskProvider.twoTasks);
      var setTasks = Set.from(_taskProvider.tasks);
      reducedTask = List.from(_taskProvider.tasks.where((element) => !_taskProvider.twoTasks.contains(element)));
    }
    return _loading ? Loading() : Scaffold(
      appBar: CustomAppBar(true, "Tugas"),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Stack(
          children: [
            Column(
              children: [
                SizedBox(height: 25.0,),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: _buildHeader(),
                ),
                SizedBox(height: 25.0,),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: SubHeader(title: 'Segera diselesaikan',isLihatSemua: false),
                ),
                SizedBox(height: 25.0,),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: _taskProvider.twoTasks.length > 0 ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ..._taskProvider.twoTasks.asMap().map((idx, element) =>
                          MapEntry(idx, Expanded(
                            child: _buildCard(idx, element),
                          )
                          )).values.toList(),
                    ],
                  ) : Text(
                    'Tidak ada tugas',
                    style: TextStyle(
                        fontSize: 15.0,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500
                    ),
                  ),
                ),
                SizedBox(height: 35.0,),
              ],
            ),
            _buildAnotherTask(reducedTask),
          ],
        ),
      ),
    );
  }

  Widget _buildAnotherTask(List<Task> tasks){
    return DraggableScrollableSheet(
      expand: true,
      initialChildSize: 0.4,
      minChildSize: 0.4,
      maxChildSize: 0.5,
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
            width: double.infinity,
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: shadowColor,
                    spreadRadius: 2.0,
                    blurRadius: 2.0,
                  ),
                ],
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20))
            ),
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                    child: SubHeader(title: "Tugas Lain",isLihatSemua: false,),
                  ),
                  Divider(thickness: 2.0,color: shadowColor,),
                  tasks.length <= 0 ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    child: Text(
                      "Tidak ada tugas lain",
                      style: TextStyle(
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          fontSize: 18.0
                      ),
                    ),
                  ) : ListView.builder(
                    itemCount: tasks.length,
                    shrinkWrap: true,
                    controller: ScrollController(keepScrollOffset: false),
                    itemBuilder: (context, index){
                      return InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => DetailTaskKid(taskId: tasks[index].uid,)));
                        },
                        splashFactory: InkRipple.splashFactory,
                        child: Card(
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
                                  tasks[index].title,
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20.0,
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
                                      DateFormat("dd-MM-yyyy").format(tasks[index].deadline).toString(),
                                      style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18.0,
                                          color: shadowColor
                                      ),
                                    ),
                                    trailing: Container(
                                      padding: EdgeInsets.symmetric(vertical:3.0, horizontal: 15.0),
                                      decoration: BoxDecoration(
                                          color: tasks[index].deadline.difference(DateTime.now()).inSeconds < 0 ? redColor : tasks[index].isDone ? greenColor : primaryColor,
                                          borderRadius: BorderRadius.circular(10.0)
                                      ),
                                      child: Text(
                                        tasks[index].deadline.difference(DateTime.now()).inSeconds < 0 ? "Gagal Diselesaikan" : tasks[index].isDone ? "Sudah Selesai" : "Sedang Berjuang",
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
                                  title: Row(
                                    children: [
                                      Text(
                                        'Hadiah  ',
                                        style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w600,
                                            fontSize: 18.0,
                                            color: shadowColor
                                        ),
                                      ),
                                      Text(
                                        '${tasks[index].point}pts',
                                        style: TextStyle(
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                ListTile(
                                  dense: true,
                                  visualDensity: VisualDensity.compact,
                                  leading: Icon(
                                    Icons.category,
                                    color: shadowColor,
                                    size: 23.0,
                                  ),
                                  contentPadding: EdgeInsets.zero,
                                  minLeadingWidth: 0.0,
                                  title: Row(
                                    children: [
                                      Text(
                                        'Kategori  ',
                                        style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontWeight: FontWeight.w600,
                                            fontSize: 18.0,
                                            color: shadowColor
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(vertical:3.0, horizontal: 15.0),
                                        decoration: BoxDecoration(
                                            color: secondaryColor,
                                            borderRadius: BorderRadius.circular(10.0)
                                        ),
                                        child: Text(
                                          tasks[index].category,
                                          style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontWeight: FontWeight.w400,
                                              fontSize: 15.0,
                                              color: Colors.white
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            )
        );
      },
    );
  }

  Widget _buildAnother(){
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            spreadRadius: 2.0,
            blurRadius: 2.0,
          ),
        ],
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0)
      ),
      padding: EdgeInsets.all(20.0),
      child: Column(
        children: [
          SubHeader(title: "Tugas Lain",isLihatSemua: false,),
          SizedBox(height: 10.0,),
          ListView.builder(
            itemCount: 9,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index){
              return InkWell(
                onTap: ()=>Navigator.pushNamed(context, '/parent/detail_task'),
                splashFactory: InkRipple.splashFactory,
                child: Container(
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: shadowColor,
                          spreadRadius: 3.0,
                          blurRadius: 2.0,
                        ),
                      ],
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10.0)
                  ),
                  margin: EdgeInsets.symmetric(vertical: 10.0),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Berhasil menyelesaikan tugas',
                          style: TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                              fontSize: 16.0,
                              color: Colors.black
                          ),
                        ),
                        SizedBox(height: 10.0,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(vertical:3.0, horizontal: 15.0),
                              decoration: BoxDecoration(
                                  color: redColor,
                                  borderRadius: BorderRadius.circular(10.0)
                              ),
                              child: Text(
                                "5 hari lagi",
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15.0,
                                    color: Colors.white
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(vertical:3.0, horizontal: 15.0),
                              decoration: BoxDecoration(
                                  color: primaryColor,
                                  borderRadius: BorderRadius.circular(10.0)
                              ),
                              child: Text(
                                "+10pts",
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                    fontSize: 15.0,
                                    color: Colors.white
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      )
    );
  }

  Widget _buildCard(int idx, Task task) {
    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => DetailTaskKid(taskId: task.uid,)));
      },
      child: Container(
        padding: EdgeInsets.all(15.0),
        margin: (idx < _taskProvider.twoTasks.length-1) ? EdgeInsets.only(right: 10.0) : EdgeInsets.only(left: 10.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
          border: Border.all(color: Colors.white),
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              offset: Offset(1, 2),
              spreadRadius: 1,
              blurRadius: 3,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Container(
                //   padding: EdgeInsets.all(8.0),
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.all(Radius.circular(7)),
                //     color: redColor,
                //   ),
                //   child: Text(
                //     DateFormat("dd MMMM yyyy").format(task.deadline).toString(),
                //     style: TextStyle(
                //         color: Colors.white,
                //         fontFamily: 'Poppins',
                //         fontSize: 15.0,
                //         fontWeight: FontWeight.w600),
                //   ),
                // ),
                Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(7)),
                    color: redColor,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '+${task.point}',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          fontFamily: 'Poppins',
                          fontSize: 15.0,
                        ),
                      ),
                      Text(
                        'pts',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          fontFamily: 'Poppins',
                          fontSize: 10.0,
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            Text(
              task.title,
              style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                  fontSize: 20.0),
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              children: [
                Text(
                  "Batas",
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      fontSize: 15.0),
                ),
                SizedBox(width: 10.0,),
                Text(
                  DateFormat("dd MMMM yyyy").format(task.deadline).toString(),
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      color: shadowColor,
                      fontSize: 15.0),
                ),
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(7)),
                color: greenColor,
              ),
              child: Text(
                task.category,
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Poppins',
                    fontSize: 15.0,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(){
    return Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Tugasku",
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                      fontSize: 23.0
                  ),
                ),
                SizedBox(height: 8.0,),
                Text(
                  "Selesaikan segera tugas-tugas \nagar mendapat poin",
                  style: TextStyle(
                      color: shadowColor,
                      fontSize: 16.0,
                      letterSpacing: 0.5
                  ),
                )
              ],
            ),
          ]
        )
    );
  }


}
