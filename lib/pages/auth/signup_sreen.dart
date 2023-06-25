import 'package:firebase_auth/firebase_auth.dart';
import 'package:insure_boost/api/user_api.dart';
import 'package:insure_boost/main.dart';
import 'package:insure_boost/pages/auth/login_screen.dart';
import 'package:insure_boost/provider/google_sign_in.dart';
import 'package:insure_boost/utils/exports.dart';
import 'package:provider/provider.dart';
import 'package:social_login_buttons/social_login_buttons.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _value = false;
  // bool islogin = true;
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
                        txt: "Sign Up",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 26,
                        )),
                    const SizedBox(
                      height: 8,
                    ),
                    customText(
                        txt: "Please sign up to enter in a app.",
                        style: const TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 14,
                        )),
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
                      height: 30,
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
                    const SizedBox(
                      height: 20,
                    ),
                    SocialLoginButton(
                      buttonType: SocialLoginButtonType.facebook,
                      onPressed: () {},
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
                    const SizedBox(height: 50),

                    ElevatedButton(
                      onPressed: signUp,
                      child: Text('Sign Up'),
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
                    SizedBox(
                      height: 20,
                    ),
                    InkWell(
                      child: RichText(
                        text: RichTextSpan(
                            one: "Already have an account ? ", two: "Login"),
                      ),
                      onTap: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(
                            builder: (context) => const LoginScreen()));
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

  Future signUp() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(child: CircularProgressIndicator()),
    );
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
    } on FirebaseAuthException catch (e) {
      print(e);
    }
    await UserApi(FirebaseAuth.instance.currentUser!.uid).addUserToStore();
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}
