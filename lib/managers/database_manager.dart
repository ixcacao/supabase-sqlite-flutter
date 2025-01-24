import 'package:sample_premium_database_switch_supabase_sqlite/database_implementations/sqlite.dart';
import 'package:sample_premium_database_switch_supabase_sqlite/database_implementations/supabase.dart';

import 'database_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DatabaseManager {
  static final DatabaseManager _instance = DatabaseManager._internal();

  late SupabaseDB supabaseDB;
  late SQLiteDB sqliteDB;
  late DatabaseService activeDB;

  /// Private constructor
  DatabaseManager._internal();

  /// Factory constructor to access the singleton instance
  factory DatabaseManager() {
    return _instance;
  }

  Future<void> initialize(bool isPremium) async {
    print("Initializing DatabaseManager");
    ///create supabase and sqlite database service instances
    ///set activeDB to correct value. Initialize chosen database

    sqliteDB = SQLiteDB();
    supabaseDB = SupabaseDB();
    if(isPremium){
      activeDB = supabaseDB;
      ///initialize supabase

    } else {
      activeDB = sqliteDB;

    }
    await activeDB.initialize();


  }



  ///only done once, when switch is done. Afterwards, it's just a matter of setting
  ///the activeDB. I think.
  void switchToOnline() async {
    print("Switching to online DB---------------------");

    ///initialize supabase stuff
    await supabaseDB.initialize();

    ///sign in to get user_id
    final response = await supabaseDB.supabase.auth.signInAnonymously();

    //TODO:: wrap in try block

    final userId = response.user?.id;

    print("user_id: $userId");


    ///change money's table user id to uuid
    await sqliteDB.db.rawUpdate('UPDATE money SET user_id = ?', [userId]);

    ///retrieve data
    List<Map<String, dynamic>> result = await sqliteDB.db.rawQuery('SELECT * FROM money');


    ///insert data into supabase
    for (var row in result) {
      await supabaseDB.supabase.from('money').insert(row);
    }

    ///change active db from sqlite to supabase
    activeDB = supabaseDB;

  }

  void switchToOffline() async {
    ///TODO::: need bang i-initialize tong sqliteDB?
    print("Switching to offline DB---------------------");

    ///retrieve supabase data
    final data = await supabaseDB.supabase
        .from('money')
        .select();
    ///delete sqlite table contents
    await sqliteDB.db.delete('money');

    ///insert all retrieved data to sqlite
    for (var item in data) {
      await sqliteDB.db.insert('money', item);
    }

    ///delete supabase rows
    await supabaseDB.supabase
        .from('money')
        .delete()
        .match({});
    /// set activeDB to sqlite
    activeDB = sqliteDB;

    ///TODO:: there should be a delete data from supabase
  }


  ///idk what the point of these are but it feels right
  Future<List<Map<String, dynamic>>> queryAll(String tableName) async {
    return activeDB.queryAll(tableName);
  }
  Future<void> update(String tableName, map) async {
    activeDB.update(tableName, map);
  }
  Future<void> insert(String tableName, map) async {
    activeDB.insert(tableName, map);
  }


}