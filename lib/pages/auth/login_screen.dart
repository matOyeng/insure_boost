import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:insure_boost/api/user_api.dart';
import 'package:insure_boost/main.dart';
import 'package:insure_boost/pages/auth/signup_sreen.dart';
import 'package:insure_boost/pages/welcome_Screen.dart';
import 'package:insure_boost/provider/google_sign_in.dart';
import 'package:insure_boost/utils/appColors.dart';
import 'package:insure_boost/utils/code_refector.dart';
import 'package:provider/provider.dart';
import 'package:social_login_buttons/social_login_buttons.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Map? _userData;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  String userEmail = "";

  bool _value = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 13),
            child: Center(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    customText(
                        txt: "Login Now",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 26,
                        )),
                    const SizedBox(
                      height: 8,
                    ),
                    customText(
                        txt: "Please login to continue using our app.",
                        style: const TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                        )),
                    // const SizedBox(
                    //   height: 15,
                    // ),
                    const SizedBox(
                      height: 60,
                    ),
                    customText(
                        txt: "Enter via social networks",
                        style: const TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                        )),
                    const SizedBox(
                      height: 15,
                    ),
                    SocialLoginButton(
                      buttonType: SocialLoginButtonType.google,
                      onPressed: () {
                        final provider = Provider.of<GoogleSignInProvider>(
                            context,
                            listen: false);
                        provider.googleLogin();
                      },
                    ),
                    // const SizedBox(
                    //   height: 10,
                    // ),
                    const SizedBox(
                      height: 20,
                    ),
                    SocialLoginButton(
                      buttonType: SocialLoginButtonType.facebook,
                      onPressed: () async {
                        await signInWithFacebook();
                      },
                    ),

                    const SizedBox(
                      height: 25,
                    ),
                    customText(
                        txt: "or login with email",
                        style: const TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                        )),
                    const SizedBox(
                      height: 30,
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                        controller: emailController,
                        Lone: "Email",
                        Htwo: "Email"),
                    const SizedBox(height: 20),
                    CustomTextField(
                        controller: passwordController,
                        Lone: "Password",
                        Htwo: "Password"),
                    const SizedBox(height: 20),
                    // Row(
                    //   children: [
                    //     Checkbox(
                    //       value: _value,
                    //       onChanged: (newValue) {
                    //         setState(() {
                    //           _value = newValue!;
                    //         });
                    //         const Text(
                    //           "Remember me",
                    //           style: TextStyle(
                    //               fontSize: 13, color: AppColors.kBlackColor),
                    //         );
                    //       },
                    //     ),
                    //     // Spacer(),
                    //     // const TextButton(
                    //     //   onPressed: null,
                    //     //   child: Text(
                    //     //     "Forgot password?",
                    //     //     style: TextStyle(
                    //     //       fontSize: 15,
                    //     //     ),
                    //     //   ),
                    //     // ),
                    //   ],
                    // ),

                    const SizedBox(height: 40),
                    ElevatedButton(
                      onPressed: login,
                      child: Text('Log in'),
                      style: ElevatedButton.styleFrom(
                        shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(40.0),
                        ),
                        primary: Colors.teal,
                        onPrimary: Colors.white,
                        padding:
                            EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    InkWell(
                      child: RichText(
                        text: RichTextSpan(
                            one: "Don’t have an account ? ", two: "Sign Up"),
                      ),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const SignupScreen()));
                      },
                    ),
                    //Text("data"),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future login() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
    } on FirebaseAuthException catch (e) {
      print(e);
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }

  Future signInWithFacebook() async {
    // Trigger the sign-in flow
    final LoginResult loginResult =
        await FacebookAuth.instance.login(permissions: [
      'email', 'public_profile'
      // , 'user_birthday'
    ]);

    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.token);

    final userData = await FacebookAuth.instance.getUserData();

    userEmail = userData['email'];

    // Once signed in, return the UserCredential
    await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
    bool n = true;
    await FirebaseFirestore.instance
        .collection('user')
        // .collection('email')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      print(value);
      print(value.exists);
      n = value.exists;
    });
    if (!n) {
      await UserApi(FirebaseAuth.instance.currentUser!.uid).addUserToStore();
    }
  }
}
