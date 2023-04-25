import 'package:flutter/material.dart';

import '../design/app_drawer.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({Key? key}) : super(key: key);

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text('Host Profile'),
      ),
      drawer: const AppDrawer(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Name: ',
              style: TextStyle(fontSize: 24),
            ),
            Text(
              'Email: ',
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
