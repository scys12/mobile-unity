
import 'package:cloud_firestore/cloud_firestore.dart';

class ParentDatabase{
  final String uid;
  ParentDatabase({this.uid});

  final CollectionReference _parentCollection = FirebaseFirestore.instance.collection("parents");
  Future updateParentData(String name, int gender, String phone_number) async {
    return await _parentCollection.doc(uid).set({
      'name' : name,
      'gender' : gender,
      'phone_number' : phone_number,
    });
  }
}