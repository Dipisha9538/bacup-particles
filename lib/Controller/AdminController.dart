import 'dart:convert';
import '../Helpers/BaseServerUrl.dart';
import '../Models/Home/ProductHome.dart';
import '../Models/ResponseModels.dart';
import '../Models/UploadPicture.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AdminController {
  String server = baseServerUrl;
  // baseServerUrl

  final secureStorage = FlutterSecureStorage();

  Future<ResponseModels> addCategory({String category, String picture}) async {
    final token = await readToken();
    final resp = await http.post(Uri.parse('$server/category'), headers: {
      'Accept': 'application/json',
      'xx-token': token
    }, body: {
      'category': category,
      'picture': picture,
    });

    return ResponseModels.fromJson(jsonDecode(resp.body));
  }

  Future<ResponseModels> updateCategory(
      {String id, String category, String picture}) async {
    final token = await readToken();
    final resp = await http.put(Uri.parse('$server/category'), headers: {
      'Accept': 'application/json',
      'xx-token': token
    }, body: {
      "id": id,
      'category': category,
      'picture': picture,
    });

    print("I am here in upsate category $resp");

    return ResponseModels.fromJson(jsonDecode(resp.body));
  }

  Future<ResponseModels> deleteCategory({String id}) async {
    final token = await readToken();
    final resp = await http.delete(Uri.parse('$server/category'),
        headers: {'Accept': 'application/json', 'xx-token': token},
        body: {"id": id});

    return ResponseModels.fromJson(jsonDecode(resp.body));
  }

  Future<ResponseModels> getCategoryById({String id}) async {
    final token = await readToken();
    final resp = await http.get(
      Uri.parse('$server/category/$id'),
      headers: {'Accept': 'application/json', 'xx-token': token},
    );

    return ResponseModels.fromJson(jsonDecode(resp.body));
  }

  Future<ResponseModels> addCourse({Course course}) async {
    final token = await readToken();
    final data = {
      "nameProduct": course.nameCourse,
      "description": course.description,
      "codeProduct": course.codeCourse,
      "stock": course.stock.toString(),
      "price": course.price.toString(),
      "status": course.status,
      "picture": course.picture,
      "category_id": course.categoryId.id.toString()
    };
    print("This is patload daa $data");

    final resp = await http.post(Uri.parse('$server/product'),
        headers: {'Accept': 'application/json', 'xx-token': token}, body: data);
    print("This is resp $resp");

    return ResponseModels.fromJson(jsonDecode(resp.body));
  }

  Future<ResponseModels> updateCourse({Course course}) async {
    final token = await readToken();
    final data = {
      "id": course.id.toString(),
      "nameProduct": course.nameCourse,
      "description": course.description,
      "codeProduct": course.codeCourse,
      "stock": course.stock.toString(),
      "price": course.price.toString(),
      "status": course.status,
      "picture": course.picture,
      "category_id": course.categoryId.id.toString()
    };
    print("This is patload daa $data");

    final resp = await http.put(Uri.parse('$server/product'),
        headers: {'Accept': 'application/json', 'xx-token': token}, body: data);
    print("This is resp $resp");

    return ResponseModels.fromJson(jsonDecode(resp.body));
  }

  Future<ResponseModels> deleteCourse({String id}) async {
    final token = await readToken();
    final resp = await http.delete(Uri.parse('$server/product'),
        headers: {'Accept': 'application/json', 'xx-token': token},
        body: {"id": id});

    return ResponseModels.fromJson(jsonDecode(resp.body));
  }

  Future<ResponseModels> getCourseById({String id}) async {
    final token = await readToken();
    final resp = await http.get(
      Uri.parse('$server/category/$id'),
      headers: {'Accept': 'application/json', 'xx-token': token},
    );

    return ResponseModels.fromJson(jsonDecode(resp.body));
  }

  Future<UploadPicture> uploadPicture({String picture}) async {
    final token = await readToken();

    var request =
        http.MultipartRequest('POST', Uri.parse('$server/upload-picture'))
          ..headers['Accept'] = 'application/json'
          ..headers['xx-token'] = token
          ..files.add(await http.MultipartFile.fromPath('picture', picture));

    final resp = await request.send();
    var datas = await http.Response.fromStream(resp);

    return UploadPicture.fromJson(jsonDecode(datas.body));
  }

  // Flutter Secure Storage

  Future<String> readToken() async {
    return secureStorage.read(key: 'xtoken');
  }
}

final adminController = AdminController();
