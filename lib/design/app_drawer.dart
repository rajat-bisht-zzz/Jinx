import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../firebase/auth.dart';


class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            padding: EdgeInsets.zero,
            child: Column(
              children: const [
                CircleAvatar(
                  backgroundImage:
                      NetworkImage("https://picsum.photos/200/300"),
                  radius: 24,
                ),
                const Divider(),
                Text(
                  'Rajat',
                  style: TextStyle(fontFamily: 'monospace', fontSize: 16),
                ),
                const Divider(),
                Text(
                  'Rajat',
                  style: TextStyle(fontFamily: 'monospace', fontSize: 16),
                ),
              ],
            ),
          ),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.logout, color: Colors.brown),
            title: const Text(
              'Logout',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
            ),
            onTap: () {
              Navigator.of(context).pop();
              Navigator.of(context)
                  .pushReplacementNamed('/');
              Provider.of<Auth>(context, listen: false).logOut();
            },
          ),
          const Divider(),
        ],
      ),
    );
  }
}
