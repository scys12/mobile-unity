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
      return _mapDataFromDynamic(data.id, data.data());
    }).toList();
    return resp;
  }

  Financial _mapDataFromDynamic(String id, Map<String, dynamic> data){
    DateTime createdDate = data["created_at"].toDate();
    return Financial(
        uid: id,
        title: data["title"],
        createdAt: createdDate,
        type: data["type"],
        description: data["description"],
        money: data["money"],
        childId: data["child_id"]
    );
  }

  Financial _financialListFromQueryDocumentSnapshot(QueryDocumentSnapshot snapshot) {
    var data =snapshot.data();
    return _mapDataFromDynamic(snapshot.id, data);
  }

  Future<List<Financial>> getFinancialsBasesChildId(String childId) async{
    var resp =  await _financialCollection
        .where('child_id', isEqualTo: childId)
        .get();
    return resp.docs.map(_financialListFromQueryDocumentSnapshot).toList();
  }

  Stream<List<Financial>> getFinancials(String childId) {
    return _financialCollection
      .where('child_id', isEqualTo: childId)
      .snapshots()
      .map(_financialListFromSnapshot);
  }
}
