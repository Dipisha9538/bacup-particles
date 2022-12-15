import '../../Controller/CourseController.dart';
import '../../Helpers/BaseServerUrl.dart';
import '../../Models/Home/ProductHome.dart';
import '../../Widgets/StaggeredDualView.dart';
import '../../Widgets/CustomText.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Products/DetailsProductPage.dart';

class CategoryCoursesPage extends StatefulWidget {
  final String uidCategory;
  final String category;

  const CategoryCoursesPage(
      {@required this.uidCategory, @required this.category});

  @override
  _CategoryCoursesPageState createState() => _CategoryCoursesPageState();
}

class _CategoryCoursesPageState extends State<CategoryCoursesPage> {
  List<Course> listCourse = [];

  getCourses() async {
    listCourse = await dbCourseController.getCoursesForCategories(
        id: widget.uidCategory);
    setState(() {});
  }

  @override
  void initState() {
    getCourses();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff5f5f5),
      appBar: AppBar(
        title: CustomText(text: widget.category, color: Colors.black),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView.separated(
        separatorBuilder: (BuildContext context, int index) {
          return SizedBox(
            height: 10,
          );
        },
        itemCount: listCourse.length,
        itemBuilder: (_, i) => Card(
          color: Color.fromARGB(255, 250, 249, 249),
          // shadowColor: Colors.black26,
          margin: EdgeInsets.only(left: 16, right: 16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 5.0,
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            splashColor: Colors.blue[300],
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => DetailsCoursePage(course: listCourse[i]))),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 150,
                  width: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      scale: 1.0,
                      image: NetworkImage(
                        publicServerUrl + listCourse[i].picture,
                      ),
                    ),
                  ),
                ),
                // Container(
                //   // width: 400,
                //   child: Hero(
                //       tag: listCourse[i].id,
                //       // child: Image.network(
                //       //   publicServerUrl + listCourse[i].picture,
                //       //   height: 140.sm,
                //       // )
                //       ),
                // ),
                SizedBox(
                  width: 30,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        listCourse[i].nameCourse,
                        maxLines: 3,
                        style: GoogleFonts.getFont('Roboto',
                            fontSize: 17, fontWeight: FontWeight.w500),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      // Stars(rating: totalRating),

                      CustomText(
                          text: '\Rs ${listCourse[i].price}', fontSize: 16),
                      const Text(
                        'status: used',
                        style:
                            TextStyle(color: Color.fromARGB(255, 14, 14, 14)),
                      ),
                    ],
                  ),
                ),
                // SizedBox(height: 10.0),
                // Text(
                //   listCourse[i].nameCourse,
                //   style: GoogleFonts.getFont('Roboto',
                //       fontSize: 17, fontWeight: FontWeight.w500),
                //   overflow: TextOverflow.ellipsis,
                // ),
                // CustomText(
                //     text: '\Rs ${listCourse[i].price}',
                //     fontSize: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
