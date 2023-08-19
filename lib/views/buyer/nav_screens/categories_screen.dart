import 'package:flutter/material.dart';
import 'package:msika_wathu/views/buyer/nav_screens/widgets/app_bar.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 214, 211, 211),
        body: Column(
          children: [
            AppBarWidget(title: 'Categories'),
          ],
        ),
      ),
    );
  }
}
