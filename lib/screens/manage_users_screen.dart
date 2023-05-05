import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ManageUsersScreen extends StatefulWidget {
  const ManageUsersScreen({Key? key}) : super(key: key);

  @override
  State<ManageUsersScreen> createState() => _ManageUsersScreenState();
}

class _ManageUsersScreenState extends State<ManageUsersScreen> {
  Stream<List<DocumentSnapshot<Map<String, dynamic>>>> getUsersStream() {
    final userRef = FirebaseFirestore.instance.collection('users');
    final usersStream = userRef.snapshots();
    return usersStream.map((snapshot) => snapshot.docs);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hi'),
      ),
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
                  return Dismissible(
                    key: const ValueKey(0),
                    background: Container(
                      color: Theme.of(context).primaryColorLight,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.only(right: 20),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 4),
                      child: const Icon(
                        Icons.delete,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                    direction: DismissDirection.endToStart,
                    confirmDismiss: (direction) {
                      return showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                                title: const Text('Are you sure?'),
                                content: const Text(
                                    "Do you want to remove the item from cart?"),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(false);
                                      },
                                      child: const Text('NO')),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop(true);
                                      },
                                      child: const Text('YES'))
                                ],
                              ));
                    },
                    onDismissed: (direction) {
                      print("Dismisseddd!!!!");
                    },
                    child: ListTile(
                      title: Text(name),
                      subtitle: Text(email),
                      trailing: Text(role),
                    ),
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
