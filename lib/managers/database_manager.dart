import 'package:sample_premium_database_switch_supabase_sqlite/database_implementations/sqlite.dart';
import 'package:sample_premium_database_switch_supabase_sqlite/database_implementations/supabase.dart';

import 'database_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class DatabaseManager {
  late SupabaseDB supabaseDB;
  late SQLiteDB sqliteDB;
  late DatabaseService activeDB;


  ///only done once, when switch is done. Afterwards, it's just a matter of setting
  ///the activeDB. I think.
  void switchToOnline() async {
    ///initialize supabase stuff

    ///sign in to get user_id
    final response = await supabaseDB.supabase.auth.signInAnonymously();

    ///if may error, throw exception
    if(response.error != null){
      throw Exception(
        'error w anonymous sign in: ${response.error?.message}'
      );
    }

    final userId = response.user?.id;


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
    ///ottoke...
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

    ///TODO:: there should be a delete data from
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

  DatabaseManager(bool isPremium){
    ///create supabase and sqlite database service instances
    ///set activeDB to correct value. Initialize chosen database

    if(isPremium){
      activeDB = supabaseDB;
      ///initialize supabase

    } else {
      activeDB = sqliteDB;

    }

    activeDB.initialize();

  }
}