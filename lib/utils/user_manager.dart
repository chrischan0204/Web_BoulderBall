import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class UserManager {
  static Future<String> getUsername() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    return auth.currentUser?.displayName ?? auth.currentUser?.email ?? "";
  }

  static Future<void> signInWithEmail(email, password) async {
    final FirebaseAuth auth = FirebaseAuth.instance;

    try {
      await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> signUpWithEmail(email, password) async {
    final FirebaseAuth auth = FirebaseAuth.instance;

    try {
      await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      createFirebaseUser(auth.currentUser!.uid);
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> signInWithGoogle() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();

      if (googleSignInAccount == null) {
        throw "Sign in failed";
      }

      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      await auth.signInWithCredential(credential);

      createFirebaseUser(auth.currentUser!.uid);
    } catch (e) {
      rethrow;
    }
  }

  static Future<void> createFirebaseUser(uid) async {
    CollectionReference collection =
        FirebaseFirestore.instance.collection("users");

    if (!(await collection.doc(uid).get()).exists) {
      collection.doc(uid).set({"created-on": DateTime.now()});
    }
  }

  static Future<void> signOut() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    final FirebaseAuth auth = FirebaseAuth.instance;

    if (await googleSignIn.isSignedIn()) {
      await googleSignIn.signOut();
    }

    await auth.signOut();
  }

  static Future<void> resetPassword({required String email}) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    await auth
        .sendPasswordResetEmail(email: email)
        .then((value) {})
        .catchError((e) {});
  }
}
