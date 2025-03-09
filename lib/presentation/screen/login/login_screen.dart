// ignore_for_file: must_be_immutable

import 'package:brandsinfo/presentation/screen/login/signup_controller.dart';
import 'package:brandsinfo/presentation/widgets/circular_image_widget.dart';
import 'package:brandsinfo/widgets/sized_box.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});
  final SignupController controller = SignupController();
  TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CommonSizedBox.h20,
                    CircularImageWidget(),
                    CommonSizedBox.h25,
                    Text(
                      'Login to Your Account',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    CommonSizedBox.h25,
                    Text(
                      'Welcome back! Please enter your phone number and verify with OTP to access your account.',
                      style: Theme.of(context).textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                    CommonSizedBox.h30,
                    TextField(
                      maxLength: 10,
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      style: Theme.of(context).textTheme.headlineSmall,
                      decoration: InputDecoration(
                        labelText: 'Enter your phone number',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide:
                              const BorderSide(color: Color(0xffFF750C)),
                        ),
                        prefixText: '+91  ',
                        prefixStyle: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                    CommonSizedBox.h20,
                    Row(
                      children: [
                        Checkbox(
                          value: true, // Already checked
                          onChanged: (bool? value) {
                            // Do nothing, or implement logic if needed
                          },
                          activeColor: Color(
                              0xffFF750C), // Background color of the checkbox
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                        ),
                        Expanded(
                          child: RichText(
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.start,
                            text: TextSpan(
                              text: 'By continuing you agree to our ',
                              style: Theme.of(context).textTheme.bodyMedium,
                              children: [
                                TextSpan(
                                  text: 'terms and conditions',
                                  style: const TextStyle(
                                    color: Color(0xffFF750C),
                                    fontWeight: FontWeight.normal,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      // termsandcontion();
                                    },
                                ),
                                const TextSpan(
                                  text: ' and ',
                                ),
                                TextSpan(
                                  text: 'privacy policy',
                                  style: const TextStyle(
                                    color: Color(0xffFF750C), // Highlight color

                                    fontWeight: FontWeight.normal,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      // privacyPolicy();
                                    },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    CommonSizedBox.h30,
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        onPressed: () {
                          controller.signup(phoneController.text);
                        },
                        child: Text('LOGIN',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 16,
                            )),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
