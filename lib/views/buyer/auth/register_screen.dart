import 'package:flutter/material.dart';
import 'package:msika_wathu/controllers/auth_controller.dart';
import 'package:msika_wathu/views/buyer/auth/loging_screan.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:ui';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key, Key});

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
  XFile? globalImage;
  XFile? globalImage1;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isPasswordVisible = false;
  PasswordStrength passwordStrength = PasswordStrength.none;
  bool passwordsMatch = false;
  bool isLoading = false; // Track loading state

  _signUpUser() async {
    if (_formKey.currentState!.validate()) {
      if (password == confirmPassword) {
        setState(() {
          isLoading = true; // Set loading state to true
        });

        String result = await _authController.signUpUsers(
            email, fullName, phoneNumber, password, globalImage);

        if (result == 'Success') {
          print('Registration successful');
          Navigator.push(context, MaterialPageRoute(builder: (context) => BLoginScreen()));
        } else {
          print('Registration failed: $result');
          // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(result)));
        }

        setState(() {
          isLoading = false; // Set loading state to false
        });
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

  selectImage() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          child: Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'Select Image Source',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () async {
                    final img = await _authController.imagePicker(
                        context, ImageSource.camera);
                    if (img != null) {
                      setState(() {
                        globalImage = img;
                      });
                    }
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: Text(
                    'Camera',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
                ElevatedButton(
                  onPressed: () async {
                    final img = await _authController.imagePicker(
                        context, ImageSource.gallery);
                    if (img != null) {
                      setState(() {
                        globalImage = img;
                        globalImage1 = img;
                      });
                    }
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: Text(
                    'Gallery',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
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
                GestureDetector(
                  onTap: () {
                    selectImage();
                  },
                  child: Container(
                    width: 360,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.green.shade900,
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        globalImage != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(12.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(
                                        sigmaX: 5.0,
                                        sigmaY: 5.0,
                                      ),
                                      child: Image.file(
                                        File(globalImage!.path),
                                        width: double.infinity,
                                        height: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : SizedBox.shrink(),
                        Container(
                          color: Colors.transparent,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12.0),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(
                                sigmaX: 7.0,
                                sigmaY: 7.0,
                              ),
                              child: Container(
                                color: Colors.transparent,
                              ),
                            ),
                          ),
                        ),
                        Center(
                          child: Container(
                            width: 100.0,
                            height: 100.0,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.green,
                                width: 4.0,
                              ),
                            ),
                            child: CircleAvatar(
                              radius: 48.0,
                              backgroundColor: Colors.white,
                              backgroundImage: globalImage != null
                                  ? FileImage(File(globalImage!.path))
                                  : null,
                              child: globalImage != null
                                  ? null
                                  : Icon(
                                      Icons.person,
                                      size: 80,
                                      color: Colors.green.shade900,
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
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
                    child: Center(
                      child: isLoading
                          ? CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                            )
                          : const Text(
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
                          return const BLoginScreen();
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
