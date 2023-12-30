import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PasswordField extends StatefulWidget {
  const PasswordField({super.key});

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obs = true;
  final TextEditingController _password = TextEditingController();
  final _formFieldKey = GlobalKey<FormFieldState>();
  late String? error;

  final User user = FirebaseAuth.instance.currentUser!;

  Future<bool> _submit() async {
    if (_password.text.trim().isEmpty) {
      error = 'Please Enter Password';
    } else {
      try {
        await user.reauthenticateWithCredential(EmailAuthProvider.credential(email: user.email!, password: _password.text));
        error = null;
      } on FirebaseAuthException catch (e) {
        // print('Failed with error code: ${e.code}');
        // print(e.message);
        error = e.code;
      }
    }

    _formFieldKey.currentState?.validate();
    return error == null;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Permanent Deletion of Account !'),
      content: Builder(builder: (context) {
        return TextFormField(
          key: _formFieldKey,
          keyboardType: TextInputType.visiblePassword,
          obscureText: _obs,
          textInputAction: TextInputAction.done,
          controller: _password,
          validator: ((_) => error),
          decoration: InputDecoration(
              hintText: 'Enter the password',
              labelText: "Password",
              suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      _obs = !_obs;
                    });
                  },
                  icon: Icon(_obs ? Icons.visibility_outlined : Icons.visibility_off_outlined))),
        );
      }),
      actions: [
        TextButton(
          onPressed: () async {
            if (await _submit()) {
              if (mounted) Navigator.pop<bool>(context, true);
            }
          },
          child: const Text('Delete My Account'),
        ),
        TextButton(
          onPressed: () => Navigator.pop<bool>(context, false),
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}
