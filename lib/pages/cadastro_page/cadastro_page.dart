import 'package:flutter/material.dart';
import 'package:flutter_application_1/communs/input_form/input_form.dart';

const List<String> list = <String>[
  'Gênero',
  'Masculino',
  'Feminino',
  'Prefiro não dizer'
];

class CadastrOpage extends StatefulWidget {
  const CadastrOpage({Key? key}) : super(key: key);

  @override
  State<CadastrOpage> createState() => _CadastrOpageState();
}

class _CadastrOpageState extends State<CadastrOpage> {
  String generoValor = list.first;
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return Column(
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.fromLTRB(40, 80, 40, 10),
            child: InputForm(
              text: "Nome",
              type: TextInputType.name,
            ),
          ),
          const Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 40),
              child: InputForm(
                text: "Sobrenome",
                type: TextInputType.name,
              )),
          const Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 40),
              child: InputForm(
                text: "Idade",
                type: TextInputType.number,
              )),
          const Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 40),
              child: InputForm(
                text: "Peso",
                type: TextInputType.number,
              )),
          const Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 40),
              child: InputForm(
                text: "Altura",
                type: TextInputType.number,
              )),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 40),
            child: DropdownButtonFormField(
              decoration: const InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                  borderSide: BorderSide(
                    color: Color.fromARGB(116, 0, 0, 1),
                    width: 2,
                  ),
                ),
                disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(12),
                  ),
                  borderSide: BorderSide(
                    color: Color.fromARGB(116, 0, 0, 1),
                    width: 2,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(12),
                  ),
                  borderSide: BorderSide(
                    color: Color.fromARGB(193, 0, 0, 1),
                    width: 2,
                  ),
                ),
              ),
              isExpanded: true,
              value: generoValor,
              onChanged: (String? value) {
                setState(() {
                  generoValor = value!;
                });
              },
              items: list.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ],
      );
    });
  }
}
