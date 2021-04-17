import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';

class Storage{
  final File image;
  final String filename;
  final String folderName;
  Storage({this.image, this.filename, this.folderName});
  FirebaseStorage storage =
      FirebaseStorage.instance;

  Future<String> uploadPicture() async{
    String filename = basename(image.path);
    Reference storageRef = storage.ref().child("${folderName}/${filename}");
    UploadTask uploadTask = storageRef.putFile(image);
    String urlImage = '';
    try {
      TaskSnapshot taskSnapshot = await uploadTask;
      urlImage = await taskSnapshot.ref.getDownloadURL();
    } on FirebaseException catch (e) {
      print(uploadTask.snapshot);
    }
    return urlImage;
  }
}