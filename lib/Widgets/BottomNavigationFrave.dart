import 'package:pasell/Views/Profile/Shopping/ShoppingPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../Helpers/Colors.dart';
import '../Views/Cart/CartPage.dart';
import '../Views/Favorite/FavoritePage.dart';
import '../Views/Home/HomePage.dart';
import '../Views/Profile/ProfilePage.dart';
import 'AnimationRoute.dart';

class BottomNavigationFrave extends StatelessWidget {
  final int index;
  final bool showMenu;

  BottomNavigationFrave({@required this.index, this.showMenu = true});

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: Duration(milliseconds: 250),
      opacity: (showMenu) ? 1 : 0,
      child: Container(
        height: 60,
        width: 380,
        decoration: BoxDecoration(
            color: Color.fromARGB(255, 244, 243, 242),
            borderRadius: BorderRadius.circular(15.0),
            boxShadow: [
              BoxShadow(
                  color: Color.fromARGB(96, 146, 15, 15),
                  blurRadius: 10,
                  spreadRadius: -5)
            ]),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          _ItemsButton(
              i: 0,
              index: index,
              svg: 'Assets/home.svg',
              activeSvg: 'Assets/home-selected.svg',
              onPressed: () => Navigator.push(context,
                  customRoute(page: HomePage(), curved: Curves.easeInOut))),
          _ItemsButton(
              i: 1,
              index: index,
              icon: Icons.favorite_outline_rounded,
              isIcon: true,
              activeIcon: Icons.favorite_rounded,
              onPressed: () => Navigator.push(context,
                  customRoute(page: FavoritePage(), curved: Curves.easeInOut))),
          _ItemsButton(
              i: 2,
              index: index,
              svg: 'Assets/bolso.svg',
              center: true,
              activeSvg: 'Assets/bolso-selected.svg',
              onPressed: () => Navigator.pushReplacement(context,
                  customRoute(page: CartPage(), curved: Curves.easeInOut))),
          _ItemsButton(
            i: 3,
            index: index,
            icon: Icons.shopping_bag_outlined,
            isIcon: true,
            activeIcon: Icons.shopping_bag,
            onPressed: () => Navigator.push(context,
                customRoute(page: PurchasesPage(), curved: Curves.easeInOut)),
          ),
          _ItemsButton(
              i: 4,
              index: index,
              icon: Icons.person_outline_rounded,
              isIcon: true,
              activeIcon: Icons.person,
              onPressed: () => Navigator.push(context,
                  customRoute(page: ProfilePage(), curved: Curves.easeInOut))),
        ]),
      ),
    );
  }
}

class _ItemsButton extends StatelessWidget {
  final IconData icon;
  final String svg;
  final bool isIcon;
  final bool center;
  final Function onPressed;
  final IconData activeIcon;
  final String activeSvg;
  final int index;
  final int i;

  _ItemsButton(
      {this.i,
      this.index,
      this.icon,
      this.svg,
      this.center = false,
      this.isIcon = false,
      this.onPressed,
      this.activeIcon,
      this.activeSvg});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onPressed,
        child: center
            ? CircleAvatar(
                backgroundColor: primaryColor,
                radius: 26,
                child: SvgPicture.asset(i == index ? activeSvg : svg,
                    height: 26, color: Color.fromARGB(255, 167, 78, 78)),
              )
            : isIcon
                ? Icon(i == index ? activeIcon : icon,
                    size: 30,
                    color: i == index
                        ? primaryColor
                        : Color.fromARGB(255, 179, 28, 28))
                : SvgPicture.asset(i == index ? activeSvg : svg,
                    height: 26,
                    color: i == index
                        ? primaryColor
                        : Color.fromARGB(255, 182, 39, 39)));
  }
}
