class LoginResponse {
  int flag;
  String status;

  LoginResponse({this.flag,this.status});

  factory LoginResponse.fromJson(Map<String,dynamic> json){
    return LoginResponse(
      flag : json['flag'],
      status : json['status']
    );
  }

  Map toJson(){
    var map = new Map<String, dynamic>();
    map['flag'] = flag;
    map['status'] = status;

    return map;
  }
}