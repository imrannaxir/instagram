import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram/resources/auth_methods.dart';
import 'package:instagram/responsive/mobile_screen_layout.dart';
import 'package:instagram/responsive/responsive_layout_screen.dart';
import 'package:instagram/responsive/web_screen_layout.dart';
import 'package:instagram/screens/login_screen.dart';
import 'package:instagram/utils/colors.dart';
import 'package:instagram/utils/utils.dart';
import 'package:instagram/widgets/text_field_input.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  //
  //
  final TextEditingController nameController = TextEditingController();
  final TextEditingController mailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController bioController = TextEditingController();

  /*
     "Uint8List" is derived from the combination of "Uint" (unsigned integer)
      and "8" (8-bit), indicating that it stores a list of 8-bit unsigned integers.
  */
  Uint8List? _image;
  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    mailController.dispose();
    passwordController.dispose();
    bioController.dispose();
    nameController.dispose();
  }

  void selectImage() async {
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  void signupUser() async {
    setState(() {
      isLoading = true;
    });
    String result = await AuthMethods().signupUser(
        name: nameController.text,
        mail: mailController.text,
        password: passwordController.text,
        bio: bioController.text,
        file: _image!);
    print(result);

    if (result != 'success') {
      showSnackBar(result, context);
      print('Something went wrong!');

      setState(() {
        isLoading = false;
      });
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) {
            return const ResponsiveLayoutScreen(
              mobileScreenLayout: MobileScreenLayout(),
              webScreenLayout: WebScreenLayout(),
            );
          },
        ),
      );
    }
  }

  void navigateToLogin() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) {
          return const LoginScreen();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /*
              1) Instagram Logo
              2) Circular Widget to accept and show our selected Fil
              3) Text Field Input For Name
              4) Text Field Input For Email
              5) Text Fiels Input For Password
              6) Text Field Input For Bio
              7) Button For Login
              8) Transitioning For Sign Up
              */

              Flexible(
                flex: 2,
                child: Container(),
              ),
              SvgPicture.asset(
                'assets/images/instagram.svg',
                color: primaryColor,
                height: 64,
              ),
              const SizedBox(height: 64),
              Stack(
                children: [
                  // Now we use here Ternary Operator
                  _image != null
                      ? CircleAvatar(
                          radius: 64,
                          backgroundImage: MemoryImage(_image!),
                        )
                      : const CircleAvatar(
                          radius: 64,
                          backgroundImage: AssetImage(
                            'assets/images/profile.jpeg',
                          ),
                        ),
                  Positioned(
                    bottom: -10,
                    left: 80,
                    child: IconButton(
                      onPressed: selectImage,
                      icon: const Icon(
                        Icons.add_a_photo,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              TextFieldInput(
                hintText: 'Enter Your Name',
                textEditingController: nameController,
                textInputType: TextInputType.text,
              ),
              const SizedBox(height: 24),
              TextFieldInput(
                hintText: 'Enter Your Email',
                textEditingController: mailController,
                textInputType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 24),
              TextFieldInput(
                hintText: 'Enter Your Password',
                textEditingController: passwordController,
                textInputType: TextInputType.text,
                isPass: true,
              ),
              const SizedBox(height: 24),
              TextFieldInput(
                hintText: 'Enter Your Bio',
                textEditingController: bioController,
                textInputType: TextInputType.text,
              ),
              const SizedBox(height: 24),
              InkWell(
                onTap: signupUser,
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: const ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(4),
                      ),
                    ),
                    color: blueColor,
                  ),
                  child: isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Sign up'),
                ),
              ),
              const SizedBox(height: 12),
              Flexible(
                flex: 2,
                child: Container(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: const Text('Don\'t have and account?'),
                  ),
                  const SizedBox(width: 5),
                  GestureDetector(
                    onTap: navigateToLogin,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text(
                        'Login',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

