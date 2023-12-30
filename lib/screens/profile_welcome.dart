import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_churche/states/app_state.dart';
import 'package:the_churche/screens/login_profile.dart';
import 'package:the_churche/widgets/profile_actions.dart';

class ProfileWelcome extends StatelessWidget {
  const ProfileWelcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationState>(builder: (context, appState, _) {
      if (appState.user == null) {
        return appState.signInScreen();
      }
      if (!appState.user!.emailVerified) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              appState.user!.email!,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              'Please check your email to verify the email address',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            TextButton(
                onPressed: () async {
                  await appState.user!.sendEmailVerification();
                },
                child: const Text('Resend Verification Email')),
            ProfileActions(
              context,
            ),
          ],
        );
      }
      return const Profile();
    });
  }
}


// class _ProfileWelcome extends StatelessWidget {
//   const _ProfileWelcome(this._state);

//   final ApplicationState _state;

//   @override
//   Widget build(BuildContext context) {
    
//   }
// }
