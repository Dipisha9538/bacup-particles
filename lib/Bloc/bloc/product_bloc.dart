import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import 'package:pasell/Controller/CourseController.dart';
import 'package:pasell/Models/Product.dart';

part 'product_event.dart';
part 'product_state.dart';

class CourseBloc extends Bloc<CourseEvent, CourseState> {
  CourseBloc() : super(CourseState());

  List<CourseCart> course = [];

  @override
  Stream<CourseState> mapEventToState(CourseEvent event) async* {
    if (event is AddOrDeleteCourseFavorite) {
      yield* mapEventAddOrDeleteCourseFavorite(event.uidCourse);
    } else if (event is AddCourseToCart) {
      final hasCourse = course.contains(event.course);

      if (!hasCourse) {
        course.add(event.course);

        double sum = 0;
        course.forEach((e) {
          sum = sum + e.price;
        });

        yield state.copyWith(
            courses: course, total: sum, amount: course.length);
      }
    } else if (event is DeleteCourseToCart) {
      course.removeAt(event.index);

      double sum = 0;
      course.forEach((e) {
        sum = sum + e.price;
      });

      yield state.copyWith(courses: course, total: sum, amount: course.length);
    } else if (event is PlusQuantityCourse) {
      course[event.plus].amount++;

      double total = 0;
      course.forEach((e) {
        total = total + (e.price * e.amount);
      });

      yield state.copyWith(courses: course, total: total);
    } else if (event is SubtractQuantityCourseEvent) {
      course[event.subtract].amount--;

      double total = 0;
      course.forEach((e) {
        total = total - (e.price * e.amount);
      });

      yield state.copyWith(courses: course, total: total.abs());
    } else if (event is ClearCoursesEvent) {
      course.clear();

      yield state.copyWith(
        amount: 00,
        delivery: 0.0,
        insurance: 0.0,
        courses: course,
        total: 00.0,
      );
    } else if (event is SaveCoursesBuy) {
      try {
        await dbCourseController.saveOrderBuyCourse(
            receipt: 'Ticket',
            date: event.date,
            amount: event.amount,
            courses: event.course);
      } catch (e) {
        print('Something went wrong!');
        print(e.toString());
      }
    }
  }

  Stream<CourseState> mapEventAddOrDeleteCourseFavorite(
      String uidCourse) async* {
    try {
      final resp = await dbCourseController.addOrDeleteCourseFavorite(
          uidCourse: uidCourse);

      if (resp.resp) {}
    } catch (e) {}
  }
}
