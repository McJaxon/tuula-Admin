import 'package:card_swiper/card_swiper.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class DashboardController extends GetxController {
  //var dashData = GetStorage().read('dashData');
  final sliderKey = GlobalKey<SliderDrawerState>();
  List<BottomNavigationBarItem> navigationBarItems = const [
    BottomNavigationBarItem(icon: Icon(CupertinoIcons.home), label: 'Dash'),
    BottomNavigationBarItem(
        icon: Icon(CupertinoIcons.doc_on_doc), label: 'Sheets')
  ];
  PageController controller = PageController();
  SwiperController cardController = SwiperController();
  late TabController tabController;
  PageController tabPageController = PageController();
  int tabCurrentPage = 0;

  var currentIndex = 0.obs;
  var currentCard = 1;

  void onTapped(index) {
    HapticFeedback.lightImpact();

    currentIndex.value = index;

    switch (index) {
      case 0:
        controller.animateToPage(0,
            duration: const Duration(milliseconds: 300), curve: Curves.ease);
        break;

      case 1:
        controller.animateToPage(1,
            duration: const Duration(milliseconds: 300), curve: Curves.ease);
        break;
      default:
    }
  }

  FlTitlesData get titlesEducationData => FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          getTextStyles: (context, value) => TextStyle(
            color: const Color(0xff7589a2),
            fontWeight: FontWeight.bold,
            fontSize: 12.sp,
          ),
          margin: 10,
          getTitles: (double value) {
            switch (value.toInt()) {
              case 0:
                return 'JAN';
              case 1:
                return 'FEB';
              case 2:
                return 'MAR';
              case 3:
                return 'APR';
              case 4:
                return 'MAY';
              case 5:
                return 'JUN';
              case 6:
                return 'JUL';
              case 7:
                return 'AUG';
              case 8:
                return 'SEPT';
              case 9:
                return 'OCT';
              case 10:
                return 'NOV';
              case 11:
                return 'DEC';
              default:
                return '';
            }
          },
        ),
        leftTitles: SideTitles(
          margin: 10,
          showTitles: true,
          getTextStyles: (context, value) => TextStyle(
            color: const Color(0xff7589a2),
            fontWeight: FontWeight.bold,
            fontSize: 12.sp,
          ),
        ),
        topTitles: SideTitles(showTitles: false),
        rightTitles: SideTitles(showTitles: false),
      );
}
