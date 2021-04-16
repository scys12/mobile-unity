
import 'package:cloud_firestore/cloud_firestore.dart';

class ParentDatabase{
  final String uid;
  ParentDatabase({this.uid});

  final CollectionReference _parentCollection = FirebaseFirestore.instance.collection("parents");

  Future updateParentData(Map<String, dynamic> data) async {
    return await _parentCollection.doc(uid).set({
      'name' : data["name"],
      'gender' : data["gender"],
      'phone_number' : data["phone_number"],
      'is_profile_filled' : data["is_profile_filled"],
    });
  }
}