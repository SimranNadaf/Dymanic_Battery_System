import 'package:flutter/material.dart';

class ButtonSample extends StatelessWidget {
  const ButtonSample({super.key, required this.text, required this.onPress});
  final String text;
  final void Function() onPress;
  @override
  Widget build(context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor:
            const MaterialStatePropertyAll(Color.fromARGB(255, 2, 62, 11)),
        foregroundColor:
            const MaterialStatePropertyAll(Color.fromARGB(255, 247, 249, 247)),
        padding: const MaterialStatePropertyAll(
          EdgeInsets.symmetric(vertical: 12, horizontal: 50),
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      onPressed: onPress,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
