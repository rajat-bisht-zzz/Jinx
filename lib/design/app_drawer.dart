import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../firebase/auth.dart';


class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: const Text('Konnichiwa'),
            automaticallyImplyLeading: false,
          ),
          const Divider(),
          ListTile(
            leading: const Icon(
              Icons.shop,
              color: Colors.blue,
            ),
            title: const Text(
              'Shop',
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18),
            ),
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
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
