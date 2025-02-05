import 'package:flutter/material.dart';
import 'sign_in.dart';
import 'animation.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/front.jpg'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black54,
                  BlendMode.darken,
                ),
              ),
            ),
          ),
          Positioned(
            top: 100,
            left: MediaQuery.of(context).size.width / 2 - 50,
            child: Icon(
              Icons.restaurant_menu,
              size: 100,
              color: Colors.white,
            ),
          ),
          Positioned(
            top: 200,
            left: MediaQuery.of(context).size.width / 3.2,
            child: Text(
              'Premium Recipe',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Positioned(
            top: 450,
            left: MediaQuery.of(context).size.width / 4.3,
            child: Text(
              'Get Cooking',
              style: TextStyle(
                color: Colors.white,
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Positioned(
            top: 500,
            left: MediaQuery.of(context).size.width / 5,
            child: Text(
              'Simple way to find Tasty Recipe',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),
          ),
          Positioned(
            top: 550,
            left: MediaQuery.of(context).size.width / 4.5,
            child: AnimatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SignIn()),
                );
              },
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignIn()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 5, 38, 7),
                  padding: EdgeInsets.symmetric(horizontal: 60, vertical: 23),
                  textStyle: TextStyle(fontSize: 20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Start Cooking',
                      style: TextStyle(color: Colors.white),
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
          ),
        ],
      ),
    );
  }
}
