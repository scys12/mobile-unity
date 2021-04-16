
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile_unity/src/models/child.dart';

class ChildDatabase{
  final String uid;
  ChildDatabase({this.uid});

  final CollectionReference _childCollection = FirebaseFirestore.instance.collection("childs");

  Future<bool> checkUser() async{
    var resp = await _childCollection.doc(uid).get();
    return resp.exists;
  }

  Future<Child> get users async{
    print("kk");
    var resp =  await _childCollection.doc(uid).get();
    var data = resp.data();
    return Child(
      uid: uid,
      phoneNumber: data["phone_number"],
      isProfileFilled: data["is_profile_filled"],
      gender: data["gender"],
      income: data["income"],
      outcome: data["outcome"],
      parentId: data["parent_id"],
      totalPoint: data["total_point"],
      name: data["name"],
    );
  }

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