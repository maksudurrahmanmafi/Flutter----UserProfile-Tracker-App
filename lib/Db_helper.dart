import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  DbHelper._();

  static final DbHelper getInstance = DbHelper._();

  static const String TABLE_NAME = 'user';
  static const String COLUMN_ID = 'id';
  static const String COLUMN_USER_NAME = 'name';
  static const String COLUMN_EMAIL = 'email';
  static const String COLUMN_ADDRESS = 'address';

  Database? myDb;

  Future<Database> getDb() async {
    myDb = myDb ?? await openDb();
    return myDb!;
  }

  Future<Database> openDb() async {
    Directory appDir = await getApplicationDocumentsDirectory();
    String dbpath = join(appDir.path, "user_db.db");

    return await openDatabase(
      dbpath,
      version: 1,
      onCreate: (db, version) {
        db.execute(
          "CREATE TABLE $TABLE_NAME ($COLUMN_ID INTEGER PRIMARY KEY AUTOINCREMENT, $COLUMN_USER_NAME TEXT, $COLUMN_EMAIL TEXT, $COLUMN_ADDRESS TEXT)",
        );
      },
    );
  }

  // Insert Data
  Future<bool> addNote({
    required String mName,
    required String mEmail,
    required String mAddress,
  }) async {
    var db = await getDb();
    int rowsEffected = await db.insert(TABLE_NAME, {
      COLUMN_USER_NAME: mName,
      COLUMN_EMAIL: mEmail,
      COLUMN_ADDRESS: mAddress,
    });
    return rowsEffected > 0;
  }

  Future<List<Map<String, dynamic>>> fetchAllNotes() async {
    var db = await getDb();
    List<Map<String, dynamic>> mData = await db.query(TABLE_NAME, orderBy: "$COLUMN_ID DESC");
    return mData;
  }

  Future<bool> updateData({
    required String mName,
    required String mEmail,
    required String mAddress,
    required int id,
  }) async {
    var db = await getDb();
    int rowsEffected = await db.update(
      TABLE_NAME,
      {
        COLUMN_USER_NAME: mName,
        COLUMN_EMAIL: mEmail,
        COLUMN_ADDRESS: mAddress,
      },
      where: "$COLUMN_ID = ?",
      whereArgs: [id],
    );
    return rowsEffected > 0;
  }

  Future<bool> deleteData({required int id}) async {
    var db = await getDb();
    int rowsEffected = await db.delete(
      TABLE_NAME,
      where: "$COLUMN_ID = ?",
      whereArgs: [id],
    );
    return rowsEffected > 0;
  }
}