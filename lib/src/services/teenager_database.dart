
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
    if (data != null) {
      DateTime bornDate = data["born_date"].toDate();
      DateTime incomeDate = data["income_date"].toDate();
      DateTime outcomeDate = data["outcome_date"].toDate();
      DateTime lastLogin = data["last_login"].toDate();
      List<bool> achievements = data["achievements"].cast<bool>();
      return Teenager(
        uid: resp.id,
        phoneNumber: data["phone_number"],
        isProfileFilled: data["is_profile_filled"],
        gender: data["gender"],
        email: data["email"],
        name: data["name"],
        imageUrl: data["image_url"],
        totalPoint: data["total_point"],
        outcome: data["outcome"],
        income: data["income"],
        achievements: achievements,
        bornDate: bornDate,
        incomeFrekuensi: data["income_frekuensi"],
        incomeMoney: data["income_money"],
        outcomeFrekuensi: data["outcome_frekuensi"],
        outcomeMoney: data["outcome_money"],
        incomeDate: incomeDate,
        outcomeDate: outcomeDate,
        lastLogin: lastLogin,
        totalLogin: data["total_login"]
      );
    } else {
      return null;
    }
  }

  Stream<Teenager> getTeenagerData(){
    return _teenagerCollection.doc(uid).snapshots().map(_teenagerFromSnapshot);
  }

  Stream<Teenager> getTeenagerDataFromUser(AuthUser user){
    return user == null ? null : user.uid != null ? _teenagerCollection.doc(user.uid).snapshots().map(_teenagerFromSnapshot) : null;
  }

  Teenager _teenagerFromSnapshot(DocumentSnapshot snapshot) {
    var data = snapshot.data();
    if (data != null) {
      DateTime bornDate = data["born_date"].toDate();
      DateTime incomeDate = data["income_date"].toDate();
      DateTime outcomeDate = data["outcome_date"].toDate();
      DateTime lastLogin = data["last_login"].toDate();
      List<bool> achievements = data["achievements"].cast<bool>();
      return Teenager(
        uid: snapshot.id,
        phoneNumber: data["phone_number"],
        isProfileFilled: data["is_profile_filled"],
        gender: data["gender"],
        email: data["email"],
        name: data["name"],
        imageUrl: data["image_url"],
        totalPoint: data["total_point"],
        outcome: data["outcome"],
        income: data["income"],
        achievements: achievements,
        bornDate: bornDate,
        incomeFrekuensi: data["income_frekuensi"],
        incomeMoney: data["income_money"],
        outcomeFrekuensi: data["outcome_frekuensi"],
        outcomeMoney: data["outcome_money"],
        incomeDate: incomeDate,
        outcomeDate: outcomeDate,
        lastLogin: lastLogin,
        totalLogin: data["total_login"],
      );
    } else {
      return null;
    }
  }


  Future<void> updateTeenagerData(Map<String, dynamic> data) async {
    print(uid);
    return await _teenagerCollection.doc(uid).update(data);
  }

  Future<void> createTeenagerData(Map<String, dynamic> data) async {
    return await _teenagerCollection.doc(uid).set(data);
  }
}