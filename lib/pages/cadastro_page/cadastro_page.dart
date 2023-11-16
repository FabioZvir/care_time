import 'package:flutter/material.dart';
import 'package:flutter_application_1/communs/input_form/input_form.dart';

class CadastrOpage extends StatefulWidget {
  const CadastrOpage({Key? key}) : super(key: key);

  @override
  State<CadastrOpage> createState() => _CadastrOpageState();
}

class _CadastrOpageState extends State<CadastrOpage> {
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return Column(
        children: const <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(40, 80, 40, 10),
            child: InputForm(
              text: "Nome",
            ),
          ),
          Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 40),
              child: InputForm(
                text: "Sobrenome",
              )),
        ],
      );
    });
  }
}
