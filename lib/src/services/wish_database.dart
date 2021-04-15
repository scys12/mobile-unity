import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile_unity/src/models/task.dart';

class WishDatabase {
  final String uid;
  WishDatabase({this.uid});

  final CollectionReference _wishesCollection =
  FirebaseFirestore.instance.collection("wishes");

  Future createTask(Map<String, dynamic> answers) async {
    var response = await _wishesCollection.add(answers);
  }

  List<Task> _taskListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((data) {
      DateTime date = data["created_at"].toDate();
      return Task(
        uid: data.id,
        title: data["title"],
        category: data["category"],
        deadline: data["deadline"],
        createdAt: date,
        isDone: data["is_done"],
        point: data["point"],
      );
    }).toList();
  }

  Stream<List<Task>> getTasks(int limit) {
    return _wishesCollection
        .where('is_done', isEqualTo: false)
        .orderBy('created_at')
        .limit(limit)
        .snapshots()
        .map(_taskListFromSnapshot);
  }
}
