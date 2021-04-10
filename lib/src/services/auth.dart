import 'package:firebase_auth/firebase_auth.dart';
import 'package:mobile_unity/src/models/user.dart' as Custom;

class AuthService {
  final FirebaseAuth _auth =  FirebaseAuth.instance;

  Custom.User _userFromFirebaseUser(User user){
    return user != null ? Custom.User(uid: user.uid, name: user.displayName) : null ;
  }

  Stream<Custom.User> get user{
    return _auth.authStateChanges()
        .map(_userFromFirebaseUser);
  }

  //sign in phone
  Future verifyPhoneNumber(String phoneNumber) async {
    phoneNumber  = "+62 " + phoneNumber.toString().trim();

    void verificationCompleted(PhoneAuthCredential credential) async {
      await _auth.signInWithCredential(credential);
    }

    void verificationFailed(FirebaseAuthException e){
      if (e.code == 'invalid-phone-number') {
        print('The provided phone number is not valid');
      }
    }

    void codeSent(String verificationId, int resendToken) async {
      String smsCode = '123456';
      AuthCredential credential = PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode);
      await _auth.signInWithCredential(credential);
    }

    void codeAutoRetrievalTimeout(String verificationId){

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

  Future signInWithPhoneNumber(String phoneNumber, String verificationCode) async{
    ConfirmationResult confirmationResult = await _auth.signInWithPhoneNumber(phoneNumber);
    UserCredential userCredential = await confirmationResult.confirm(verificationCode);
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
    Custom.User _user;
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User user = credential.user;
      _user = _userFromFirebaseUser(user);
    } catch (e) {
      print(e);
    }
    return _user;
  }
  //register email password
  Future signInWithEmailAndPassword(String email, String password) async {
    Custom.User _user;
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