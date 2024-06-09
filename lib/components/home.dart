import 'package:flutter/material.dart';
import 'package:battery_system_app/components/button.dart';

class Home extends StatelessWidget {
  const Home({super.key, required this.onClick});
  final Function(String) onClick;
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Welcome To Dynamic Battery System',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: Color.fromARGB(255, 255, 255, 255)),
          ),
          const SizedBox(
            height: 50,
          ),
          ButtonSample(
            text: 'Sign Up',
            onPress: () {
              onClick('SignUp');
            },
          ),
          const SizedBox(
            height: 20,
          ),
          ButtonSample(
            text: 'Sign In',
            onPress: () {
              onClick('SignIn');
            },
          ),
        ],
      ),
    );
  }
}
