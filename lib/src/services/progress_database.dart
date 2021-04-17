import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile_unity/src/models/task.dart';

class ProgressDatabase {
  final String uid;
  ProgressDatabase({this.uid});

  final CollectionReference _progressCollection =
  FirebaseFirestore.instance.collection("progress");

  Future createTask(Map<String, dynamic> answers) async {
    var response = await _progressCollection.add(answers);
  }

  List<Task> _taskListFromSnapshot(QuerySnapshot snapshot) {
    var resp =  snapshot.docs.map((data) {
      DateTime createdDate = data["created_at"].toDate();
      DateTime deadlineDate = data["deadline"].toDate();
      return Task(
          uid: data.id,
          title: data["title"],
          category: data["category"],
          deadline: deadlineDate,
          createdAt: createdDate,
          isDone: data["is_done"],
          point: data["point"],
          parentId: data["parent_id"],
          childId: data["child_id"]
      );
    }).toList();
    print(resp.length);
    return resp;
  }

  Stream<List<Task>> getTasks(int limit) {
    return _progressCollection
        .where('is_done', isEqualTo: false)
        .where('deadline', isGreaterThanOrEqualTo: DateTime.now())
        .limit(limit)
        .snapshots()
        .map(_taskListFromSnapshot);
  }
}
