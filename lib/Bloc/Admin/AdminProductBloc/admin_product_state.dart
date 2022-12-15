part of 'admin_product_bloc.dart';

@immutable
class AdminCoursestate {
  final String id;
  final String Course;
  final String picture;

  AdminCoursestate({this.id, this.Course, this.picture});

  AdminCoursestate copyWith({String id, String Course, String picture}) =>
      AdminCoursestate(
        id: id ?? this.id,
        Course: Course ?? this.Course,
        picture: id ?? this.picture,
      );
}

// --------------------------------------------------//
class AddCoursestate extends AdminCoursestate {}

class LoadingAddCoursestate extends AdminCoursestate {}

class AddCoursesuccessState extends AdminCoursestate {}

class FailureAddCoursestate extends AdminCoursestate {
  final String error;

  FailureAddCoursestate({this.error});
}

// -------------------------------------------------//
class LoadingUpdateCoursestate extends AdminCoursestate {}

class UpdateCoursesuccessState extends AdminCoursestate {}

class FailureUpdateCoursestate extends AdminCoursestate {
  final String error;

  FailureUpdateCoursestate({this.error});
}

// --------------- delete state -------------------
class DeleteCourseLoadingState extends AdminCoursestate {}

class DeleteCoursesuccessState extends AdminCoursestate {}

class DeleteCourseFailureState extends AdminCoursestate {
  final String error;

  DeleteCourseFailureState({this.error});
}

// --------------- get Course details by id state -------------------
class GetCourseByIdLoadingState extends AdminCoursestate {}

class GetCourseByIdSuccessState extends AdminCoursestate {}

class GetCourseByIdFailureState extends AdminCoursestate {
  final String error;

  GetCourseByIdFailureState({this.error});
}
