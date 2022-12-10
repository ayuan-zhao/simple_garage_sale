import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/citem.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();
  static Database? _database;
  DatabaseService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('citems.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    // const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    // const textType = 'TEXT NOT NULL';
    // const boolType = 'BOOLEAN NOT NULL';
    // const integerType = 'INTEGER NOT NULL';

    await db.execute('''
CREATE TABLE citems ( 
  _id INTEGER PRIMARY KEY AUTOINCREMENT, 
  isImportant BOOLEAN NOT NULL,
  number INTEGER NOT NULL,
  title TEXT NOT NULL,
  description NOT NULL,
  time NOT NULL
  )
''');
  }

  Future<CommodityItem> create(CommodityItem cItem) async {
    final db = await instance.database;
    final id = await db.insert(itemTable, cItem.toJson());
    return cItem.copy(id: id);
  }

  Future<CommodityItem> readItem({required int id}) async {
    final db = await instance.database;

    final maps = await db.query(
      itemTable,
      columns: ItemFields.values,
      where: '${ItemFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return CommodityItem.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  Future<List<CommodityItem>> readAllItems() async {
    final db = await instance.database;
    const orderBy = '${ItemFields.time} ASC';
    final result = await db.query(itemTable, orderBy: orderBy);

    return result.map((json) => CommodityItem.fromJson(json)).toList();
  }

  Future<int> update({required CommodityItem cItem}) async {
    final db = await instance.database;

    return db.update(
      itemTable,
      cItem.toJson(),
      where: '${ItemFields.id} = ?',
      whereArgs: [cItem.id],
    );
  }

  Future<int> delete({required int id}) async {
    final db = await instance.database;

    return await db.delete(
      itemTable,
      where: '${ItemFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
