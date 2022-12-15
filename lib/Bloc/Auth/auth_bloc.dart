import 'dart:async';

import 'package:bloc/bloc.dart';
import '../../Controller/AuthController.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthState());

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    if (event is RegisterEvent) {
      yield* _mapAuthenticationRegister(
          event.username, event.email, event.password);
    } else if (event is LoginEvent) {
      yield* _mapAuthenticationLogin(event.email, event.password);
    } else if (event is CheckLoginEvent) {
      yield* _mapCheckAuthentication();
    } else if (event is LogOutEvent) {
      yield* _mapLogOutLogin();
    } else if (event is ChangePictureProfile) {
      yield* _mapChangeFotoProfile(event.image);
    } else if (event is GetPersistentRoleEvent) {
      yield* _mapPersistentRole();
    }
  }

  Stream<AuthState> _mapAuthenticationRegister(
      String user, String email, String password) async* {
    try {
      yield LoadingRegisterState();

      await Future.delayed(Duration(seconds: 1));

      final data = await authController.createUsers(
          user: user, email: email, password: password);

      if (data.resp)
        yield RegisterSuccess();
      else
        yield FailureRegisterState(error: data.msj);
    } catch (e) {
      yield FailureRegisterState(error: e.toString());
    }
  }

  Stream<AuthState> _mapPersistentRole() async* {
    try {
      String role = await authController.rolePersonStorage();
      yield state.copyWith(role: role);
    } catch (e) {}
  }

  Stream<AuthState> _mapAuthenticationLogin(
      String email, String password) async* {
    try {
      yield LoadingState();

      await Future.delayed(Duration(seconds: 2));

      final secureStorage = FlutterSecureStorage();

      final data = await authController.login(email: email, password: password);

      if (data.resp) {
        await authController.persistenToken(data.token);
        await secureStorage.write(key: 'uid', value: data.users.id.toString());
        await secureStorage.write(key: 'email', value: data.users.email);
        await secureStorage.write(key: 'user', value: data.users.users);
        await secureStorage.write(key: 'profile', value: data.users.profile);
        await secureStorage.write(key: 'role', value: data.users.role);

        yield LogInState();

        yield state.copyWith(
            uid: data.users.id.toString(),
            email: data.users.email,
            username: data.users.users,
            profile: data.users.profile,
            role: data.users.role);
      } else {
        yield FailureState(error: data.msj);
      }
    } catch (e) {
      yield FailureState(error: e.toString());
    }
  }

  Stream<AuthState> _mapCheckAuthentication() async* {
    print("Check login event");
    final secureStorage = FlutterSecureStorage();

    final hasToken = await authController.hasToken();

    if (hasToken) {
      final data = await authController.renewToken();

      await Future.delayed(Duration(seconds: 1));

      if (data.resp) {
        yield LogInState();

        yield state.copyWith(
            uid: data.users.id.toString(),
            username: data.users.users,
            email: data.users.email,
            profile: data.users.profile,
            role: data.users.role);
      } else {
        yield LogOutState();
        await secureStorage.deleteAll();
      }
    } else {
      yield LogOutState();
      await secureStorage.deleteAll();
    }
  }

  Stream<AuthState> _mapLogOutLogin() async* {
    final secure = FlutterSecureStorage();

    await secure.deleteAll();
    yield LogOutState();
  }

  Stream<AuthState> _mapChangeFotoProfile(String image) async* {
    try {
      final secureStorage = FlutterSecureStorage();

      yield LoadingImageState();

      final resp = await authController.updatedImageProfile(
          image: image, uidPerson: await authController.uidPersonStorage());

      await secureStorage.write(key: 'profile', value: resp.profile);

      await Future.delayed(Duration(seconds: 3));

      yield ChangeProfileSuccess();

      yield state.copyWith(
          profile: resp.profile,
          username: await secureStorage.read(key: 'user'),
          email: await secureStorage.read(key: 'email'),
          uid: await secureStorage.read(key: 'uid'),
          role: await secureStorage.read(key: 'role'));
    } catch (e) {
      yield FailureSaveImage(error: e.toString());
    }
  }
}
