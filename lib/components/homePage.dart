import 'package:battery_system_app/components/dashboard.dart';
import 'package:battery_system_app/components/signIn.dart';
import 'package:battery_system_app/components/signUp.dart';
import 'package:flutter/material.dart';
import 'package:battery_system_app/components/home.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  String page = 'SignIn';
  void onClickButton(String text) {
    print(text);
    setState(() {
      page = text;
    });
  }

  @override
  Widget build(context) {
    Widget currentPage = Home(
      onClick: onClickButton,
    );

    if (page == 'SignIn') {
      currentPage = SignIn(
        onSubmit: onClickButton,
        register: onClickButton,
      );
    } else if (page == 'SignUp') {
      currentPage = SignUp(
        onSubmit: onClickButton,
      );
    } else if (page == 'DashBoard') {
      currentPage = DashBoard(
        onOut: onClickButton,
      );
    }
    return MaterialApp(
      home: Scaffold(
        body: Container(
          // decoration: const BoxDecoration(
          //   gradient: LinearGradient(
          //     colors: [
          //       Color.fromARGB(255, 5, 157, 83),
          //       Color.fromARGB(255, 9, 206, 121),
          //     ],
          //     begin: Alignment.topLeft,
          //     end: Alignment.bottomRight,
          //   ),
          // ),
          child: currentPage,
        ),
      ),
    );
  }
}
