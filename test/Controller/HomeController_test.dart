import 'package:pasell/Controller/HomeController.dart';
import 'package:pasell/Models/Home/CategoriesCourses.dart';
import 'package:pasell/Models/Home/HomeCarousel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:pasell/Models/Product/Product.dart';

import 'HomeController_test.mocks.dart';

@GenerateMocks([HomeController])
void main() {
  HomeController homeController;
  List<SliderHome> listSliderHome;
  List<Category> listCategory;
  List<Course> listCourse;
  setUpAll(() {
    homeController = MockHomeController();
    listSliderHome = [
      SliderHome(
        category: "Marketing",
        id: "1",
        image: "image.png",
        v: 1,
      ),
      SliderHome(
        category: "Coding",
        id: "2",
        image: "image.png",
        v: 2,
      ),
      SliderHome(
        category: "Programming",
        id: "3",
        image: "image.png",
        v: 3,
      ),
    ];
    listCategory = [
      Category(
        id: "1",
        category: "Marketing",
        picture: "image.png",
        status: true,
        v: 1,
      ),
      Category(
        id: "2",
        category: "Coding",
        picture: "image.png",
        status: false,
        v: 2,
      ),
      Category(
        id: "3",
        category: "Personal",
        picture: "image.png",
        status: true,
        v: 3,
      ),
    ];
    listCourse = [
      Course(
        id: "1",
        categoryId: "1",
        codeCourse: "1",
        description: "Description",
        nameCourse: "How to become flutter developer",
        picture: "image.png",
        price: 100.0,
        status: "Active",
        stock: 100,
        v: 1,
      ),
      Course(
        id: "2",
        categoryId: "2",
        codeCourse: "2",
        description: "Description",
        nameCourse: "Learn Node JS",
        picture: "image.png",
        price: 100.0,
        status: "Active",
        stock: 100,
        v: 2,
      ),
    ];
  });
  test('Getting sliders for home ...', () async {
    when(homeController.getHomeCarouselSlider())
        .thenAnswer((realInvocation) async => listSliderHome);

    List<SliderHome> result = await homeController.getHomeCarouselSlider();
    expect(result, listSliderHome);
  });
  test('Getting sliders for home unsuccessful ...', () async {
    when(homeController.getHomeCarouselSlider())
        .thenAnswer((realInvocation) async => []);

    List<SliderHome> result = await homeController.getHomeCarouselSlider();
    expect(result, []);
  });
  test('Fetching list of categories that belongs to the Courses ...', () async {
    when(homeController.getListCategoriesCourses())
        .thenAnswer((realInvocation) async => listCategory);

    List<Category> result = await homeController.getListCategoriesCourses();
    expect(result, listCategory);
  });
  test(
      'Fetching list of categories that belongs to the Courses but returns empty ...',
      () async {
    when(homeController.getListCategoriesCourses())
        .thenAnswer((realInvocation) async => []);

    List<Category> result = await homeController.getListCategoriesCourses();
    expect(result, []);
  });
}
