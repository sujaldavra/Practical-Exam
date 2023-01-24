import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  Database? db;

  Future<Database> checkDatabase() async {
    if (db != null) {
      return db!;
    } else {
      return await createDatabase();
    }
  }

  Future<Database> createDatabase() async {
    Directory folder = await getApplicationDocumentsDirectory();
    String path = join(folder.path, "DatabaseApp.db");
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        String query =
            "CREATE TABLE quotes(id INTEGER PRIMARY KEY AUTOINCREMENT,name TEXT,addName TEXT)";
        db.execute(query);
      },
    );
  }

  void insertData(String n1, String q1) async {
    db = await checkDatabase();
    print(n1);
    print(q1);
    db!.insert(
      "quotes",
      {"name": n1, "addName": q1},
    );
  }

  Future<List<Map>> readData() async {
    db = await checkDatabase();
    String query = "SELECT * FROM quotes";
    List<Map> quotesList = await db!.rawQuery(query, null);
    return quotesList;
  }

  void deleteData(String id) async {
    db = await checkDatabase();
    db!.delete("quotes", where: "id = ?", whereArgs: [int.parse(id)]);
  }

  void updateData(String id, String n1, String q1) async {
    db = await checkDatabase();
    db!.update("quotes", {"name": n1, "addName": q1},
        where: "id = ?", whereArgs: [int.parse(id)]);
  }
}
