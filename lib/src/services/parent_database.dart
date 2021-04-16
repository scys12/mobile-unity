
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile_unity/src/models/parent.dart';

class ParentDatabase{
  final String uid;
  ParentDatabase({this.uid});

  final CollectionReference _parentCollection = FirebaseFirestore.instance.collection("parents");

  Future<Parent> get users async{
    var resp =  await _parentCollection.doc(uid).get();
    var data = resp.data();
    return Parent(
      uid: uid,
      phoneNumber: data["phone_number"],
      isProfileFilled: data["is_profile_filled"],
      gender: data["gender"],
      email: data["email"],
      name: data["name"],
    );
  }

  Future<void> updateParentData(Map<String, dynamic> data) async {
    return await _parentCollection.doc(uid).update(data);
  }

  Future<void> createParentData(Map<String, dynamic> data) async {
    return await _parentCollection.doc(uid).set(data);
  }
}