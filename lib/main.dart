import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:the_churche/states/app_state.dart';
import 'package:the_churche/firebase_options.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:the_churche/states/church_state.dart';

import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseUIAuth.configureProviders([EmailAuthProvider()]);

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (context) => ApplicationState()),
    ],
    builder: ((context, child) => const App()),
  ));
}
