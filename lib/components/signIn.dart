import 'package:flutter/material.dart';
import 'package:battery_system_app/components/button.dart';
import 'package:battery_system_app/components/inputComponent.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignIn extends StatelessWidget {
  const SignIn({super.key, required this.onSubmit, required this.register});

  final Function(String) onSubmit;
  final Function(String) register;

  void setData() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    // Collection reference
    CollectionReference users = firestore.collection('users');

    // Set data to document
    await users.doc('emps').set({
      'name': 'Simran Nadaf',
      'age': 22,
      // Add more fields as needed
    }).then((value) {
      print('Data set successfully');
    }).catchError((error) {
      print('Failed to set data: $error');
    });
  }

  @override
  Widget build(context) {
    TextEditingController email = TextEditingController();
    TextEditingController pwd = TextEditingController();
    void getData() async {
      // setData();
      print(email.text);
      print(pwd.text);
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Get a reference to a specific document
      DocumentSnapshot documentSnapshot = await firestore
          .collection(
              'users') // Replace 'your_collection' with your collection name
          .doc(email.text) // Replace 'your_document_id' with your document ID
          .get();

      // Check if the document exists
      if (documentSnapshot.exists) {
        // Access data from the document
        var psw1 = documentSnapshot.get('password');
        if (psw1 == pwd.text) {
          var snackBar = const SnackBar(
            backgroundColor: Color.fromARGB(255, 17, 100, 19),
            content: Text(
              'You are Logged In Successfully!',
              style: TextStyle(color: Colors.white),
            ),
          );

          // Find the ScaffoldMessenger in the widget tree
          // and use it to show a SnackBar.
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setString('email', email.text);

          onSubmit('DashBoard');
        } else {
          var snackBar = const SnackBar(
            backgroundColor: Color.fromARGB(255, 187, 10, 10),
            content: Text(
              'Wrong Credential. Try Again!',
              style: TextStyle(color: Colors.white),
            ),
          );

          // Find the ScaffoldMessenger in the widget tree
          // and use it to show a SnackBar.
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      } else {
        var snackBar = const SnackBar(
          backgroundColor: Color.fromARGB(255, 187, 10, 10),
          content: Text(
            'Email ID Does Not Found. Try Again!',
            style: TextStyle(color: Colors.white),
          ),
        );

        // Find the ScaffoldMessenger in the widget tree
        // and use it to show a SnackBar.
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        print('Document does not exist');
      }
    }

    ;

    return Center(
      child: Container(
        margin: const EdgeInsets.all(40.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 190,
                child: Image.asset(
                  "assets/logo.png",
                  height: 120,
                  width: 120,
                ),
              ),
              const Text(
                "Welcome \n To \n Dynamic Battery System",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Color.fromARGB(255, 2, 77, 3),
                    fontSize: 20,
                    fontWeight: FontWeight.w900),
              ),
              const SizedBox(
                height: 35,
              ),
              const Text(
                "Log In",
                style: TextStyle(
                    color: Color.fromARGB(255, 2, 77, 3),
                    fontSize: 30,
                    fontWeight: FontWeight.w900),
              ),
              const SizedBox(
                height: 25,
              ),
              InputComponent(false, text: "Email", textEC: email),
              InputComponent(true, text: "Password", textEC: pwd),
              // InputComponent("", email, text: "Email"),
              // InputComponent("Enter Your Email", email, text: "Email"),
              // InputComponent("Enter Your PassWord", pwd, text: "Password"),
              const SizedBox(
                height: 25,
              ),
              ButtonSample(
                text: "Log In",
                onPress: () {
                  getData();
                },
              ),
              const SizedBox(
                height: 80,
              ),
              const Text(
                "don't have a account?",
                textAlign: TextAlign.center,
              ),
              TextButton(
                onPressed: () {
                  register("SignUp");
                },
                child: const Text(
                  "Create new one",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color.fromARGB(255, 2, 94, 5),
                    decoration: TextDecoration.underline,
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
