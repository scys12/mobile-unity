import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_unity/src/models/child.dart';
import 'package:mobile_unity/src/models/task.dart';
import 'package:mobile_unity/src/models/teenager.dart';
import 'package:mobile_unity/src/models/wish.dart';
import 'package:mobile_unity/src/pages/kid/detail_task.dart';
import 'package:mobile_unity/src/pages/kid/detail_wish.dart';
import 'package:mobile_unity/src/provider/task_provider.dart';
import 'package:mobile_unity/src/provider/wish_provider.dart';
import 'package:mobile_unity/src/shared/alert_dialog.dart';
import 'package:mobile_unity/src/shared/constants.dart';
import 'package:mobile_unity/src/widgets/app_bar.dart';
import 'package:mobile_unity/src/widgets/loading.dart';
import 'package:provider/provider.dart';

class TeenagerAchivement extends StatefulWidget {
  @override
  _TeenagerAchivementState createState() => _TeenagerAchivementState();
}

class _TeenagerAchivementState extends State<TeenagerAchivement> with TickerProviderStateMixin{
  int _tabIndex = 0;
  TabController _tabController;
  Teenager _user;
  List<String> tabItems = [
    "Lencana",
    "Tantangan Selesai"
  ];
  TaskProvider _taskProvider;
  Wish _wish;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _user = Provider.of<Teenager>(context, listen: false);
    _taskProvider = Provider.of<TaskProvider>(context, listen: false);
    _taskProvider.getTeenagerFinishTasks(childId: _user.uid);
  }
  @override
  Widget build(BuildContext context) {
    _taskProvider = Provider.of<TaskProvider>(context);
    if(_taskProvider.tasks != null)
      setState(() {
        _loading = false;
      });
    _wish = Provider.of<Wish>(context);
    return _loading ? Loading() : Scaffold(
      appBar: CustomAppBar(false, "Prestasi"),
      body: ListView(
        padding: EdgeInsets.all(20.0),
        children: [
          _buildHeader("Prestasiku", "Semua prestasi yang sudah diraih"),
          SizedBox(height: 20.0,),
          _buildTab(),
          SizedBox(height: 20.0,),
          _tabIndex == 0
              ? _buildAchievement()
              : _taskProvider.tasks.length <= 0
              ? Text(
                  "Tidak ada tantangan yang sudah diselesaikan",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    fontSize: 16.0
                  ),
                )
              : _buildFinishedTask(_taskProvider.tasks),
          SizedBox(height: 20.0,),
          _buildHeader("Impianku", "Impian yang aku inginkan"),
          SizedBox(height: 20.0,),
          _buildImpian(),
          SizedBox(height: 20.0,),
          Container(child: _buildButtonAllWishes())
        ],
      ),
    );
  }

  Widget _buildFinishedTask(List<Task> tasks){
    return ListView.builder(
      itemCount: tasks.length,
      shrinkWrap: true,
      controller: ScrollController(keepScrollOffset: false),
      itemBuilder: (context, index){
        return InkWell(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => DetailTaskKid(taskId: tasks[index].uid,)));
          },
          splashFactory: InkRipple.splashFactory,
          child: Container(
            decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: shadowColor,
                    spreadRadius: 1.0,
                    blurRadius: 1.0,
                  ),
                ],
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0)
            ),
            margin: EdgeInsets.symmetric(vertical: 10.0),
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),

            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Icon(
                  Icons.article,
                  size: 50.0,
                  color: primaryColor,
                ),
                SizedBox(width: 10.0,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        tasks[index].title,
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
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(vertical:3.0, horizontal: 15.0),
                            decoration: BoxDecoration(
                                color: primaryColor,
                                borderRadius: BorderRadius.circular(10.0)
                            ),
                            child: Text(
                              tasks[index].category,
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 15.0,
                                  color: Colors.white
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.0,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(vertical:3.0, horizontal: 15.0),
                            decoration: BoxDecoration(
                                color: greenColor,
                                borderRadius: BorderRadius.circular(10.0)
                            ),
                            child: Text(
                              DateFormat("dd MMMM yyyy").format(tasks[index].deadline).toString(),
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
                                color: secondaryColor,
                                borderRadius: BorderRadius.circular(10.0)
                            ),
                            child: Text(
                              "+${tasks[index].point}pts",
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
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAchievement(){
    List<String> message  = [
      "Selamat ${_user.name} telah menyelesaikan 1 tugas",
      "Selamat ${_user.name}kamu telah menyelesaikan 1 impian",
      "Selamat ${_user.name} telah menyelesaikan 5 tugas",
      "Selamat ${_user.name} telah menyelesaikan 5 impian",
      "Selamat ${_user.name} telah menyelesaikan 20 tugas",
      "Selamat ${_user.name} telah menyelesaikan 15 impian",
    ];
    var achievements = _user.achievements;
    return GridView.builder(
      itemCount: 6,
      padding: EdgeInsets.all(5.0),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 10.0,
      ),
      itemBuilder: (BuildContext context, int index) {
        return InkWell(
          onTap: achievements[index]
              ? (){
            achievementDialog(context, message[index]);
          }
              : null,
          child: Column(
            children: [
              Text(
                "0${(index+1).toString()}",
                style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    color: achievements[index] ? primaryColor : shadowColor
                ),
              ),
              Expanded(
                child: Image(
                  image: AssetImage(achievements[index] ? "assets/images/achievement.png" : "assets/images/not_achievement.png"),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(String title, String description){
    return Container(
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        fontSize: 23.0
                    ),
                  ),
                  SizedBox(height: 8.0,),
                  Text(
                    description,
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

  Widget _buildTab(){
    return Container(
      decoration: BoxDecoration(
          color: primaryColor,
          borderRadius: BorderRadius.circular(30.0)
      ),
      child: TabBar(
        controller: _tabController,
        indicatorColor: Colors.transparent,
        onTap: (val) => setState(() => _tabIndex = val),
        unselectedLabelColor: Colors.white,
        isScrollable: false,
        tabs: [
          ...tabItems.map((e) => Tab(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 8.0),
              width: double.infinity,
              decoration: e == tabItems[_tabIndex] ? BoxDecoration(
                color: orangeOpColor,
                borderRadius: BorderRadius.circular(30.0),
              ) : BoxDecoration(),
              child: Text(
                e,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 15.0,
                ),
              ),
            ),
          )).toList()
        ],
      ),
    );
  }

  Widget _buildImpian(){
    return _wish != null ? InkWell(
      splashFactory: InkRipple.splashFactory,
      onTap: (){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DetailWishKid(wishId: _wish.uid))
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                  color: shadowColor,
                  blurRadius: 8,
                  spreadRadius: 0,
                  offset: Offset(1.0, 3.0)
              )
            ]
        ),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.nights_stay_rounded,
                  color: primaryColor,
                  size: 30.0,
                ),
                SizedBox(width: 10,),
                Expanded(
                  child: Text(
                    _wish.title,
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        fontSize: 15.0,
                        color: Colors.black
                    ),
                  ),
                ),
                Text(
                  DateFormat("dd MMMM yyyy").format(_wish.deadline).toString(),
                  style: TextStyle(
                      color: shadowColor,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w600
                  ),
                )
              ],
            ),
            SizedBox(height: 12.0,),
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: LinearProgressIndicator(
                minHeight: 5.0,
                backgroundColor: thirdColor,
                valueColor: AlwaysStoppedAnimation<Color>(secondaryColor),
                value: _wish.currentMoney/_wish.target,
              ),
            ),
            SizedBox(height: 8.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Rp ${_wish.currentMoney}",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                      fontSize: 13.0
                  ),
                ),
                Text(
                  "Rp ${_wish.target}",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                      fontSize: 13.0
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ) : Text(
      'Belum ada yang diimpikan si kecil',
      style: TextStyle(
          fontSize: 15.0,
          fontFamily: 'Poppins',
          fontWeight: FontWeight.w500
      ),
    );
  }

  Widget _buildButtonAllWishes() {
    return ElevatedButton(
      onPressed: () {
        Navigator.pushNamed(context, '/teenager/all_wishes');
      },
      style: ButtonStyle(
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
          EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        ),
        elevation: MaterialStateProperty.all<double>(0.0),
        backgroundColor: MaterialStateProperty.all<Color>(secondaryColor),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Lihat semua Impianku",
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              fontSize: 17.0,
            ),
          ),
          SizedBox(
            width: 15.0,
          ),
          Icon(
            Icons.arrow_forward,
          ),
        ],
      ),
    );
  }
}
