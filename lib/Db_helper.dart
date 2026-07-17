import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart'; // ১. এটি ইমপোর্ট করতে হবে
import 'package:sqflite/sqflite.dart'; // ২. এটি ইমপোর্ট করতে হবে

class DbHelper {
  // প্রাইভেট কনস্ট্রাক্টর
  DbHelper._();

  // সিঙ্গেলটন ইন্সট্যান্স
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
    // ডাটাবেজের একটি সঠিক নাম দিন এক্সটেনশনসহ (যেমন: user_db.db)
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

  // Fetch Data (মেথডের নাম ছোট হাতের অক্ষরে পরিবর্তন করা হয়েছে)
  Future<List<Map<String, dynamic>>> fetchAllNotes() async {
    var db = await getDb();
    List<Map<String, dynamic>> mData = await db.query(TABLE_NAME, orderBy: "$COLUMN_ID DESC");
    return mData;
  }

  // Update Data (whereArgs ব্যবহার করে সুরক্ষিত করা হয়েছে)
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
      where: "$COLUMN_ID = ?", // সরাসরি $id না বসিয়ে '?' দেওয়া নিরাপদ
      whereArgs: [id],
    );
    return rowsEffected > 0;
  }

  // Delete Data
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