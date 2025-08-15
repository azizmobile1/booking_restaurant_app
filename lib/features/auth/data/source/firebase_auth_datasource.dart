import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class AuthRemoteDataSource {
  Future<User> signUp({required String name, required String email, required String password});
  Future<User> signIn({required String email, required String password});
  Future<User> signInWithGoogle();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn.instance;

  @override
  Future<User> signUp({required String name, required String email, required String password}) async {
    final credential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    await credential.user?.updateDisplayName(name);
    await credential.user?.reload();
    return _auth.currentUser!;
  }

  @override
  Future<User> signIn({required String email, required String password}) async {
    final credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
    return credential.user!;
  }
  
  @override
  Future<User> signInWithGoogle() {
    throw UnimplementedError();
  }

  // @override
  // Future<User> signInWithGoogle() async {
  //   final googleUser = await _googleSignIn.signIn();
  //   if (googleUser == null) throw FirebaseAuthException(code: 'ERROR_ABORTED_BY_USER', message: 'Canceled');
  //   final googleAuth = await googleUser.authentication;
  //   final credential = GoogleAuthProvider.credential(
  //     accessToken: googleAuth.accessToken, idToken: googleAuth.idToken,
  //   );
  //   final userCred = await _auth.signInWithCredential(credential);
  //   return userCred.user!;
  // }
}
