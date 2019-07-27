import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  FirebaseAuth _firebaseAuth;
  FirebaseUser _user;

  Auth() {
    this._firebaseAuth = FirebaseAuth.instance;
  }

  Future<bool> isLoggedIn() async {
    this._user = await _firebaseAuth.currentUser();
    if (this._user == null) {
      return false;
    }
    return true;
  }
}
