import 'package:sample_premium_database_switch_supabase_sqlite/managers/database_service.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../names.dart';

class SQLiteDB extends DatabaseService {
  late Database db;

  @override
  void initialize() async{
    ///create database, create tables, insert preliminary rows
    // Get a location using getDatabasesPath
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'database.db');


    db = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          await db.execute('''
          create table $money ( 
            $columnId integer primary key autoincrement, 
            $columnUserId text not null,
            $columnAmount integer not null)
          ''');

          await db.insert(money, {columnId: 1, columnUserId: 'eh', columnAmount: 0});

        });

    }

  @override
  Future<void> insert(String tableName, map) async {
    //TODO: wrap in a try block
    await db.insert(tableName, map);
  }

  @override
  ///List of json maps, where string is the column name
  Future<List<Map<String, dynamic>>> queryAll(String tableName) async {

    List<Map<String, dynamic>> all = await db.query(tableName);

    return all;
  }

  @override
  Future<void> update(String tableName, map) async {
    await db.update(tableName, map,
        ///ASSUMPTION: All tables will have a non null 'id' field that serves
        ///as their primary key
        where: '$columnId = ?', whereArgs: [map['id']]);
  }
  
}