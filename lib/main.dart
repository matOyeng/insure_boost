import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:insure_boost/pages/about_page.dart';
import 'package:insure_boost/pages/auth/login_screen.dart';
import 'package:insure_boost/pages/auth/signup_sreen.dart';
import 'package:insure_boost/pages/change_pwd_page.dart';
import 'package:insure_boost/pages/edit_profile_page.dart';
import 'package:insure_boost/global/global_variables.dart' as globals;
import 'package:insure_boost/pages/index_page.dart';
import 'package:insure_boost/pages/log_switch_page.dart';
import 'package:insure_boost/pages/reward_page.dart';
import 'package:insure_boost/pages/settings_page.dart';
import 'package:insure_boost/pages/splash_page.dart';
import 'package:insure_boost/pages/welcome_Screen.dart';
import 'package:insure_boost/provider/google_sign_in.dart';
import 'package:provider/provider.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(const MyApp());
// }
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => GoogleSignInProvider(),
        child: MaterialApp(
          navigatorKey: navigatorKey,
          title: 'Flutter Demo',
          // themeMode: ThemeMode.dark,
          debugShowCheckedModeBanner: false,
          // onGenerateTitle: (context) {
          //   return AppLocalizations.of(context)!.appTitle;
          // },
          // localizationsDelegates: AppLocalizations.localizationsDelegates,
          // supportedLocales: AppLocalizations.supportedLocales,
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          // home: const MyHomePage(title: 'Flutter Demo Home Page'),
          initialRoute: '/',
          routes: {
            '/': (context) => SplashPage(),
            '/MainPage': (context) => MainPage(),
            '/WelcomeScreen': (context) => WelcomeScreen(),
            '/LoginScreen': (context) => LoginScreen(),
            '/SignupScreen': (context) => SignupScreen(),
            '/Home': (context) => IndexPage(),
            '/SettingsPage': (context) => SettingsPage(),
            '/EditProfilePage': (context) => EditProfilePage(),
            '/ChangePwdPage': (context) => ChangePwdPage(),
            '/RewardPage': (context) => DashBoardPage(),
            '/AboutPage': (context) => AboutPage(),
          },
        ));
  }
}
