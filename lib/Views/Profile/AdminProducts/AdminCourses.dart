import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

import '../../../Bloc/Admin/AdminProductBloc/admin_product_bloc.dart';
import '../../../Controller/HomeController.dart';
import '../../../Helpers/Colors.dart';
import '../../../Helpers/ModalFrave.dart';
import '../../../Helpers/ModalLoading.dart';
import '../../../Models/Home/ProductHome.dart';
import '../../../Widgets/AnimationRoute.dart';
import '../../../Widgets/CustomText.dart';
import 'AddAdminCourse.dart';

class AdminCourses extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff5f5f5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: CustomText(text: 'Manage Products', color: Colors.black),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        // height: 1.sh,
        child: Column(
          children: [
            SizedBox(height: 5.0),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    text: 'All Item list',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                  TextButton(
                      onPressed: () => Navigator.of(context).push(customRoute(
                          page: AddAdminCourse(), curved: Curves.easeInOut)),
                      child: Text(
                        "Add New Items",
                        style: TextStyle(fontSize: 15.sm),
                      ))
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 15.0, bottom: 10.0),
              child: _ListCourses(),
            ),
          ],
        ),
      ),
    );
  }
}

class _ListCourses extends StatefulWidget {
  @override
  State<_ListCourses> createState() => _ListCoursesState();
}

class _ListCoursesState extends State<_ListCourses> {
  @override
  Widget build(BuildContext context) {
    final _adminCategoryBloc = BlocProvider.of<AdminCourseBloc>(context);
    return BlocListener<AdminCourseBloc, AdminCoursestate>(
      listener: (context, state) {
        if (state is DeleteCourseLoadingState) {
          modalLoading(context, 'Deleting Item...');
        } else if (state is DeleteCoursesuccessState) {
          setState(() {});
          Navigator.of(context).pop();
          modalFrave(context, 'Item Deleted Successfully');
        } else if (state is DeleteCourseFailureState) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: CustomText(text: 'Iterm Deleting Error'),
              backgroundColor: Colors.red));
        }
      },
      child: Container(
        height: 600.sm,
        width: MediaQuery.of(context).size.width,
        child: FutureBuilder<List<Course>>(
          future: dbHomeController.getListCoursesHome(),
          builder: (context, snapshot) {
            print("This is snapsohot of Product data ${snapshot.data}");
            List<Course> list = snapshot.data;

            return !snapshot.hasData
                ? _LoadingShimmerCourses()
                : RefreshIndicator(
                    onRefresh: () async {
                      await dbHomeController.getListCoursesHome();
                      setState(() {});
                      return dbHomeController.getListCoursesHome();
                    },
                    child: ListView.builder(
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      itemCount: list.length == null ? 0 : list.length,
                      itemBuilder: (context, i) => Container(
                        margin: EdgeInsets.all(10.sm),
                        padding: EdgeInsets.symmetric(vertical: 10.sm),
                        width: 150,
                        decoration: BoxDecoration(
                            color: primaryColor.withOpacity(.1),
                            borderRadius: BorderRadius.circular(10.0)),
                        child: Center(
                          child: ListTile(
                            title: Text(
                              list[i].nameCourse,
                              style: GoogleFonts.getFont('Roboto',
                                  fontSize: 18, color: primaryColor),
                              overflow: TextOverflow.ellipsis,
                            ),
                            trailing: Container(
                              width: 100.sm,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  IconButton(
                                    splashColor:
                                        Color.fromARGB(255, 192, 118, 241),
                                    icon: Icon(
                                      Icons.edit,
                                      color: primaryColor,
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).push(customRoute(
                                          page: AddAdminCourse(
                                              isUpdate: true, course: list[i]),
                                          curved: Curves.easeInOut));
                                    },
                                  ),
                                  IconButton(
                                    splashColor:
                                        Color.fromARGB(255, 253, 154, 154),
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed: () {
                                      _adminCategoryBloc.add(
                                          DeleteCourseEvent(id: list[i].id));
                                    },
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
          },
        ),
      ),
    );
  }
}

class _LoadingShimmerCourses extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 600.sm,
      child: ListView.builder(
          itemCount: 8,
          itemBuilder: (context, index) {
            return Container(
              margin: EdgeInsets.all(10.sm),
              height: 50.sm,
              child: Shimmer.fromColors(
                baseColor: Colors.white,
                highlightColor: Color(0xFFF7F7F7),
                child: Container(
                  color: Colors.white,
                ),
              ),
            );
          }),
    );
  }
}
