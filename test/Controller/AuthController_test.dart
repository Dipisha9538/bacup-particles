import 'package:pasell/Controller/AuthController.dart';
import 'package:pasell/Models/AuthModel.dart';
import 'package:pasell/Models/ResponseModels.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'AuthController_test.mocks.dart';

@GenerateMocks([AuthController])
void main() {
  AuthController authController;
  var userData = {"user": "", "password": "", "email": ""};
  var authUserData;
  setUpAll(() {
    authController = MockAuthController();
    userData = {
      "user": "test3",
      "password": "Test@12345",
      "email": "test3@gmail.com"
    };
    authUserData = Users(
      email: userData['email'],
      id: "1",
      profile: "profile.png",
      role: "User",
      users: userData['user'],
    );
  });

  test('Registering user when is successful', () async {
    when(authController.createUsers(
            user: userData["user"],
            email: userData['email'],
            password: userData['password']))
        .thenAnswer(
      (_) async => ResponseModels(
        resp: true,
        msj: "Registered Successfully",
      ),
    );
    ResponseModels response = await authController.createUsers(
        user: userData["user"],
        email: userData['email'],
        password: userData['password']);
    verify(authController.createUsers(
        user: userData["user"],
        email: userData['email'],
        password: userData['password']));
    expect(response.msj, "Registered Successfully");
    expect(response.resp, true);
  });

  test('Login user when is successful', () async {
    when(authController.login(
            email: userData['email'], password: userData['password']))
        .thenAnswer(
      (_) async => AuthModel(
        resp: true,
        msj: "Logged Successfully",
        token: "token",
        role: "User",
        users: authUserData,
      ),
    );
    AuthModel response = await authController.login(
        email: userData['email'], password: userData['password']);
    verify(authController.login(
        email: userData['email'], password: userData['password']));
    expect(response.msj, "Logged Successfully");
    expect(response.resp, true);
    expect(response.role, "User");
    expect(response.token, "token");
    expect(response.users, authUserData);
  });

  test('Registering user when is not successful', () async {
    when(authController.createUsers(
            user: userData["user"],
            email: userData['email'],
            password: userData['password']))
        .thenAnswer(
      (_) async => ResponseModels(
        resp: false,
        msj: "There is some error registering",
      ),
    );
    ResponseModels response = await authController.createUsers(
        user: userData["user"],
        email: userData['email'],
        password: userData['password']);
    verify(authController.createUsers(
        user: userData["user"],
        email: userData['email'],
        password: userData['password']));
    expect(response.msj, "There is some error registering");
    expect(response.resp, false);
  });

  test('Login user when is not successful', () async {
    when(authController.login(
            email: userData['email'], password: userData['password']))
        .thenAnswer(
      (_) async => AuthModel(
        resp: false,
        msj: "There is some error logging",
        token: "",
        role: "",
        users: null,
      ),
    );
    AuthModel response = await authController.login(
        email: userData['email'], password: userData['password']);
    verify(authController.login(
        email: userData['email'], password: userData['password']));
    expect(response.msj, "There is some error logging");
    expect(response.resp, false);
    expect(response.role, "");
    expect(response.token, "");
    expect(response.users, null);
  });

  test('Renewing Token When Successful', () async {
    when(authController.renewToken()).thenAnswer(
      (_) async => AuthModel(
        resp: true,
        msj: "Token Renewed Successfully",
        token: "newToken",
        role: "User",
        users: authUserData,
      ),
    );
    AuthModel response = await authController.renewToken();
    verify(authController.renewToken());
    expect(response.msj, "Token Renewed Successfully");
    expect(response.resp, true);
    expect(response.role, "User");
    expect(response.token, "newToken");
    expect(response.users, authUserData);
  });

  test('Renewing Token When Not Successful', () async {
    when(authController.renewToken()).thenAnswer(
      (_) async => AuthModel(
        resp: false,
        msj: "There is some error renewing token",
        token: "",
        role: "",
        users: null,
      ),
    );
    AuthModel response = await authController.renewToken();
    verify(authController.renewToken());
    expect(response.msj, "There is some error renewing token");
    expect(response.resp, false);
    expect(response.role, "");
    expect(response.token, "");
    expect(response.users, null);
  });

  tearDownAll(() {
    authController = null;
  });
}
