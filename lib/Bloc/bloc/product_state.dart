part of 'product_bloc.dart';


@immutable
class CourseState {
  final List<CourseCart> courses;
  final double total;
  final int amount;
  final double delivery;
  final double insurance;

  CourseState(
      {this.courses,
      this.total = 00.0,
      this.amount = 0,
      this.delivery = 15.0,
      this.insurance = 10.0});

  CourseState copyWith(
          {List<CourseCart> courses,
          double total,
          int amount,
          double delivery,
          double insurance}) =>
      CourseState(
          courses: courses ?? this.courses,
          total: total ?? this.total,
          amount: amount ?? this.amount,
          delivery: delivery ?? this.delivery,
          insurance: insurance ?? this.insurance);
}
