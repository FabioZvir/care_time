import 'package:flutter/material.dart';

class InputForm extends StatelessWidget {
  final String? text;
  const InputForm({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      child: TextFormField(
        decoration: InputDecoration(
            enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10),
              ),
              borderSide: BorderSide(
                color: Color.fromARGB(116, 0, 0, 1),
                width: 2,
              ),
            ),
            disabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(12),
              ),
              borderSide: BorderSide(
                color: Color.fromARGB(116, 0, 0, 1),
                width: 2,
              ),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(12),
              ),
              borderSide: BorderSide(
                color: Color.fromARGB(193, 0, 0, 1),
                width: 2,
              ),
            ),
            hintText: text,
            hintStyle: const TextStyle(color: Color.fromRGBO(0, 0, 0, 0.5))),
      ),
    );
  }
}
