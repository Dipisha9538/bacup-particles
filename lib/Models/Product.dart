import 'package:meta/meta.dart';

class CourseCart {
  final String uidCourse;
  final String image;
  final String name;
  double price;
  int amount;

  CourseCart({
    @required this.uidCourse,
    @required this.image,
    @required this.name,
    @required this.price,
    @required this.amount,
  });

  Map<String, dynamic> toJson() {
    return {'uidCourse': uidCourse, 'price': price, 'amount': amount};
  }
}
