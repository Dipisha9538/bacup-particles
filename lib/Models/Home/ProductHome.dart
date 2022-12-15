import 'dart:convert';


CoursesHome coursesHomeFromJson(String str) =>
    CoursesHome.fromJson(json.decode(str));

String coursesHomeToJson(CoursesHome data) => json.encode(data.toJson());

class CoursesHome {
  CoursesHome({
    this.resp,
    this.msj,
    this.courses,
  });

  bool resp;
  String msj;
  List<Course> courses;

  factory CoursesHome.fromJson(Map<String, dynamic> json) {
    return CoursesHome(
      resp: json["resp"],
      msj: json["msj"],
      courses: List<Course>.from(json["products"].map((x) {
        return Course.fromJson(x);
      })),
    );
  }

  Map<String, dynamic> toJson() => {
        "resp": resp,
        "msj": msj,
        "products": List<dynamic>.from(courses.map((x) => x.toJson())),
      };
}

class Course {
  Course({
    this.status,
    this.id,
    this.nameCourse,
    this.description,
    this.codeCourse,
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
  String codeCourse;
  int stock;
  double price;
  String picture;
  CategoryId categoryId;
  int v;

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      status: json["status"],
      id: json["_id"],
      nameCourse: json["nameProduct"],
      description: json["description"],
      codeCourse: json["codeProduct"],
      stock: json["stock"],
      price: json["price"].toDouble(),
      picture: json["picture"],
      categoryId: CategoryId.fromJson(json["category_id"]),
      // categoryId: CategoryId.fromJson(json["category_id"]),
      v: json["__v"],
    );
  }

  Map<String, dynamic> toJson() => {
        "status": status,
        "_id": id,
        "nameProduct": nameCourse,
        "description": description,
        "codeProduct": codeCourse,
        "stock": stock,
        "price": price,
        "picture": picture,
        "category_id": categoryId.toJson(),
        "__v": v,
      };
}

class CategoryId {
  CategoryId({
    this.id,
    this.category,
  });

  String id;
  String category;

  factory CategoryId.fromJson(Map<String, dynamic> json) => CategoryId(
        id: json["_id"],
        category: json["category"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "category": category,
      };
}
