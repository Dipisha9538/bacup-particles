
import '../Views/Cart/CartPage.dart';
import '../Views/Favorite/FavoritePage.dart';
import '../Views/Login/LoadingPage.dart';
import '../Views/Start/HomeScreenPage.dart';
import '../Views/Home/HomePage.dart';
import '../Views/Login/SignInPage.dart';
import '../Views/Login/SignupPage.dart';
import '../Views/Profile/ProfilePage.dart';
import 'package:flutter/material.dart';

import '../Views/Start/HomeScreenPageee.dart';

Map<String, Widget Function(BuildContext context)> routes = {

  // 'sininpage': (context) => SignInPage(),
  'loadingPage': (context) => LoadingPage(),
  'getStarted': (context) => HomeScreenPage(),
  'HomeScreenPageee': (context) => HomeScreenPageee(),
  'signInPage': (context) => SignInPage(),
  'signUpPage': (context) => SignUpPage(),
  'homePage': (context) => HomePage(),





































  // 'dashboard': (context) => Wearos_dashboard(),
  'cartPage': (context) => CartPage(),
  'favoritePage': (context) => FavoritePage(),
  'profilePage': (context) => ProfilePage(),
};
