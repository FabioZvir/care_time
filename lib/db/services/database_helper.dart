import 'package:flutter_application_1/db/pessoa_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static const int _version = 1;
  static const String _dbName = "care_time.db";

  static Future<Database> _getDB() async {
    return openDatabase(
      join(await getDatabasesPath(), _dbName),
      onCreate: (db, version) async => await db.execute(
          "CREATE TABLE Pessoa(id INTEGER PRIMARY KEY, nome TEXT NOT NULL, sobrenome TEXT NOT NULL, idade INTEGER NOT NULL, peso REAL NOT NULL, altura REAL NOT NULL, genero TEXT NOT NULL);"),
      version: _version,
    );
  }

  static Future<int> addPessoa(Pessoa pessoa) async {
    final db = await _getDB();
    return await db.insert("Pessoa", pessoa.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> updatePessoa(Pessoa pessoa) async {
    final db = await _getDB();
    return await db.update("Pessoa", pessoa.toJson(),
        where: 'id = ?',
        whereArgs: [pessoa.id],
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  static Future<int> deletePessoa(Pessoa pessoa) async {
    final db = await _getDB();
    return await db.delete(
      "Pessoa",
      where: 'id = ?',
      whereArgs: [pessoa.id],
    );
  }

  static Future<List<Pessoa>?> getAllPessoa() async {
    final db = await _getDB();

    final List<Map<String, dynamic>> maps = await db.query("Pessoa");

    if (maps.isEmpty) {
      return null;
    }

    return List.generate(maps.length, (index) => Pessoa.fromJson(maps[index]));
  }
}
