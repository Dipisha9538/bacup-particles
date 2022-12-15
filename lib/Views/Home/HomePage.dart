import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pasell/Helpers/ModalAddCart.dart';
import 'package:proximity_sensor/proximity_sensor.dart';
import 'package:shake/shake.dart';
import 'package:shimmer/shimmer.dart';

import '../../Bloc/Auth/auth_bloc.dart';
import '../../Bloc/General/general_bloc.dart';
import '../../Bloc/bloc/product_bloc.dart';
import '../../Controller/HomeController.dart';
import '../../Helpers/BaseServerUrl.dart';
import '../../Helpers/Colors.dart';
import '../../Models/Home/CategoriesCourses.dart';
import '../../Models/Home/HomeCarousel.dart';
import '../../Models/Home/ProductHome.dart';
import '../../Models/Product.dart';
import '../../Widgets/AnimationRoute.dart';
import '../../Widgets/BottomNavigationFrave.dart';
import '../../Widgets/CustomText.dart';
import '../Cart/CartPage.dart';
import '../Categories/CategoriesPage.dart';
import '../Products/DetailsProductPage.dart';
import '../Start/HomeScreenPage.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ShakeDetector detector;
  bool _isNear = false;
  StreamSubscription<dynamic> _streamSubscription;

  @override
  void initState() {
    // Shake
    detector = ShakeDetector.autoStart(
      onPhoneShake: () {
        return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text("Log Out"),
              content: Text("Are you sure, want to log out?"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "CANCEL",
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    BlocProvider.of<AuthBloc>(context).add(LogOutEvent());
                  },
                  child: Text("LOG OUT"),
                ),
              ],
            );
          },
        );
      },
    );
    listenProximitySensor();
    super.initState();
  }

  Future<void> listenProximitySensor() async {
    FlutterError.onError = (FlutterErrorDetails details) {
      if (foundation.kDebugMode) {
        FlutterError.dumpErrorToConsole(details);
      }
    };
    _streamSubscription = ProximitySensor.events.listen((int event) {
      setState(() {
        _isNear = (event > 0) ? true : false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      body: Stack(
        children: [
          BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is LogOutState) {
                Navigator.pushReplacement(
                  context,
                  customRoute(page: HomeScreenPage(), curved: Curves.easeInOut),
                );
              }
            },
            child: _isNear ? CartPage() : ListHome(),
          ),
          Positioned(
            bottom: 10,
            child: Container(
              width: size.width,
              child: Align(
                child: BlocBuilder<GeneralBloc, GeneralState>(
                  builder: (context, state) => BottomNavigationFrave(
                      index: 0, showMenu: state.showMenuHome),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ListHome extends StatefulWidget {
  @override
  _ListHomeState createState() => _ListHomeState();
}

class _ListHomeState extends State<ListHome> {
  ScrollController scrollControllerHome = ScrollController();
  double scrollPrevious = 0;

  @override
  void initState() {
    scrollControllerHome.addListener(() {
      if (scrollControllerHome.offset > scrollPrevious) {
        BlocProvider.of<GeneralBloc>(context, listen: false)
            .add(OnShowHideMenuHome(showMenu: false));
      } else {
        BlocProvider.of<GeneralBloc>(context, listen: false)
            .add(OnShowHideMenuHome(showMenu: true));
      }

      scrollPrevious = scrollControllerHome.offset;
    });

    super.initState();
  }

  @override
  void dispose() {
    scrollControllerHome.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authBlocState = BlocProvider.of<AuthBloc>(context).state;

    return SafeArea(
      child: Container(
        child: ListView(
          controller: scrollControllerHome,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FadeInLeft(
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 15,
                            backgroundColor: primaryColor,
                            child: CustomText(
                              text: authBlocState.username
                                  .substring(0, 2)
                                  .toUpperCase(),
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 104, 93, 93),
                            ),
                          ),
                          SizedBox(width: 5.0),
                          CustomText(
                            text: authBlocState.username,
                            fontSize: 18,
                          )
                        ],
                      ),
                    ),
                    InkWell(
                      borderRadius: BorderRadius.circular(20.0),
                      onTap: () => Navigator.of(context).pushReplacement(
                          customRoute(
                              page: CartPage(), curved: Curves.easeInOut)),
                      child: Stack(
                        children: [
                          FadeInRight(
                            child: Container(
                              height: 32,
                              width: 32,
                              child: SvgPicture.asset('Assets/bolso-negro.svg',
                                  height: 25),
                            ),
                          ),
                          Positioned(
                            left: 0,
                            top: 12,
                            child: FadeInDown(
                              child: Container(
                                height: 20,
                                width: 20,
                                decoration: BoxDecoration(
                                    color: primaryColor,
                                    shape: BoxShape.circle),
                                child: Center(
                                  child: BlocBuilder<CourseBloc, CourseState>(
                                    builder: (context, state) =>
                                        state.amount == 0
                                            ? CustomText(
                                                text: '0',
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold)
                                            : CustomText(
                                                text: '${state.courses.length}',
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 15.0, top: 0.0, right: 10.0),
              child: _CarCarousel(),
            ),
            SizedBox(height: 5.0),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    text: 'Categories',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).push(customRoute(
                        page: CategoriesPage(), curved: Curves.easeInOut)),
                    child: Row(
                      children: [
                        SizedBox(width: 5.0),
                        Icon(Icons.arrow_forward_ios_rounded,
                            size: 18, color: primaryColor)
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 15.0, bottom: 10.0),
              child: _ListCategories(),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CustomText(
                    text: 'Products',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                  Row(
                    children: [
                      SizedBox(width: 5.0),
                      GestureDetector(
                        onTap: () => Navigator.of(context).push(
                          customRoute(
                              page: CategoriesPage(), curved: Curves.easeInOut),
                        ),
                        child: Row(
                          children: [
                            SizedBox(width: 5.0),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 18,
                              color: primaryColor,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
              child: _ListCourses(),
            )
          ],
        ),
      ),
    );
  }
}

class _ListCourses extends StatelessWidget {
  Course course;
  // _ListCourses({@required this.course});

  @override
  Widget build(BuildContext context) {
    final courseBloc = BlocProvider.of<CourseBloc>(context);
    return FutureBuilder<List<Course>>(
      future: dbHomeController.getListCoursesHome(),
      builder: (context, snapshot) {
        List<Course> list = snapshot.data;
        print("$list, this is snapshot of data");
        return !snapshot.hasData
            ? _LoadingShimmerCourses()
            : GridView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 25,
                    mainAxisSpacing: 20,
                    mainAxisExtent: 220),
                itemCount: list.length == null ? 0 : list.length,
                itemBuilder: (context, i) => Container(
                  // padding: EdgeInsets.only(top: 0, bottom: 40),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 238, 235, 235),
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (_) => DetailsCoursePage(course: list[i]))),
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                            height: MediaQuery.of(context).size.width * 0.3,
                            width: double.infinity,
                            // height: 140,
                            // width: 300,
                            child: Container(
                              height: MediaQuery.of(context).size.width * 0.3,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.0),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  scale: 2.0,
                                  image: NetworkImage(
                                      publicServerUrl + list[i].picture),
                                ),
                              ),
                            )),
                        // Divider(),
                        // Container(
                        //   child: Hero(
                        //       tag: list[i].id,
                        //       child: Image.network(
                        //         publicServerUrl + list[i].picture,
                        //         height: 150,
                        //         fit: BoxFit.cover,
                        //       )),
                        // ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // SizedBox(
                            //   height: 10,
                            // ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 5, right: 0, bottom: 0, top: 7),
                              child: Text(
                                list[i].nameCourse,
                                style: GoogleFonts.getFont('Roboto',
                                    fontSize: 19, fontWeight: FontWeight.w400),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 5, right: 00, bottom: 0, top: 7),
                              child: CustomText(
                                text: '\Rs ${list[i].price}',
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 115, bottom: 10, top: 0),
                                  child: GestureDetector(
                                    onTap: () async {
                                      modalAddCartSuccess(
                                          context, course.picture);

                                      final Courseselect = CourseCart(
                                          uidCourse: course.id,
                                          image: course.picture,
                                          name: course.nameCourse,
                                          price: course.price.toDouble(),
                                          amount: 1);

                                      courseBloc.add(AddCourseToCart(
                                          course: Courseselect));
                                      await Future.delayed(
                                          Duration(seconds: 2));
                                      Navigator.pop(context);
                                    },
                                    child: SizedBox(
                                      width: 40,
                                      // width: 300,
                                      height: 40,
                                      child: SvgPicture.asset(
                                        'Assets/cartt.svg',
                                        height: 60,
                                        // color: Colors.blue,
                                      ),
                                      // fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
      },
    );
  }
}

class _ListCategories extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: MediaQuery.of(context).size.width,
      child: FutureBuilder<List<Category>>(
        future: dbHomeController.getListCategoriesCourses(),
        builder: (context, snapshot) {
          List<Category> list = snapshot.data;

          return !snapshot.hasData
              ? _LoadingShimmerCategories()
              : ListView.builder(
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: list.length == null ? 0 : list.length,
                  itemBuilder: (context, i) => Container(
                    margin: EdgeInsets.only(right: 8.0),
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    width: 150,
                    decoration: BoxDecoration(
                        color: primaryColor.withOpacity(.1),
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Center(
                      child: Text(
                        list[i].category,
                        style: GoogleFonts.getFont('Roboto',
                            fontSize: 18, color: primaryColor),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                );
        },
      ),
    );
  }
}

class _CarCarousel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 190,
      width: MediaQuery.of(context).size.width,
      child: FutureBuilder<List<SliderHome>>(
          future: dbHomeController.getHomeCarouselSlider(),
          builder: (context, snapshot) {
            List<SliderHome> silerHome = snapshot.data;

            return !snapshot.hasData
                ? _LoadingShimmerCarosusel()
                : PageView.builder(
                    itemCount: silerHome.length,
                    itemBuilder: (context, i) {
                      return Container(
                        margin: EdgeInsets.only(right: 10.0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15.0),
                            image: DecorationImage(
                                fit: BoxFit.fill,
                                image: NetworkImage(
                                    publicServerUrl + silerHome[i].image))),
                      );
                    },
                  );
          }),
    );
  }
}

class _LoadingShimmerCourses extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
        baseColor: Colors.white,
        highlightColor: Color.fromARGB(255, 248, 245, 245),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: 250,
              width: 140,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.0)),
            ),
            Container(
              height: 250,
              width: 190,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15.0)),
            ),
          ],
        ));
  }
}

class _LoadingShimmerCategories extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.white,
      highlightColor: Color(0xFFF7F7F7),
      child: Container(
        color: Colors.white,
      ),
    );
  }
}

class _LoadingShimmerCarosusel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Color.fromARGB(255, 184, 11, 11),
      highlightColor: Color.fromARGB(255, 214, 2, 2),
      child: Container(
        decoration: BoxDecoration(
            color: Color.fromARGB(255, 204, 14, 14),
            borderRadius: BorderRadius.circular(15.0)),
      ),
    );
  }
}
