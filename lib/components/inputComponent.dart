import 'package:flutter/material.dart';

class InputComponent extends StatelessWidget {
  const InputComponent(
    this.obscureText, {
    super.key,
    required this.text,
    required this.textEC,
  });

  final String text;
  final TextEditingController textEC;
  final obscureText;

  @override
  Widget build(context) {
    bool hasFocus = false;
    return Center(
      child: Column(
        children: [
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          //   child: Align(
          //     alignment: Alignment.topLeft,
          //     child: Text(
          //       text,
          //       textAlign: TextAlign.left,
          //       style: const TextStyle(
          //         color: Colors.white,
          //         fontSize: 20,
          //         fontWeight: FontWeight.w500,
          //       ),
          //     ),
          //   ),
          // ),
          SizedBox(
            height: 60,
            width: 300,
            child: TextField(
              obscureText: obscureText,
              controller: textEC,
              cursorHeight: 25,
              decoration: InputDecoration(
                // ignore: dead_code
                hintText: (hasFocus) ? text : null,
                hintStyle: const TextStyle(
                  color: Color.fromARGB(255, 3, 70, 2),
                ), // Placeholder text
                border: const OutlineInputBorder(
                    // Set circular border radius here
                    ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(
                      color: Color.fromRGBO(
                          212, 239, 210, 1)), // Border color when enabled
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: const BorderSide(
                      color: Color.fromARGB(
                          255, 4, 98, 2)), // Border color when focused
                ),
                filled: true,
                fillColor: const Color.fromARGB(255, 250, 248, 248),
                label: Text(
                  text,
                  style: const TextStyle(
                    color: Color.fromARGB(255, 4, 98, 2),
                    fontSize: 20,
                  ),
                ),
                labelText: null,

                // Border decoration
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}
