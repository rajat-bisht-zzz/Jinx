import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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

  Stream<List<DocumentSnapshot<Map<String, dynamic>>>> getUsersStream() {
    final userRef = FirebaseFirestore.instance.collection('users');
    final usersStream = userRef.snapshots();
    return usersStream.map((snapshot) => snapshot.docs);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Host Profile'),
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      drawer: AppDrawer(name: _currentUserName, role: _currentUserRole),
      body: StreamBuilder(
          stream: getUsersStream(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const CircularProgressIndicator();
            }
            final users = snapshot.data!;
            return ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final userData = users[index].data()!;
                  final name = userData['name'] ?? 'Unknown';
                  final email = userData['email'] ?? 'Unknown';
                  final role = userData['role'] ?? 'Unknown';
                  return ListTile(
                    title: Text(name),
                    subtitle: Text(email),
                    trailing: Text(role),
                  );
                });
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // FirebaseFirestore.instance
          //     .collection('users')
          //     .add({
          //   'text' :'Jinx Jinx'
          // });
          print('TEST pressed!!!');
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
