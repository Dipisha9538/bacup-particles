import 'dart:async';

import 'package:bloc/bloc.dart';
import '../../../Controller/AdminController.dart';
import 'package:meta/meta.dart';

part 'admin_category_event.dart';
part 'admin_category_state.dart';

class AdminCategoryBloc extends Bloc<AdminCategoryEvent, AdminCategoryState> {
  AdminCategoryBloc() : super(AdminCategoryState());

  @override
  Stream<AdminCategoryState> mapEventToState(AdminCategoryEvent event) async* {
    if (event is AddCategoryEvent) {
      yield* _mapAddCategory(
        event.category,
        event.picture,
      );
    } else if (event is UpdateCategoryEvent) {
      yield* _mapUpdateCategory(event.id, event.category, event.picture);
    } else if (event is DeleteCategoryEvent) {
      yield* _mapDeleteCategory(event.id);
    } else if (event is GetCategoryDetailsByIdEvent) {
      yield* _mapGetCategoryById(event.id);
    }
  }

  Stream<AdminCategoryState> _mapAddCategory(
      String category, String picture) async* {
    try {
      yield LoadingAddCategoryState();
      await Future.delayed(Duration(seconds: 1));
      final data = await adminController.addCategory(
          category: category, picture: picture);

      if (data.resp)
        yield AddCategorySuccessState();
      else
        yield FailureAddCategoryState(error: data.msj);
    } catch (e) {
      yield FailureAddCategoryState(error: e.toString());
    }
  }

  Stream<AdminCategoryState> _mapUpdateCategory(
      String id, String category, String picture) async* {
    try {
      yield LoadingUpdateCategoryState();
      await Future.delayed(Duration(seconds: 2));

      final data = await adminController.updateCategory(
          id: id, category: category, picture: picture);

      if (data.resp) {
        yield UpdateCategorySuccessState();
      } else {
        yield FailureUpdateCategoryState(error: data.msj);
      }
    } catch (e) {
      yield FailureUpdateCategoryState(error: e.toString());
    }
  }

  Stream<AdminCategoryState> _mapDeleteCategory(String id) async* {
    try {
      yield DeleteCategoryLoadingState();
      await Future.delayed(Duration(seconds: 2));

      final data = await adminController.deleteCategory(id: id);
      if (data.resp) {
        yield DeleteCategorySuccessState();
      } else {
        yield DeleteCategoryFailureState(error: data.msj);
      }
    } catch (e) {
      yield DeleteCategoryFailureState(error: e.toString());
    }
  }

  Stream<AdminCategoryState> _mapGetCategoryById(String id) async* {
    try {
      yield GetCategoryByIdLoadingState();
      await Future.delayed(Duration(seconds: 2));

      final data = await adminController.getCategoryById(id: id);
      if (data.resp) {
        yield GetCategoryByIdSuccessState();
      } else {
        yield GetCategoryByIdFailureState(error: data.msj);
      }
    } catch (e) {
      yield GetCategoryByIdFailureState(error: e.toString());
    }
  }
}
