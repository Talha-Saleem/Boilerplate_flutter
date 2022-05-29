import "package:flutter/material.dart";
import "package:flutter_app/Provider/auth.provider.dart";
import "package:flutter_app/Widget/loader.widget.dart";
import "package:provider/provider.dart";

class SignUp extends StatefulWidget {
  const SignUp({final Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  static final _signUpFormKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool isMale = true;

  @override
  Widget build(final BuildContext context) => isLoading
        ? const LoadingWidget()
        : Scaffold(
            appBar: AppBar(
              title: const Text("Sign Up"),
            ),
            body: Center(
              child: SingleChildScrollView(
                child: Form(
                  key: _signUpFormKey,
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
                              controller: _nameController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                labelText: "Username",
                                contentPadding: EdgeInsets.only(left: 10),
                              ),
                              validator: (final value) {
                                if (value!.isEmpty) {
                                  return "Please enter name";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                labelText: "Email",
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
                                  labelText: "Password",
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
                        height: 15,
                      ),
                      Container(
                        height: 60,
                        width: double.maxFinite,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Row(
                                children: [
                                  Radio<bool>(
                                      value: true,
                                      groupValue: isMale,
                                      onChanged: (final value) {
                                        setState(() {
                                          isMale = true;
                                        });
                                      }),
                                  const Flexible(
                                    child: Text(
                                      "Male",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Flexible(
                              child: Row(
                                children: [
                                  Radio<bool>(
                                      value: false,
                                      groupValue: isMale,
                                      onChanged: (final value) {
                                        setState(() {
                                          isMale = false;
                                        });
                                      }),
                                  const Flexible(
                                    child: Text(
                                      "Female",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: TextButton(
                          style: TextButton.styleFrom(
                              primary: Colors.white,
                              backgroundColor: Colors.blue,
                              padding: const EdgeInsets.symmetric(
                                vertical: 18,
                              ),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50))),
                          onPressed: () async {
                            if (_signUpFormKey.currentState!.validate()) {
                              try {
                                setState(() {
                                  isLoading = true;
                                });
                                await Provider.of<AuthProvider>(context,
                                        listen: false)
                                    .signUp(
                                        context,
                                        _emailController.text,
                                        _passwordController.text,
                                        _nameController.text,
                                        isMale ? "male" : "female");
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
                            "Sign Up",
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
