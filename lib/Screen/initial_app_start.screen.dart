import "package:flutter/material.dart";
import "package:flutter_app/Screen/login.screen.dart";
import "package:flutter_app/Screen/sign_up.screen.dart";

class InitialAppStart extends StatefulWidget {
  const InitialAppStart({final Key? key}) : super(key: key);

  static const String id = "HOMESCREEN";

  @override
  _InitialAppStartState createState() => _InitialAppStartState();
}

class _InitialAppStartState extends State<InitialAppStart> {
  @override
  Widget build(final BuildContext context) => Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.06),
              child: Image.asset("assets/images/logo.png"),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              child: TextButton(
                style: TextButton.styleFrom(
                    backgroundColor: Colors.blue,
                    primary: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30))),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (final context) => const Login()));
                },
                child: const Text(
                  "Log In",
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              child: TextButton(
                style: TextButton.styleFrom(
                    backgroundColor: Colors.blue,
                    primary: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30))),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (final context) => const SignUp()));
                },
                child: const Text("Register",
                    style:
                        TextStyle(fontWeight: FontWeight.w700, fontSize: 18)),
              ),
            ),
          ],
        ),
      );
}
