import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile_unity/src/models/financial.dart';
import 'package:mobile_unity/src/models/task.dart';

class FinancialDatabase {
  final String uid;
  FinancialDatabase({this.uid});

  final CollectionReference _financialCollection =
  FirebaseFirestore.instance.collection("financials");

  Future createFinancial(Map<String, dynamic> data) async {
    var response = await _financialCollection.add(data);
  }

  List<Financial> _financialListFromSnapshot(QuerySnapshot snapshot) {
    var resp =  snapshot.docs.map((data) {
      DateTime createdDate = data["created_at"].toDate();
      return Financial(
          uid: data.id,
          title: data["title"],
          createdAt: createdDate,
          type: data["type"],
          description: data["description"],
          money: data["money"],
          childId: data["child_id"]
      );
    }).toList();
    return resp;
  }

  Stream<List<Financial>> getTasks(int limit) {
    return _financialCollection
        .where('is_done', isEqualTo: false)
        .where('deadline', isGreaterThanOrEqualTo: DateTime.now())
        .limit(limit)
        .snapshots()
        .map(_financialListFromSnapshot);
  }
}
