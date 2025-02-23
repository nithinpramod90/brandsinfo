// import 'package:brandsinfo/presentation/controllers/auth_controller.dart';
import 'package:brandsinfo/presentation/screen/login/signup_controller.dart';
import 'package:brandsinfo/presentation/widgets/circular_image_widget.dart';
import 'package:brandsinfo/widgets/sized_box.dart';
import 'package:flutter/material.dart';

class NameScreen extends StatelessWidget {
  NameScreen({super.key, required this.phone});
  final String phone;
  final SignupController controller = SignupController();
  final TextEditingController namecontroller = TextEditingController();
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
                      'Welcome back! Please enter your Name and verify with OTP to access your account.',
                      style: Theme.of(context).textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                    CommonSizedBox.h30,
                    TextField(
                      controller: namecontroller,
                      keyboardType: TextInputType.name,
                      style: Theme.of(context).textTheme.headlineSmall,
                      decoration: InputDecoration(
                        labelText: 'Enter your Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: const BorderSide(color: Colors.orange),
                        ),
                      ),
                    ),
                    CommonSizedBox.h30,
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          // backgroundColor:
                          //     const Color(0xFF539B9B), // Button color

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        onPressed: () {
                          controller.saveName(phone, namecontroller.text);
                        },
                        child: Text(
                          'Continue',
                          style: TextStyle(
                            fontSize: 16,
                            // color: Colors.white,
                          ),
                        ),
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
