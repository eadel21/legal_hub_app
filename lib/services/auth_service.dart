import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'firestore_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirestoreService _firestoreService = FirestoreService();

  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // ── Register with Email ──────────────────────────────────────────
  Future<UserCredential> registerWithEmail({
    required String fullName,
    required String email,
    required String phone,
    required String password,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await _firestoreService.createUser(
      uid: credential.user!.uid,
      fullName: fullName,
      email: email,
      phone: phone,
      photoUrl: '',
    );
    return credential;
  }

  // ── Login with Email ─────────────────────────────────────────────
  Future<UserCredential> loginWithEmail({
    required String email,
    required String password,
  }) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // ── Google Sign-In ───────────────────────────────────────────────
  Future<UserCredential?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) return null;
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final result = await _auth.signInWithCredential(credential);
    if (result.additionalUserInfo?.isNewUser == true) {
      await _firestoreService.createUser(
        uid: result.user!.uid,
        fullName: googleUser.displayName ?? '',
        email: googleUser.email,
        phone: result.user!.phoneNumber ?? '',
        photoUrl: googleUser.photoUrl ?? '',
      );
    }
    return result;
  }

  Future<UserCredential?> signInWithFacebook() async {
    final loginResult = await FacebookAuth.instance.login();
    if (loginResult.status != LoginStatus.success) return null;

    final userData = await FacebookAuth.instance.getUserData(
      fields: 'name,email,picture.width(200)',
    );

    final credential = FacebookAuthProvider.credential(
      loginResult.accessToken!.tokenString,
    );
    final result = await _auth.signInWithCredential(credential);

    if (result.additionalUserInfo?.isNewUser == true) {
      await _firestoreService.createUser(
        uid: result.user!.uid,
        fullName: userData['name'] ?? '',
        email: userData['email'] ?? '',
        phone: '',
        photoUrl: userData['picture']?['data']?['url'] ?? '',
      );
    }
    return result;
  }

  Future<UserCredential?> signInWithApple() async {
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );
    final oauthCredential = OAuthProvider('apple.com').credential(
      idToken: appleCredential.identityToken,
      accessToken: appleCredential.authorizationCode,
    );
    final result = await _auth.signInWithCredential(oauthCredential);

    if (result.additionalUserInfo?.isNewUser == true) {
      final name =
          '${appleCredential.givenName ?? ''} ${appleCredential.familyName ?? ''}'
              .trim();
      await _firestoreService.createUser(
        uid: result.user!.uid,
        fullName: name,
        email: appleCredential.email ?? result.user!.email ?? '',
        phone: '',
        photoUrl: '',
      );
    }
    return result;
  }

  // ── Forgot Password — Email Reset ────────────────────────────────
  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  // ── Forgot Password — SMS OTP ────────────────────────────────────
  Future<void> sendOtpToPhone({
    required String phoneNumber,
    required Function(String verificationId) onCodeSent,
    required Function(String error) onError,
  }) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
      },
      verificationFailed: (FirebaseAuthException e) {
        onError(e.message ?? 'Verification failed');
      },
      codeSent: (String verificationId, int? resendToken) {
        onCodeSent(verificationId);
      },
      codeAutoRetrievalTimeout: (_) {},
    );
  }

  // ── Verify OTP ───────────────────────────────────────────────────
  Future<void> verifyOtp({
    required String verificationId,
    required String otp,
  }) async {
    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: otp,
    );
    await _auth.signInWithCredential(credential);
  }

  // ── Sign Out ─────────────────────────────────────────────────────
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}