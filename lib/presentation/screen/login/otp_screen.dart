import 'package:brandsinfo/presentation/screen/login/signup_controller.dart';
import 'package:brandsinfo/presentation/widgets/circular_image_widget.dart';
import 'package:brandsinfo/theme/pinput_theme.dart';
import 'package:brandsinfo/widgets/sized_box.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

class OtpScreen extends StatelessWidget {
  OtpScreen({super.key, required this.phno});
  final String phno;
  final SignupController controller = SignupController();
  @override
  Widget build(BuildContext context) {
    final TextEditingController otpcontroller = TextEditingController();

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
                    Row(
                      children: [
                        Text(
                          "OTP sent to +91 $phno",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        IconButton(
                          onPressed: () {
                            Get.back();
                          },
                          icon: Icon(
                            Icons.edit_note_rounded,
                            color: Colors.orange,
                          ),
                        )
                      ],
                    ),
                    CommonSizedBox.h30,
                    Pinput(
                      length: 6,
                      defaultPinTheme:
                          PinInputThemes.getDefaultPinTheme(context),
                      focusedPinTheme:
                          PinInputThemes.getFocusedPinTheme(context),
                      submittedPinTheme:
                          PinInputThemes.getSubmittedPinTheme(context),
                      pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                      showCursor: true,
                      controller: otpcontroller,
                      onCompleted: (pin) => otpcontroller.value,
                    ),
                    CommonSizedBox.h30,
                    Row(
                      children: [
                        Text(
                          "Didn't Receive the OTP?",
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        Spacer(),
                        TextButton(onPressed: () {}, child: Text("Resend OTP"))
                      ],
                    ),
                    CommonSizedBox.h20,
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          controller.verifyOtp(phno, otpcontroller.text);
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
