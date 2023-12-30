import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:the_churche/services/db_service.dart';
import 'package:the_churche/states/app_state.dart';
import 'package:the_churche/widgets/password_field.dart';

class ProfileActions extends StatelessWidget {
  const ProfileActions(this.context, {bool isReg = false, super.key, void Function()? regFunc})
      : _regFunc = regFunc,
        _isReg = isReg;

  final bool _isReg;
  final BuildContext context;
  final void Function()? _regFunc;

  Future<bool?> _confirme(String title, String msg, String main, String secondary, BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(title),
        content: Text(msg),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(main),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(secondary),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Visibility(
          visible: _isReg,
          child: ElevatedButton(onPressed: _regFunc, child: const Text('Register')),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
                onPressed: () async {
                  if (await _confirme('Sign Out', 'Do you want to sign out from your account ?', 'Yes', 'no', context) ?? false) {
                    await FirebaseAuth.instance.signOut();
                  }
                },
                child: const Text('Sign Out')),
            const SizedBox(width: 20),
            FilledButton(
              onPressed: () async {
                if (await showDialog<bool>(
                        context: context,
                        builder: (BuildContext context) => Builder(
                              builder: (context) => const PasswordField(),
                            )) ??
                    false) {
                  await FirebaseAuth.instance.currentUser!.delete();
                }
              },
              child: const Row(
                children: [
                  Icon(Icons.delete_forever),
                  SizedBox(width: 10),
                  Text('Delete The account'),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
