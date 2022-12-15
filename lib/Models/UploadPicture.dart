import 'dart:convert';

UploadPicture authModelFromJson(String str) =>
    UploadPicture.fromJson(json.decode(str));

String authModelToJson(UploadPicture data) => json.encode(data.toJson());

class UploadPicture {
  UploadPicture({
    this.resp,
    this.msj,
    this.picture,
  });

  bool resp;
  String msj;
  String picture;

  factory UploadPicture.fromJson(Map<String, dynamic> json) => UploadPicture(
        resp: json["resp"],
        msj: json["msj"],
        picture: json["picture"],
      );

  Map<String, dynamic> toJson() => {
        "resp": resp,
        "msj": msj,
        "picture": picture,
      };
}
