import 'workType.dart';

class Assignment  { 
  String workCode;
  String workFile;
  String workCourse;
  int isSubmit;
  String workCreateTime;
  String workFinishTime;
  String workAlarmTime;
  String semester;
  String workTitle;
  WorkType workType;
  int isAlarm ;
  int flag ;

  Assignment({this.workCode,this.workFile,this.workCourse,
  this.isSubmit,this.workCreateTime,this.workFinishTime,this.workAlarmTime,
  this.semester,this.workTitle,this.workType,
  this.isAlarm,this.flag});

  factory Assignment.fromJson(Map<String,dynamic> json){
    String getDefaultAlarm(String tempFinishTime){
      if (tempFinishTime != "0") {
        tempFinishTime = (tempFinishTime.length < 11)
            ? tempFinishTime + " 24:00"
            : tempFinishTime;
        tempFinishTime = tempFinishTime.replaceAll("(RE)", "");
        var finishDateTime = DateTime.parse(tempFinishTime);
        return finishDateTime.add(new Duration(days: -1)).toString();
      }
      return "0";
    }
    return Assignment(
      workCode : json['workCode'],
      workFile : json['workFile'],
      workCourse : json['workCourse'],
      isSubmit : json['isSubmit'],
      workCreateTime : json['workCreateTime'],
      workFinishTime : json['workFinishTime'],
      workAlarmTime : json['workAlarmTime'] == null ? getDefaultAlarm(json['workFinishTime']) : json['workAlarmTime'],
      semester : json['semester'],
      workTitle : json['workTitle'],
      workType : WorkType.values.firstWhere((e) => e.toString() == 'WorkType.' + json['workType']),
      isAlarm: json['isAlarm'] == null ? 1 : json['isAlarm'],
      flag: json['flag'] == null ? 1 : json['flag'],
    ); 
  }
 
  Map toJson(){
     var map = new Map<String, dynamic>();
     map['workCode'] = workCode;
     map['workFile'] = workFile;
     map['workCourse'] = workCourse;
     map['isSubmit'] = isSubmit;
     map['workCreateTime'] = workCreateTime;
     map['workFinishTime'] = workFinishTime;
     map['workAlarmTime'] = workAlarmTime;
     map['workType'] = workType.toString().split('WorkType.')[1];
     map['semester'] = semester;
     map['workTitle'] = workTitle;
     map['isAlarm'] = isAlarm;
     map['flag'] = flag;
     return map;
   }
   String getValue(){
     String workTypeString = workType.toString().split('WorkType.')[1];
     return """( '$workCode', '$semester', '$workFile', '$workCourse', $isSubmit, '$workTypeString', '$workTitle', '$workCreateTime', '$workFinishTime', '$workAlarmTime', $isAlarm, $flag)""";
   }
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