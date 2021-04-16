import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobile_unity/src/models/child.dart';
import 'package:mobile_unity/src/models/parent.dart';
import 'package:mobile_unity/src/services/child_database.dart';
import 'package:mobile_unity/src/services/parent_database.dart';

class AuthService {
  final FirebaseAuth _auth =  FirebaseAuth.instance;
  String verificationId;

  Parent _parentFromFirebaseUser(User user){
    return user != null && user.providerData[0].providerId == 'password' ? Parent(uid: user.uid, name: user.displayName) : null ;
  }
  Child _childFromFirebaseUser(User user){
    return user != null && user.providerData[0].providerId == 'phone' ? Child(uid: user.uid, name: user.displayName) : null ;
  }

  Stream<Parent> get parent{
    return _auth.authStateChanges()
        .map(_parentFromFirebaseUser);
  }

  Stream<Child> get child{
    return _auth.authStateChanges()
        .map(_childFromFirebaseUser);
  }

  //sign in phone
  Future<void> verifyPhoneNumber(String phoneNumber) async {
    phoneNumber  = phoneNumber.toString().trim();

    void verificationCompleted(PhoneAuthCredential credential) async {
      await _auth.signInWithCredential(credential);
    }

    void verificationFailed(FirebaseAuthException e){
     print(e.message);
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
      print(e);
    }
  }

  Future<Child> signInWithPhoneNumber(String pin) async{
    Child _user;
    PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: pin);
    UserCredential userCredential = await _auth.signInWithCredential(phoneAuthCredential);
    User user = userCredential.user;
    _user = _childFromFirebaseUser(user);
    return _user;
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
  Future registerEmailAndPassword(String email, String password) async {
    Parent _user;
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User user = credential.user;
      var data = {
        "name": "",
        "gender" : "",
        "phone_number" : "",
        "is_profile_filled" : 0,
      };
      await ParentDatabase(uid: user.uid).updateParentData(data);
      _user = _parentFromFirebaseUser(user);
    } on FirebaseAuthException catch (e) {
      return e.code;
    }
    return _user;
  }
  //register email password
  Future<Parent> signInWithEmailAndPassword(String email, String password) async {
    Parent _user;
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User user = credential.user;
      _user = _parentFromFirebaseUser(user);
    } catch (e) {
      print(e);
    }
    return _user;
  }
}