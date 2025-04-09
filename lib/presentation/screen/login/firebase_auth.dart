// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// class AuthService {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   late String _verificationId;
//   int? _resendToken;

//   Future<void> sendOtp(String phoneNumber, BuildContext context,
//       {bool isResend = false}) async {
//     await _auth.verifyPhoneNumber(
//       phoneNumber: phoneNumber,
//       forceResendingToken: isResend ? _resendToken : null,
//       timeout: const Duration(seconds: 60),
//       verificationCompleted: (PhoneAuthCredential credential) async {
//         UserCredential userCredential =
//             await _auth.signInWithCredential(credential);
//         _handleSuccess(userCredential, context);
//       },
//       verificationFailed: (FirebaseAuthException e) {
//         print("Verification Failed: ${e.message}");
//         ScaffoldMessenger.of(context)
//             .showSnackBar(SnackBar(content: Text("Error: ${e.message}")));
//       },
//       codeSent: (String verificationId, int? resendToken) {
//         _verificationId = verificationId;
//         _resendToken = resendToken;

//         Navigator.push(
//           context,
//           MaterialPageRoute(
//               builder: (context) => OTPScreen(
//                   verificationId: verificationId, phoneNumber: phoneNumber)),
//         );
//       },
//       codeAutoRetrievalTimeout: (String verificationId) {
//         _verificationId = verificationId;
//       },
//     );
//   }

//   Future<void> verifyOtp(
//       String otp, String verificationId, BuildContext context) async {
//     try {
//       PhoneAuthCredential credential = PhoneAuthProvider.credential(
//           verificationId: verificationId, smsCode: otp);
//       UserCredential userCredential =
//           await _auth.signInWithCredential(credential);
//       _handleSuccess(userCredential, context);
//     } catch (e) {
//       print("OTP Verification Failed: $e");
//       ScaffoldMessenger.of(context)
//           .showSnackBar(SnackBar(content: Text("Invalid OTP. Try again.")));
//     }
//   }

//   void _handleSuccess(UserCredential userCredential, BuildContext context) {
//     if (userCredential.user != null) {
//       print("User UID: ${userCredential.user!.uid}");
//       Navigator.pushAndRemoveUntil(
//         context,
//         MaterialPageRoute(builder: (context) => HomeScreen()),
//         (route) => false,
//       );
//     }
//   }
// }
