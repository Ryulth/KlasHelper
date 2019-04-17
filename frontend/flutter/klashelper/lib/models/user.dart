class User  {
  String id;
  String pw;

  User({this.id,this.pw});

  factory User.fromJson(Map<String,dynamic> json){
    return User(
      id : json['id'],
      pw : json['pw']
    );
  }

  Map toJson(){
    var map = new Map<String, dynamic>();
    map['id'] = id;
    map['pw'] = pw;

    return map;
  }
}