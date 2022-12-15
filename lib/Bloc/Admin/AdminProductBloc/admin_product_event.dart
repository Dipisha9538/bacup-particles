part of 'admin_product_bloc.dart';

@immutable
abstract class AdminCourseEvent {}

class AddCourseEvent extends AdminCourseEvent {
  final Course course;

  AddCourseEvent({this.course});
}

class UpdateCourseEvent extends AdminCourseEvent {
  final Course course;

  UpdateCourseEvent({this.course});
}

// delete Course
class DeleteCourseEvent extends AdminCourseEvent {
  final String id;
  DeleteCourseEvent({this.id});
}

// get Course details by id
class GetCourseDetailsByIdEvent extends AdminCourseEvent {
  final String id;
  GetCourseDetailsByIdEvent({this.id});
}
