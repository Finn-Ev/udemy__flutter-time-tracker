import 'package:apple_sign_in/apple_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class AuthBase {
  User get currentUser;

  Stream<User> authStateChanges();

  Future<User> signInAnonymously();

  Future<User> signInWithEmailAndPassword(String email, String password);

  Future<User> createUserWithEmailAndPassword(String email, String password);

  Future<User> signInWithGoogle();

  Future<User> signInWithFacebook();

  Future<User> signInWithApple();

  Future<void> signOut();

  Future<void> sendPasswordResetEmail(String email);
}

class Auth implements AuthBase {
  final _firebaseAuth = FirebaseAuth.instance;

  Stream<User> authStateChanges() {
    return _firebaseAuth.authStateChanges();
  }

  @override
  User get currentUser => _firebaseAuth.currentUser;

  @override
  Future<User> signInAnonymously() async {
    final userCredential = await _firebaseAuth.signInAnonymously();
    return userCredential.user;
  }

  @override
  Future<User> signInWithEmailAndPassword(String email, String password) async {
    final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    return userCredential.user;
  }

  @override
  Future<User> createUserWithEmailAndPassword(
      String email, String password) async {
    final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    return userCredential.user;
  }

  @override
  Future<User> signInWithGoogle() async {
    final googleSignIn = GoogleSignIn();
    final googleUser = await googleSignIn.signIn();

    if (googleUser != null) {
      final googleAuth = await googleUser.authentication;

      if (googleAuth.idToken != null) {
        final userCredential = await _firebaseAuth.signInWithCredential(
            GoogleAuthProvider.credential(
                accessToken: googleAuth.accessToken,
                idToken: googleAuth.idToken));

        return userCredential.user;
      } else {
        throw FirebaseAuthException(
            message: 'Missing Google ID Token',
            code: 'ERROR_MISSING_GOOGLE_ID_TOKEN');
      }
    } else {
      throw FirebaseAuthException(
          message: 'Sign in aborted by user', code: 'ERROR_ABORTED_BY_USER');
    }
  }

  @override
  Future<User> signInWithFacebook() async {
    final facebookLogin = FacebookLogin();
    final response = await facebookLogin.logIn(permissions: [
      FacebookPermission.publicProfile,
      FacebookPermission.email
    ]);

    switch (response.status) {
      case FacebookLoginStatus.Success:
        final accessToken = response.accessToken;
        final userCredential = await _firebaseAuth.signInWithCredential(
            FacebookAuthProvider.credential(accessToken.token));
        return userCredential.user;
      case FacebookLoginStatus.Cancel:
        throw FirebaseAuthException(
            message: 'Facebook login aborted by user',
            code: 'ERROR_ABORTED_BY_USER');
      case FacebookLoginStatus.Error:
        throw FirebaseAuthException(
            message: response.error.developerMessage,
            code: 'ERROR_FACEBOOK_SIGN_IN_FAILED');
      default:
        throw UnimplementedError();
    }
  }

  Future<User> signInWithApple({List<Scope> scopes = const []}) async {
    // 1. perform the sign-in request
    final result = await AppleSignIn.performRequests(
        [AppleIdRequest(requestedScopes: scopes)]);
    // 2. check the result
    switch (result.status) {
      case AuthorizationStatus.authorized:
        final appleIdCredential = result.credential;
        final oAuthProvider = OAuthProvider('apple.com');
        final credential = oAuthProvider.credential(
          idToken: String.fromCharCodes(appleIdCredential.identityToken),
          accessToken:
              String.fromCharCodes(appleIdCredential.authorizationCode),
        );
        final authResult = await _firebaseAuth.signInWithCredential(credential);
        final firebaseUser = authResult.user;
        if (scopes.contains(Scope.fullName)) {
          final displayName =
              '${appleIdCredential.fullName.givenName} ${appleIdCredential.fullName.familyName}';
          await firebaseUser.updateProfile(displayName: displayName);
        }
        return firebaseUser;
      case AuthorizationStatus.error:
        throw PlatformException(
          code: 'ERROR_AUTHORIZATION_DENIED',
          message: result.error.toString(),
        );

      case AuthorizationStatus.cancelled:
        throw PlatformException(
          code: 'ERROR_ABORTED_BY_USER',
          message: 'Sign in aborted by user',
        );
      default:
        throw UnimplementedError();
    }
  }

  @override
  Future<void> signOut() async {
    // google
    final googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();

    // facebook
    final facebookLogin = FacebookLogin();
    await facebookLogin.logOut();

    await _firebaseAuth.signOut();
  }

  @override
  Future<void> sendPasswordResetEmail(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }
}
