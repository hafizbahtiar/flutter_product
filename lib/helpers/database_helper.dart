import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  // Singleton instance
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  // Table names
  static const String productsTable = 'products';
  static const String companiesTable = 'companies';
  static const String categoriesTable = 'categories';

  // Database initialization
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    try {
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, 'flutter_product.db');

      return await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) async {
          await _enableForeignKeys(db);
          await _createTables(db);
        },
      );
    } catch (e) {
      throw Exception('Error initializing database: $e');
    }
  }

  // Enable foreign key constraints
  Future<void> _enableForeignKeys(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON;');
  }

  // Create tables
  Future<void> _createTables(Database db) async {
    await db.execute('''
      CREATE TABLE $productsTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        company_id INTEGER,
        category_id INTEGER,
        name TEXT NOT NULL,
        price REAL,
        description TEXT,
        barcode TEXT,
        FOREIGN KEY (company_id) REFERENCES $companiesTable (id) ON DELETE CASCADE
        FOREIGN KEY (category_id) REFERENCES $categoriesTable (id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE $companiesTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        parent_company_id INTEGER,
        name TEXT NOT NULL,
        description TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE $categoriesTable (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        parent_category_id INTEGER,
        title TEXT NOT NULL
      )
    ''');
  }

  // Insert into any table
  Future<int> insert(String table, Map<String, dynamic> data) async {
    try {
      final db = await database;
      return await db.insert(table, data, conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (e) {
      throw Exception('Insert Error: $e');
    }
  }

  // Retrieve all rows
  Future<List<Map<String, dynamic>>> getAll(String table) async {
    try {
      final db = await database;
      return await db.query(table);
    } catch (e) {
      throw Exception('Fetch All Error: $e');
    }
  }

  // Retrieve a single row by ID
  Future<Map<String, dynamic>?> getById(String table, int id) async {
    try {
      final db = await database;
      final result = await db.query(table, where: 'id = ?', whereArgs: [id]);
      return result.isNotEmpty ? result.first : null;
    } catch (e) {
      throw Exception('Fetch By ID Error: $e');
    }
  }

  // Update a row
  Future<int> update(String table, int id, Map<String, dynamic> data) async {
    try {
      final db = await database;
      return await db.update(table, data, where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      throw Exception('Update Error: $e');
    }
  }

  // Delete a row
  Future<int> delete(String table, int id) async {
    try {
      final db = await database;
      return await db.delete(table, where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      throw Exception('Delete Error: $e');
    }
  }

  // Close database
  Future<void> closeDatabase() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }
}
