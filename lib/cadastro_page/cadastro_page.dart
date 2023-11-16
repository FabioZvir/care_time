import 'package:flutter/material.dart';

class CadastrOpage extends StatefulWidget {
  const CadastrOpage({Key? key}) : super(key: key);

  @override
  State<CadastrOpage> createState() => _CadastrOpageState();
}

class _CadastrOpageState extends State<CadastrOpage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Builder(builder: (context) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 40),
            child: TextFormField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(12),
                    ),
                  ),
                  hintText: "Primeiro Nome",
                  hintStyle: TextStyle(color: Color.fromRGBO(0, 0, 0, 0.5))),
            ),
          );
        })
      ],
    );
  }
}
