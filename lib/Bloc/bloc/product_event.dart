part of 'product_bloc.dart';



@immutable
abstract class CourseEvent {}

class AddOrDeleteCourseFavorite extends CourseEvent {
  final String uidCourse;

  AddOrDeleteCourseFavorite({this.uidCourse});
}

class AddCourseToCart extends CourseEvent {
  final CourseCart course;

  AddCourseToCart({this.course});
}

class DeleteCourseToCart extends CourseEvent {
  final int index;

  DeleteCourseToCart({this.index});
}

class PlusQuantityCourse extends CourseEvent {
  final int plus;

  PlusQuantityCourse({this.plus});
}

class SubtractQuantityCourseEvent extends CourseEvent {
  final int subtract;

  SubtractQuantityCourseEvent({this.subtract});
}

class SaveCoursesBuy extends CourseEvent {
  final String user;
  final String date;
  final String amount;
  final List course;

  SaveCoursesBuy({this.user, this.date, this.amount, this.course});
}

class ClearCoursesEvent extends CourseEvent {}
