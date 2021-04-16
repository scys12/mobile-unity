
import 'package:cloud_firestore/cloud_firestore.dart';

class ChildDatabase{
  final String uid;
  ChildDatabase({this.uid});

  final CollectionReference _childCollection = FirebaseFirestore.instance.collection("childs");

  Future updateChildData(Map<String, dynamic> data) async {
    return await _childCollection.doc(uid).set({
      'name' : data["name"],
      'gender' : data["gender"],
      'phone_number' : data["phone_number"],
      'income' : data["income"],
      'outcome' : data["outcome"],
      'total_point' : data["total_point"],
      'is_profile_filled' : data["is_profile_filled"],
      'parent_id' : data["parent_id"],
    });
  }
}