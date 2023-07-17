// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:instagram/resources/auth_methods.dart';
// import 'package:instagram/responsive/mobile_screen_layout.dart';
// import 'package:instagram/responsive/responsive_layout_screen.dart';
// import 'package:instagram/responsive/web_screen_layout.dart';
// import 'package:instagram/screens/signup_screen.dart';
// import 'package:instagram/utils/colors.dart';
// import 'package:instagram/utils/utils.dart';
// import 'package:instagram/widgets/text_field_input.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   //
//   final TextEditingController mailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   //
//   bool loading = false;
//   //

//   @override
//   void dispose() {
//     super.dispose();
//     mailController.dispose();
//     passwordController.dispose();
//   }

//   void loginUser() async {
//     setState(() {
//       loading = true;
//     });
//     String result = await AuthMethods().loginUser(
//       mail: mailController.text,
//       password: passwordController.text,
//     );
//     if (result == 'success') {
//       //
//       Navigator.of(context).pushReplacement(
//         MaterialPageRoute(
//           builder: (context) {
//             return const ResponsiveLayoutScreen(
//               mobileScreenLayout: MobileScreenLayout(),
//               webScreenLayout: WebScreenLayout(),
//             );
//           },
//         ),
//       );

//       setState(() {
//         loading = false;
//       });
//     } else {
//       //
//       showSnackBar(result, context);

//       setState(() {
//         loading = false;
//       });
//     }
//   }

//   void navigateToSignup() {
//     Navigator.of(context).pushReplacement(
//       MaterialPageRoute(
//         builder: (context) {
//           return const SignupScreen();
//         },
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Container(
//           padding: const EdgeInsets.symmetric(horizontal: 32),
//           width: double.infinity,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               /*
//               1) Image
//               2) Text Field Input For Email
//               3) Text Fiels Input For Password
//               4) Button For Login
//               5) Transitioning For Sign Up
//               */

//               Flexible(
//                 flex: 2,
//                 child: Container(),
//               ),
//               SvgPicture.asset(
//                 'assets/images/instagram.svg',
//                 color: primaryColor,
//                 height: 64,
//               ),
//               const SizedBox(height: 64),
//               TextFieldInput(
//                 hintText: 'Enter Your Email',
//                 textEditingController: mailController,
//                 textInputType: TextInputType.emailAddress,
//               ),
//               const SizedBox(height: 24),
//               TextFieldInput(
//                 hintText: 'Enter Your Password',
//                 textEditingController: passwordController,
//                 textInputType: TextInputType.text,
//                 isPass: true,
//               ),
//               const SizedBox(height: 24),
//               InkWell(
//                 onTap: loginUser,
//                 child: Container(
//                   width: double.infinity,
//                   alignment: Alignment.center,
//                   padding: const EdgeInsets.symmetric(vertical: 12),
//                   decoration: const ShapeDecoration(
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.all(
//                         Radius.circular(4),
//                       ),
//                     ),
//                     color: blueColor,
//                   ),
//                   child: loading
//                       ? const Center(
//                           child: CircularProgressIndicator(
//                             strokeWidth: 3,
//                             color: primaryColor,
//                           ),
//                         )
//                       : const Text('Login'),
//                 ),
//               ),
//               const SizedBox(height: 12),
//               Flexible(
//                 flex: 2,
//                 child: Container(),
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.symmetric(vertical: 8),
//                     child: const Text('Don\'t have and account?'),
//                   ),
//                   const SizedBox(width: 5),
//                   GestureDetector(
//                     onTap: navigateToSignup,
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(vertical: 8),
//                       child: const Text(
//                         'Signup',
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram/resources/auth_methods.dart';
import 'package:instagram/responsive/mobile_screen_layout.dart';
import 'package:instagram/responsive/responsive_layout_screen.dart';
import 'package:instagram/responsive/web_screen_layout.dart';
import 'package:instagram/screens/signup_screen.dart';
import 'package:instagram/utils/colors.dart';
import 'package:instagram/utils/global_variables.dart';
import 'package:instagram/utils/utils.dart';
import 'package:instagram/widgets/text_field_input.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void loginUser() async {
    setState(() {
      _isLoading = true;
    });
    String res = await AuthMethods().loginUser(
        mail: _emailController.text, password: _passwordController.text);
    if (res == 'success') {
      if (context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const ResponsiveLayoutScreen(
                mobileScreenLayout: MobileScreenLayout(),
                webScreenLayout: WebScreenLayout(),
              ),
            ),
            (route) => false);

        setState(() {
          _isLoading = false;
        });
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      if (context.mounted) {
        showSnackBar(res, context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          padding: MediaQuery.of(context).size.width > webScreenSize
              ? EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width / 3)
              : const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                flex: 2,
                child: Container(),
              ),
              SvgPicture.asset(
                'assets/images/instagram.svg',
                color: primaryColor,
                height: 64,
              ),
              const SizedBox(
                height: 64,
              ),
              TextFieldInput(
                hintText: 'Enter your email',
                textInputType: TextInputType.emailAddress,
                textEditingController: _emailController,
              ),
              const SizedBox(
                height: 24,
              ),
              TextFieldInput(
                hintText: 'Enter your password',
                textInputType: TextInputType.text,
                textEditingController: _passwordController,
                isPass: true,
              ),
              const SizedBox(
                height: 24,
              ),
              InkWell(
                onTap: loginUser,
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: const ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                    ),
                    color: blueColor,
                  ),
                  child: !_isLoading
                      ? const Text(
                          'Log in',
                        )
                      : const CircularProgressIndicator(
                          color: primaryColor,
                        ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Flexible(
                flex: 2,
                child: Container(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: const Text(
                      'Dont have an account?',
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const SignupScreen(),
                      ),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text(
                        ' Signup.',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
