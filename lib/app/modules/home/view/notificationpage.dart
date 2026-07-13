import 'package:flutter/material.dart';
import 'package:veterinaryapp/app/widgets/commonwidget.dart';

class Notificationpage extends StatelessWidget {
  const Notificationpage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: VetAppBar(title:'Notifications',),
    );
  }
}
