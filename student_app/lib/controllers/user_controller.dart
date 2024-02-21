import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserController {
  static User? user = FirebaseAuth.instance.currentUser;

  static Future<User?> loginWithGoogle() async {
    var googleAccount = await GoogleSignIn().signIn();
    var googleAuth = await googleAccount?.authentication;

    var credentials = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    var userCredential = await FirebaseAuth.instance.signInWithCredential(
      credentials,
    );
    user = FirebaseAuth.instance.currentUser;
    return userCredential.user;
  }

  static Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
    user = null;
  }
}
