import "package:flutter/material.dart";
import "package:flutter_app/Model/user.model.dart";
import "package:flutter_app/Provider/auth.provider.dart";
import "package:flutter_app/Widget/profile_picture.widget.dart";
import "package:provider/provider.dart";

class SettingScreen extends StatefulWidget {
  const SettingScreen({
    required this.user,
    final Key? key,
  }) : super(key: key);

  final UserModel user;

  @override
  _SettingScreenState createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(final BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text("Account Settings"),
        ),
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ProfilePictureWidget(
                  path: widget.user.profilePicture!, size: 150),
              const SizedBox(height: 30),
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      child: RichText(
                        text: TextSpan(children: [
                          const TextSpan(
                              text: "Username: ",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(text: widget.user.name)
                        ]),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(8),
                      child: RichText(
                        text: TextSpan(children: [
                          const TextSpan(
                              text: "Email: ",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          TextSpan(text: widget.user.email)
                        ]),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.6,
                child: TextButton(
                  style: TextButton.styleFrom(
                      primary: Colors.blue,
                      padding: const EdgeInsets.symmetric(
                        vertical: 18,
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50))),
                  onPressed: () async {
                    await Provider.of<AuthProvider>(context, listen: false)
                        .signOut();
                  },
                  child: const Text(
                    "Sign Out",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        )),
      );
}
