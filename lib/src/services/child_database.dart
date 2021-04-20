
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile_unity/src/models/child.dart';
import 'package:mobile_unity/src/models/user.dart';

class ChildDatabase{
  final String uid;
  ChildDatabase({this.uid});

  final CollectionReference _childCollection = FirebaseFirestore.instance.collection("childs");

  Future<bool> checkUser() async{
    var resp = await _childCollection.doc(uid).get();
    return resp.exists;
  }

  Future<Child> getChild() async{
    var resp = await _childCollection.doc(uid).get();
    return _mapDataFromDynamic(uid, resp.data());
  }

  Future<Child> getOneChild(String parentId) async {
    var resp = await _childCollection
        .where('parent_id', isEqualTo:  parentId)
        .orderBy('created_at', descending: false)
        .limit(1)
        .get();
     var data = resp.docs.map(_childListFromQueryDocumentSnapshot).toList();
     return data.length > 0 ? data[0] : null;
  }

  Stream<Child> getChildData(){
    return _childCollection.doc(uid).snapshots().map(_parentFromSnapshot);
  }

  Stream<Child> getChildDataFromUser(AuthUser user){
    return user == null ? null : _childCollection.doc(user.uid).snapshots().map(_parentFromSnapshot);
  }

  Child _parentFromSnapshot(DocumentSnapshot snapshot) {
    var data = snapshot.data();
    return data != null ? _mapDataFromDynamic(snapshot.id, data) : null;
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
      return _mapDataFromDynamic(data.id, data.data());
    }).toList();
  }

  Child _childListFromQueryDocumentSnapshot(QueryDocumentSnapshot snapshot) {
    var data =snapshot.data();
    return _mapDataFromDynamic(snapshot.id, data);
  }

  Child _mapDataFromDynamic(String uid, Map<String, dynamic> data){
    print("DATA ${data}");
    DateTime bornDate = data["born_date"].toDate();
    DateTime createdAt = data["created_at"].toDate();
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
        bornDate: bornDate,
        imageUrl: data["image_url"],
        createdAt: createdAt,
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
    print("UID ${uid}");
    var resp =  await _childCollection.doc(uid).get();
    var data = resp.data();
    return _mapDataFromDynamic(resp.id, data);
  }

  Future updateChildData(Map<String, dynamic> data) async {
    return await _childCollection.doc(uid).update(data);
  }

  Future createChildData(Map<String, dynamic> data) async {
    return await _childCollection.doc(uid).set(data);
  }
}