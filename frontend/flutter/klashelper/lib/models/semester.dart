class Semester  {
  String semesterCode;
  String semesterName;

  Semester({this.semesterCode = "",this.semesterName = ""});

  factory Semester.fromJson(Map<String,dynamic> json){
    return Semester(
      semesterCode : json['semesterCode'],
      semesterName : json['semesterName']
    );
  }

  Map toJson(){
    var map = new Map<String, dynamic>();
    map['semesterCode'] = semesterCode;
    map['semesterName'] = semesterName;

    return map;
  }
}