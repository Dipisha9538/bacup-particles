import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../Controller/AdminController.dart';
import '../../../Models/Home/ProductHome.dart';


part 'admin_product_event.dart';
part 'admin_product_state.dart';

class AdminCourseBloc extends Bloc<AdminCourseEvent, AdminCoursestate> {
  AdminCourseBloc() : super(AdminCoursestate());

  @override
  Stream<AdminCoursestate> mapEventToState(AdminCourseEvent event) async* {
    if (event is AddCourseEvent) {
      yield* _mapAddCourse(
        event.course,
      );
    } else if (event is UpdateCourseEvent) {
      yield* _mapUpdateCourse(event.course);
    } else if (event is DeleteCourseEvent) {
      yield* _mapDeleteCourse(event.id);
    } else if (event is GetCourseDetailsByIdEvent) {
      yield* _mapGetCourseById(event.id);
    }
  }

  Stream<AdminCoursestate> _mapAddCourse(Course course) async* {
    try {
      yield LoadingAddCoursestate();
      await Future.delayed(Duration(seconds: 1));
      final data = await adminController.addCourse(course: course);

      if (data.resp)
        yield AddCoursesuccessState();
      else
        yield FailureAddCoursestate(error: data.msj);
    } catch (e) {
      yield FailureAddCoursestate(error: e.toString());
    }
  }

  Stream<AdminCoursestate> _mapUpdateCourse(Course course) async* {
    try {
      yield LoadingUpdateCoursestate();
      await Future.delayed(Duration(seconds: 2));

      final data = await adminController.updateCourse(course: course);

      if (data.resp) {
        yield UpdateCoursesuccessState();
      } else {
        yield FailureUpdateCoursestate(error: data.msj);
      }
    } catch (e) {
      yield FailureUpdateCoursestate(error: e.toString());
    }
  }

  Stream<AdminCoursestate> _mapDeleteCourse(String id) async* {
    try {
      yield DeleteCourseLoadingState();
      await Future.delayed(Duration(seconds: 2));

      final data = await adminController.deleteCourse(id: id);
      if (data.resp) {
        yield DeleteCoursesuccessState();
      } else {
        yield DeleteCourseFailureState(error: data.msj);
      }
    } catch (e) {
      yield DeleteCourseFailureState(error: e.toString());
    }
  }

  Stream<AdminCoursestate> _mapGetCourseById(String id) async* {
    try {
      yield GetCourseByIdLoadingState();
      await Future.delayed(Duration(seconds: 2));

      final data = await adminController.getCourseById(id: id);
      if (data.resp) {
        yield GetCourseByIdSuccessState();
      } else {
        yield GetCourseByIdFailureState(error: data.msj);
      }
    } catch (e) {
      yield GetCourseByIdFailureState(error: e.toString());
    }
  }
}
