import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:udemy_snsapp/model/account.dart';

class Authentication {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static User? currentFirebaseUser;
  static Account? myAccount;

  static Future<dynamic> signUp({required String email, required String pass}) async {
    try {
      UserCredential newAccount = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: pass);
      print('auth登録完了');
      return newAccount;
    } on FirebaseAuthException catch(e) {
      print('auth登録エラー');
      return '登録エラーが発生しました';
    }
  }

  static Future<dynamic> emailSignIn({required String email, required String pass}) async {
    try {
      final UserCredential _result = await _firebaseAuth.signInWithEmailAndPassword(
          email: email,
          password: pass);
      currentFirebaseUser = _result.user;
      print('authサインイン完了');
      return _result;
    } on FirebaseAuthException catch(e) {
      print('authサインインエラー');
      return false;
    }
  }

  static Future<void> signOut() async{
    await _firebaseAuth.signOut();
  }

  static Future<void> deleteAuth() async {
    await currentFirebaseUser!.delete();
  }

  static Future<dynamic> signInWithGoogle() async{
    try{
      final googleUser = await GoogleSignIn(scopes: ['email']).signIn();
      if(googleUser != null){
        final googleAuth = await googleUser.authentication;
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken
        );
        final UserCredential _result = await _firebaseAuth.signInWithCredential(credential);
        currentFirebaseUser = _result.user;
        print('Googleログイン完了');
        return _result;
      }
    } on FirebaseException catch(e){
      print('Googleログインエラー');
      return false;
    }
  }




}