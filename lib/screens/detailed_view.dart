import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:the_churche/models/fetched_church.dart';
import 'package:the_churche/models/mass.dart';
import 'package:the_churche/services/place_photos.dart';
import 'package:the_churche/widgets/mass_form.dart';

class Details extends StatelessWidget {
  const Details(this.church, {super.key});

  final FetchedChurch church;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(church.name ?? 'A Church')),
        body: Column(
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 4,
              width: MediaQuery.of(context).size.width,
              child: Image.network(
                PlacePhotoAPI.getPhotoUri(church.photos?[0].photo_reference).toString(),
                fit: BoxFit.cover,
                loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes! : null,
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(shrinkWrap: true, children: [
                Text(
                  church.name ?? 'A Church',
                  style: Theme.of(context).textTheme.headlineMedium,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  church.vicinity ?? '',
                  style: Theme.of(context).textTheme.bodySmall,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  church.formatted_phone_number ?? '',
                  style: Theme.of(context).textTheme.bodySmall,
                  overflow: TextOverflow.ellipsis,
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('masses')
                      .where('churchId', isEqualTo: church.place_id)
                      .withConverter(
                          fromFirestore: (
                            DocumentSnapshot<Map<String, dynamic>> snapshot,
                            SnapshotOptions? options,
                          ) =>
                              Mass.fromJson(snapshot.data()!),
                          toFirestore: (Mass mass, _) => mass.toJson())
                      .snapshots(),
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
                                ],
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
            ),
          ],
        )

        // floatingActionButton: FloatingActionButton(onPressed: () {
        //   Navigator.pop(context);
        // }),
        );
  }
}
