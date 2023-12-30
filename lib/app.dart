import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:the_churche/screens/login_profile.dart';
import 'package:the_churche/skelton.dart';

import 'color_schemes.g.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
      darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
      home: Skelton(0),
      // routes: {
      //   '/': (BuildContext context) => const Skelton(0),
      //   '/sign-in': (context) => SignInScreen(
      //         actions: [
      //           AuthStateChangeAction(((context, state) {
      //             final user = switch (state) { SignedIn state => state.user, UserCreated state => state.credential.user, _ => null };
      //             if (user == null) {
      //               return;
      //             }
      //             if (state is UserCreated) {
      //               user.updateDisplayName(user.email!.split('@')[0]);
      //             }
      //             if (!user.emailVerified) {
      //               user.sendEmailVerification();
      //               const snackBar = SnackBar(content: Text('Please check your email to verify your email address'));
      //               ScaffoldMessenger.of(context).showSnackBar(snackBar);
      //             }
      //             Navigator.of(context).pushReplacementNamed('/profile');
      //           }))
      //         ],
      //       ),
      //   '/profile': (context) => const Skelton(2)
      // },
      // initialRoute: '/',
    );
  }
}
