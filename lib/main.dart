import "package:firebase_core/firebase_core.dart";
import "package:flutter/material.dart";
import "package:flutter_app/Provider/auth.provider.dart";
import "package:flutter_app/Screen/app_start.screen.dart";
import "package:provider/provider.dart";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({final Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(final BuildContext context) => MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProvider>(create: (final _) => AuthProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Flutter Demo",
        theme: ThemeData.dark(),
        home: const AppStartScreen(),
      ),
    );
}
