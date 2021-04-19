import 'dart:io';

import 'package:bubble/bubble.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mobile_unity/src/models/child.dart';
import 'file:///D:/FlutterProject/mobile_unity/lib/src/shared/task_photo.dart';
import 'package:mobile_unity/src/provider/child_provider.dart';
import 'package:mobile_unity/src/provider/task_provider.dart';
import 'package:mobile_unity/src/services/child_database.dart';
import 'package:mobile_unity/src/services/storage.dart';
import 'package:mobile_unity/src/services/task_database.dart';
import 'package:mobile_unity/src/shared/alert_dialog.dart';
import 'package:mobile_unity/src/shared/constants.dart';
import 'package:mobile_unity/src/widgets/app_bar.dart';
import 'package:mobile_unity/src/widgets/loading.dart';
import 'package:mobile_unity/src/widgets/sub_header.dart';
import 'package:provider/provider.dart';

class DetailTaskKid extends StatefulWidget {
  final String taskId;
  DetailTaskKid({this.taskId});
  @override
  _DetailTaskKidState createState() => _DetailTaskKidState();
}

class _DetailTaskKidState extends State<DetailTaskKid> {
  TaskProvider _taskProvider;
  bool _loading = true;
  File _image;
  final ImagePicker _picker = ImagePicker();
  Child _user;
  List<String> status = [
    "Belum Selesai",
    "Menunggu Persetujuan",
    "Sudah Disetujui",
    "Ditolak"
  ];
  List<Color> colors = [
    redColor,
    primaryColor,
    greenColor,
    shadowColor
  ];

  @override
  void initState() {
    super.initState();
    _taskProvider = Provider.of(context, listen: false);
    _taskProvider.getTask(taskId: widget.taskId);
    _user = Provider.of<Child>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    String title;
    _taskProvider =  Provider.of<TaskProvider>(context);
    if (_taskProvider.selectedTask != null && _taskProvider.selectedTask.uid == widget.taskId) {
      setState(() {
        _loading = false;
      });
    }
    return _loading ? Loading() : Scaffold(
      appBar: CustomAppBar(true, "Detail Tugas"),
      body: ListView(
        physics: ClampingScrollPhysics(),
        padding: EdgeInsets.all(30.0),
        children: [
          Form(
            child: Column(
              children: [
                _buildChildProfile(),
                _buildTitleField(),
                SizedBox(height: 20.0,),
                _buildDeadlineField(),
                SizedBox(height: 20.0,),
                _buildCategoryField(),
                SizedBox(height: 20.0,),
                _buildPointField(),
                SizedBox(height: 20.0,),
                Divider(color: shadowColor,thickness: 2.0,),
                SizedBox(height: 10.0,),
                (_taskProvider.selectedTask.imageUrl == "" && _image == null)
                    ? Column(
                      children: [
                        _buildWarning(),
                        SizedBox(height: 20.0,),
                        _buildButtonFinishTask(),
                      ],)
                    : _taskProvider.selectedTask.imageUrl != "" && _image == null
                    ? Column(
                      children: [
                        SubHeader(title: "Progress", isLihatSemua: false,),
                        SizedBox(height: 10.0,),
                        _buildProgress(),
                      ],
                    ) :  Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                                _buildLihatBukti(),
                                _buildUploadButton(),
                          ],
                        ),
                        SizedBox(height: 20.0,),
                        _buildSubmitButton(),
                      ],
                    ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLihatBukti(){
    return TextButton.icon(
      label: Text(
        'Lihat Bukti',
        style: TextStyle(
            color: primaryColor
        ),
      ),
      onPressed: (){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TaskPhoto(image: _image,)),
        );
      },
      icon: Icon(
        Icons.photo_library,
        color: primaryColor,
      ),
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.all(thirdColor),
        side: MaterialStateProperty.all(
          BorderSide(
            color: primaryColor,
          ),
        ),

      ),
    );
  }

  Widget _buildUploadButton(){
    return TextButton.icon(
      label: Text(
        'Unggah Ulang',
        style: TextStyle(
            color: secondaryColor
        ),
      ),
      onPressed: (){
        showModalUploadImageBottom(context, _getImageFromCamera, _getImageFromGallery);
      },
      icon: Icon(
        Icons.camera_alt,
        color: secondaryColor,
      ),
      style: ButtonStyle(
        overlayColor: MaterialStateProperty.all(thirdColor),
        side: MaterialStateProperty.all(
          BorderSide(
            color: secondaryColor,
          ),
        ),

      ),
    );
  }

  Widget _buildWarning(){
    return Bubble(
      margin: BubbleEdges.only(left: 100.0),
      padding: BubbleEdges.only(left: 20.0, right: 25.0, top: 20.0, bottom: 20.0),
      alignment: Alignment.topLeft,
      nip: BubbleNip.rightTop,
      child: Text(
        'Segera selesaikan tugas agar mendapat lencana',
        style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
            fontSize: 15.0,
            color: Colors.white),
      ),
      color: primaryColor,
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
              "Tugas sudah diselesaikan",
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
                    DateFormat("dd-MM-yyyy").format(_taskProvider.selectedTask.submitTaskDate).toString(),
                  style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w700,
                      color: shadowColor
                  ),
                )
              ],
            ),
            SizedBox(height: 10.0,),
            Container(
              decoration: BoxDecoration(
                color: colors[_taskProvider.selectedTask.status],
                borderRadius: BorderRadius.circular(15.0)
              ),
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              child: Text(
                status[_taskProvider.selectedTask.status],
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Poppins',
                  fontSize: 15.0
                ),
              ),
            ),
            SizedBox(height: 10.0,),
            TextButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(
                    shadowColor
                ),
              ),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => TaskPhoto(imageUrl: _taskProvider.selectedTask.imageUrl,)));
              },
              child: Text(
                "Lihat Bukti",
                style: TextStyle(
                    color: Colors.white
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChildProfile(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          "Nama Tugas",
          style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 20.0,
              color: shadowColor,
              fontWeight: FontWeight.w700
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton(){
    return ElevatedButton(
      onPressed: () async{
        var imageUrl = await Storage(folderName: "task", filename: _taskProvider.selectedTask.uid, image: _image).uploadPicture();
        setState(() {
          _loading = true;
        });
        if(_loading) createLoadingAlertDialog(context);
        var data = {
          "image_url" : imageUrl,
          "submit_task_date" : DateTime.now(),
          "status" : 1,
        };
        await TaskDatabase(uid: _taskProvider.selectedTask.uid).updateTask(data);
        Navigator.pop(context);
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => this.widget));
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
            "Kirim Tugas",
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              fontSize: 17.0,
            ),
          ),
        ],
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
      initialValue: _taskProvider.selectedTask.title,
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

  Widget _buildButtonFinishTask() {
    return ElevatedButton(
      onPressed: (){
        showModalUploadImageBottom(context, _getImageFromCamera, _getImageFromGallery);
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
            "Selesaikan Tugas",
            style: TextStyle(
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
              fontSize: 17.0,
            ),
          ),
        ],
      ),
    );
  }

  Future _getImageFromCamera() async{
    final pickedFile = await _picker.getImage(source: ImageSource.camera, imageQuality: 50);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        Navigator.pop(context);
      });
    }
  }

  Future _getImageFromGallery() async{
    final pickedFile = await _picker.getImage(source: ImageSource.gallery, imageQuality: 50);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        Navigator.pop(context);
      });
    }
  }
}
