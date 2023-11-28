class Pessoa {
  final int? id;
  final String nome;
  final String sobrenome;
  final int idade;
  final double peso;
  final double altura;
  final String genero;

  const Pessoa(
      {this.id,
      required this.nome,
      required this.sobrenome,
      required this.idade,
      required this.peso,
      required this.altura,
      required this.genero});

  factory Pessoa.fromJson(Map<String, dynamic> json) => Pessoa(
        id: json['id'],
        nome: json['nome'],
        sobrenome: json['sobrenome'],
        idade: json['idade'],
        peso: json['peso'],
        altura: json['altura'],
        genero: json['genero'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'nome': nome,
        'sobrenome': sobrenome,
        'idade': idade,
        'peso': peso,
        'altura': altura,
        'genero': genero,
      };
}
