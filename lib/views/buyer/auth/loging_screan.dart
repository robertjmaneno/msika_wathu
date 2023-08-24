import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:msika_wathu/views/buyer/main_screen.dart';
import 'package:msika_wathu/views/buyer/auth/register_screen.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class BLoginScreen extends StatefulWidget {
  const BLoginScreen({Key? key}) : super(key: key);

  @override
  _BLoginScreanState createState() => _BLoginScreanState();
}

class _BLoginScreanState extends State<BLoginScreen> {
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
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return const MainScreen();
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
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const RegisterScreen(); // Navigate to RegisterScreen
                }));
              },
              child: const Text("Sign Up"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
            // if (message
            //     .contains('sign up')) // Check if the message contains 'sign up'
            //   TextButton(
            //     onPressed: () {
            //       Navigator.push(context, MaterialPageRoute(builder: (context) {
            //         return const RegisterScreen();
            //       }));
            //     },
            //     child: Text("Sign Up"),
            //   ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login Customer Account'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              const Text(
                "Login Customer's Account",
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 20), // Increased height here
              Padding(
                padding: const EdgeInsets.all(13.0),
                child: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Enter Email Address',
                    border: const OutlineInputBorder(),
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
                    border: const OutlineInputBorder(),
                    errorText: _passwordError,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: _isLoading ? null : _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isLoading
                      ? Colors.green.withOpacity(0.5)
                      : Colors.green, // Adjusted button color during loading
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  minimumSize: const Size(355, 50),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      )
                    : Text(
                        _isLoading ? 'Logging In...' : 'Login',
                        style: const TextStyle(
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
                    style: const TextStyle(
                      color: Colors.red,
                    ),
                  ),
                ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const RegisterScreen(); // Navigate to RegisterScreen
                  }));
                },
                child: const Text(
                  "Don't have an account? Sign up",
                  style: TextStyle(
                    color: Colors.blue, // Customize the color
                  ),
                ),
          )],
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
  runApp(const MaterialApp(
    home: BLoginScreen(),
  ));
}
