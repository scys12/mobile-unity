import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobile_unity/src/models/parent.dart' as Custom;
import 'package:mobile_unity/src/services/parent_database.dart';

class AuthService {
  final FirebaseAuth _auth =  FirebaseAuth.instance;
  String verificationId;

  Custom.Parent _userFromFirebaseUser(User user){
    return user != null ? Custom.Parent(uid: user.uid, name: user.displayName) : null ;
  }

  Stream<Custom.Parent> get user{
    return _auth.authStateChanges()
        .map(_userFromFirebaseUser);
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

  Future<UserCredential> signInWithPhoneNumber(String pin) async{
    PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: pin);
    UserCredential userCredential = await _auth.signInWithCredential(phoneAuthCredential);
    return userCredential;
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
    Custom.Parent _user;
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User user = credential.user;
      await ParentDatabase(uid: user.uid).updateParentData('', 0, '');
      _user = _userFromFirebaseUser(user);
    } catch (e) {
      print(e);
    }
    return _user;
  }
  //register email password
  Future signInWithEmailAndPassword(String email, String password) async {
    Custom.Parent _user;
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User user = credential.user;
      _user = _userFromFirebaseUser(user);
    } catch (e) {
      print(e);
    }
    return _user;
  }
}