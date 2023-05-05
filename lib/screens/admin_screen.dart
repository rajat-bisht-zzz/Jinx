import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:jinx/screens/manage_users_screen.dart';

import '../design/app_drawer.dart';

class AdminScreen extends StatefulWidget {
  final String? userId;

  const AdminScreen({Key? key, required this.userId}) : super(key: key);

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  String _currentUserName = 'Unknown';
  String _currentUserRole = 'Unknown';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() async {
    final userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.userId)
        .get();

    setState(() {
      _currentUserName = userDoc.get('name') ?? 'Unknown';
      _currentUserRole = userDoc.get('role') ?? 'Unknown';
    });
  }

  // Stream<List<DocumentSnapshot<Map<String, dynamic>>>> getUsersStream() {
  //   final userRef = FirebaseFirestore.instance.collection('users');
  //   final usersStream = userRef.snapshots();
  //   return usersStream.map((snapshot) => snapshot.docs);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Host Profile'),
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      drawer: AppDrawer(name: _currentUserName, role: _currentUserRole),
      body:  GridView.count(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        padding: const EdgeInsets.all(20),
        children: [
          _buildTile(
            context: context,
            label: 'Manage Users',
            icon: Icons.calculate,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ManageUsersScreen()),
              );
            },
          ),
          _buildTile(
            context: context,
            label: 'Manage Services',
            icon: Icons.info,
            onTap: () {
              // Navigator.push(
              //   context,
              //   // MaterialPageRoute(builder: (context) => InformationScreen()),
              // );
            },
          ),
          _buildTile(
            context: context,
            label: 'Settings',
            icon: Icons.settings,
            onTap: () {
              // Navigator.push(
              //   context,
              //   // MaterialPageRoute(builder: (context) => SettingsScreen()),
              // );
            },
          ),
          _buildTile(
            context: context,
            label: 'Sign out',
            icon: Icons.logout,
            onTap: () {
              // Perform sign out action here
            },
          ),
        ],
      )
    );
  }

  Widget _buildTile({
    required BuildContext context,
    required String label,
    required IconData icon,
    required void Function() onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 50,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 10),
            Text(
              label,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
