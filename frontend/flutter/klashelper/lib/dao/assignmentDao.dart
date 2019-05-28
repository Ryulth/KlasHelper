import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'package:klashelper/models/assignment.dart';

class AssignmentDao {

  Database _database;
  String _tableName;
  Future<void> setDatabase(String tableName) async {
    _tableName = tableName;
    if (_database == null) {
      _database = await _setConnection();
      
    }
  }
  Future<Database> _setConnection() async {
    String databasesPath = await getDatabasesPath();
    String dbPath = join(databasesPath, 'klashelper.db');
    return await openDatabase(
      dbPath, version: 1,
      onCreate: _createTable
    );
  }
  Future<void> _createTable(Database db,int version) async{
    await db.execute("""
        CREATE TABLE IF NOT EXISTS $_tableName (
          workCode TEXT PRIMARY KEY,
          semester TEXT, 
          workFile TEXT, 
          workCourse TEXT, 
          isSubmit INTEGER, 
          workType TEXT, 
          workTitle TEXT, 
          workCreateTime TEXT, 
          workFinishTime TEXT, 
          workAlarmTime TEXT,
          isAlarm INTEGER, 
          flag INTEGER )
    """
    );
  }

  Future<void> insertAssignments(List<Assignment> assignments) async {
    final Database db =  this._database;
    for (final assignment in assignments) {
      String workCode = assignment.workCode;
      final List<Map<String,dynamic>> temp = await db.rawQuery("""SELECT isAlarm,workAlarmTime FROM $_tableName WHERE workCode = '$workCode';""");
      if(temp.length !=0){
      assignment.isAlarm = temp[0]['isAlarm'];
      assignment.workAlarmTime = temp[0]['workAlarmTime'];
      }
      db.insert(
        _tableName,
        assignment.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }
  Future<void> updateAssignment(Assignment assignment) async{
    final Database db = this._database;
    await db.update(
      _tableName,
        assignment.toJson(),
        where: "workCode = ?",
        whereArgs: [assignment.workCode],
    );
  }
  Future<void> updateAssignmentByWorkCode(Assignment assignment) async{
    final Database db = _database;
    await db.rawUpdate("""
      UPDATE $_tableName
      SET isAlarm = 
    """
    );
  }
  Future<List<Assignment>> getAllAssignment()async{
    final Database db = _database;
    final List<Map<String,dynamic>> maps = await db.query(_tableName);
    print(maps.toString());
    return List.generate(maps.length, (index){
      return Assignment.fromJson(maps[index]);
    });
  }
  Future<List<Assignment>> getAllAssignmentBySemesterCode(String semesterCode) async{
      final Database db = _database;
    await _createTable(db,1);
    final List<Map<String,dynamic>> maps = await db.rawQuery('SELECT * FROM $_tableName WHERE semester = \'$semesterCode\' ');
    print(maps.toString());
    return List.generate(maps.length, (index){
      return Assignment.fromJson(maps[index]);
    });
  }
}
