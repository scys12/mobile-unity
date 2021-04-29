import 'package:flutter/cupertino.dart';
import 'package:mobile_unity/src/models/challenge.dart';
import 'package:mobile_unity/src/models/child.dart';
import 'package:mobile_unity/src/services/challenge_database.dart';
import 'package:mobile_unity/src/services/child_database.dart';

class ChallengeProvider extends ChangeNotifier{
  Challenge selectedChallenge;

  Future<void> getChallenge({challengeId: String}) async {
    var resp = await ChallengeDatabase(uid: challengeId).getChallengeById();
    this.selectedChallenge = resp;
    notifyListeners();
  }
}