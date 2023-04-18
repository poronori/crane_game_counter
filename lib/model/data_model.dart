import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DataModel {
  final int? id;
  final String text;

  DataModel({
    this.id,
    required this.text
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
    };
  }


  // データベース接続
  static Future<Database> get database async {
    final Future<Database> database = openDatabase(
      join(await getDatabasesPath(), 'sale_database.db'),
      onCreate: (db, version) {
        return db.execute(
          // テーブル作成
          "CREATE TABLE sales(id INTEGER PRIMARY KEY AUTOINCREMENT, text TEXT)",
        );
      },
      version: 1,
    );
    return database;
  }

  // 挿入
  static Future<void> insertData(DataModel data) async {

    final Database db = await database;
    await db.insert(
      'sales',
      data.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // 取得
  static Future<List<DataModel>> getData() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query('sales');
    return List.generate(maps.length, (i) {
      return DataModel(
        id: maps[i]['id'],
        text: maps[i]['text'],
      );
    });
  }

  // 更新
  static Future<void> updateData(DataModel data) async {
    final db = await database;
    await db.update(
      'sales',
      data.toMap(),
      where: "id = ?",
      whereArgs: [data.id],
      conflictAlgorithm: ConflictAlgorithm.fail,
    );
  }

  // 削除
  static Future<void> deleteData(int id) async {
    final db = await database;
    await db.delete(
      'sales',
      where: "id = ?",
      whereArgs: [id],
    );
  }
}