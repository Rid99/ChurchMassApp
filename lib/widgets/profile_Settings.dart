import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire2/geoflutterfire2.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:the_churche/models/db_church.dart';
import 'package:the_churche/screens/location_selection.dart';
import 'package:the_churche/services/db_service.dart';
import 'package:the_churche/states/app_state.dart';
import 'package:the_churche/widgets/password_field.dart';
import 'package:the_churche/widgets/profile_actions.dart';

class ProfileSettings extends StatefulWidget {
  const ProfileSettings({super.key});

  @override
  State<ProfileSettings> createState() => _ProfileSettingsState();
}

class _ProfileSettingsState extends State<ProfileSettings> {
  late User _user;
  late Future<DocumentSnapshot<Map<String, dynamic>>> church;

  final _formKey = GlobalKey<FormState>();

  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _phoneFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _addressFocusNode = FocusNode();
  final FocusNode _regNoFocusNode = FocusNode();
  final FocusNode _latFocusNode = FocusNode();
  final FocusNode _lngFocusNode = FocusNode();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _regNoController = TextEditingController();
  final TextEditingController _latController = TextEditingController();
  final TextEditingController _lngController = TextEditingController();

  final ScrollController scroll = ScrollController();

  _nextFocus(FocusNode focusNode) {
    FocusScope.of(context).requestFocus(focusNode);
  }

  _submitForm() {
    Church church = Church.form(_nameController.text, _phoneController.text, _emailController.text, _addressController.text, _regNoController.text,
        GeoFlutterFire().point(latitude: double.tryParse(_latController.text) ?? 0.0, longitude: double.tryParse(_lngController.text) ?? 0.0));
    if (_formKey.currentState!.validate()) {
      FirebaseFirestore.instance.collection("users").doc(_user.uid).set(church.toJson(), SetOptions(merge: true));
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Profile updated'),
        backgroundColor: Colors.green,
      ));
    }
  }

  String? _validateInput(String? value) {
    if (value == null) return null;
    if (value.trim().isEmpty) {
      return 'Field required';
    }
    return null;
  }

  @override
  void initState() {
    _user = FirebaseAuth.instance.currentUser!;
    church = FirebaseFirestore.instance.collection("users").doc(_user.uid).get();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: FutureBuilder(
        future: church,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            Church church = Church.fromJson(snapshot.data!.data()!);
            _nameController.text = church.name;
            _phoneController.text = church.phoneNumber.toString();
            _emailController.text = church.email!;
            _addressController.text = church.address!;
            _regNoController.text = church.regNo!;
            _latController.text = church.location!.latitude.toString();
            _lngController.text = church.location!.longitude.toString();

            return ListView(controller: scroll, scrollDirection: Axis.horizontal, children: [
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.3,
                child: LocationSelector((target) {
                  _latController.text = target.latitude.toString();
                  _lngController.text = target.longitude.toString();
                }, oldLoc: LatLng(church.location!.latitude, church.location!.longitude)),
              ),
              Container(
                padding: const EdgeInsets.all(10.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              enableInteractiveSelection: false,
                              readOnly: true,
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                              // focusNode: _latFocusNode,
                              onFieldSubmitted: (String value) {
                                _nextFocus(_lngFocusNode);
                              },
                              controller: _latController,
                              validator: _validateInput,
                              decoration: const InputDecoration(
                                enabled: false,
                                // hintText: 'Enter the Latitude',
                                labelText: 'Latitude',
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextFormField(
                              readOnly: true,
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.done,
                              focusNode: _lngFocusNode,
                              onFieldSubmitted: (String value) {
                                // _submitForm();
                              },
                              controller: _lngController,
                              validator: _validateInput,
                              decoration: const InputDecoration(
                                enabled: false,
                                labelText: 'Longitude',
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ],
                      ),
                      TextFormField(
                        keyboardType: TextInputType.name,
                        textInputAction: TextInputAction.next,
                        focusNode: _nameFocusNode,
                        onFieldSubmitted: (String value) {
                          _nextFocus(_phoneFocusNode);
                        },
                        controller: _nameController,
                        validator: _validateInput,
                        decoration: const InputDecoration(
                          hintText: 'Enter Name of the church',
                          labelText: "Church's Name",
                        ),
                      ),
                      TextFormField(
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.next,
                        focusNode: _phoneFocusNode,
                        onFieldSubmitted: (String value) {
                          _nextFocus(_addressFocusNode);
                        },
                        controller: _phoneController,
                        validator: _validateInput,
                        decoration: const InputDecoration(
                          hintText: 'Enter the phone number',
                          labelText: 'Phone Number',
                        ),
                      ),
                      TextFormField(
                        readOnly: true,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        focusNode: _emailFocusNode,
                        onFieldSubmitted: (String value) {
                          _nextFocus(_addressFocusNode);
                        },
                        controller: _emailController,
                        validator: _validateInput,
                        decoration: const InputDecoration(
                          hintText: 'Enter the email address',
                          labelText: 'Email Address',
                        ),
                      ),
                      TextFormField(
                        keyboardType: TextInputType.streetAddress,
                        textInputAction: TextInputAction.next,
                        focusNode: _addressFocusNode,
                        onFieldSubmitted: (String value) {
                          _nextFocus(_regNoFocusNode);
                        },
                        controller: _addressController,
                        validator: _validateInput,
                        decoration: const InputDecoration(
                          hintText: 'Enter the address',
                          labelText: 'Address',
                        ),
                      ),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.next,
                        focusNode: _regNoFocusNode,
                        onFieldSubmitted: (String value) {
                          // _nextFocus(_latFocusNode);
                          _submitForm();
                        },
                        controller: _regNoController,
                        validator: _validateInput,
                        decoration: const InputDecoration(
                          hintText: 'Enter registration number',
                          labelText: 'Registration number',
                        ),
                      ),
                      const SizedBox(height: 8),
                      Align(alignment: Alignment.centerRight, child: ElevatedButton(onPressed: _submitForm, child: const Text('Update'))),
                      ExpansionTile(
                        title: const Text('Advanced Settings'),
                        leading: const Icon(Icons.shield),
                        onExpansionChanged: (value) {
                          if (value) {
                            scroll.jumpTo(scroll.position.maxScrollExtent);
                          }
                        },
                        children: [
                          ElevatedButton(
                              onPressed: () async {
                                if (await showDialog<bool>(
                                        context: context,
                                        builder: (BuildContext context) => Builder(
                                              builder: (context) => const PasswordField(),
                                            )) ??
                                    false) {
                                  // await Db().deleteAccountDetails();
                                  await FirebaseAuth.instance.currentUser!.delete();
                                  if (mounted) Navigator.of(context).pop(context);
                                }
                              },
                              child: const Row(
                                children: [Icon(Icons.delete_forever), Text('Delete Account')],
                              ))
                        ],
                      )
                    ],
                  ),
                ),
              )
            ]);
          }
          return const Center(
            child: CircularProgressIndicator.adaptive(),
          );
        },
      ),
    );
  }
}
