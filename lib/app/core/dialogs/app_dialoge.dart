// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:innsouls_flutter/app/common/dialogs/app_dialog_widgets.dart';
//
// class AppDialogs {
//   static networkErrorDialog() => show(title: 'No internet connection', message: '');
//
//   static somethingWentWrong({String? message}) => show(title: 'Somthing went wrong', message: message ?? 'Please try again');
//
//   static Future show<T>(
//       {String? title,
//         String? message,
//         VoidCallback? onClickPositive,
//         VoidCallback? onClickNegative,
//         String? positiveButtonText,
//         String? negativeButtonText,
//         String? dialogId,
//         String? iconPath,
//         bool isDismissible = false}) async {
//     await Get.dialog<T>(
//       DialogWidget(
//         title: title,
//         message: message,
//         onClickNegative: onClickNegative,
//         onClickPositive: onClickPositive,
//         negativeButtonText: negativeButtonText,
//         positiveButtonText: positiveButtonText,
//         iconPath: iconPath,
//       ),
//       barrierDismissible: isDismissible,
//       name: dialogId,
//     );
//   }
//
//   static confirmLogout() {
//     show(
//         title: "Confirm Logout",
//         message: "Are you sure want to logout?",
//         positiveButtonText: "Logout",
//         negativeButtonText: "Back",
//         onClickPositive: () {});
//   }
// }