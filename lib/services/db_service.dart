import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Db {
  static Db? _instance;

  Db._internal() {
    _instance = this;
  }

  factory Db() => _instance ?? Db._internal();

  Future<void> deleteAccountDetails() async {
    User user = FirebaseAuth.instance.currentUser!;
    await FirebaseFirestore.instance.collection("masses").where('churchId', isEqualTo: user.uid).get().then((value) async {
      for (var mass in value.docs) {
        await FirebaseFirestore.instance.collection("masses").doc(mass.id).delete();
      }
    }).then(
      (doc) => print("Masses deleted"),
      onError: (e) => print("Error delering masses $e"),
    );

    await FirebaseFirestore.instance.collection("users").doc(user.uid).delete().then(
          (doc) => print("User deleted"),
          onError: (e) => print("Error deleting user $e"),
        );
  }
}
