import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../firebase/auth.dart';

class AppDrawer extends StatelessWidget {
  final String name;
  final String role;

  const AppDrawer({Key? key, required this.name, required this.role})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          SizedBox(
            height: 300,
            child: DrawerHeader(
              decoration: const BoxDecoration(color: Colors.red),
              child: Column(
                children: [
                  const CircleAvatar(
                    backgroundImage:
                        NetworkImage("https://picsum.photos/200/300"),
                    radius: 80,
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    name,
                    style: const TextStyle(fontSize: 32),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Text(
                    role,
                    style: const TextStyle(fontSize: 24),
                  ),
                ],
              ),
            ),
          ),
          const ListTile(
            leading: Icon(Icons.account_circle),
            title: Text(
              'Profile',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
            ),
          ),
          const Divider(),
          const ListTile(
            leading: Icon(Icons.settings),
            title: Text(
              'Settings',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
            ),
          ),
          const Divider(),
          const ListTile(
            leading: Icon(Icons.star),
            title: Text(
              'Review App',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
            ),
          ),
          const Divider(),
          const ListTile(
            leading: Icon(Icons.phone),
            title: Text(
              'Contact Us',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.brown),
            title: const Text(
              'Logout',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
            ),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/');
              Provider.of<Auth>(context, listen: false).logOut();
            },
          ),
          const Divider(),
        ],
      ),
    );
  }
}
