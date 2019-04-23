class SemesterResponse {
  String status;
  String semesters;

  SemesterResponse({this.status,this.semesters});

  factory SemesterResponse.fromJson(Map<String,dynamic> json){
    return SemesterResponse(
      status : json['status'],
      semesters : json['semesters']
    );
  }


}