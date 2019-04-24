class AssignmentResponse {
  String status;
  List<dynamic> assignmentList;

  AssignmentResponse({this.status,this.assignmentList});

  factory AssignmentResponse.fromJson(Map<String,dynamic> json){
    return AssignmentResponse(
      status : json['status'],
      assignmentList : json['assignment']
    );
  }


}