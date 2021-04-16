import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobile_unity/src/models/child.dart';
import 'package:mobile_unity/src/models/parent.dart';
import 'package:mobile_unity/src/services/child_database.dart';
import 'package:mobile_unity/src/services/parent_database.dart';

class AuthService {
  final FirebaseAuth _auth =  FirebaseAuth.instance;
  String verificationId;

  Future<Parent> _parentFromFirebaseUser(User user) async{
    return user != null && user.providerData[0].providerId == 'password' ? ParentDatabase(uid: user.uid).users : null ;
  }

  Future<Child> _childFromFirebaseUser(User user) async{
    return user != null && user.providerData[0].providerId == 'phone' ? ChildDatabase(uid: user.uid).users : null ;
  }

  Stream<Parent> get parent{
    return _auth.authStateChanges()
        .asyncMap(_parentFromFirebaseUser);
  }

  Stream<Child> get child{
    return _auth.authStateChanges()
        .asyncMap(_childFromFirebaseUser);
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

  Future<User> signInWithPhoneNumber(String pin) async{
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
  Future registerEmailAndPassword(String email, String password) async {
    Parent _user;
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User user = credential.user;
      var data = {
        "name": "",
        "gender" : "",
        "phone_number" : "",
        "is_profile_filled" : false,
        "email" : user.email,
      };
      await ParentDatabase(uid: user.uid).createParentData(data);
      _user = await _parentFromFirebaseUser(user);
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
      _user = await _parentFromFirebaseUser(user);
    } catch (e) {
      print(e);
    }
    return _user;
  }
}