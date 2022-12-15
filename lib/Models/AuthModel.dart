import 'dart:convert';

AuthModel authModelFromJson(String str) => AuthModel.fromJson(json.decode(str));

String authModelToJson(AuthModel data) => json.encode(data.toJson());

class AuthModel {
  bool resp;
  String msj;
  Users users;
  String token;
  String role;

  AuthModel({
    this.resp,
    this.msj,
    this.users,
    this.token,
    this.role,
  });

  factory AuthModel.fromJson(Map<String, dynamic> json) => AuthModel(
        resp: json["resp"],
        msj: json["msj"],
        users: Users.fromJson(json["users"]),
        token: json["token"],
        role: json["role"],
      );

  Map<String, dynamic> toJson() => {
        "resp": resp,
        "msj": msj,
        "users": users.toJson(),
        "token": token,
        "role": role,
      };
}

class Users {
  Users({this.id, this.email, this.users, this.profile, this.role});

  String id;
  String email;
  String users;
  String profile;
  String role;

  factory Users.fromJson(Map<String, dynamic> json) => Users(
        id: json["id"],
        email: json["email"],
        users: json["users"],
        profile: json["profile"],
        role: json["role"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "users": users,
        "profile": profile,
        "role": role,
      };
}
