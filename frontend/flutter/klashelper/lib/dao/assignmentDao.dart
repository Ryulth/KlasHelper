import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:klashelper/models/assignment.dart';

class AssignmentDao {
 // AssignmentDao._();
//  static final AssignmentDao database = AssignmentDao._();
  Database database;
  String tableName;

  Future<bool> setConnection() async {
    String databasesPath = await getDatabasesPath();
    String dbPath = join(databasesPath, 'klashelper.db');
    this.database = await openDatabase(
      dbPath, version: 1,
    );
    print("setConnection");
    return true;
  }
  Future<bool> createTable() async {
    if(database ==null){
      await setConnection();
    }
    final Database db =  this.database;
    
    print(tableName);
    StringBuffer sb = new StringBuffer();
    sb.write(" CREATE TABLE IF NOT EXISTS ");
    sb.write(tableName);
    sb.write(" ( workCode TEXT PRIMARY KEY, ");
    sb.write(" semester TEXT, ");
    sb.write(" workFile TEXT, ");
    sb.write(" workCourse TEXT, ");
    sb.write(" isSubmit INTEGER, ");
    sb.write(" workType TEXT, ");
    sb.write(" workTitle TEXT, ");
    sb.write(" workCreateTime TEXT, ");
    sb.write(" workFinishTime TEXT, ");
    sb.write("isAlarm INTEGER, ");
    sb.write("flag INTEGER )");
    await db.execute(sb.toString());
    return true;
  }

  Future<void> insertAssignments(List<Assignment> assignments) async {
    final Database db =  this.database;

    for (final assignment in assignments) {
      db.insert(
        tableName,
        assignment.toJson(),
        conflictAlgorithm: ConflictAlgorithm.ignore,
      );
    }
  }
  Future<void> updateAssignment(Assignment assignment) async{
    final Database db = database;
    await db.update(
        tableName,
        assignment.toJson(),
        where: "workCode = ?",
        whereArgs: [assignment.workCode],
    );
  }

  Future<List<Assignment>> getAllAssignment()async{
    if(database ==null){
      await setConnection();
    }
    final Database db = database;
    final List<Map<String,dynamic>> maps = await db.query(tableName);
    return List.generate(maps.length, (index){
      return Assignment.fromJson(maps[index]);
    });
  }
}
