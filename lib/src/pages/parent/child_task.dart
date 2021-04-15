import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_unity/src/models/task.dart';
import 'package:mobile_unity/src/services/task_database.dart';
import 'package:mobile_unity/src/shared/alert_dialog.dart';
import 'package:mobile_unity/src/shared/constants.dart';
import 'package:mobile_unity/src/widgets/app_bar.dart';
import 'package:mobile_unity/src/widgets/sub_header.dart';
import 'package:provider/provider.dart';

class ChildTask extends StatefulWidget {
  @override
  _ChildTaskState createState() => _ChildTaskState();
}

class _ChildTaskState extends State<ChildTask> {
  List<Task> tasks = [];

  get i => null;

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    tasks = Provider.of<List<Task>>(context);
    return Scaffold(
      appBar: CustomAppBar(false, "Tugas"),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 20.0),
        physics: ClampingScrollPhysics(),
        children: [
          SizedBox(height: 25.0,),
          _buildHeader(context),
          SizedBox(height: 25.0,),
          SubHeader(title: 'Tugas', isLihatSemua: tasks.length > 0 ? true : false, path: '/parent/all_tasks'),
          SizedBox(height: 25.0,),
          tasks.length > 0 ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ...tasks.asMap().map((idx, element) =>
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
          SizedBox(height: 25.0,),
          SubHeader(title: 'Edukasi Finansial', isLihatSemua: true, path: '/parent/all_educations'),
          SizedBox(height: 25.0,),
          tasks.length > 0 ? Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ...tasks.asMap().map((idx, element) =>
                  MapEntry(idx, Expanded(
                    child: _buildCard(idx, element),
                  )
                  )).values.toList(),
            ],
          ) : Text(
            'Tidak ada edukasi finansial',
            style: TextStyle(
                fontSize: 15.0,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500
            ),
          ),
          SizedBox(height: 25.0,),
          SubHeader(title: 'Impian', isLihatSemua: true,),
          SizedBox(height: 25.0,),
          _buildImpian(),
          SizedBox(height: 15.0,),
        ],
      ),
    );
  }

  Widget _buildImpian(){
    return Container(
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
                  'Berhasil menyelesaikan tugas abcdeffsdfasdfaskl',
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      fontSize: 15.0,
                      color: Colors.black
                  ),
                ),
              ),
              Text(
                "30 tahun lagi",
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
              value: .5,
            ),
          ),
          SizedBox(height: 8.0,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Rp 40000",
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Poppins',
                    fontSize: 13.0
                ),
              ),
              Text(
                "Rp 100000",
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
    );
  }

  Widget _buildCard(int idx, Task task){
    return Container(
      padding: EdgeInsets.all(15.0),
      margin: (idx < tasks.length-1) ? EdgeInsets.only(right: 10.0) : EdgeInsets.only(left: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(15),
        ),
        border: Border.all(color: Colors.white),
        boxShadow: [
          BoxShadow(
            color: shadowColor,
            offset: Offset(1,2),
            spreadRadius: 1,
            blurRadius: 3,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            task.title,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w700,
              fontSize: 15.0
            ),
          ),
          SizedBox(height: 10.0,),
          Container(
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              color: task.isDone ? greenColor : redColor,
            ),
            child: Text(
              task.isDone ? 'Sudah Selesai' : 'Sedang Berjuang',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Poppins',
                fontSize: 12.0,
                fontWeight: FontWeight.w600
              ),
            ),
          ),
          SizedBox(height: 10.0,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                DateFormat("dd-MM-yyyy").format(task.deadline).toString(),
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  color: thirdColor,
                  fontSize: 15.0
                ),
              ),
              Text(
                "${task.point}pts",
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Poppins',
                  fontSize: 20.0,
                ),
              ),
            ],
          )
        ],
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
              color: secondaryColor,
              splashRadius: 30.0,
              iconSize: 50.0,
              onPressed: () => createAlertDialog(context),
            )
          ],
        )
    );
  }
  

}
