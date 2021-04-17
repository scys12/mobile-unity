
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

  Future<List<Child>> getOneChild(String parentId) async {
    var resp = await _childCollection
        .where('parent_id', isEqualTo:  parentId)
        .orderBy('created_at', descending: false)
        .limit(1)
        .get();
    return resp.docs.map(_childListFromQueryDocumentSnapshot).toList();
  }

  Stream<List<Child>> getChildrenFromParent(String parentId) {
    return  _childCollection
        .where('parent_id', isEqualTo:  parentId)
        .orderBy('created_at', descending: false)
        .snapshots()
        .map(_childListFromSnapshot);
  }

  List<Child> _childListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((data) {
      DateTime bornDate = data["born_date"].toDate();
      return Child(
        uid: data.id,
        name: data["name"],
        gender: data["gender"],
        isProfileFilled: data["is_profile_filled"],
        phoneNumber: data["phone_number"],
        income: data["income"],
        outcome: data["outcome"],
        parentId: data["parent_id"],
        totalPoint: data["total_point"],
        bornDate: bornDate,
      );
    }).toList();
  }

  Child _childListFromQueryDocumentSnapshot(QueryDocumentSnapshot snapshot) {
    var data =snapshot.data();
    return Child(
        uid: snapshot.id,
        name: data["name"],
        gender: data["gender"],
        isProfileFilled: data["is_profile_filled"],
        phoneNumber: data["phone_number"],
        income: data["income"],
        outcome: data["outcome"],
        parentId: data["parent_id"],
        totalPoint: data["total_point"],
        bornDate: data["born_date"],
        imageUrl: data["image_url"]
    );
  }

  Future<List<Child>> checkPhoneNumber(String phoneNumber) async {
    var resp = await _childCollection
        .where('phone_number', isEqualTo: phoneNumber)
        .where('parent_id', isEqualTo: '')
        .get();
    return resp.docs.map(_childListFromQueryDocumentSnapshot).toList();
  }

  Future<Child> get users async{
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
      bornDate: data["born_date"],
      imageUrl: data["image_url"]
    );
  }

  Future updateChildData(Map<String, dynamic> data) async {
    return await _childCollection.doc(uid).update(data);
  }

  Future createChildData(Map<String, dynamic> data) async {
    return await _childCollection.doc(uid).set(data);
  }
}