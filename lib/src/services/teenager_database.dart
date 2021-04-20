
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mobile_unity/src/models/teenager.dart';
import 'package:mobile_unity/src/models/user.dart';

class TeenagerDatabase{
  final String uid;
  TeenagerDatabase({this.uid});

  final CollectionReference _teenagerCollection = FirebaseFirestore.instance.collection("teenagers");

  Future<Teenager> get users async{
    print("FUTURE TEENAGER ${uid}");
    var resp =  await _teenagerCollection.doc(uid).get();
    var data = resp.data();
    return data != null ? Teenager(
      uid: uid,
      phoneNumber: data["phone_number"],
      isProfileFilled: data["is_profile_filled"],
      gender: data["gender"],
      email: data["email"],
      name: data["name"],
      imageUrl: data["image_url"],
      totalPoint: data["total_point"],
      outcome: data["outcome"],
      income: data["income"]
    ) : null;
  }

  Stream<Teenager> getTeenagerData(){
    return _teenagerCollection.doc(uid).snapshots().map(_teenagerFromSnapshot);
  }

  Stream<Teenager> getTeenagerDataFromUser(AuthUser user){
    print("Sini teenager ${user}");
    return user == null ? null :  _teenagerCollection.doc(user.uid).snapshots().map(_teenagerFromSnapshot);
  }

  Teenager _teenagerFromSnapshot(DocumentSnapshot snapshot) {
    var data = snapshot.data();
    return data != null ? Teenager(
        uid: snapshot.id,
        phoneNumber: data["phone_number"],
        isProfileFilled: data["is_profile_filled"],
        gender: data["gender"],
        email: data["email"],
        name: data["name"],
        imageUrl: data["image_url"],
        totalPoint: data["total_point"],
        outcome: data["outcome"],
        income: data["income"]
    ) : null;
  }


  Future<void> updateTeenagerData(Map<String, dynamic> data) async {
    print(uid);
    return await _teenagerCollection.doc(uid).update(data);
  }

  Future<void> createTeenagerData(Map<String, dynamic> data) async {
    return await _teenagerCollection.doc(uid).set(data);
  }
}