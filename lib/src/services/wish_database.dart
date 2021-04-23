import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile_unity/src/models/child.dart';
import 'package:mobile_unity/src/models/task.dart';
import 'package:mobile_unity/src/models/wish.dart';

class WishDatabase {
  final String uid;
  WishDatabase({this.uid});

  final CollectionReference _wishesCollection =
  FirebaseFirestore.instance.collection("wishes");

  Future createWish(Map<String, dynamic> answers) async {
    var response = await _wishesCollection.add(answers);
  }

  Future updateWish(Map<String, dynamic> answers) async {
    var response = await _wishesCollection.doc(uid).update(answers);
  }

  Future<int> countFinishedWish(String childId) async{
    var resp = await _wishesCollection
        .where('is_done', isEqualTo: true)
        .where('child_id', isEqualTo: childId)
        .get();
    return resp.docs.map(_wishListFromQueryDocumentSnapshot).toList().length;
  }

  List<Wish> _wishListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((data) {
      return _mapDataFromDynamic(data.id, data.data());
    }).toList();
  }

  Wish _wishListFromQueryDocumentSnapshot(QueryDocumentSnapshot snapshot) {
    var data =snapshot.data();
    return _mapDataFromDynamic(snapshot.id, data);
  }

  Future<List<Wish>> getWishes(String childId) async{
    var resp =  await _wishesCollection
        .where('child_id', isEqualTo: childId)
        .orderBy('created_at', descending: true)
      .get();
    return resp.docs.map(_wishListFromQueryDocumentSnapshot).toList();
  }

  Future<Wish> getWishById() async{
    var resp =  await _wishesCollection
        .doc(uid)
        .get();
    return _mapDataFromDynamic(resp.id, resp.data());
  }

  Wish _mapDataFromDynamic(String id, Map<String, dynamic> data){
    DateTime createdDate = data["created_at"].toDate();
    DateTime deadlineDate = data["deadline"].toDate();
    return Wish(
      uid: id,
      title: data["title"],
      point: data["point"],
      deadline: deadlineDate,
      isDone: data["is_done"],
      childId: data["child_id"],
      createdAt: createdDate,
      currentMoney: data["current_money"],
      target: data["target"],
      frekuensi: data["frekuensi"],
      expectedMoney: data["expected_money"],
    );
  }

  Stream<List<Wish>> getWish(Child child) {
    return child == null ? null : _wishesCollection
      .where('child_id', isEqualTo: child.uid)
      .where('is_done', isEqualTo: false)
      .orderBy('created_at', descending: true)
      .snapshots()
      .map(_wishListFromSnapshot);
  }

  Stream<Wish> getActiveWish(String childId) {
    var wish = _wishesCollection
        .where('child_id', isEqualTo: childId)
        .where('is_done', isEqualTo: false)
        .where('deadline', isGreaterThanOrEqualTo: DateTime.now())
        .snapshots();
    var oneWish =  wish.map(_wishListFromSnapshot);
    return oneWish.map((event){
      return event.length > 0? event.first : null;
    });
  }

  Stream<Wish> getActiveWishFromChild(Child child) {
    if (child == null) {
      return null;
    }else {
      var wish = _wishesCollection
          .where('child_id', isEqualTo: child.uid)
          .where('is_done', isEqualTo: false)
          .where('deadline', isGreaterThanOrEqualTo: DateTime.now())
          .snapshots();
      var oneWish =  wish.map(_wishListFromSnapshot);
      return oneWish.map((event){
        return event.length > 0? event.first : null;
      });
    }
  }
}
