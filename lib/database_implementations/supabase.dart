import 'package:sample_premium_database_switch_supabase_sqlite/managers/database_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../names.dart';

class SupabaseDB extends DatabaseService {
  String SUPABASE_URL = 'https://kafeetimewdxgemqsktx.supabase.co';
  String SUPABASE_ANON_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImthZmVldGltZXdkeGdlbXFza3R4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzc2NDA0MDEsImV4cCI6MjA1MzIxNjQwMX0.ESamwDyG6a17cXrdnDrOfxoWpA8-_i0W4kNCuWin3_A';

  late final supabase;

  @override
  Future<void> initialize() async {
    await Supabase.initialize(
      url: SUPABASE_URL,
      anonKey: SUPABASE_ANON_KEY,
    );
    supabase = Supabase.instance.client;

  }

  @override
  Future<void> insert(String tableName, map) async {
    // Insert a new row
    await supabase
        .from(tableName)
        .insert(map);
  }

  @override
  Future<List<Map<String, dynamic>>> queryAll(String tableName) async{
    final data = await supabase
        .from('countries')
        .select();

    return data;
  }

  @override
  Future<void> update(String tableName, map) async {
    await supabase
        .from(tableName)
        .update(map)
        .eq(columnId, map['id']);
  }
  
}