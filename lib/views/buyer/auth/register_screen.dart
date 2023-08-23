import 'package:flutter/material.dart';
import 'package:msika_wathu/controllers/auth_controller.dart';
import 'package:msika_wathu/views/buyer/auth/loging_screan.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final AuthController _authController = AuthController();
  late String email = '';
  late String fullName = '';
  late String phoneNumber = '';
  late String password = '';
  late String confirmPassword = '';

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isPasswordVisible = false;
  PasswordStrength passwordStrength = PasswordStrength.none;
  bool passwordsMatch = false;

  _signUpUser() async {
    if (_formKey.currentState!.validate()) {
      if (password == confirmPassword) {
        String result = await _authController.signUpUsers(
            email, fullName, phoneNumber, password);

        if (result == 'Success') {
          print('Registration successful');
          // Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
        } else {
          print('Registration failed: $result');
          // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result)));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Passwords do not match'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  PasswordStrength calculatePasswordStrength(String value) {
    bool hasUppercase = false;
    bool hasLowercase = false;
    bool hasSymbol = false;
    bool hasNumber = false;

    for (var char in value.runes) {
      if (char >= 65 && char <= 90) {
        hasUppercase = true;
      } else if (char >= 97 && char <= 122) {
        hasLowercase = true;
      } else if ((char >= 33 && char <= 47) || (char >= 58 && char <= 64)) {
        hasSymbol = true;
      } else if (char >= 48 && char <= 57) {
        hasNumber = true;
      }
    }

    int score = 0;

    if (hasUppercase) score++;
    if (hasLowercase) score++;
    if (hasSymbol) score++;
    if (hasNumber) score++;

    if (value.length < 6) {
      return PasswordStrength.weak;
    }

    if (score >= 4) {
      return PasswordStrength.strong;
    }

    if (score >= 2) {
      return PasswordStrength.medium;
    }

    return PasswordStrength.weak;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your App Title'), // Set your app title here
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                CircleAvatar(
                  radius: 64,
                  backgroundColor: Colors.green.shade900,
                  child: const Icon(
                    Icons.person,
                    size: 64,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Create Customer's Account",
                  style: TextStyle(fontSize: 20),
                ),
                Padding(
                  padding: const EdgeInsets.all(13.0),
                  child: TextFormField(
                    onChanged: (value) {
                      setState(() {
                        fullName = value;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: 'Enter Full Name',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.green,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your full name';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      fullName = value!;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(13.0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: _CountrySelect(),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 3,
                        child: TextFormField(
                          onChanged: (value) {
                            setState(() {
                              phoneNumber = value;
                            });
                          },
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: 'Phone Number',
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.green,
                              ),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your phone number';
                            }
                            if (value.length < 10) {
                              return 'Phone number must have at least 10 digits';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            phoneNumber = value!;
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(13.0),
                  child: TextFormField(
                    onChanged: (value) {
                      setState(() {
                        email = value;
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: 'Enter Email',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.green,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an email address';
                      }
                      if (!isValidEmail(value)) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      email = value!;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(13.0),
                  child: TextFormField(
                    onChanged: (value) {
                      setState(() {
                        password = value;
                        if (value.isNotEmpty) {
                          passwordStrength = calculatePasswordStrength(value);
                        } else {
                          passwordStrength = PasswordStrength.none;
                        }
                        passwordsMatch = password == confirmPassword;
                      });
                    },
                    obscureText: !isPasswordVisible,
                    decoration: InputDecoration(
                      labelText: 'Enter Password',
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.green,
                        ),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            isPasswordVisible = !isPasswordVisible;
                          });
                        },
                      ),
                      suffix: passwordsMatch
                          ? const Icon(
                              Icons.check,
                              color: Colors.green,
                            )
                          : confirmPassword.isNotEmpty
                              ? const Icon(
                                  Icons.close,
                                  color: Colors.red,
                                )
                              : null,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
                      }
                      if (value.length < 6) {
                        return 'Password must have at least 6 characters';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      password = value!;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(13.0),
                  child: TextFormField(
                    onChanged: (value) {
                      setState(() {
                        confirmPassword = value;
                        passwordsMatch = password == confirmPassword;
                      });
                    },
                    obscureText: !isPasswordVisible,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.green,
                        ),
                      ),
                      suffix: passwordsMatch
                          ? const Icon(
                              Icons.check,
                              color: Colors.green,
                            )
                          : confirmPassword.isNotEmpty
                              ? const Icon(
                                  Icons.close,
                                  color: Colors.red,
                                )
                              : null,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your password';
                      }
                      if (value != password) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      confirmPassword = value!;
                    },
                  ),
                ),
                if (password.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(13.0),
                    child: LinearProgressIndicator(
                      value: passwordStrength == PasswordStrength.none
                          ? 0.0
                          : passwordStrength == PasswordStrength.weak
                              ? 0.33
                              : passwordStrength == PasswordStrength.medium
                                  ? 0.66
                                  : 1.0,
                      backgroundColor: Colors.grey,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        passwordStrength == PasswordStrength.none
                            ? Colors.grey
                            : passwordStrength == PasswordStrength.weak
                                ? Colors.red
                                : passwordStrength == PasswordStrength.medium
                                    ? Colors.orange
                                    : Colors.green,
                      ),
                    ),
                  ),
                if (password.isNotEmpty) const SizedBox(height: 8),
                if (password.isNotEmpty)
                  Text(
                    passwordStrength == PasswordStrength.none
                        ? 'None'
                        : passwordStrength == PasswordStrength.weak
                            ? 'Weak'
                            : passwordStrength == PasswordStrength.medium
                                ? 'Medium'
                                : 'Strong',
                    style: TextStyle(
                      color: passwordStrength == PasswordStrength.none
                          ? Colors.grey
                          : passwordStrength == PasswordStrength.weak
                              ? Colors.red
                              : passwordStrength == PasswordStrength.medium
                                  ? Colors.orange
                                  : Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () {
                    _signUpUser();
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width - 40,
                    height: 50,
                    decoration: BoxDecoration(
                      color: Colors.green.shade900,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Text(
                        'Register',
                        style: TextStyle(
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Already Have An Account?'),
                    TextButton(
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return const BLoginScrean();
                        }));
                      },
                      child: const Row(
                        children: [
                          Text('Login'),
                          Icon(Icons.login),
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
    return emailRegex.hasMatch(email);
  }
}

enum PasswordStrength {
  none,
  weak,
  medium,
  strong,
}

class _CountrySelect extends StatefulWidget {
  @override
  __CountrySelectState createState() => __CountrySelectState();
}

class __CountrySelectState extends State<_CountrySelect> {
  String? _selectedCountry = 'Malawi (+265)';

  void _showCountryMenu(BuildContext context) {
    final RenderBox button = context.findRenderObject() as RenderBox;
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject() as RenderBox;

    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset.zero, ancestor: overlay),
        button.localToGlobal(button.size.bottomLeft(Offset.zero),
            ancestor: overlay),
      ),
      Offset.zero & overlay.size,
    );

    showMenu<String>(
      context: context,
      position: position,
      items: [
        const PopupMenuItem<String>(
          value: 'Malawi (+265)',
          child: Text('Malawi (+265)'),
        ),
        const PopupMenuItem<String>(
          value: 'Nigeria (+234)',
          child: Text('Nigeria (+234)'),
        ),
        const PopupMenuItem<String>(
          value: 'Kenya (+254)',
          child: Text('Kenya (+254)'),
        ),
        const PopupMenuItem<String>(
          value: 'South Africa (+27)',
          child: Text('South Africa (+27)'),
        ),
        const PopupMenuItem<String>(
          value: 'Ghana (+233)',
          child: Text('Ghana (+233)'),
        ),
        const PopupMenuItem<String>(
          value: 'Egypt (+20)',
          child: Text('Egypt (+20)'),
        ),
        // Add more countries and codes here
      ],
    ).then<void>((String? value) {
      if (value != null) {
        setState(() {
          _selectedCountry = value;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showCountryMenu(context);
      },
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: 'Country Code',
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.green,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(_selectedCountry!),
            const Icon(Icons.keyboard_arrow_down),
          ],
        ),
      ),
    );
  }
}
