import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';


class HomePageController extends GetxController {
  final sliderKey = GlobalKey<SliderDrawerState>();
  PageController pageController = PageController();
  late AnimationController controller;
  var currentPage = 0.obs;

  List<BottomNavigationBarItem> navBarItems = const [
    BottomNavigationBarItem(
      icon: Icon(Icons.dashboard),
      label: '',
    ),
    BottomNavigationBarItem(icon: Icon(CupertinoIcons.person_solid), label: '')
  ];

  void pageSelector(index) {
    HapticFeedback.lightImpact();
    currentPage.value = index;

    switch (index) {
      case 0:
        pageController.animateToPage(0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.decelerate);

        break;

      case 1:
        pageController.animateToPage(1,
            duration: const Duration(milliseconds: 300),
            curve: Curves.decelerate);

        break;
      default:
    }
  }

  //   void _callPhone() async {
  //   const url = 'http://dmis.mglsd.go.ug/terms-of-use';

  //   if (await launchUrl(url)) {
  //     await launchUrl(url);
  //   } else {
  //     throw 'Could not launch $url';
  //   }
  // }



}
