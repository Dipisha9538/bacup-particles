import 'dart:convert';

FavoriteCourse favoriteCourseFromJson(String str) =>
    FavoriteCourse.fromJson(json.decode(str));

String favoriteProductToJson(FavoriteCourse data) => json.encode(data.toJson());

class FavoriteCourse {
  FavoriteCourse({
    this.resp,
    this.msj,
    this.favorites,
  });

  bool resp;
  String msj;
  List<Favorite> favorites;

  factory FavoriteCourse.fromJson(Map<String, dynamic> json) {
    print("This is Favorite course map $json");

    var favCourse = FavoriteCourse(
      resp: json["resp"],
      msj: json["msj"],
      favorites: List<Favorite>.from(
          json["favorites"].map((x) => Favorite.fromJson(x))),
    );
    print("This is fav course $favCourse");
    return favCourse;
  }

  Map<String, dynamic> toJson() => {
        "resp": resp,
        "msj": msj,
        "favorites": List<dynamic>.from(favorites.map((x) => x.toJson())),
      };
}

class Favorite {
  Favorite({
    this.id,
    this.courseId,
    this.userId,
    this.v,
  });

  String id;
  CourseId courseId;
  String userId;
  int v;

  factory Favorite.fromJson(Map<String, dynamic> json) {
    print("This is favorite map $json");

    var fav = Favorite(
      id: json["_id"],
      courseId: CourseId.fromJson(json["product_id"]),
      userId: json["user_id"],
      v: json["__v"],
    );
    print("This is fav $fav");
    return fav;
  }

  Map<String, dynamic> toJson() => {
        "_id": id,
        "product_id": courseId.toJson(),
        "user_id": userId,
        "__v": v,
      };
}

class CourseId {
  CourseId({
    this.status,
    this.id,
    this.nameCourse,
    this.description,
    this.codeProduct,
    this.stock,
    this.price,
    this.picture,
    this.categoryId,
    this.v,
  });

  String status;
  String id;
  String nameCourse;
  String description;
  String codeProduct;
  int stock;
  double price;
  String picture;
  String categoryId;
  int v;

  factory CourseId.fromJson(Map<String, dynamic> json) {
    print("This is course map $json");
    var course = CourseId(
      status: json["status"],
      id: json["_id"],
      nameCourse: json["nameProduct"],
      description: json["description"],
      codeProduct: json["codeProduct"],
      stock: json["stock"],
      price: json["price"].toDouble(),
      picture: json["picture"],
      categoryId: json["category_id"],
      v: json["__v"],
    );
    print("This is course $course");
    return course;
  }

  Map<String, dynamic> toJson() => {
        "status": status,
        "_id": id,
        "nameProduct": nameCourse,
        "description": description,
        "codeProduct": codeProduct,
        "stock": stock,
        "price": price,
        "picture": picture,
        "category_id": categoryId,
        "__v": v,
      };
}
