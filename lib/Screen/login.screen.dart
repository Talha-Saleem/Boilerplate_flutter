import "package:flutter/material.dart";
import "package:flutter_app/Provider/auth.provider.dart";
import "package:flutter_app/Widget/loader.widget.dart";
import "package:provider/provider.dart";

class Login extends StatefulWidget {
  const Login({final Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  static final _loginFormKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  Widget build(final BuildContext context) => isLoading
        ? const LoadingWidget()
        : Scaffold(
            resizeToAvoidBottomInset: true,
            appBar: AppBar(
              title: const Text("Login"),
            ),
            body: Center(
              child: SingleChildScrollView(
                child: Form(
                  key: _loginFormKey,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(
                            MediaQuery.of(context).size.width * 0.06),
                        child: Image.asset("assets/images/logo.png"),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 0.08),
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                labelText: "Enter Email",
                                contentPadding: EdgeInsets.only(left: 10),
                              ),
                              validator: (final value) {
                                if (value!.isEmpty) {
                                  return "Please enter email";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              controller: _passwordController,
                              obscureText: true,
                              decoration: const InputDecoration(
                                  labelText: "Enter Password",
                                  contentPadding: EdgeInsets.only(left: 10)),
                              validator: (final value) {
                                if (value!.isEmpty) {
                                  return "Please enter password";
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 75,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: TextButton(
                          style: TextButton.styleFrom(
                              backgroundColor: Colors.blue,
                              primary: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                vertical: 18,
                              ),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30))),
                          onPressed: () async {
                            if (_loginFormKey.currentState!.validate()) {
                              try {
                                setState(() {
                                  isLoading = true;
                                });
                                await Provider.of<AuthProvider>(context,
                                        listen: false)
                                    .login(context,
                                        email: _emailController.text,
                                        password: _passwordController.text);
                                Navigator.pop(context);
                              } catch (error) {
                                //Handle Error
                              }
                              setState(() {
                                isLoading = false;
                              });
                            }
                          },
                          child: const Text(
                            "Log In",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, fontSize: 16),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
}
