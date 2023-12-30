import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_churche/models/db_church.dart';
import 'package:the_churche/models/mass.dart';
import 'package:the_churche/states/app_state.dart';
import 'package:the_churche/widgets/mass_form.dart';
import 'package:the_churche/widgets/profile_Settings.dart';
import 'package:the_churche/widgets/profile_reg.dart';

class Profile extends StatelessWidget {
  const Profile({super.key});

  // final VoidCallback callback;

  // Future<Church> getChurch(User user) {
  //   return FirebaseFirestore.instance.collection("users").doc(user.uid).get().then((DocumentSnapshot doc) {
  //     return Church.fromJson(doc.data() as Map<String, dynamic>);
  //   }, onError: (e) => Future.error("Error getting document: $e"));
  // }

  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationState>(builder: (context, appState, _) {
      if (appState.church == null) {
        debugPrint(appState.church.toString());
        return const ProfileReg();
      }
      return Container(
        decoration: const BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/img/bg2.jpg'), fit: BoxFit.cover),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Stack(alignment: Alignment.bottomRight, children: [
              Column(children: [
                Text(
                  appState.church!.name,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  appState.church!.email!,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                        // widget.callback();
                      },
                      icon: const Icon(Icons.logout),
                      color: Colors.white,
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const ProfileSettings(),
                        ));
                      },
                      icon: const Icon(Icons.settings),
                      color: Colors.white,
                    )
                  ],
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: appState.churchMassesStream(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return const Text('Something went wrong');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Text("Loading");
                    }

                    return ListView(
                      shrinkWrap: true,
                      children: snapshot.data!.docs
                          .map((DocumentSnapshot document) {
                            Mass mass = document.data()! as Mass;
                            return Card(
                              child: InkWell(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        content: MassForm(doc: document),
                                      );
                                    },
                                  );
                                },
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        children: [
                                          Text(mass.title),
                                          Text(mass.description ?? ""),
                                          Text(mass.time.toIso8601String()),
                                        ],
                                      ),
                                    ),
                                    IconButton(
                                        onPressed: () {
                                          FirebaseFirestore.instance.collection("masses").doc(document.id).delete().then(
                                                (doc) => print("Document deleted"),
                                                onError: (e) => print("Error updating document $e"),
                                              );
                                        },
                                        icon: const Icon(Icons.delete_forever))
                                  ],
                                ),
                              ),

                              // subtitle: Text(data['company']),
                            );
                          })
                          .toList()
                          .cast(),
                    );
                  },
                ),
              ]),
              FloatingActionButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: MassForm(),
                      );
                    },
                  );
                },
                child: const Icon(Icons.add),
              ),
            ]),
          ),
        ),
      );
    });
  }
}
