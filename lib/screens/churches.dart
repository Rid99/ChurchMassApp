import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Churches extends StatelessWidget {
  const Churches(this.name, {super.key});

  final String name;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const Text('Church List'),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('users').snapshots(),
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
                        Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                        return Card(
                          child: Column(
                            children: [
                              Text(data['name']),
                              Text(data['address']),
                              Text(data['phoneNumber']),
                            ],
                          ),

                          // subtitle: Text(data['company']),
                        );
                      })
                      .toList()
                      .cast(),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
