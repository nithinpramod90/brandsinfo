import 'package:brandsinfo/presentation/screen/login/signup_controller.dart';
import 'package:brandsinfo/widgets/loader.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late String _verificationId;
  int? _resendToken;
  final SignupController controller = SignupController();

  Future<void> sendOtp(String phoneNumber, BuildContext context,
      {bool isResend = false}) async {
    print("Sending OTP to: $phoneNumber");
    await _auth.verifyPhoneNumber(
      phoneNumber: "+91$phoneNumber",
      forceResendingToken: isResend ? _resendToken : null,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        print("Auto verification completed.");
      },
      verificationFailed: (FirebaseAuthException e) {
        print("Verification Failed: ${e.code} ${e.message}");
        Loader.hide();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${e.message}")),
        );
      },
      codeSent: (String verificationId, int? resendToken) async {
        print("Code sent! VerificationId: $verificationId");
        _verificationId = verificationId;
        _resendToken = resendToken;
        await controller.signup(phoneNumber, verificationId);
      },
      codeAutoRetrievalTimeout: (String verificationId) async {
        print("Auto-retrieval timeout.");
        _verificationId = verificationId;
      },
    );
  }

  Future<void> verifyOtp(String otp, String verificationId,
      BuildContext context, String phno) async {
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );
      UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      _handleSuccess(userCredential, otp, phno, context);
    } catch (e) {
      print("OTP Verification Failed: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Invalid OTP. Try again.")),
      );
    }
  }

  Future<void> resendOtp(String phoneNumber, BuildContext context) async {
    await sendOtp(phoneNumber, context, isResend: true);
  }

  Future<void> _handleSuccess(UserCredential userCredential, String otp,
      String phno, BuildContext context) async {
    String? idToken = await userCredential.user?.getIdToken();

    if (userCredential.user != null && idToken != null) {
      controller.verifyOtp(phno, otp, idToken);
    }
  }

  String get currentVerificationId => _verificationId;
}
