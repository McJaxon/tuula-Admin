import 'package:admin_banja/widgets/notifications.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class NotificationsController extends GetxController {
  // showNotificationModalPage(BuildContext context, Function build) {
  //   showGeneralDialog(
  //     barrierDismissible: true,
  //     barrierLabel: 'TUULA',
  //     barrierColor: Colors.black,
  //     context: context,
  //     transitionDuration: const Duration(milliseconds: 900),
  //     transitionBuilder: (context, animation, secondaryAnimation, child) {
  //       return CupertinoModalTransition(
  //         animation: animation,
  //         child: child,
  //         behindChild: build(context),
  //       );
  //     },
  //     pageBuilder: (context, animation, secondaryAnimation) {
  //       return CupertinoFullscreenDialogTransition(
  //         primaryRouteAnimation: animation,
  //         secondaryRouteAnimation: secondaryAnimation,
  //         child: const NotificationSheet(),
  //         linearTransition: false,
  //       );
  //     },
  //   );
  // }

  showNotificationModalPage(BuildContext context, Function build) {
    HapticFeedback.lightImpact();
    showCupertinoModalBottomSheet(
      context: context,
      builder: (context) {
        return const NotificationSheet();
      },
    );
  }
}
