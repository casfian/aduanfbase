import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthenticationProvider {
  //1. class instance (salinan)
  // variable Firebase Auth
  final FirebaseAuth firebaseAuth;

  //2. Constructor
  AuthenticationProvider(this.firebaseAuth);

  //Guna Stream utk dengar perubahan keadaan Authentication
  // Keadaan dia login atau logout
  //User ne adalah FirebaseUser bukan User dari kelas kita tadi
  Stream<User?> get authState => firebaseAuth.idTokenChanges();

  //KITA AKAN BUAT 3 FUNCTIONS: SignUp, SignIn, SignOut
  //
  //1. SignUp
  Future<String?> signUp(
      {required String email, required String password}) async {
    try {
      await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return 'Dah Register';
    } on FirebaseAuthException catch (e) {
      debugPrint(e.toString());
      return e.message;
    }
  }

  //2. SignIn
  Future<String?> signIn(
      {required String email, required String password}) async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return 'Dah Login';
    } on FirebaseAuthException catch (e) {
      debugPrint(e.toString());
      return e.message;
    }
  }

  //3. SignOut
  Future<void> signOut() async {
    try {
      await firebaseAuth.signOut();
      debugPrint('Sign Out');
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
