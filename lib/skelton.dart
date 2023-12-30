import 'package:flutter/material.dart';
import 'package:the_churche/screens/location_selection.dart';
import 'package:the_churche/screens/main_map.dart';
import 'package:the_churche/screens/login_profile.dart';
import 'package:the_churche/screens/profile_welcome.dart';
import 'package:the_churche/screens/churches.dart';

class Skelton extends StatefulWidget {
  const Skelton(this.index, {super.key});
  final int index;

  @override
  State<Skelton> createState() => _SkeltonState();
}

class _SkeltonState extends State<Skelton> {
  late int _selectedPage;

  @override
  void initState() {
    _selectedPage = widget.index;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(title: const Text('The app')),
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(icon: Icon(Icons.map), label: 'Map'),
          NavigationDestination(icon: Icon(Icons.church), label: 'Church'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Account')
        ],
        selectedIndex: _selectedPage,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedPage = index;
          });
        },
      ),
      body: [const MainMap(), const Churches('name'), const ProfileWelcome()][_selectedPage],
    );
  }
}
