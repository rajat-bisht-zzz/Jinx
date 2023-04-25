import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../firebase/auth.dart';

enum AuthMode { signUp, logIn }

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  static const routeName = '/auth-screen';


  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {


  final _formKey = GlobalKey<FormState>();

  late AnimationController _animationController;
  // var _signUpType = SignUpType.User;
  var _authMode = AuthMode.logIn;

  final Map<String?, String> _authData = {
    'name': '',
    'email': '',
    'password': '',
    'userRole': ''
  };

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  var _isLoading = false;
  String? _selectedSignUpType;
  final List<String> _signUpTypes = ['User', 'Host'];

  void _submitForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });

    try {
      if (_authMode == AuthMode.logIn) {
        await Provider.of<Auth>(context, listen: false).logIn(
          _authData['email']!,
          _authData['password']!,
        );
      } else {
        await Provider.of<Auth>(context, listen: false).signUp(
          _authData['name']!,
          _authData['email']!,
          _authData['password']!,
          _authData['userRole']!
        );
      }
    } catch (e) {
      var errorMessage = 'Could not authenticate you. Please try again later';
      if (e.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This E-Mail address is already in use';
      } else if (e.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'This E-Mail address is invalid';
      } else if (e.toString().contains('WEAK_PASSWORD')) {
        errorMessage = 'This Password is weak. Please use a strong one';
      } else if (e.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'This email address is not registered';
      } else if (e.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'This password is invalid';
      }
      _showErrorDialog(errorMessage);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _emailController.dispose();
    _nameController.dispose();
    _animationController.dispose();
    super.dispose();
  }



  void _switchAuthMode() {
    if (_authMode == AuthMode.logIn) {
      setState(() {
        _authMode = AuthMode.signUp;
      });
    } else {
      setState(() {
        _authMode = AuthMode.logIn;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..forward();

  }

  void _showErrorDialog(String message) {
    showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
              title: const Text('An Error Occurred'),
              content: Text(message),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                    child: const Text('OK'))
              ],
            ));
  }

  void _onSignUpTypeChanged(String? value) {
    setState(() {
      _selectedSignUpType = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(-1, 0),
                          end: Offset.zero,
                        ).animate(_animationController),
                        child: Text(
                          _authMode == AuthMode.logIn ? 'Login' : 'Sign Up',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              const SizedBox(height: 50),
                              Visibility(
                                visible: _authMode == AuthMode.signUp,
                                child: TextFormField(
                                  controller: _nameController,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'Please enter your name';
                                    }
                                    return null;
                                  },
                                  decoration: const InputDecoration(
                                    hintText: 'Name',
                                    prefixIcon: Icon(Icons.account_circle),
                                  ),
                                  onSaved: (value) {
                                    _authData['name'] = value!;
                                  },
                                ),
                              ),
                              const SizedBox(height: 20),
                              TextFormField(
                                controller: _emailController,
                                onSaved: (value) {
                                  _authData['email'] = value!;
                                },
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter your email';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  hintText: 'Email',
                                  prefixIcon: Icon(Icons.email),
                                ),
                              ),
                              const SizedBox(height: 20),
                              TextFormField(
                                controller: _passwordController,
                                onSaved: (value) {
                                  _authData['password'] = value!;
                                },
                                obscureText: true,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'Please enter your password';
                                  }
                                  return null;
                                },
                                decoration: const InputDecoration(
                                  hintText: 'Password',
                                  prefixIcon: Icon(Icons.lock),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Visibility(
                                visible: _authMode == AuthMode.signUp,
                                child: DropdownButtonFormField<String>(
                                  decoration: const InputDecoration(
                                    hintText: 'Select mode of sign up',
                                    prefixIcon: Icon(Icons.person),
                                  ),
                                  value: _selectedSignUpType,
                                  onSaved: (value) {
                                    _authData['userRole'] = value!;
                                  },
                                  items: _signUpTypes.map((String signUpType) {
                                    return DropdownMenuItem<String>(
                                      value: signUpType,
                                      child: Text(signUpType),
                                    );
                                  }).toList(),
                                  onChanged: _onSignUpTypeChanged,
                                ),
                              ),
                              const SizedBox(height: 50),
                              _isLoading
                                  ? const CircularProgressIndicator()
                                  : ScaleTransition(
                                      scale: Tween<double>(
                                        begin: 0,
                                        end: 1,
                                      ).animate(_animationController),
                                      child: ElevatedButton(
                                        onPressed: _submitForm,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.black,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                        ),
                                        child: Text(
                                          _authMode == AuthMode.logIn
                                              ? 'Login'
                                              : 'Sign Up',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                              const SizedBox(height: 50),
                              FadeTransition(
                                opacity: Tween<double>(
                                  begin: 0,
                                  end: 1,
                                ).animate(_animationController),
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _switchAuthMode();
                                    });
                                  },
                                  child: Text(
                                    _authMode == AuthMode.signUp
                                        ? 'Already have an account? Login'
                                        : 'Dont have an account? SignUp!',
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
