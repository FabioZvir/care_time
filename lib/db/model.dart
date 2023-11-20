import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:sqfentity/sqfentity.dart';
import 'package:sqfentity_gen/sqfentity_gen.dart';
import 'package:http/http.dart' as http;

part 'model.g.dart';

const SqfEntityTable pessoa = SqfEntityTable(
    tableName: 'pessoa',
    primaryKeyName: 'id',
    useSoftDeleting: false,
    primaryKeyType: PrimaryKeyType.integer_auto_incremental,
    fields: [
      SqfEntityField('nome', DbType.text), //Title of todo item
      SqfEntityField('sobrenome', DbType.text),
      SqfEntityField('idade', DbType.real),
      SqfEntityField('peso', DbType.real),
      SqfEntityField('altura', DbType.real),
      SqfEntityField('genero', DbType.text),
    ]);

const seqIdentity = SqfEntitySequence(
    sequenceName: 'identity', maxValue: 9007199254740991, cycle: false);

@SqfEntityBuilder(myDbModel)
const myDbModel = SqfEntityModel(
  modelName: 'AppDatabase',
  databaseName: 'AppDatabase.db',
  sequences: [seqIdentity],
  bundledDatabasePath: null,
  databaseTables: [pessoa],
);
