import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../core/errors/failures.dart';
import '../models/user_model.dart';

abstract class FirebaseAuthDatasource {
  Future<UserModel> signInWithGoogle();
  Future<void> signOut();
  Future<UserModel?> getCurrentUser();
}

class FirebaseAuthDatasourceImpl implements FirebaseAuthDatasource {
  final firebase.FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  FirebaseAuthDatasourceImpl(this._firebaseAuth, this._firestore);

  @override
  Future<UserModel> signInWithGoogle() async {
    try {
      // google_sign_in v7.x uses a singleton and `authenticate()`
      final GoogleSignInAccount googleUser = await GoogleSignIn.instance
          .authenticate();

      final idToken = googleUser.authentication.idToken;
      final firebase.AuthCredential credential =
          firebase.GoogleAuthProvider.credential(idToken: idToken);

      final firebase.UserCredential userCredential = await _firebaseAuth
          .signInWithCredential(credential);
      final firebase.User? user = userCredential.user;

      if (user != null) {
        final userModel = UserModel(
          id: user.uid,
          name: user.displayName ?? googleUser.displayName ?? '',
          email: user.email ?? googleUser.email,
          photoUrl: user.photoURL ?? googleUser.photoUrl,
          lastLogin: DateTime.now(),
        );

        await _firestore
            .collection('users')
            .doc(user.uid)
            .set(userModel.toJson(), SetOptions(merge: true));
        return userModel;
      } else {
        throw const AuthFailure('Failed to sign in with Google');
      }
    } catch (e) {
      if (e is AuthFailure) rethrow;
      throw AuthFailure(e.toString());
    }
  }

  @override
  Future<void> signOut() async {
    await GoogleSignIn.instance.signOut();
    await _firebaseAuth.signOut();
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    final user = _firebaseAuth.currentUser;
    if (user != null) {
      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists && doc.data() != null) {
        return UserModel.fromJson(doc.data()!);
      }
      // If Firestore doc doesn't exist yet, build from Firebase Auth user
      return UserModel(
        id: user.uid,
        name: user.displayName ?? '',
        email: user.email ?? '',
        photoUrl: user.photoURL,
        lastLogin: null,
      );
    }
    return null;
  }
}
