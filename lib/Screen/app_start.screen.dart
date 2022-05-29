import "package:flutter/material.dart";
import "package:flutter_app/Provider/auth.provider.dart";
import "package:flutter_app/Screen/home_page.screen.dart";
import "package:flutter_app/Screen/initial_app_start.screen.dart";
import "package:flutter_app/Widget/loader.widget.dart";
import "package:provider/provider.dart";

class AppStartScreen extends StatefulWidget {
  const AppStartScreen({final Key? key}) : super(key: key);
  @override
  _AppStartScreenState createState() => _AppStartScreenState();
}

class _AppStartScreenState extends State<AppStartScreen> {
  @override
  Widget build(final BuildContext context) => Scaffold(
        backgroundColor: const Color(0xFF303030),
        body: Consumer<AuthProvider>(
            builder: (final context, final auth, final _) {
          switch (auth.authStatus) {
            case AuthStatus.uninitialized:
              WidgetsBinding.instance!.addPostFrameCallback((final _) {
                auth.isSignedIn(context: context);
              });
              return const LoadingWidget();
            case AuthStatus.unauthenticated:
              return const InitialAppStart();
            case AuthStatus.authenticating:
              return const LoadingWidget();
            case AuthStatus.authenticated:
              return HomePage(loggedInUser: auth.user!);
            case AuthStatus.error:
              return const Center(
                  child: Text("Sorry an error has occurred..."));
          }
        }),
      );
}
