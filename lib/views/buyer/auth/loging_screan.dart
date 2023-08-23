import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:msika_wathu/views/buyer/main_screen.dart';
import 'package:msika_wathu/views/buyer/auth/register_screen.dart';

class BLoginScrean extends StatefulWidget {
  const BLoginScrean({Key? key}) : super(key: key);

  @override
  _BLoginScreanState createState() => _BLoginScreanState();
}

class _BLoginScreanState extends State<BLoginScrean> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _emailError;
  String? _passwordError;
  String? _firebaseError;
  bool _isLoading = false;

  void _clearErrors() {
    setState(() {
      _emailError = null;
      _passwordError = null;
      _firebaseError = null;
    });
  }

  Future<void> _login() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    _clearErrors();

    if (email.isEmpty) {
      setState(() {
        _emailError = 'Email cannot be empty';
      });
    } else if (!isValidEmail(email)) {
      setState(() {
        _emailError = 'Enter a valid email';
      });
    }

    if (password.isEmpty) {
      setState(() {
        _passwordError = 'Password cannot be empty';
      });
    }

    if (_emailError != null || _passwordError != null) {
      return;
    }

    try {
      setState(() {
        _isLoading = true;
      });

      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final User? user = userCredential.user;

      if (user != null) {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return MainScreen();
        }));
      } else {
        // Handle authentication failure if needed.
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        _showFirebaseErrorDialog(
            'Account not found. Would you like to sign up?');
      } else if (e.code == 'wrong-password') {
        _showFirebaseErrorDialog('Wrong email or password. Please try again.');
      } else {
        _showFirebaseErrorDialog('An error occurred. Please try again later.');
      }
    } catch (e) {
      _showFirebaseErrorDialog('An error occurred. Please try again later.');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showFirebaseErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: null,
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
            if (message
                .contains('sign up')) // Check if the message contains 'sign up'
              TextButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const RegisterScreen();
                  }));
                },
                child: Text("Sign Up"),
              ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Login Customer Account'),
          backgroundColor: Colors.green,
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 60),
                const CircleAvatar(
                  radius: 64,
                  backgroundColor: Colors.green,
                  child: Icon(
                    Icons.person,
                    size: 64,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Login Customer's Account",
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(13.0),
                  child: TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Enter Email Address',
                      border: OutlineInputBorder(),
                      errorText: _emailError,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(13.0),
                  child: TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Enter Password',
                      border: OutlineInputBorder(),
                      errorText: _passwordError,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  style: ElevatedButton.styleFrom(
                    primary: _isLoading
                        ? Colors.green.withOpacity(0.5)
                        : Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    minimumSize: const Size(355, 50),
                  ),
                  child: _isLoading
                      ? CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                      : Text(
                          _isLoading ? 'Logging In...' : 'Login',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
                if (_firebaseError != null)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      _firebaseError!,
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return const RegisterScreen();
                    }));
                  },
                  child: Text("Don't have an account? Sign Up"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool isValidEmail(String email) {
    final emailRegExp = RegExp(
      r'^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$',
    );
    return emailRegExp.hasMatch(email);
  }
}

void main() {
  runApp(MaterialApp(
    home: BLoginScrean(),
  ));
}
