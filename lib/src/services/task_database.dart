import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile_unity/src/models/task.dart';

class TaskDatabase {
  final String uid;
  TaskDatabase({this.uid});

  final CollectionReference _tasksCollection =
      FirebaseFirestore.instance.collection("tasks");

  Future createTask(Map<String, dynamic> answers) async {
    var response = await _tasksCollection.add(answers);
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
    return _tasksCollection
        .where('is_done', isEqualTo: false)
        .where('deadline', isGreaterThanOrEqualTo: DateTime.now())
        .limit(limit)
        .snapshots()
        .map(_taskListFromSnapshot);
  }
}
