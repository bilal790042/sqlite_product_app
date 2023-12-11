import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final _databaseName = "ProductDatabase.db";
  static final _databaseVersion = 1;

  static final table = 'products';

  static final columnId = 'id';
  static final columnName = 'name';
  static final columnPrice = 'price';

  // make this a singleton class
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY,
            $columnName TEXT NOT NULL,
            $columnPrice REAL NOT NULL
          )
          ''');
  }

  // Helper methods

  Future<int> insert(Product product) async {
    Database db = await instance.database;
    return await db.insert(table, product.toMap());
  }

  Future<List<Product>> queryAllProducts() async {
    Database db = await instance.database;
    var result = await db.query(table);
    return result.map((map) => Product.fromMap(map)).toList();
  }

  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }
}
