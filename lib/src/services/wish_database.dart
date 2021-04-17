import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile_unity/src/models/task.dart';
import 'package:mobile_unity/src/models/wish.dart';

class WishDatabase {
  final String uid;
  WishDatabase({this.uid});

  final CollectionReference _wishesCollection =
  FirebaseFirestore.instance.collection("wishes");

  Future createTask(Map<String, dynamic> answers) async {
    var response = await _wishesCollection.add(answers);
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
    );
  }

  Stream<List<Wish>> getWish(String childId) {
    return _wishesCollection
      .where('child_id', isEqualTo: childId)
      .orderBy('created_at', descending: true)
      .snapshots()
      .map(_wishListFromSnapshot);
  }
}
