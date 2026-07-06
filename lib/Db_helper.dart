import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  // ১. প্রাইভেট কনস্ট্রাক্টর (যাতে বাইরে থেকে এই ক্লাসের অবজেক্ট তৈরি করা না যায়)
  DbHelper._();

  //static final ektdhoroner instane,, class er object create kora sarai access kora jai..singletone

  static final DbHelper getInstance = DbHelper._();

  static final TABLE_NAME = 'user';
  static final COLUMN_ID = 'id';
  static final COLUMN_USER_NAME = 'name';
  static final COLUMN_EMAIL = 'email';
  static final COLUMN_ADDRESS = 'address';

  // ৪. ডাটাবেজ অবজেক্ট হোল্ডার (শুরুতে এটি null থাকবে)
  Database? myDb;

  Future<Database> getDb() async {
    myDb = myDb ?? await openDb();
    return myDb!;
    /*if(myDb != null){
      return myDb!;
    }
    else{
      myDb = await openDb();
      return myDb!;
    }*/
  }

  Future<Database> openDb() async {
    // ফোনের ভেতরে অ্যাপের জন্য নিরাপদ ডিরেক্টরি বা ফোল্ডার খুঁজে বের করা
    Directory appDir = await getApplicationDocumentsDirectory();
    String dbpath = join(appDir.path, "user_db");
    // ডাটাবেজ ওপেন করা (প্রথমবার হলে onCreate রান হবে)
    return await openDatabase(
      dbpath,
      version: 1,
      onCreate: (db, version) {
        db.execute(
          "create table $TABLE_NAME ($COLUMN_ID integer primary key autoincrement,$COLUMN_USER_NAME text,$COLUMN_EMAIL text,$COLUMN_ADDRESS text)",
        );
      },
    );
  }

  //insert

  Future<bool> addNote({
    required String mName,
    required String mEmail,
    required String mAddress
  }) async {
    var db = await getDb();
    int rowsEffected = await db.insert(TABLE_NAME, {
      COLUMN_USER_NAME : mName,
      COLUMN_EMAIL : mEmail,
      COLUMN_ADDRESS :mAddress
    });
    return rowsEffected > 0;
  }

  //fetch data\

  Future<List<Map<String, dynamic>>> FetchAllNote() async {
    var db = await getDb();
    //select from note
    List<Map<String, dynamic>> mData = await db.query(TABLE_NAME,orderBy: "$COLUMN_ID DESC");
    return mData;
  }

  //update data
  Future<bool> updateData({
    required String mName,
    required String mEmail,
    required String mAddress,
    required int id,
  }) async {
    var db = await getDb();
    int rowsEffected = await db.update(TABLE_NAME, {
      COLUMN_USER_NAME : mName,
      COLUMN_EMAIL : mEmail,
      COLUMN_ADDRESS : mAddress,
    }, where: "$COLUMN_ID = $id");
    return rowsEffected > 0;
  }

  //delete data
  Future<bool> deleteData({required int id}) async {
    var db = await getDb();
    int rowseffect = await db.delete(
      TABLE_NAME,
      where: "$COLUMN_ID = ? ",
      whereArgs: [id],
    );
    return rowseffect > 0;
  }
}
