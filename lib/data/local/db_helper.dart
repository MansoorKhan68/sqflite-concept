// ignore_for_file: constant_identifier_names

import 'dart:io';
import 'dart:ui';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  // this constructor is being private,
  // we can not create multiple instance of the class in the case of database
  DBHelper._();
  // create a static function to to create a single instance of the class
  // when use the object again and again but same object
  // we can access this in other file like the given approach
  // DBHelper db = DBHelper.getInstance();
  // we will use only the name of the class not the constructor to create the instance as shown in above approach

  // static DBHelper getInstance(){
  //   return DBHelper._();

  // }
  static final DBHelper getInstance = DBHelper._();
  // TABLE NOTE VARIABLES
  static const String TABLE_NOTE = "note";
  static const String COLUMN_NOTE_SNO = "s_no";
  static const String COLUMN_NOTE_TITLE = "title";
  static const String COLUMN_NOTE_DESC = "desc";

// db instance using sqflite package
  Database?
      myDb; // used to open one time db and use in multiple places without reopening
// Database getDb(){

// }
  // in the above the term Database in getDb is used as a db refrence
  //
  Future<Database> getDb() async {
    // ?? mean if it is null
    myDb ??= await openDb();
    return myDb!;
    // if (myDb != null) {
    //   return myDb!; // ! shows it must not null
    // } else {
    // myDb = await openDb();
    //   await openDb();
    // }
  }
   

// two packages are use
// path_provider is used to get the derictory path
// Path is used to to perform different operations on path like joining,splitting etc
  Future<Database> openDb() async {
    // this function will do two things
    // -> 1 open db if already exist
    // -> create db if not exist already

    Directory appDir = await getApplicationDocumentsDirectory();

    // create the path
    // and join them using PATH PACKAGE JOIN
    String dbPath = join(appDir.path, "noteDb.db");
    // open databse
    // the given functions come form sqflite package
    return await openDatabase(dbPath, onCreate: (db, version) {
      // create all tables for db
      db.execute(
          "create table $TABLE_NOTE($COLUMN_NOTE_SNO integer primary key autoincrement, $COLUMN_NOTE_TITLE text, $COLUMN_NOTE_DESC text)");
    }, version: 1);
  }

// all queries here
/// INSERTION

Future<bool> addNote({required String myTitle, required String myDesc}) async {
  var db = await getDb();
  int rowsEffected = await db.insert(TABLE_NOTE, {
    COLUMN_NOTE_TITLE : myTitle,
    COLUMN_NOTE_DESC : myDesc
  });
  return rowsEffected>0;
}

// READING ALL DATA
Future<List<Map<String , dynamic>>> getAllNotes() async {
  var db = await getDb();
  // the  data in table is stored in List,
  // while the in a row data is stored in MAP
  // selet * from note
 List<Map<String, dynamic>> myData = await db.query(TABLE_NOTE);

 return myData;
}

}
