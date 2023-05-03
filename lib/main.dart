import 'package:flutter/material.dart';
import 'package:jinx/screens/auth_screen.dart';
import 'package:jinx/screens/user_profile_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'firebase/auth.dart';
import 'screens/admin_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Auth()),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            unselectedWidgetColor: Colors.white,
          ),
          routes: {
            UserProfileScreen.routeName: (ctx) => const UserProfileScreen(),
            AuthScreen.routeName: (ctx) => const UserProfileScreen(),
          },
          home: auth.isAuth
              ? auth.isAdmin
                  ? AdminScreen(userId: auth.userId.toString())
                  : const UserProfileScreen()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authSnapshot) =>
                      authSnapshot.connectionState == ConnectionState.waiting
                          ? const Center(child: CircularProgressIndicator())
                          : const AuthScreen()),
        ),
      ),
    );
  }
}
