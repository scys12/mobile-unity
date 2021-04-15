
import 'package:cloud_firestore/cloud_firestore.dart';

class ChildDatabase{
  final String uid;
  ChildDatabase({this.uid});

  final CollectionReference _parentCollection = FirebaseFirestore.instance.collection("childs");

  Future updateParentData(String name, int gender, String phone_number) async {
    return await _parentCollection.doc(uid).set({
      'name' : name,
      'gender' : gender,
      'phone_number' : phone_number,
    });
  }
}