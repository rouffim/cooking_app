import 'package:cool_cooker/core/model/app_sorting.dart';
import 'package:cool_cooker/core/persistence/api/sql_lite_persistence.dart';
import 'package:cool_cooker/utils/number_utils.dart';
import 'package:cool_cooker/utils/string_utils.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SqlLitePersistenceImpl extends SqlLitePersistence {
  Database _db;

  @override
  Future<Map<String, dynamic>> selectById(String tableName, int id) async {
    Database db = await database();

    List<Map<String, dynamic>> maps = await db.query(
        tableName,
        where: "id = ?",
        whereArgs: [id]);
    if (maps.length > 0) {
      return Map.of(maps.first);
    }
    return null;
  }

  @override
  Future<Map<String, dynamic>> selectByUuid(String tableName, String uuid) async {
    Database db = await database();

    List<Map<String, dynamic>> maps = await db.query(
        tableName,
        where: "uuid = ?",
        whereArgs: [uuid]);
    if (maps.length > 0) {
      return maps.first;
    }
    return null;
  }

  @override
  Future<List<Map<String, dynamic>>> selectAllByName(String tableName, String term, [int from, int to, SortEnum sort]) async {
    Database db = await database();

    List<Map<String, dynamic>> maps = await db.query(
        tableName,
        where: "name LIKE ?",
        whereArgs: ['%$term%'],
        orderBy: getOrderBy(sort),
        limit: getLimit(from, to),
        offset: getOffset(from, to),
    );
    if (maps.length > 0) {
      return maps.toList();
    }
    return new List();
  }

  @override
  Future<List<Map<String, dynamic>>> selectAll(String tableName, {int from, int to, SortEnum sort, int fkId, String fkKey}) async {
    Database db = await database();
    bool isFk = fkId != null && StringUtils.isNotBlank(fkKey);

    List<Map<String, dynamic>> maps = await db.query(
        tableName,
        where: isFk ? "$fkKey = ?" : null,
        whereArgs: isFk ? [fkId] : null,
        orderBy: getOrderBy(sort),
        limit: getLimit(from, to),
        offset: getOffset(from, to),
    );
    if (maps.length > 0) {
      return maps.toList();
    }
    return new List();
  }

  @override
  Future<int> save(String tableName, Map<String, dynamic> record) async {
    Map existing = await selectByUuid(tableName, record['uuid']);

    if(existing == null) {
      return insert(tableName, record);
    }

    record['id'] = existing['id'];
    return update(tableName, record);
  }

  @override
  Future<void> delete(String tableName, String uuid) async {
    Database db = await database();
    
    await db.delete(
      tableName,
      where: "uuid = ?",
      whereArgs: [uuid],
    );
  }

  @override
  Future<void> deleteAll(String tableName) async {
    Database db = await database();

    await db.delete(
      tableName
    );
  }


  Future<int> insert(String tableName, Map<String, dynamic> record) async {
    Database db = await database();

    return db.insert(
      tableName,
      record,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> update(String tableName, Map<String, dynamic> record) async {
    Database db = await database();

    await db.update(
      tableName,
      record,
      where: "id = ?",
      whereArgs: [record['id']]
    );

    return record['id'];
  }

  @override
  Future<Database> database() async {
    if(_db == null) {
      _db = await openDatabase(
        // Set the path to the database. Note: Using the `join` function from the
        // `path` package is best practice to ensure the path is correctly
        // constructed for each platform.
        join(await getDatabasesPath(), 'coolcooking_database.db'),

        onConfigure: (db) async {
          await db.execute('PRAGMA foreign_keys = ON');
        },

        onCreate: (db, version) async {
          // Run the CREATE TABLE statement on the database.
          await db.execute(
            "CREATE TABLE recipe("
                "id INTEGER PRIMARY KEY, "
                "uuid TEXT, "
                "creation_date TEXT, "
                "last_modification_date TEXT, "
                "name TEXT, "
                "last_viewed_date TEXT, "
                "views INTEGER, "
                "is_favorite INTEGER, "
                "url TEXT, "
                "nb_persons INTEGER"
            ")");
          await db.execute(
            "CREATE TABLE ingredient("
                "id INTEGER PRIMARY KEY, "
                "uuid TEXT, "
                "creation_date TEXT, "
                "last_modification_date TEXT, "
                "name TEXT, "
                "checked INTEGER, "
                "quantity NUMERIC, "
                "max_quantity NUMERIC, "
                "quantity_unite TEXT, "
                "recipe_id INTEGER REFERENCES recipe(id) ON DELETE CASCADE"
            ")");
          await db.execute(
            "CREATE TABLE instruction("
                "id INTEGER PRIMARY KEY, "
                "uuid TEXT, "
                "creation_date TEXT, "
                "last_modification_date TEXT, "
                "name TEXT, "
                "checked INTEGER, "
                "instruction_order INTEGER, "
                "recipe_id INTEGER REFERENCES recipe(id) ON DELETE CASCADE"
            ")");
          await db.execute(
            "CREATE TABLE shopping_list("
                "id INTEGER PRIMARY KEY, "
                "uuid TEXT, "
                "creation_date TEXT, "
                "last_modification_date TEXT, "
                "name TEXT, "
                "last_viewed_date TEXT, "
                "views INTEGER, "
                "is_favorite INTEGER"
            ")");
          await db.execute(
            "CREATE TABLE shopping_item("
                "id INTEGER PRIMARY KEY, "
                "uuid TEXT, "
                "creation_date TEXT, "
                "last_modification_date TEXT, "
                "checked INTEGER, "
                "list_id INTEGER REFERENCES shopping_list(id) ON DELETE CASCADE, "
                "ingredient_id INTEGER REFERENCES ingredient(id) ON DELETE CASCADE"
                ")");
          await db.execute(
            "CREATE TABLE shopping_recipe("
                "id INTEGER PRIMARY KEY, "
                "uuid TEXT, "
                "creation_date TEXT, "
                "last_modification_date TEXT, "
                "list_id INTEGER REFERENCES shopping_list(id) ON DELETE CASCADE, "
                "recipe_id INTEGER REFERENCES recipe(id) ON DELETE CASCADE"
            ")");
        },
        // Set the version. This executes the onCreate function and provides a
        // path to perform database upgrades and downgrades.
        version: 1,
      );
    }

    return _db;
  }

  String getOrderBy(SortEnum sort) {
    if(sort != null) {
      return SortUtils.enumToKey(sort) + ' ' + (SortUtils.isEnumAsc(sort) ? 'asc' : 'desc');
    }
    return null;
  }

  int getLimit(int from, int to) {
    return NumberUtils.checkLimitsNotNull(from, to) ? to - from : null;
  }

  int getOffset(int from, int to) {
    return NumberUtils.checkLimitsNotNull(from, to) ? from : null;
  }
}
