import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pawspitalapp/models/user_model.dart';
import 'package:pawspitalapp/screens/profile/user_controller.dart';
import 'package:pawspitalapp/services/storage_repo.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  AuthService();

  Stream<String> get onAuthStateChanged =>
      _firebaseAuth.onAuthStateChanged.map(
            (FirebaseUser user) => user?.uid,
      );

  // GET UID
  Future<String> getCurrentUID() async {
    return (await _firebaseAuth.currentUser()).uid;
  }

  // GET CURRENT USER
  Future getCurrentUser() async {
    return await _firebaseAuth.currentUser();
  }

  Future<UserModel> getUser() async {
    var firebaseUser = await _firebaseAuth.currentUser();
    return UserModel(firebaseUser?.uid,
        displayName: firebaseUser?.displayName);
  }

  // Email & Password Sign Up
  Future<String> createUserWithEmailAndPassword(String email, String password,
      String name) async {
    final authResult = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // Update the username
    await updateUserName(name, authResult.user);
    return authResult.user.uid;
  }

  Future<void> updateDisplayName(String displayName) async {
    var user = await _firebaseAuth.currentUser();

    user.updateProfile(
      UserUpdateInfo()..displayName = displayName,
    );
  }

  Future updateUserName(String name, FirebaseUser currentUser) async {
    var userUpdateInfo = UserUpdateInfo();
    userUpdateInfo.displayName = name;
    await currentUser.updateProfile(userUpdateInfo);
    await currentUser.reload();
  }

  Future<bool> validatePassword(String password) async {
    var firebaseUser = await _firebaseAuth.currentUser();

    var authCredentials = EmailAuthProvider.getCredential(
        email: firebaseUser.email, password: password);
    try {
      var authResult = await firebaseUser
          .reauthenticateWithCredential(authCredentials);
      return authResult.user != null;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<void> updatePassword(String password) async {
    var firebaseUser = await _firebaseAuth.currentUser();
    firebaseUser.updatePassword(password);
  }

  // Email & Password Sign In
  // Future<String> signInWithEmailAndPassword(String email,
  //     String password) async {
  //   return (await _firebaseAuth.signInWithEmailAndPassword(
  //       email: email, password: password))
  //       .user.uid;
  // }

  Future<UserModel> signInWithEmailAndPassword2(
      String email, String password) async {
    var authResult = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return UserModel(authResult.user.uid,
        displayName: authResult.user.displayName);
  }

  // Sign Out
  signOut() {
    return _firebaseAuth.signOut();
  }

  // Reset Password
  Future sendPasswordResetEmail(String email) async {
    return _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  // Create Anonymous User
  Future singInAnonymously() {
    return _firebaseAuth.signInAnonymously();
  }

  Future convertUserWithEmail(String email, String password, String name) async {
    final currentUser = await _firebaseAuth.currentUser();

    final credential = EmailAuthProvider.getCredential(email: email, password: password);
    await currentUser.linkWithCredential(credential);
    await updateUserName(name, currentUser);
  }

  Future convertWithGoogle() async {
    final currentUser = await _firebaseAuth.currentUser();
    final GoogleSignInAccount account = await _googleSignIn.signIn();
    final GoogleSignInAuthentication _googleAuth = await account.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      idToken: _googleAuth.idToken,
      accessToken: _googleAuth.accessToken,
    );
    await currentUser.linkWithCredential(credential);
    await updateUserName(_googleSignIn.currentUser.displayName, currentUser);
  }

  // GOOGLE
  Future<String> signInWithGoogle() async {
    final GoogleSignInAccount account = await _googleSignIn.signIn();
    final GoogleSignInAuthentication _googleAuth = await account.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: _googleAuth.idToken,
        accessToken: _googleAuth.accessToken,
    );
    return (await _firebaseAuth.signInWithCredential(credential)).user.uid;
  }

  Future<bool> validateCurrentPassword(String password) async {
    var firebaseUser = await _firebaseAuth.currentUser();

    var authCredentials = EmailAuthProvider.getCredential(
        email: firebaseUser.email, password: password);
    try {
      var authResult = await firebaseUser
          .reauthenticateWithCredential(authCredentials);
      return authResult.user.uid != null;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<void> updateUserPassword(String password) async {
    var firebaseUser = await _firebaseAuth.currentUser();
    firebaseUser.updatePassword(password);
  }

}

class NameValidator {
  static String validate(String value) {
    if (value.isEmpty) {
      return "Name can't be empty";
    }
    if (value.length < 2) {
      return "Name must be at least 2 characters long";
    }
    if (value.length > 50) {
      return "Name must be less than 50 characters long";
    }
    return null;
  }
}

class EmailValidator {
  static String validate(String value) {
    if (value.isEmpty) {
      return "Email can't be empty";
    }
    return null;
  }
}

class PasswordValidator {
  static String validate(String value) {
    if (value.isEmpty) {
      return "Password can't be empty";
    }
    return null;
  }

}
