import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/mass.dart';

class MassForm extends StatefulWidget {
  MassForm({this.doc, super.key}) : mass = doc?.data() as Mass?;
  final Mass? mass;
  final DocumentSnapshot? doc;

  @override
  State<MassForm> createState() => _MassFormState();
}

class _MassFormState extends State<MassForm> {
  late DateTime massTime;
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late Mass? mass;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.mass?.title);
    _descriptionController = TextEditingController(text: widget.mass?.description);
    massTime = DateTime.parse((widget.mass?.time ?? DateTime.now()).toIso8601String());
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Add new mass', style: Theme.of(context).textTheme.headlineMedium),
            TextFormField(
              decoration: const InputDecoration(label: Text('Title')),
              controller: _titleController,
            ),
            const SizedBox(height: 10),
            TextFormField(
              decoration: const InputDecoration(label: Text('Description')),
              controller: _descriptionController,
            ),
            const SizedBox(height: 10),
            Row(children: [
              ElevatedButton(
                  onPressed: () async {
                    final pickedDate =
                        await showDatePicker(context: context, initialDate: massTime, firstDate: DateTime(2000), lastDate: DateTime(2600)) ?? massTime;
                    massTime = DateTime(pickedDate.year, pickedDate.month, pickedDate.day, massTime.hour, massTime.minute);
                  },
                  child: const Text('Set Date')),
              const SizedBox(width: 10),
              ElevatedButton(
                  onPressed: () async {
                    final time = await showTimePicker(context: context, initialTime: TimeOfDay.fromDateTime(massTime)) ?? TimeOfDay.now();
                    massTime = DateTime(massTime.year, massTime.month, massTime.day, time.hour, time.minute);
                  },
                  child: const Text('Set Time'))
            ]),
            Row(
              children: [
                FilledButton.tonal(
                    onPressed: () {
                      if (widget.mass == null) {
                        Mass mass = Mass('', massTime, FirebaseAuth.instance.currentUser!.uid, _titleController.text, _descriptionController.text);
                        FirebaseFirestore.instance.collection('masses').add(mass.toJson()).then((value) => print(value)).catchError((error) => print(error));
                        _titleController.clear();
                        _descriptionController.clear();
                      } else {
                        Mass mass = Mass('', massTime, FirebaseAuth.instance.currentUser!.uid, _titleController.text, _descriptionController.text);
                        FirebaseFirestore.instance.collection('masses').doc(widget.doc!.id).set(mass.toJson()).catchError((error) => print(error));
                      }
                      Navigator.pop(context);
                    },
                    child: Text(widget.mass == null ? 'Add' : 'update')),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancel'),
                ),
              ],
            )
          ])),
    );
  }
}
