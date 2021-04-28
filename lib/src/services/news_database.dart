import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile_unity/src/models/child.dart';
import 'package:mobile_unity/src/models/financial.dart';
import 'package:mobile_unity/src/models/news.dart';

class NewsDatabase {
  final String uid;
  NewsDatabase({this.uid});

  final CollectionReference _newsCollection =
  FirebaseFirestore.instance.collection("news");

  List<News> _newsListFromSnapshot(QuerySnapshot snapshot) {
    var resp =  snapshot.docs.map((data) {
      return _mapDataFromDynamic(data.id, data.data());
    }).toList();
    return resp;
  }

  News _mapDataFromDynamic(String id, Map<String, dynamic> data){
    DateTime createdDate = data["created_at"].toDate();
    return News(
      uid: id,
      createdAt: createdDate,
      title: data["title"],
      description: data["description"],
      imageUrl: data["image_url"]
    );
  }

  Stream<List<News>> getNews() {
    return _newsCollection
        .snapshots()
        .map(_newsListFromSnapshot);
  }
}
