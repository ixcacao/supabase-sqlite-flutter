
abstract class DatabaseService
{
  ///should only be initialized once every app open
  Future<void> initialize();


  Future<List<Map<String, dynamic>>> queryAll(String tableName);
  Future<void> update(String tableName, map);
  Future<void> insert(String tableName, map);


  ///TODO:: implement
  ///Future<void> delete(String tableName, object);
  ///Future<void> rawQuery(String tableName, map);?
}

abstract class OnlineDatabaseService extends DatabaseService {
  late final db;
}