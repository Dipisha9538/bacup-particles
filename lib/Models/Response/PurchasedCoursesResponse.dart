

import 'dart:convert';


PurchasedCoursesResponse purchasedCoursesResponseFromJson(String str) =>
    PurchasedCoursesResponse.fromJson(json.decode(str));

String purchasedCoursesResponseToJson(PurchasedCoursesResponse data) =>
    json.encode(data.toJson());

class PurchasedCoursesResponse {
  PurchasedCoursesResponse({
    this.resp,
    this.msg,
    this.orderBuy,
    this.orderDetails,
  });

  bool resp;
  String msg;
  OrderBuy orderBuy;
  List<OrderDetail> orderDetails;

  factory PurchasedCoursesResponse.fromJson(Map<String, dynamic> json) =>
      PurchasedCoursesResponse(
        resp: json["resp"],
        msg: json["msg"],
        orderBuy: OrderBuy.fromJson(json["orderBuy"]),
        orderDetails: List<OrderDetail>.from(
            json["orderDetails"].map((x) => OrderDetail.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "resp": resp,
        "msg": msg,
        "orderBuy": orderBuy.toJson(),
        "orderDetails": List<dynamic>.from(orderDetails.map((x) => x.toJson())),
      };
}

class OrderBuy {
  OrderBuy({
    this.id,
    this.userId,
    this.receipt,
    this.datee,
    this.amount,
    this.v,
  });

  String id;
  String userId;
  String receipt;
  DateTime datee;
  double amount;
  int v;

  factory OrderBuy.fromJson(Map<String, dynamic> json) => OrderBuy(
        id: json["_id"],
        userId: json["user_id"],
        receipt: json["receipt"],
        datee: DateTime.parse(json["datee"]),
        amount: json["amount"].toDouble(),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "user_id": userId,
        "receipt": receipt,
        "datee": datee.toIso8601String(),
        "amount": amount,
        "__v": v,
      };
}

class OrderDetail {
  OrderDetail({
    this.id,
    this.courseId,
    this.orderBuyId,
    this.quantity,
    this.price,
    this.v,
  });

  String id;
  CourseId courseId;
  String orderBuyId;
  int quantity;
  double price;
  int v;

  factory OrderDetail.fromJson(Map<String, dynamic> json) => OrderDetail(
        id: json["_id"],
        courseId: CourseId.fromJson(json["product_id"]),
        orderBuyId: json["orderBuy_id"],
        quantity: json["quantity"],
        price: json["price"].toDouble(),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "product_id": courseId.toJson(),
        "orderBuy_id": orderBuyId,
        "quantity": quantity,
        "price": price,
        "__v": v,
      };
}

class CourseId {
  CourseId({
    this.id,
    this.nameCourse,
    this.price,
    this.picture,
  });

  String id;
  String nameCourse;
  double price;
  String picture;

  factory CourseId.fromJson(Map<String, dynamic> json) => CourseId(
        id: json["_id"],
        nameCourse: json["nameProduct"],
        price: json["price"].toDouble(),
        picture: json["picture"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "nameProduct": nameCourse,
        "price": price,
        "picture": picture,
      };
}
