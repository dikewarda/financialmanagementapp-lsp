import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:financialmanagement_app/models/user.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'financialmanagement.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<String> exportDatabase() async {
    Directory? externalDir = await getExternalStorageDirectory();
    if (externalDir == null) {
      throw FileSystemException("External storage directory not found");
    }

    String backupDirPath = join(externalDir.path, 'FinancialmanagementBackup');

    if (!(await Directory(backupDirPath).exists())) {
      await Directory(backupDirPath).create(recursive: true);
    }

    String databasePath = join(await getDatabasesPath(), 'financialmanagemen.db');

    String backupPath = join(backupDirPath, 'financialmanagement_backup.db');
    File databaseFile = File(databasePath);

    if (databaseFile.existsSync()) {
      databaseFile.copySync(backupPath);
      return backupPath;
    } else {
      throw FileSystemException("Database file not found");
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        username TEXT,
        password TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE transaksi(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        type TEXT,
        amount REAL,
        date TEXT,
        description TEXT
      )
    ''');
  }

  Future<int> insertUser(User user) async {
    Database db = await instance.database;
    return await db.insert('users', user.toMap());
  }

  Future<User?> getUserByUsername(String username) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> users = await db.query('users',
        where: 'username = ?', whereArgs: [username], limit: 1);

    if (users.isNotEmpty) {
      return User.fromMap(users.first);
    } else {
      return null;
    }
  }

  Future<int> updateUser(User user) async {
    Database db = await instance.database;
    return await db
        .update('users', user.toMap(), where: 'id = ?', whereArgs: [user.id]);
  }

  Future<int> insertPemasukan(
      String date, double amount, String description) async {
    Database db = await instance.database;
    Map<String, dynamic> row = {
      'type': 'pemasukan',
      'amount': amount,
      'date': date,
      'description': description,
    };
    return await db.insert('transaksi', row);
  }

  Future<int> insertPengeluaran(
      String date, double amount, String description) async {
    Database db = await instance.database;
    Map<String, dynamic> row = {
      'type': 'pengeluaran',
      'amount': amount,
      'date': date,
      'description': description,
    };
    return await db.insert('transaksi', row);
  }

  Future<List<Map<String, dynamic>>> queryAllTransaksi() async {
    Database db = await instance.database;
    return await db.query('transaksi');
  }

  Future<double?> getTotalPemasukan() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> amount = await db.query('transaksi',
        where: 'type = ?', whereArgs: ['pemasukan'], columns: ['amount']);
    if (amount.isNotEmpty) {
      double totalPemasukan = 0;
      for (int i = 0; i < amount.length; i++) {
        totalPemasukan += amount[i]['amount'];
      }
      return totalPemasukan;
    } else {
      return null;
    }
  }

  Future<double?> getTotalPengeluaran() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> amount = await db.query('transaksi',
        where: 'type = ?', whereArgs: ['pengeluaran'], columns: ['amount']);
    if (amount.isNotEmpty) {
      double totalPengeluaran = 0;
      for (int i = 0; i < amount.length; i++) {
        totalPengeluaran += amount[i]['amount'];
      }
      return totalPengeluaran;
    } else {
      return null;
    }
  }
}
