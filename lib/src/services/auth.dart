import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobile_unity/src/models/child.dart';
import 'package:mobile_unity/src/models/parent.dart';
import 'package:mobile_unity/src/models/teenager.dart';
import 'package:mobile_unity/src/models/user.dart';
import 'package:mobile_unity/src/services/child_database.dart';
import 'package:mobile_unity/src/services/parent_database.dart';
import 'package:mobile_unity/src/services/teenager_database.dart';

class AuthService {
  final FirebaseAuth _auth =  FirebaseAuth.instance;
  String verificationId;

  Future<Parent> _parentFromFirebaseUser(User user) async{
    return user != null && user.providerData[0].providerId == 'password' ? await ParentDatabase(uid: user.uid).users : null ;
  }

  Future<Teenager> _teenagerFromFirebaseUser(User user) async{
    return user != null && user.providerData[0].providerId == 'password' ? await TeenagerDatabase(uid: user.uid).users : null ;
  }

  Future<AuthUser> _authUserFromFirebaseUser(User user) async{
    if (user != null) {
      var providerId = user.providerData[0].providerId;
      return AuthUser(uid: user.uid, authId: providerId == "phone" ? user.phoneNumber : user.email, providerId: providerId);
    } else {
      return null;
    }
  }

  Stream<AuthUser> get user{
    print("_AUTH USER FROM GET USER");
    return _auth.authStateChanges()
        .asyncMap(_authUserFromFirebaseUser);
  }

  //sign in phone
  Future<void> verifyPhoneNumber(String phoneNumber) async {
    phoneNumber  = phoneNumber.toString().trim();

    void verificationCompleted(PhoneAuthCredential credential) async {
      var a = await _auth.signInWithCredential(credential);
    }

    void verificationFailed(FirebaseAuthException e){
     print("VERIFICATION FAILED ${e.message}");
    }

    void codeSent(String verificationId, [int resendToken]) async {
      this.verificationId = verificationId;
    }

    void codeAutoRetrievalTimeout(String verificationId){
      this.verificationId = verificationId;
    }

    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          timeout: const Duration(minutes: 2),
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
    }catch (e) {
      print("AUTH VERIFY PHONE NUMBER FAILED : ${e}");
    }
  }

  Future<User> signInWithPhoneNumber(String pin) async{
    print(pin);
    print(verificationId);
    PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: pin);
    UserCredential userCredential = await _auth.signInWithCredential(phoneAuthCredential);
    User user = userCredential.user;
    return user;
  }

  //sign in email password
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    }catch (e) {
      print(e);
    }
  }

  //register phone
  Future registerEmailAndPassword(String email, String password, String type) async {
    dynamic _user;
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User user = credential.user;
      var data = {
        "name": "",
        "gender" : "",
        "phone_number" : "",
        "is_profile_filled" : false,
        "email" : user.email,
        "image_url" : "",
      };
      if (type == "parent") {
        await ParentDatabase(uid: user.uid).createParentData(data);
        _user = await _parentFromFirebaseUser(user);
      }else{
        data["total_point"] = 0;
        data["outcome"] = 0;
        data["income"] = 0;
        await TeenagerDatabase(uid: user.uid).createTeenagerData(data);
        _user = await _teenagerFromFirebaseUser(user);
      }
    } on FirebaseAuthException catch (e) {
      return e.code;
    }
    return _user;
  }
  //register email password
  Future signInWithEmailAndPassword(String email, String password, String type) async {
    dynamic _user;
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User user = credential.user;
      if(type == "teenager") _user = await _teenagerFromFirebaseUser(user);
      else _user = await _parentFromFirebaseUser(user);
    } catch (e) {
      print(e);
    }
    return _user;
  }
}