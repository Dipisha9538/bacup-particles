import '../../Helpers/BaseServerUrl.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../../Controller/CourseController.dart';
import '../../Models/Product/FavoriteCourse.dart';
import '../../Widgets/BottomNavigationFrave.dart';
import '../../Widgets/CustomText.dart';

class FavoritePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 248, 246, 246),
      appBar: AppBar(
        title: CustomText(
          text: 'Favorites',
          color: Colors.black,
        ),
        centerTitle: true,
        backgroundColor: Color(0xfff2f2f2),
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: [
          FutureBuilder<List<Favorite>>(
            future: dbCourseController.favoriteCourses(),
            builder: (context, snapshot) {
              return !snapshot.hasData
                  ? LoadingFavoriteCourse()
                  : ListFavoriteCourse(list: snapshot.data);
            },
          ),
          Positioned(
            bottom: 20,
            child: Container(
                width: size.width,
                child: Align(child: BottomNavigationFrave(index: 1))),
          ),
        ],
      ),
    );
  }
}

class LoadingFavoriteCourse extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.white,
      highlightColor: Color(0xFFF5F5F5),
      child: GridView.builder(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.only(left: 15.0, right: 15.0, bottom: 90),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 25,
            mainAxisSpacing: 20,
            mainAxisExtent: 210),
        itemCount: 6,
        itemBuilder: (context, index) => Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(25.0)),
        ),
      ),
    );
  }
}

class ListFavoriteCourse extends StatelessWidget {
  final List<Favorite> list;

  ListFavoriteCourse({this.list});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.only(left: 15.0, right: 15.0, bottom: 90),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 25,
            mainAxisSpacing: 20,
            mainAxisExtent: 220),
        itemCount: list.length == null ? 0 : list.length,
        itemBuilder: (context, i) => CourseFavorite(course: list[i]));
  }
}

class CourseFavorite extends StatelessWidget {
  final Favorite course;

  CourseFavorite({this.course});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(20.0)),
        child: Column(
          children: [
            Image.network(publicServerUrl + course.courseId.picture,
                height: 140),
            CustomText(
                text: course.courseId.nameCourse,
                fontSize: 17,
                textOverflow: TextOverflow.ellipsis),
            SizedBox(height: 10.0),
            Padding(
              padding: const EdgeInsets.only(left: 90),
              child: CustomText(
                  text: '\Rs ${course.courseId.price}',
                  fontSize: 15,
                  fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
    );
  }
}
