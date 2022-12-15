import 'dart:convert';
import 'package:pasell/Helpers/BaseServerUrl.dart';
import 'package:pasell/Models/Home/ProductHome.dart';
import 'package:pasell/Models/Product.dart';
import 'package:pasell/Models/Product/FavoriteCourse.dart';
import 'package:pasell/Models/Response/PurchasedCoursesResponse.dart';
import 'package:http/http.dart' as http;
import 'package:pasell/Controller/AuthController.dart';
import 'package:pasell/Models/ResponseModels.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class CourseController {
  String server = baseServerUrl;
  final secureStorage = FlutterSecureStorage();

  Future<ResponseModels> addOrDeleteCourseFavorite({String uidCourse}) async {
    final token = await authController.readToken();
    final resp = await http.post(Uri.parse('$server/add-Favorite-Product'),
        headers: {
          'Accept': 'application/json',
          'xx-token': token
        },
        body: {
          'uidProduct': uidCourse,
          'uidUser': await secureStorage.read(key: 'uid')
        });
    print(resp.body);

    return ResponseModels.fromJson(jsonDecode(resp.body));
  }

  Future<List<Favorite>> favoriteCourses() async {
    final token = await authController.readToken();

    final resp = await http.get(
      Uri.parse('$server/product-favorite-for-user'),
      headers: {'Accept': 'application/json', 'xx-token': token},
    );

    // print(resp.body);

    var favs = FavoriteCourse.fromJson(jsonDecode(resp.body)).favorites;
    print(favs);
    return favs;
  }

  Future<ResponseModels> saveOrderBuyCourse(
      {String receipt,
      String date,
      String amount,
      List<CourseCart> courses}) async {
    final token = await authController.readToken();

    Map<String, dynamic> data = {
      'receipt': receipt,
      'date': date,
      'amount': amount,
      'products': courses
    };

    final body = json.encode(data);

    final resp = await http.post(Uri.parse('$server/save-order-products'),
        headers: {'Content-type': 'application/json', 'xx-token': token},
        body: body);

    return ResponseModels.fromJson(jsonDecode(resp.body));
  }

  Future<PurchasedCoursesResponse> getPurchasedCourses() async {
    final token = await authController.readToken();

    final response = await http.get(
      Uri.parse('$server/get-purchased-products'),
      headers: {'Content-type': 'application/json', 'xx-token': token},
    );

    return PurchasedCoursesResponse.fromJson(jsonDecode(response.body));
  }

  Future<List<Course>> getCoursesForCategories({String id}) async {
    final token = await authController.readToken();

    final response = await http.get(
      Uri.parse('$server/get-products-for-categories/' + id),
      headers: {'Content-type': 'application/json', 'xx-token': token},
    );

    return CoursesHome.fromJson(jsonDecode(response.body)).courses;
  }
}

final dbCourseController = CourseController();
