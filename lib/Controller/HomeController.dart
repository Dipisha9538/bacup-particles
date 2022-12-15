import 'dart:convert';
import '../Helpers/BaseServerUrl.dart';
import 'package:http/http.dart' as http;
import '../Models/Home/ProductHome.dart';
import 'AuthController.dart';
import '../Models/Home/HomeCarousel.dart';

import '../Models/Home/CategoriesCourses.dart';

class HomeController {
  String server = baseServerUrl;

  Future<List<SliderHome>> getHomeCarouselSlider() async {
    final token = await authController.readToken();

    final resp = await http.get(Uri.parse('$server/home-carousel'),
        headers: {'Accept': 'application/json', 'xx-token': token});

    return HomeCarousel.fromJson(jsonDecode(resp.body)).slider;
  }

  Future<List<Category>> getListCategoriesCourses() async {
    final token = await authController.readToken();

    final resp = await http.get(Uri.parse('$server/list-categories'),
        headers: {'Accept': 'application/json', 'xx-token': token});

    return CategoriesCourses.fromJson(jsonDecode(resp.body)).categories;
  }

  Future<List<Course>> getListCoursesHome() async {
    final token = await authController.readToken();

    final resp = await http.get(Uri.parse('$server/list-products-home'),
        headers: {'Accept': 'application/json', 'xx-token': token});

    return CoursesHome.fromJson(jsonDecode(resp.body)).courses;
  }

  Future<List<Category>> getListCategories() async {
    final token = await authController.readToken();

    final resp = await http.get(Uri.parse('$server/list-categories-all'),
        headers: {'Accept': 'application/json', 'xx-token': token});

    return CategoriesCourses.fromJson(jsonDecode(resp.body)).categories;
  }
}

final dbHomeController = HomeController();
