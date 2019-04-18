
class AssignmentResponse {
  String status;
  String assignmentList;

  AssignmentResponse({this.status,this.assignmentList});

  factory AssignmentResponse.fromJson(Map<String,dynamic> json){
    return AssignmentResponse(
      status : json['status'],
      assignmentList : json['assignment']
    );
  }
}