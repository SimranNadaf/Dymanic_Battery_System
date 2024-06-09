import 'package:battery_system_app/components/button.dart';
import 'package:battery_system_app/components/inputComponent.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignUp extends StatelessWidget {
  const SignUp({super.key, required this.onSubmit});

  final Function(String) onSubmit;

  @override
  Widget build(context) {
    TextEditingController fname = TextEditingController();
    TextEditingController lname = TextEditingController();
    TextEditingController email = TextEditingController();
    TextEditingController phone = TextEditingController();
    TextEditingController psw = TextEditingController();
    TextEditingController cpsw = TextEditingController();

    void register() async {
      if (psw.text == cpsw.text) {
        FirebaseFirestore firestore = FirebaseFirestore.instance;

        // Collection reference
        CollectionReference users = firestore.collection('users');

        // Set data to document
        await users.doc(email.text).set({
          'fname': fname.text,
          'lname': lname.text,
          'email': email.text,
          'phone': phone.text,
          'password': psw.text,
          // Add more fields as needed
        }).then((value) {
          print('Data set successfully');
          var snackBar = const SnackBar(
            backgroundColor: Color.fromARGB(255, 17, 100, 19),
            content: Text(
              'You are Registered Successfully!',
              style: TextStyle(color: Colors.white),
            ),
          );

          // Find the ScaffoldMessenger in the widget tree
          // and use it to show a SnackBar.
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }).catchError((error) {
          print('Failed to set data: $error');
        });

        onSubmit('SignIn');
      } else {
        var snackBar = const SnackBar(
          backgroundColor: Color.fromARGB(255, 187, 11, 11),
          content: Text(
            'Password and Confirm Password must be same!',
            style: TextStyle(color: Colors.white),
          ),
        );

        // Find the ScaffoldMessenger in the widget tree
        // and use it to show a SnackBar.
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    }

    return Center(
      child: Container(
        // margin: const EdgeInsets.only(top: 10),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 25,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: () {
                        onSubmit('SignIn');
                      },
                      icon: const Icon(
                        Icons.arrow_back,
                      ),
                      color: const Color.fromARGB(255, 2, 77, 3),
                      iconSize: 25,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 100,
                child: Image.asset(
                  "assets/logo.png",
                  // height: 120,
                  // width: 120,
                ),
              ),
              const Text(
                "Sign Up",
                style: TextStyle(
                    color: Color.fromARGB(255, 2, 77, 3),
                    fontSize: 30,
                    fontWeight: FontWeight.w900),
              ),
              const SizedBox(
                height: 25,
              ),
              InputComponent(false, text: "First Name", textEC: fname),
              InputComponent(false, text: "Last Name", textEC: lname),
              InputComponent(false, text: "Email", textEC: email),
              InputComponent(false, text: "Phone No.", textEC: phone),
              InputComponent(true, text: "Password", textEC: psw),
              InputComponent(true, text: "Confirm Password", textEC: cpsw),
              const SizedBox(
                height: 15,
              ),
              ButtonSample(
                text: "Sign Up",
                onPress: () {
                  register();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
