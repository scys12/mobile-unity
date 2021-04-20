import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile_unity/src/models/task.dart';

class TaskDatabase {
  final String uid;
  TaskDatabase({this.uid});

  final CollectionReference _tasksCollection =
  FirebaseFirestore.instance.collection("challenges");

  Future createTask(Map<String, dynamic> answers) async {
    var response = await _tasksCollection.add(answers);
  }
  Future<void > updateTask(Map<String, dynamic> answers) async {
    return await _tasksCollection.doc(uid).update(answers);
  }

  Future<List<Task>> getFinishedTasks(String childId, String parentId) async{
    var resp = await _tasksCollection
        .where('is_done', isEqualTo: true)
        .where('child_id', isEqualTo: childId)
        .where('parent_id', isEqualTo: parentId)
        .orderBy('deadline', descending: false)
        .get();
    return resp.docs.map(_taskListFromQueryDocumentSnapshot).toList();
  }

  Task _taskListFromQueryDocumentSnapshot(QueryDocumentSnapshot snapshot) {
    var data =snapshot.data();
    return _mapDataFromDynamic(snapshot.id, data);
  }

  Task _mapDataFromDynamic(String id, dynamic data){
    DateTime createdDate = data["created_at"].toDate();
    DateTime deadlineDate = data["deadline"].toDate();
    DateTime submitTaskDate = data["submit_task_date"] != null ? data["submit_task_date"].toDate() : null;
    return Task(
        uid: id,
        parentId: data["parent_id"],
        childId: data["child_id"],
        point: data["point"],
        isDone: data["is_done"],
        deadline: deadlineDate,
        category: data["category"],
        title: data["title"],
        submitTaskDate: submitTaskDate,
        status: data["status"],
        createdAt: createdDate,
        imageUrl: data["image_url"]
    );
  }

  Future<Task> getTask() async{
    var resp = await _tasksCollection.doc(uid).get();
    var data = resp.data();
    return _mapDataFromDynamic(resp.id, data);
  }

  Future<List<Task>> getChildTaskFromParent(String childId, String parentId) async{
    var resp = await _tasksCollection
        .where('child_id', isEqualTo: childId)
        .where('parent_id', isEqualTo: parentId)
        .orderBy('created_at', descending: true)
        .get();
    return resp.docs.map(_taskListFromQueryDocumentSnapshot).toList();
  }

  Future<List<Task>> getChildTaskNearDeadline(String childId, String parentId) async{
    var resp = await _tasksCollection
        .where('parent_id', isEqualTo: parentId)
        .where('child_id', isEqualTo: childId)
        .orderBy('deadline', descending: true)
        .get();
    return resp.docs.map(_taskListFromQueryDocumentSnapshot).toList();
  }

  Future<List<Task>> getTwoTasksNotFinished(String childId, String parentId) async{
    var resp = await _tasksCollection
        .where('parent_id', isEqualTo: parentId)
        .where('child_id', isEqualTo: childId)
        .where('deadline', isGreaterThanOrEqualTo: DateTime.now())
        .where('is_done', isEqualTo: false)
        .limit(2)
        .get();
    return resp.docs.map(_taskListFromQueryDocumentSnapshot).toList();
  }

  Future<List<Task>> getChildEducationFromParent(String childId, String parentId) async{
    var resp = await _tasksCollection
        .where('child_id', isEqualTo: childId)
        .where('parent_id', isEqualTo: parentId)
        .where('category', isEqualTo: 'Edukasi Finansial')
        .orderBy('created_at', descending: true)
        .get();
    return resp.docs.map(_taskListFromQueryDocumentSnapshot).toList();
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
          childId: data["child_id"],
          imageUrl: data["image_url"]
      );
    }).toList();
    return resp;
  }

  Stream<List<Task>> getTasks(String parentId, String childId) {
    return _tasksCollection
        .where('is_done', isEqualTo: false)
        .where('deadline', isGreaterThanOrEqualTo: DateTime.now())
        .where('parent_id', isEqualTo: parentId)
        .where('child_id', isEqualTo: childId)
        .snapshots()
        .map(_taskListFromSnapshot);
  }
}
