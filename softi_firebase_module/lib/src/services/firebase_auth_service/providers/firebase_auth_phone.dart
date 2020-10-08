import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:softi_core_module/softi_core_module.dart';
import 'package:softi_firebase_module/src/services/firebase_auth_service/firebase_auth_provider.dart';

class FirebaseAuthPhone extends FirebaseAuthProvider {
  FirebaseAuthPhone(FirebaseAuth firebaseAuth) : super(firebaseAuth);

  Future<AuthCredential> getCredentialForPhone(String verificationId, String smsCode) async {
    return PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode);
  }

  Future<AuthUser> signInWithPhone(verificationId, smsOTP) async {
    return signInWithCredential(await getCredentialForPhone(verificationId, smsOTP));
  }

  Future<PhoneAuthResult> sendSignInWithPhoneCode({
    String phoneNumber,
    dynamic resendingId,
    bool autoRetrive = true,
    int autoRetrievalTimeoutSeconds = 30,
  }) async {
    Completer<SendCodeResult> sendCodeCompleter = Completer<SendCodeResult>();
    Completer<AuthUser> autoRetriveCompleter = Completer<AuthUser>();

    firebaseAuth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      forceResendingToken: resendingId,
      codeSent: (verificationId, [resendingId]) {
        var result = SendCodeResult(
          phoneNumber: phoneNumber,
          codeVerification: (code) => signInWithPhone(verificationId, code),
          resendCode: () => sendSignInWithPhoneCode(
            phoneNumber: phoneNumber,
            resendingId: resendingId,
            autoRetrive: autoRetrive,
            autoRetrievalTimeoutSeconds: autoRetrievalTimeoutSeconds,
          ),
        );

        sendCodeCompleter.complete(result);
      },

      verificationFailed: (FirebaseAuthException authException) {
        sendCodeCompleter.completeError(authException);

        return;
      },

      //? Auto retrieving flow

      timeout: Duration(seconds: autoRetrive ? autoRetrievalTimeoutSeconds : 0),

      verificationCompleted: (AuthCredential authCredential) async {
        AuthUser _user = await signInWithCredential(authCredential);
        autoRetriveCompleter.complete(_user);
      },

      codeAutoRetrievalTimeout: (String verificationId) {
        // Dismiss autoretrieve timeout
        return;
      },
    );

    return PhoneAuthResult(
      sendCodeFuture: sendCodeCompleter.future,
      autoRetriveFuture: autoRetriveCompleter.future,
    );
  }
}
