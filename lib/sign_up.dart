import 'package:flutter/material.dart';
import 'animation.dart';
import 'home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});
  @override
  SignUpState createState() => SignUpState();
}

class SignUpState extends State<SignUp> {
  bool _isLoading = false;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController nameController = TextEditingController();
  String? nameError;
  String? emailError;
  String? passwordError;
  String? confirmPasswordError;
  String? errorMessage;

  final FocusNode nameFocusNode = FocusNode();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final FocusNode confirmPasswordFocusNode = FocusNode();
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  bool _validateEmail(String email) {
    String pattern = r'^[^@]+@[^@]+\.[^@]+';
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(email);
  }

  bool _validatePassword(String password) {
    String pattern =
        r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$';
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(password);
  }

  bool _validateConfirmPassword(String confirmPassword) {
    return confirmPassword == passwordController.text;
  }

  void _focusNextField({
    required FocusNode currentFocus,
    required FocusNode nextFocus,
    required Function validator,
  }) {
    if (validator()) {
      currentFocus.unfocus();
      FocusScope.of(context).requestFocus(nextFocus);
    }
  }

  Future<void> _handleSignUp() async {
    // Validate fields
    setState(() {
      nameError = nameController.text.isEmpty ? 'Name cannot be empty' : null;
      emailError =
          _validateEmail(emailController.text) ? null : 'Invalid email';
      passwordError = _validatePassword(passwordController.text)
          ? null
          : 'Password must be at least 8 characters, include a symbol, an uppercase letter, and a number';
      confirmPasswordError =
          _validateConfirmPassword(confirmPasswordController.text)
              ? null
              : 'Passwords do not match';
    });

    // Block sign-up if validation fails
    if (nameError != null ||
        emailError != null ||
        passwordError != null ||
        confirmPasswordError != null) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // Accessing user information
      User? user = userCredential.user;
      if (user != null) {
        print('User ID: ${user.uid}');
      }

      // Navigate to Home on success
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Home()),
      );
    } catch (e) {
      setState(() {
        _isLoading = false;
        emailError = e.toString(); // Display the error message
      });
      print(e); // Log the error for debugging
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false; // Ensure loading state is reset
        });
      }
    }
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        setState(() {
          _isLoading = false;
        });
        return; // User canceled the sign-in
      }
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Home()),
      );
    } catch (e) {
      print(e); // Handle errors
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 0),
              Text(
                'Create an account',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 0, 0, 0),
                ),
                textAlign: TextAlign.left,
              ),
              Text(
                "Let's help you set up your account.",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: const Color.fromARGB(255, 0, 0, 0),
                ),
                textAlign: TextAlign.left,
              ),
              SizedBox(height: 5),
              Text(
                'Name',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: const Color.fromARGB(255, 0, 0, 0),
                ),
              ),
              SizedBox(height: 5),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Enter Name',
                      errorText: nameError,
                      labelStyle: TextStyle(
                          color: const Color.fromARGB(91, 0, 8, 7),
                          fontSize: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.teal),
                      ),
                    ),
                    textInputAction: TextInputAction.next,
                    onChanged: (text) {
                      setState(() {
                        nameError =
                            text.isEmpty ? 'Name cannot be empty' : null;
                      });
                    },
                    onEditingComplete: () {
                      _focusNextField(
                        currentFocus: nameFocusNode,
                        nextFocus: emailFocusNode,
                        validator: () {
                          bool isValid = nameController.text.isNotEmpty;
                          setState(() {
                            nameError = isValid ? null : 'Name cannot be empty';
                          });
                          return isValid;
                        },
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Email',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: const Color.fromARGB(255, 0, 0, 0),
                ),
              ),
              SizedBox(height: 5),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'Enter Email',
                      errorText: emailError,
                      labelStyle: TextStyle(
                          color: const Color.fromARGB(91, 0, 8, 7),
                          fontSize: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.teal),
                      ),
                    ),
                    textInputAction: TextInputAction.next,
                    onChanged: (text) {
                      setState(() {
                        emailError =
                            _validateEmail(text) ? null : 'Invalid email';
                      });
                    },
                    onEditingComplete: () {
                      _focusNextField(
                        currentFocus: emailFocusNode,
                        nextFocus: passwordFocusNode,
                        validator: () {
                          bool isValid = emailController.text.isNotEmpty &&
                              emailError == null;
                          setState(() {
                            emailError = isValid ? null : 'Invalid email';
                          });
                          return isValid;
                        },
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Password',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: const Color.fromARGB(255, 0, 0, 0),
                ),
              ),
              SizedBox(height: 5),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Enter Password',
                      errorText: passwordError,
                      labelStyle: TextStyle(
                          color: const Color.fromARGB(91, 0, 8, 7),
                          fontSize: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.teal),
                      ),
                    ),
                    textInputAction: TextInputAction.next,
                    onChanged: (text) {
                      setState(() {
                        passwordError = _validatePassword(text)
                            ? null
                            : 'Password must be at least 8 characters, include a symbol, an uppercase letter, and a number';
                      });
                    },
                    onEditingComplete: () {
                      _focusNextField(
                        currentFocus: passwordFocusNode,
                        nextFocus: confirmPasswordFocusNode,
                        validator: () {
                          bool isValid =
                              _validatePassword(passwordController.text);
                          setState(() {
                            passwordError = isValid
                                ? null
                                : 'Password must be at least 8 characters, include a symbol, an uppercase letter, and a number';
                          });
                          return isValid;
                        },
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Confirm Password',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: const Color.fromARGB(255, 0, 0, 0),
                ),
              ),
              SizedBox(height: 5),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: confirmPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Retype Password',
                      errorText: confirmPasswordError,
                      labelStyle: TextStyle(
                          color: const Color.fromARGB(91, 0, 8, 7),
                          fontSize: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.teal),
                      ),
                    ),
                    textInputAction: TextInputAction.done,
                    onChanged: (text) {
                      setState(() {
                        confirmPasswordError = _validateConfirmPassword(text)
                            ? null
                            : 'Passwords do not match';
                      });
                    },
                  ),
                ),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Checkbox(
                    value: false,
                    side: BorderSide(color: Colors.amber),
                    onChanged: (bool? value) {
                      // Handle checkbox value change
                    },
                  ),
                  Text(
                    'Accept terms & Conditions',
                    style: TextStyle(fontSize: 15, color: Colors.amber),
                  ),
                ],
              ),
              SizedBox(height: 20),
              AnimatedButton(
                onPressed: _handleSignUp,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleSignUp,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    backgroundColor: const Color.fromARGB(255, 5, 38, 7),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: _isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Sign Up',
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                            ),
                            SizedBox(width: 10),
                            Icon(
                              Icons.arrow_forward,
                              color: Colors.white,
                            ),
                          ],
                        ),
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Divider(
                      color: const Color.fromARGB(255, 10, 159, 141),
                      thickness: 1,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      'Or Sign in With',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: const Color.fromARGB(255, 10, 159, 141),
                      thickness: 1,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: _handleGoogleSignIn,
                    icon: Icon(Icons.login),
                    color: Colors.red,
                    iconSize: 40,
                  ),
                  SizedBox(width: 20),
                  IconButton(
                    onPressed: () {
                      // Handle Facebook sign in
                    },
                    icon: Icon(Icons.facebook),
                    color: Colors.blue,
                    iconSize: 40,
                  ),
                ],
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text.rich(
                  TextSpan(
                    text: 'Already a member?',
                    style: TextStyle(
                      fontSize: 16,
                      color: const Color.fromARGB(255, 0, 0, 0),
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: ' Sign in',
                        style: TextStyle(color: Colors.amber),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
