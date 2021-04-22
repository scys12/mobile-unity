import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_unity/src/provider/child_provider.dart';
import 'package:mobile_unity/src/provider/task_provider.dart';
import 'package:mobile_unity/src/services/task_database.dart';
import 'package:mobile_unity/src/services/child_database.dart';
import 'package:mobile_unity/src/shared/alert_dialog.dart';
import 'package:mobile_unity/src/shared/constants.dart';
import 'package:mobile_unity/src/shared/task_photo.dart';
import 'package:mobile_unity/src/widgets/app_bar.dart';
import 'package:mobile_unity/src/widgets/loading.dart';
import 'package:mobile_unity/src/widgets/sub_header.dart';
import 'package:provider/provider.dart';

class DetailTaskChild extends StatefulWidget {
  final String taskId;
  DetailTaskChild({this.taskId});
  @override
  _DetailTaskChildState createState() => _DetailTaskChildState();
}

class _DetailTaskChildState extends State<DetailTaskChild> {
  TaskProvider _taskProvider;
  ChildProvider _childProvider;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _taskProvider = Provider.of(context, listen: false);
    _taskProvider.getTask(taskId: widget.taskId);
  }

  @override
  Widget build(BuildContext context) {
    String title;
    _childProvider = Provider.of<ChildProvider>(context);
    _taskProvider =  Provider.of<TaskProvider>(context);
    if (_taskProvider.selectedTask != null && _taskProvider.selectedTask.uid == widget.taskId) {
      setState(() {
        _loading = false;
      });
      title = _taskProvider.selectedTask.category == 'Edukasi Finansial' ? 'Edukasi Finansial' : 'Tugas';
    }
    return _loading ? Loading() : Scaffold(
      appBar: CustomAppBar(true, "Detail ${title}"),
      body: ListView(
        physics: ClampingScrollPhysics(),
        padding: EdgeInsets.all(30.0),
        children: [
          Form(
            child: Column(
              children: [
                _buildChildProfile(),
                SizedBox(height: 20.0,),
                _buildTitleField(),
                SizedBox(height: 20.0,),
                _buildStatusField(),
                SizedBox(height: 20.0,),
                _buildDeadlineField(),
                _buildCategoryField(),
                _buildPointField(),
                SubHeader(title: "Progress", isLihatSemua: false,),
                SizedBox(height: 10.0,),
                _taskProvider.selectedTask.imageUrl != "" && _taskProvider.selectedTask.imageUrl != ""
                    ? _buildProgress()
                    : Text(
                  "Tidak ada progress",
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    fontSize: 18.0,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusField(){
    var isFinished;
    if (_taskProvider.selectedTask.deadline.difference(DateTime.now()).inDays < 0 && !_taskProvider.selectedTask.isDone) isFinished = 0;
    else if (_taskProvider.selectedTask.isDone) isFinished = 1;
    else isFinished = 2;
    return Container(
      decoration: BoxDecoration(
        color: isFinished == 1 ? greenColor : isFinished == 0 ? redColor : primaryColor,
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: ListTile(
        leading: Icon(Icons.star, color: Colors.white),
        title: Text(
          isFinished == 1 ? "Sudah Diselesaikan" : isFinished == 0 ? "Belum Diselesaikan" : "Sedang Berjuang",
          style: TextStyle(
              fontSize: 18.0,
              color: Colors.white,
              fontFamily: "Poppins",
              fontWeight: FontWeight.w600
          ),
        ),
      ),
    );
  }

  Widget _buildProgress(){
    return Card(
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${_childProvider.selectedChild.name} mengumpul tugas",
              style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  fontSize: 15.0
              ),
            ),
            SizedBox(height: 10.0,),
            Row(
              children: [
                Icon(
                  Icons.schedule,
                  color: shadowColor,
                ),
                SizedBox(width: 10.0,),
                Text(
                  "Dikumpul pada : ",
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w700,
                      color: shadowColor
                  ),
                ),
                SizedBox(width: 5.0,),
                Text(
                  DateFormat("dd MMMM yyyy").format(_taskProvider.selectedTask.submitTaskDate).toString(),
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w700,
                      color: Colors.black
                  ),
                )
              ],
            ),
            SizedBox(height: 10.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        shadowColor
                    ),
                  ),
                  onPressed: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TaskPhoto(imageUrl: _taskProvider.selectedTask.imageUrl,)),
                    );
                  },
                  child: Text(
                    "Lihat Bukti",
                    style: TextStyle(
                        color: Colors.white
                    ),
                  ),
                ),
                _taskProvider.selectedTask.status == 2
                    ? TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        primaryColor
                    ),
                  ),
                  onPressed: null,
                  child: Text(
                    "Telah disetujui",
                    style: TextStyle(
                        color: Colors.white
                    ),
                  ),
                ) : _taskProvider.selectedTask.status == 3
                    ?TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        redColor
                    ),
                  ),

                  onPressed: null,
                  child: Text(
                    "Telah Ditolak",
                    style: TextStyle(
                        color: Colors.white
                    ),
                  ),
                ) : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            primaryColor
                        ),
                      ),

                      onPressed: () async {
                        createLoadingAlertDialog(context);
                        var data = {
                          "is_done" : true,
                          "status" : 2,
                        };
                        await TaskDatabase(uid: _taskProvider.selectedTask.uid).updateTask(data);
                        Map<String, dynamic> userData = {
                          "total_point" : _childProvider.selectedChild.totalPoint+_taskProvider.selectedTask.point,
                        };
                        var totalTask = await TaskDatabase().countFinishedTask();
                        userData["achievements"] = _childProvider.selectedChild.achievements;
                        if (totalTask >= 1) {
                          userData["achievements"][0] = true;
                        }
                        if (totalTask >= 5) {
                          userData["achievements"][2] = true;
                        }
                        if (totalTask >= 15) {
                          userData["achievements"][4] = true;
                        }
                        await ChildDatabase(uid: _childProvider.selectedChild.uid).updateChildData(userData);
                        Navigator.pop(context);
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => this.widget));
                      },
                      child: Text(
                        "Setuju",
                        style: TextStyle(
                            color: Colors.white
                        ),
                      ),
                    ),
                    SizedBox(width: 10.0,),
                    OutlinedButton(
                      style: ButtonStyle(
                          side: MaterialStateProperty.all<BorderSide>(
                              BorderSide(
                                  color: primaryColor
                              )
                          )
                      ),
                      onPressed: () async {
                        createLoadingAlertDialog(context);
                        var data = {
                          "status" : 3,
                        };
                        await TaskDatabase(uid: _taskProvider.selectedTask.uid).updateTask(data);
                        Navigator.pop(context);
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => this.widget));
                      },
                      child: Text(
                        "Tolak",
                        style: TextStyle(
                            color: primaryColor
                        ),
                      ),
                    )
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildChildProfile(){
    return Row(
      children: [
        _childProvider.selectedChild.imageUrl.length > 0
            ? ClipRRect(
          child: Image.network(
            _childProvider.selectedChild.imageUrl,
            fit: BoxFit.fill,
            height: 40,
            width: 40,
          ),borderRadius: BorderRadius.circular(20.0),) : Icon(
          Icons.account_circle,
          size: 50.0,
          color: Colors.white,
        ),
        SizedBox(width: 10.0,),
        Text(
          _childProvider.selectedChild.name,
          style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 25.0,
              fontWeight: FontWeight.w700
          ),
        )
      ],
    );
  }

  Widget _buildSubmitButton(){
    return ElevatedButton(
      onPressed: () {},
      child: Text('Buat Tugas'),
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(
              secondaryColor
          )
      ),
    );
  }

  Widget _buildPointField(){
    return ListTile(
      leading: Icon(Icons.card_giftcard, color: shadowColor,),
      title: Text(
        "Jumlah poin yang didapat",
        style: TextStyle(
            fontSize: 18.0,
            color: shadowColor,
            fontFamily: "Poppins",
            fontWeight: FontWeight.w600
        ),
      ),
      trailing: Text(
        "${_taskProvider.selectedTask.point}pts",
        style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: 17.0
        ),
      ),
    );
  }

  Widget _buildCategoryField(){
    return ListTile(
      leading: Icon(Icons.category, color: shadowColor,),
      title:Text(
        "Kategori Tugas",
        style: TextStyle(
            fontSize: 18.0,
            color: shadowColor,
            fontFamily: "Poppins",
            fontWeight: FontWeight.w600
        ),
      ),
      trailing: Container(
        padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 8.0),
        decoration: BoxDecoration(
            color: secondaryColor,
            borderRadius: BorderRadius.circular(5.0)
        ),
        child: Text(
          _taskProvider.selectedTask.category,
          style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              fontSize: 15.0,
              color: Colors.white
          ),
        ),
      ),
    );
  }

  Widget _buildTitleField(){
    return TextFormField(
      style: TextStyle(
        fontSize: 20.0,
        fontWeight: FontWeight.w600,
        fontFamily: 'Poppins',
      ),
      cursorColor: secondaryColor,
      decoration: InputDecoration(
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                  color: shadowColor,
                  width: 2.0
              )
          ),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                  color: secondaryColor,
                  width: 2.0
              )
          ),
          floatingLabelBehavior: FloatingLabelBehavior.never
      ),
      enabled: false,
      initialValue: _taskProvider.selectedTask.title,
      validator: (value) => value.isEmpty ? 'Name is required' : '',
    );
  }

  Widget _buildDeadlineField() {
    return ListTile(
      leading: Icon(Icons.schedule, color: shadowColor,),
      trailing: Text(
        DateFormat("dd-MM-yyyy").format(_taskProvider.selectedTask.deadline).toString(),
        style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: 17.0
        ),
      ),
      title: Text(
        "Batas tugas selesai",
        style: TextStyle(
            fontSize: 18.0,
            color: shadowColor,
            fontFamily: "Poppins",
            fontWeight: FontWeight.w600
        ),
      ),
    );
  }
}
