import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'package:google_sign_in/google_sign_in.dart';
import 'home.dart';
import 'sign_up.dart';
import 'animation.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});
  @override
  SignInState createState() => SignInState();
}

class SignInState extends State<SignIn> {
  bool _isLoading = false;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String? emailError;
  String? passwordError;
  String? errorMessage;

  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();

  // Google Sign-In instance
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  bool _validateEmail(String email) {
    String pattern = r'^[^@]+@[^@]+\.[^@]+';
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(email);
  }

  bool _validatePassword(String password) {
    return password.length >= 8; // Password must be at least 8 characters
  }

  void _focusNextField(
      {required FocusNode currentFocus,
      required FocusNode nextFocus,
      required Function validator}) {
    if (validator()) {
      currentFocus.unfocus();
      FocusScope.of(context).requestFocus(nextFocus);
    }
  }

  void _handleSignIn() async {
    // Validate fields
    setState(() {
      emailError =
          _validateEmail(emailController.text) ? null : 'Invalid email';
      passwordError = _validatePassword(passwordController.text)
          ? null
          : 'Password must be at least 8 characters';
    });

    // Block sign-in if validation fails
    if (emailError != null || passwordError != null) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // Access user information, such as user ID
      String userId = userCredential.user?.uid ?? '';
      print('User ID: $userId'); // Example of using the variable

      //  Navigate ONLY on success
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Home()),
      );
    } catch (e) {
      if (e is FirebaseAuthException) {
        switch (e.code) {
          case 'user-not-found':
            setState(() {
              emailError = 'No user found for that email.';
            });
            break;
          case 'wrong-password':
            setState(() {
              passwordError = 'Wrong password provided for that user.';
            });
            break;
          default:
            setState(() {
              emailError = 'An error occurred. Please try again.';
            });
        }
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _handleGoogleSignIn() async {
    setState(() {
      _isLoading = true; // Start loading
    });

    try {
      // Check if user is already signed in
      User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        // Optionally, ask for re-authentication
        // You can show a dialog to confirm re-authentication
        bool shouldReauthenticate = await _showReauthDialog();
        if (shouldReauthenticate) {
          // Proceed to re-authenticate
          final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
          if (googleUser != null) {
            // Obtain authentication details
            final GoogleSignInAuthentication googleAuth =
                await googleUser.authentication;

            // Create a new credential
            final credential = GoogleAuthProvider.credential(
              accessToken: googleAuth.accessToken,
              idToken: googleAuth.idToken,
            );

            // Re-authenticate user
            await currentUser.reauthenticateWithCredential(credential);
            // You can now proceed to the home page after re-authentication
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => Home()),
            );
          }
        } else {
          // If the user chooses not to re-authenticate, navigate to Home
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Home()),
          );
        }
        return; // Exit the method
      }

      // Initiate Google Sign-in if no user is signed in
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        setState(() {
          _isLoading = false; // Stop loading if user cancels
        });
        return; // User canceled the sign-in
      }

      // Obtain authentication details
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credential
      await FirebaseAuth.instance.signInWithCredential(credential);

      // Navigate to home on success
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Home()),
      );
    } catch (e) {
      print(e); // Handle errors (you can also show a message to the user)
    } finally {
      // Stop loading regardless of success or error
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

// Function to show a dialog asking for re-authentication
  Future<bool> _showReauthDialog() async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Re-authenticate"),
              content: Text("Do you want to re-authenticate?"),
              actions: <Widget>[
                TextButton(
                  child: Text("Cancel"),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                TextButton(
                  child: Text("Yes"),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                ),
              ],
            );
          },
        ) ??
        false;
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
        elevation: 0, // Removes shadow
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 40),
              Text(
                'Hello,',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 0, 0, 0),
                ),
                textAlign: TextAlign.left,
              ),
              Text(
                'Welcome Back!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.normal,
                  color: const Color.fromARGB(255, 0, 0, 0),
                ),
                textAlign: TextAlign.left,
              ),
              SizedBox(height: 40),
              Text(
                'Email',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: const Color.fromARGB(255, 0, 0, 0),
                ),
              ),
              SizedBox(height: 5),
              Container(
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
                  focusNode: emailFocusNode,
                  decoration: InputDecoration(
                    labelText: 'Enter Email',
                    errorText: emailError,
                    labelStyle: TextStyle(
                        color: const Color.fromARGB(91, 0, 8, 7), fontSize: 13),
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
              SizedBox(height: 20),
              Text(
                'Password',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: const Color.fromARGB(255, 0, 0, 0),
                ),
              ),
              SizedBox(height: 5),
              Container(
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
                  focusNode: passwordFocusNode,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Enter Password',
                    errorText: passwordError, // Add this line

                    labelStyle: TextStyle(
                        color: const Color.fromARGB(91, 0, 8, 7), fontSize: 13),
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
                      passwordError = _validatePassword(text)
                          ? null
                          : 'Password must be at least 8 characters';
                    });
                  },
                ),
              ),
              SizedBox(height: 10),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    // Handle forgot password
                  },
                  child: Text(
                    'Forgot Password?',
                    style: TextStyle(color: Colors.amber),
                  ),
                ),
              ),
              SizedBox(height: 20),
              AnimatedButton(
                onPressed: _handleSignIn, // Handle sign in
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _handleSignIn,
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
                              'Sign In',
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
                    onPressed:
                        _handleGoogleSignIn, // Call the Google sign-in method here
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignUp()),
                  );
                },
                child: Text.rich(
                  TextSpan(
                    text: "Don't have an account?",
                    style: TextStyle(
                      fontSize: 16,
                      color: const Color.fromARGB(255, 0, 0, 0),
                    ),
                    children: <TextSpan>[
                      TextSpan(
                        text: ' Sign up',
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
