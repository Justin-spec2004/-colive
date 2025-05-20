// import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// import 'package:font_change_md/Login%20Signup/Screen/logout_screen.dart';
import 'package:font_change_md/Login%20With%20Google/google_auth.dart';
import 'package:font_change_md/Password%20Forgot/forgot_password.dart';
// import 'package:splash_screen/Phone%20Auth/phone_login.dart';
import 'package:font_change_md/Widget/button.dart';
import 'package:font_change_md/loading/loading.dart';
import 'package:font_change_md/localization/locales.dart';
import 'package:font_change_md/localization/translator.dart';
import 'package:font_change_md/view/checking_internet.dart';
import 'package:font_change_md/view/home/home_view.dart';
import 'package:font_change_md/view/internet_provider.dart';
import 'package:provider/provider.dart';
// import 'package:font_change_md/view/home/home_view.dart';

import '../../Services/authentication.dart';
import '../../Widget/snackbar.dart';
import '../../Widget/text_field.dart';
import 'signup.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<LoginScreen> {
  void signInWithFacebook() async {
    // Implement your Facebook sign-in logic here
    // For example, you can use the Facebook SDK for Flutter
    // After successful sign-in, navigate to the HomeScreen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const EcoFontConverterScreen(),
      ),
    );
  }

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  bool _isObscure = true; //State variable for password visibility

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

// email and passowrd auth part
  void loginUser() async {
    showLoadingDialog(context); // Show Loading Dialog
    await Future.delayed(const Duration(seconds: 2)); // Simulate a task
    Navigator.pop(context);
    // Check if fields are empty
    // if (emailController.text.isEmpty || passwordController.text.isEmpty) {
    //   showSnackBar(context, "Email and password cannot be empty");
    //   return;
    // }

    setState(() {
      isLoading = true;
    });

    // signup user using our authmethod
    String res = await AuthMethod().loginUser(
        email: emailController.text, password: passwordController.text);

    if (res == "success") {
      setState(() {
        isLoading = false;
      });
      //navigate to the home screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const EcoFontConverterScreen(),
        ),
      );
    } else {
      setState(() {
        isLoading = false;
      });
      // show error
      showSnackBar(context, res);
    }
  }

  void showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (BuildContext context) {
        return const Loading(); // Uses your custom Loading widget
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<InternetProvider>(
      builder: (context, internetProvider, child) {
        if (!internetProvider.isConnected) {
          Future.microtask(() {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CheckingInternet()),
            );
          });
        }
        double height = MediaQuery.of(context).size.height;
        return Scaffold(
          // resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          body: SafeArea(
              child: SizedBox(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: height / 2.7,
                  child: Image.asset('assets/images/login.jpg'),
                ),
                TextFieldInput(
                    icon: Icons.person,
                    textEditingController: emailController,
                    hintText: tr(LocaleData.emailtxt),
                    textInputType: TextInputType.text),
                TextFieldInput(
                  icon: Icons.lock,
                  textEditingController: passwordController,
                  hintText: tr(LocaleData.passwordtxt),
                  textInputType: TextInputType.text,
                  //isPass: true,
                  isPass:
                      _isObscure, //Use _isObscure to toggle password visibility
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isObscure ? Icons.visibility_off : Icons.visibility,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      setState(() {
                        _isObscure = !_isObscure;
                      });
                    },
                  ),
                ),
                MyButtons(onTap: loginUser, text: tr(LocaleData.loginbtt)),
                //  we call our forgot password below the login in button
                const ForgotPassword(),
                Row(
                  children: [
                    Expanded(
                      child: Container(height: 1, color: Colors.black26),
                    ),
                    Text(
                      tr(LocaleData.or),
                      style: const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    Expanded(
                      child: Container(height: 1, color: Colors.black26),
                    )
                  ],
                ),
                // for google login
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueGrey),
                    // onPressed: () async {
                    //   try {
                    //     showLoadingDialog(context); // Show loading indicator
                    //     UserCredential? userCredential =
                    //         await FirebaseServices().signInWithGoogle();
                    //     Navigator.pop(context); // Close loading screen
                    //     if (userCredential != null) {
                    //       print("🎯 Navigating to EcoFontConverterScreen...");
                    //       Navigator.pushAndRemoveUntil(
                    //         context,
                    //         MaterialPageRoute(
                    //           builder: (context) =>
                    //               const EcoFontConverterScreen(),
                    //         ),
                    //         (route) => false,
                    //       );
                    //     } else {
                    //       print(
                    //           "⚠️ Google Sign-In failed. Showing snackbar...");
                    //       showSnackBar(context,
                    //           "Google Sign-In failed. Please try again.");
                    //     }
                    //   } catch (e) {
                    //     Navigator.pop(context); // Close loading screen
                    //     print("🔥 Error in Google Sign-In: $e");
                    //     showSnackBar(context, "Error: ${e.toString()}");
                    //   }
                    // },
                    onPressed: () async {
                      if (!context.mounted)
                        return; // Ensure the widget is still in the tree

                      try {
                        showLoadingDialog(context); // Show loading indicator

                        UserCredential? userCredential =
                            await FirebaseServices().signInWithGoogle();

                        if (!context.mounted)
                          return; // Prevent actions if widget is disposed

                        Navigator.pop(context); // Close loading screen

                        if (userCredential != null) {
                          print(
                              "🎯 Google Sign-In successful. Navigating to Home...");

                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    const EcoFontConverterScreen()),
                            (route) =>
                                false, // Remove all previous screens from the stack
                          );
                        } else {
                          print("⚠️ Google Sign-In failed.");
                          showSnackBar(context, tr(LocaleData.ggcheckfail));
                        }
                      } catch (e) {
                        if (context.mounted) {
                          Navigator.pop(
                              context); // Close loading screen if it's still active
                          showSnackBar(context, "Error: ${e.toString()}");
                        }
                        print("🔥 Error during Google Sign-In: $e");
                      }
                    },
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Image.network(
                            "https://ouch-cdn2.icons8.com/VGHyfDgzIiyEwg3RIll1nYupfj653vnEPRLr0AeoJ8g/rs:fit:456:456/czM6Ly9pY29uczgu/b3VjaC1wcm9kLmFz/c2V0cy9wbmcvODg2/LzRjNzU2YThjLTQx/MjgtNGZlZS04MDNl/LTAwMTM0YzEwOTMy/Ny5wbmc.png",
                            height: 35,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          tr(LocaleData.googletxt),
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                // for phone authentication
                // const PhoneAuthentication(),

                // for facebook login
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                //   child: ElevatedButton(
                //     style: ElevatedButton.styleFrom(
                //         backgroundColor: Color(0xFF4267B2)),
                //     onPressed: () async {
                //       signInWithFacebook();
                //     },
                //     child: Row(
                //       children: [
                //         Padding(
                //           padding: const EdgeInsets.symmetric(vertical: 8),
                //           child: Image.network(
                //             "https://img.icons8.com/?size=100&id=uLWV5A9vXIPu&format=png&color=000000",
                //             height: 35,
                //           ),
                //         ),
                //         const SizedBox(width: 10),
                //         const Text(
                //           "Continue with Facebook",
                //           style: TextStyle(
                //             fontWeight: FontWeight.bold,
                //             fontSize: 20,
                //             color: Colors.white,
                //           ),
                //         )
                //       ],
                //     ),
                //   ),
                // ),

                // Don't have an account? got to signup screen
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 100),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(tr(LocaleData.signuptxt),
                          style: TextStyle(color: Colors.black)),
                      GestureDetector(
                        onTap: () async {
                          showLoadingDialog(context); // Show Loading Dialog
                          await Future.delayed(
                              const Duration(seconds: 2)); // Simulate a task
                          Navigator.pop(context);
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const SignupScreen(),
                            ),
                          );
                        },
                        child: Text(
                          tr(LocaleData.signupbtt),
                          style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          )),
        );
      },
    );
  }

  Container socialIcon(image) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 32,
        vertical: 15,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFedf0f8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.black45,
          width: 2,
        ),
      ),
      child: Image.network(
        image,
        height: 40,
      ),
    );
  }
}
