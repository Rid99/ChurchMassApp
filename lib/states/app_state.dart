import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider, PhoneAuthProvider;
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:the_churche/models/db_church.dart';
import 'package:the_churche/models/mass.dart';
import 'package:the_churche/widgets/profile_reg.dart';

class ApplicationState extends ChangeNotifier {
  ApplicationState() {
    init();
  }

  Church? _church;
  User? _user;

  User? get user => _user;
  Church? get church => _church;

  Future<void> init() async {
    FirebaseAuth.instance.userChanges().listen((user) async {
      _user = user;
      if (_user != null) {
        await getUserProfile();
      } else {
        _church = null;
      }
      notifyListeners();
    });

    emailTimer();
  }

  void emailTimer() {
    Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      _user = FirebaseAuth.instance.currentUser;
      if (_user != null) {
        if (_user!.emailVerified) {
          timer.cancel();
          const ProfileReg();
          debugPrint('verified');
        }
        _user!.reload();
        debugPrint('reloaded');
      } else {
        timer.cancel();
        debugPrint('no user');
      }
    });
  }

  Stream<QuerySnapshot> churchMassesStream() => FirebaseFirestore.instance
      .collection('masses')
      .where('churchId', isEqualTo: _user!.uid)
      .withConverter(
          fromFirestore: (
            DocumentSnapshot<Map<String, dynamic>> snapshot,
            SnapshotOptions? options,
          ) =>
              Mass.fromJson(snapshot.data()!),
          toFirestore: (Mass mass, _) => mass.toJson())
      .snapshots();

  // Stream<QuerySnapshot> churchStream() => FirebaseFirestore.instance.collection('users').snapshots();
  Stream<QuerySnapshot> churchStream() => FirebaseFirestore.instance.collection('users').snapshots();

  Widget signInScreen() => SignInScreen(
        actions: [
          AuthStateChangeAction(((context, state) {
            final user = switch (state) { SignedIn state => state.user, UserCreated state => state.credential.user, _ => null };
            if (user == null) {
              return;
            }
            if (state is UserCreated) {
              user.updateDisplayName(user.email!.split('@')[0]);
              const ProfileReg();
            }
            if (!user.emailVerified) {
              user.sendEmailVerification();
              const snackBar = SnackBar(content: Text('Please check your email to verify your email address'));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              emailTimer();
            }
          }))
        ],
      );

  Future<void> getUserProfile() async {
    await FirebaseFirestore.instance.collection("users").doc(_user!.uid).get().then((doc) {
      if (doc.exists) {
        _church = Church.fromJson(doc.data()!);
      } else {
        _church = null;
      }
    });
  }

  // Future<DocumentReference> addMessageToGuestBook(String message) {
  //   if (!_loggedIn) {
  //     throw Exception('Must be logged in');
  //   }

  //   final ref = FirebaseFirestore.instance.collection("users").doc("LA").withConverter(
  //     fromFirestore: Church.fromJson(),
  //     toFirestore: (City city, _) => city.toFirestore(),
  //   );

  //   return FirebaseFirestore.instance.collection('guestbook').add(<String, dynamic>{
  //     'text': message,
  //     'timestamp': DateTime.now().millisecondsSinceEpoch,
  //     'name': FirebaseAuth.instance.currentUser!.displayName,
  //     'userId': FirebaseAuth.instance.currentUser!.uid,
  //   });
  // }
}

// final ref = db.collection("cities").doc("LA").withConverter(
//       fromFirestore: City.fromFirestore,
//       toFirestore: (City city, _) => city.toFirestore(),
//     );
// final docSnap = await ref.get();
// final city = docSnap.data(); // Convert to City object
// if (city != null) {
//   print(city);
// } else {
//   print("No such document.");
// }
