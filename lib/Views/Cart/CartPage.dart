import '../../Bloc/bloc/product_bloc.dart';
import '../../Helpers/BaseServerUrl.dart';
import '../../Helpers/Colors.dart';
import 'CheckoutPage.dart';
import '../Home/HomePage.dart';
import '../../Widgets/AnimationRoute.dart';
import 'package:flutter/material.dart';
import '../../Widgets/CustomText.dart';
import '../../Widgets/CustomButton.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final courseBloc = BlocProvider.of<CourseBloc>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          _ListCoursesCard(),
          Positioned(
            bottom: 0,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
              height: 133,
              width: size.width,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey[300],
                        blurRadius: 10,
                        spreadRadius: 5)
                  ]),
              child: Column(
                children: [
                  Padding(
                    padding:
                        EdgeInsets.only(left: 15.0, right: 15.0, top: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(
                            text: 'Total',
                            fontSize: 22,
                            fontWeight: FontWeight.w600),
                        BlocBuilder<CourseBloc, CourseState>(
                          builder: (context, state) => CustomText(
                              text: '\Rs ${state.total.toStringAsFixed(2)}',
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 18.0),
                  CustomButton(
                    color: primaryColor,
                    text: 'Checkout',
                    borderRadius: 50,
                    fontSize: 20,
                    height: 56,
                    onPressed: () {
                      if (courseBloc.course.isNotEmpty) {
                        Navigator.of(context).push(customRoute(
                            page: CheckOutPagePage(),
                            curved: Curves.easeInOut));
                      }
                    },
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _ListCoursesCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final courseBloc = BlocProvider.of<CourseBloc>(context);

    return SafeArea(
      child: Column(
        children: [
          SizedBox(height: 15.0),
          _AppBarCart(),
          SizedBox(height: 20.0),
          courseBloc.course.isEmpty ? WithoutCourses() : _DetailsCourses()
        ],
      ),
    );
  }
}

class _DetailsCourses extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final courseBloc = BlocProvider.of<CourseBloc>(context);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: Container(
        height: MediaQuery.of(context).size.height * .7,
        child: BlocBuilder<CourseBloc, CourseState>(
          builder: (context, state) => ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: state.courses.length,
            itemBuilder: (context, i) {
              return Container(
                margin: EdgeInsets.only(bottom: 20.0),
                padding: EdgeInsets.all(15.0),
                height: 150,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Color(0xffF5F5F5)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                        width: 60.w,
                        child: Image.network(
                            publicServerUrl + state.courses[i].image)),
                    SizedBox(width: 10.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 230,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                  width: 205,
                                  child: CustomText(
                                      text: state.courses[i].name,
                                      fontSize: 19,
                                      textOverflow: TextOverflow.ellipsis)),
                              GestureDetector(
                                  onTap: () => courseBloc
                                      .add(DeleteCourseToCart(index: i)),
                                  child: Icon(Icons.close,
                                      color: Colors.red, size: 25))
                            ],
                          ),
                        ),
                        SizedBox(height: 10.0),
                        CustomText(
                            text: '\Rs ${state.courses[i].price}',
                            fontSize: 22,
                            fontWeight: FontWeight.w600),
                        SizedBox(height: 20.0),
                        Container(
                          width: 230,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                child: Container(
                                  height: 35,
                                  width: 35,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10.0),
                                          bottomLeft: Radius.circular(10.0))),
                                  child:
                                      Icon(Icons.remove, color: primaryColor),
                                ),
                                onTap: () {
                                  if (state.courses[i].amount > 1) {
                                    courseBloc.add(SubtractQuantityCourseEvent(
                                        subtract: i));
                                  }
                                },
                              ),
                              Container(
                                height: 35,
                                width: 35,
                                color: Colors.white,
                                child: Center(
                                    child: CustomText(
                                        text: '${state.courses[i].amount}',
                                        fontSize: 18)),
                              ),
                              GestureDetector(
                                onTap: () async {
                                  courseBloc.add(PlusQuantityCourse(plus: i));
                                },
                                child: Container(
                                  height: 35,
                                  width: 35,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(10.0),
                                          bottomRight: Radius.circular(10.0))),
                                  child: Icon(Icons.add, color: primaryColor),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _AppBarCart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: Color(0xffF5F5F5),
                radius: 24,
                child: InkWell(
                    onTap: () => Navigator.of(context).pushReplacement(
                        customRoute(
                            page: HomePage(), curved: Curves.easeInOut)),
                    child: Icon(Icons.arrow_back_ios_rounded,
                        color: Colors.black)),
              ),
              SizedBox(width: 20.0),
              Container(
                  child: CustomText(
                      text: 'Your Cart',
                      fontSize: 24.sm,
                      fontWeight: FontWeight.w600)),
            ],
          ),
          Container(child: BlocBuilder<CourseBloc, CourseState>(
              // builder: (_, state) => CustomText(text: '${state.Courses.length} items', fontSize: 19, color: Colors.black54 ),
              builder: (_, state) {
            if (state.courses == null) {
              return CustomText(
                  text: '0 items', fontSize: 19, color: Colors.black54);
            }

            return CustomText(
                text: '${state.courses.length} items',
                fontSize: 19,
                color: Colors.black54);
          })),
        ],
      ),
    );
  }
}

class WithoutCourses extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CourseBloc, CourseState>(
        builder: (_, state) =>
            (state.courses == null || state.courses.length == 0)
                ? Container(
                    height: 270,
                    child: Column(
                      children: [
                        Icon(Icons.shopping_bag_outlined,
                            size: 90, color: primaryColor.withOpacity(.7)),
                        SizedBox(height: 20),
                        CustomText(text: 'Empty cart !!!', fontSize: 18),
                        SizedBox(height: 20),
                        CustomText(
                            text:
                                'Currently do not have any items in your Purchases cart',
                            fontSize: 16),
                        SizedBox(height: 20),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: TextButton(
                            style: ButtonStyle(
                                side: MaterialStateProperty.all(
                                    BorderSide(color: primaryColor)),
                                padding: MaterialStateProperty.all(
                                    EdgeInsets.symmetric(
                                        horizontal: 40, vertical: 10))),
                            child: CustomText(text: 'Go Home', fontSize: 10.h),
                            onPressed: () => Navigator.of(context)
                                .pushReplacement(customRoute(
                                    page: HomePage(),
                                    curved: Curves.easeInOut)),
                          ),
                        )
                      ],
                    ),
                  )
                : Container());
  }
}
