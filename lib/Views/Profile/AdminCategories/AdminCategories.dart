import '../../../Bloc/Admin/AdminCategoryBloc/admin_category_bloc.dart';
import '../../../Controller/HomeController.dart';
import '../../../Helpers/Colors.dart';
import '../../../Helpers/ModalFrave.dart';
import '../../../Helpers/ModalLoading.dart';
import '../../../Models/Home/CategoriesCourses.dart';
import 'AddAdminCategory.dart';
import '../../../Widgets/AnimationRoute.dart';
import '../../../Widgets/CustomText.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shimmer/shimmer.dart';

class AdminCategories extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff5f5f5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: CustomText(text: 'Manage Categories', color: Colors.black),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        height: 800.sm,
        child: Column(
          children: [
            SizedBox(height: 5.0),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    text: 'All Categories',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                  TextButton(
                      onPressed: () => Navigator.of(context).push(customRoute(
                          page: AddAdminCategory(), curved: Curves.easeInOut)),
                      child: Text(
                        "Add",
                        style: TextStyle(fontSize: 15.sm),
                      ))
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 15.0, bottom: 10.0),
              child: _ListCategories(),
            ),
          ],
        ),
      ),
    );
  }
}

class _ListCategories extends StatefulWidget {
  @override
  State<_ListCategories> createState() => _ListCategoriesState();
}

class _ListCategoriesState extends State<_ListCategories> {
  @override
  Widget build(BuildContext context) {
    final _adminCategoryBloc = BlocProvider.of<AdminCategoryBloc>(context);
    return BlocListener<AdminCategoryBloc, AdminCategoryState>(
      listener: (context, state) {
        if (state is DeleteCategoryLoadingState) {
          modalLoading(context, 'Deleting Category...');
        } else if (state is DeleteCategorySuccessState) {
          setState(() {});
          Navigator.of(context).pop();
          modalFrave(context, 'Category Deleted Successfully');
        } else if (state is DeleteCategoryFailureState) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: CustomText(text: 'Error Deleting Category'),
              backgroundColor: Colors.red));
        }
      },
      child: Container(
        height: 600.sm,
        width: MediaQuery.of(context).size.width,
        child: FutureBuilder<List<Category>>(
          future: dbHomeController.getListCategories(),
          builder: (context, snapshot) {
            List<Category> list = snapshot.data;

            return !snapshot.hasData
                ? _LoadingShimmerCategories()
                : RefreshIndicator(
                    onRefresh: () async {
                      await dbHomeController.getListCategories();
                      setState(() {});
                      return dbHomeController.getListCategories();
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
                            color: primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10.0)),
                        child: Center(
                          child: ListTile(
                            title: Text(
                              list[i].category,
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
                                        Color.fromARGB(255, 211, 158, 255),
                                    icon: Icon(
                                      Icons.edit,
                                      color: primaryColor,
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).push(customRoute(
                                          page: AddAdminCategory(
                                              isUpdate: true,
                                              category: list[i].category,
                                              id: list[i].id),
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
                                          DeleteCategoryEvent(id: list[i].id));
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

class _LoadingShimmerCategories extends StatelessWidget {
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
