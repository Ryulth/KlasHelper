import 'workType.dart';

class Assignment  { 
  String workCode;
  String workFile;
  String workCourse;
  int isSubmit;
  String workCreateTime;
  String workFinishTime;
  String semester;
  String workTitle;
  WorkType workType;

  Assignment({this.workCode,this.workFile,this.workCourse,
  this.isSubmit,this.workCreateTime,this.workFinishTime,
  this.semester,this.workTitle,this.workType});

  factory Assignment.fromJson(Map<String,dynamic> json){
    return Assignment(
      workCode : json['workCode'],
      workFile : json['workFile'],
      workCourse : json['workCourse'],
      isSubmit : json['isSubmit'],
      workCreateTime : json['workCreateTime'],
      workFinishTime : json['workFinishTime'],
      semester : json['semester'],
      workTitle : json['workTitle'],
      workType : WorkType.values.firstWhere((e) => e.toString() == 'WorkType.' + json['workType'])
    );
  }

  // Map toJson(){
  //   var map = new Map<String, dynamic>();
  //   map['id'] = id;
  //   map['pw'] = pw;

  //   return map;
  // }
}

/*
workCode
workFile
workCourse
isSubmit
workCreateTime
workFinishTime
semester
workTitle
workType
0 -> 과제
1 -> 인터넷 강의
2 -> 강의 자료만 올라와있는 경우
/*
Fruit f = Fruit.values.firstWhere((e) => e.toString() == 'Fruit.' + str);
*/
            */