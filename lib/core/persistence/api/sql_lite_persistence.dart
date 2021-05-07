import 'package:cool_cooker/core/model/app_sorting.dart';
import 'package:sqflite/sqflite.dart';

abstract class SqlLitePersistence {
  Future<Database> database();
  Future<Map<String, dynamic>> selectById(String tableName, int id);
  Future<Map<String, dynamic>> selectByUuid(String tableName, String uuid);
  Future<List<Map<String, dynamic>>> selectAllByName(String tableName, String term, [int from, int to, SortEnum sort]);
  Future<List<Map<String, dynamic>>> selectAll(String tableName, {int from, int to, SortEnum sort, int fkId, String fkKey});
  Future<int> save(String tableName, Map<String, dynamic> record);
  Future<void> delete(String tableName, String uuid);
  Future<void> deleteAll(String tableName);
}