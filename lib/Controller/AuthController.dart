import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../Helpers/BaseServerUrl.dart';
import '../Models/AuthModel.dart';
import '../Models/ResponseModels.dart';
import '../Models/UpdateProfile.dart';
import '../Models/UploadPicture.dart';

class AuthController {
  String server = baseServerUrl;
  // baseServerUrl

  final secureStorage = FlutterSecureStorage();

  Future<ResponseModels> createUsers(
      {String user, String email, String password}) async {
    final resp = await http.post(Uri.parse('$server/register'),
        headers: {'Accept': 'application/json'},
        body: {'username': user, 'email': email, 'passwordd': password});

    return ResponseModels.fromJson(jsonDecode(resp.body));
  }

  Future<AuthModel> login({String email, String password}) async {
    final resp = await http.post(Uri.parse('$server/login'),
        headers: {'Accept': 'application/json'},
        body: {'email': email, 'passwordd': password});
    return AuthModel.fromJson(jsonDecode(resp.body));
  }

  Future<AuthModel> renewToken() async {
    final token = await readToken();

    final resp = await http.get(Uri.parse('$server/login/renew'),
        headers: {'Accept': 'application/json', 'xx-token': token});

    return AuthModel.fromJson(jsonDecode(resp.body));
  }

  Future<UpdateProfile> updatedImageProfile(
      {String image, String uidPerson}) async {
    final token = await readToken();

    var request =
        http.MultipartRequest('PUT', Uri.parse('$server/update-image-profile'))
          ..headers['Accept'] = 'application/json'
          ..headers['xx-token'] = token
          ..fields['uidPerson'] = '$uidPerson'
          ..files.add(await http.MultipartFile.fromPath('image', image));

    final resp = await request.send();
    var datas = await http.Response.fromStream(resp);

    return UpdateProfile.fromJson(jsonDecode(datas.body));
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

  Future<void> persistenToken(String token) async {
    await secureStorage.write(key: 'xtoken', value: token);
  }

  Future<String> uidPersonStorage() async {
    return secureStorage.read(key: 'uid');
  }

  Future<String> rolePersonStorage() async {
    return secureStorage.read(key: 'role');
  }

  Future<bool> hasToken() async {
    var value = await secureStorage.read(key: 'xtoken');

    if (value != null) return true;
    return false;
  }

  Future<String> readToken() async {
    return secureStorage.read(key: 'xtoken');
  }

  Future<void> deleteToken() async {
    secureStorage.delete(key: 'xtoken');
    secureStorage.deleteAll();
  }

  Future<void> resetUpload() async {
    secureStorage.delete(key: 'picture');
  }
}

final authController = AuthController();
