import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile_unity/src/models/challenge.dart';
import 'package:mobile_unity/src/models/teenager.dart';

class ChallengeDatabase {
  final String uid;
  ChallengeDatabase({this.uid});

  final CollectionReference _challengesCollection =
  FirebaseFirestore.instance.collection("challenges");

  List<Challenge> _challengeListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((data) {
      return _mapDataFromDynamic(data.id, data.data());
    }).toList();
  }

  Future<int> countFinishedChallenge(String teenagerId) async{
    var resp = await _challengesCollection
        .where('isDone', isEqualTo: true)
        .where('teenagerId', isEqualTo: teenagerId)
        .get();
    return resp.docs.map(_challengeListFromQueryDocumentSnapshot).toList().length;
  }

  Future<void> updateChallenge(Map<String, dynamic> data){
    return _challengesCollection.doc(uid).update(data);
  }

  Challenge _challengeListFromQueryDocumentSnapshot(QueryDocumentSnapshot snapshot) {
    var data =snapshot.data();
    return _mapDataFromDynamic(snapshot.id, data);
  }

  Future<Challenge> getChallengeById() async{
    var resp = await _challengesCollection.doc(uid).get();
    return _mapDataFromDynamic(resp.id, resp.data());
  }

  Challenge _mapDataFromDynamic(String id, Map<String, dynamic> data){
    return Challenge(
      uid: id,
      isDone: data["isDone"],
      teenagerId: data["teenagerId"],
      key: data["key"],
      title: data["title"],
      description: data["description"]
    );
  }

  Stream<List<Challenge>> getChallenge(Teenager teenager) {
    return teenager == null ? null : _challengesCollection
        .where('teenagerId', isEqualTo: teenager.uid)
        .snapshots()
        .map(_challengeListFromSnapshot);
  }

  Future<void> initChallenge(String teenagerId) async {
    final List<dynamic> challenges = [
      {
        "title" : "Kumpulkan uang hingga Rp 100.000 dalam seminggu",
        "description" : "Kumpulkanlah uang hingga Rp 100.000 dalam selama satu minggu agar dapat menyelesaikan tantangan ini",
        "key" : "kumpul",
        "isDone" : false,
        "teenagerId" : teenagerId
      },
      {
        "description": "Menabunglah selama seminggu berturut-turut untuk menyelesaikan tantangan ini",
        "key": "tabung",
        "title": "Menabung berturut-turut selama seminggu",
        "isDone": false,
        "teenagerId": teenagerId
      },
      {
        "description": "Gunakanlah aplikasi ini selama seminggu untuk menyelesaikan tantangan ini",
        "title": "Aktif menggunakan aplikasi selama seminggu",
        "key": "login",
        "isDone": false,
        "teenagerId": teenagerId
      }
    ];
    await _challengesCollection.add(challenges[0]);
    await _challengesCollection.add(challenges[1]);
    await _challengesCollection.add(challenges[2]);
  }
}
