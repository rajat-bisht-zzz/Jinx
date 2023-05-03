import 'package:flutter/material.dart';

import '../design/app_drawer.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({Key? key}) : super(key: key);

  static const routeName = '/user-screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
      ),
      drawer: AppDrawer(name: '', role: ''),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'Name: ',
              style: TextStyle(fontSize: 24),
            ),
            Text(
              'Email: email',
              style: TextStyle(fontSize: 24),
            ),
            Text(
              'SignIN Type:',
              style: TextStyle(fontSize: 24),
            ),
          ],
        ),
      ),
    );
  }
}
