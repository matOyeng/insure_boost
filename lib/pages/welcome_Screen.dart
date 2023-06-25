import 'package:insure_boost/pages/auth/login_screen.dart';
import 'package:insure_boost/pages/log_switch_page.dart';
import 'package:insure_boost/utils/exports.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    var h = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                SizedBox(
                  height: h / 6,
                ),
                const Image(image: AssetImage("image/img2.png")),
                const SizedBox(height: 8),
                customText(
                    txt: "Welcome",
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    )),
                const SizedBox(height: 8),
                customText(
                    txt:
                        "A comprehensive insurance service  Your personal caretaker",
                    style: const TextStyle(
                      fontWeight: FontWeight.normal,
                      fontSize: 14,
                    )),
                const SizedBox(height: 50),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                        builder: (context) => const MainPage()));
                  },
                  child: Text("Let's Go"),
                  style: ElevatedButton.styleFrom(
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0),
                    ),
                    primary: Colors.teal,
                    onPrimary: Colors.white,
                    padding:
                        EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//
//   Column(
//     children: <Widget>[
//       const Image(image: AssetImage("image/img4.png")),
//       customText(
//           txt: "Thank you",
//           style: const TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 26,
//           )),
//       const SizedBox(
//         height: 8,
//       ),
//       customText(
//           txt: "Now, welcome to our beautiful app!",
//           style: const TextStyle(
//             fontWeight: FontWeight.normal,
//             fontSize: 14,
//           )),
//       SignUpContainer(st: "let's Go"),
//     ],
//   ),
// );
//