class LoginStatus  {
  int flag;
  String status;

  LoginStatus({this.flag,this.status});

  factory LoginStatus.fromJson(Map<String,dynamic> json){
    return LoginStatus(
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