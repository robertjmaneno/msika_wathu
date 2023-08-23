import 'package:flutter/material.dart';
import 'package:msika_wathu/views/buyer/nav_screens/widgets/banner_widget.dart';
import 'package:msika_wathu/views/buyer/nav_screens/widgets/featured_category.dart';
import 'package:msika_wathu/views/buyer/nav_screens/widgets/search_input_widget.dart';
import 'package:msika_wathu/views/buyer/nav_screens/widgets/welcome_text_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color.fromARGB(255, 229, 227, 227),
        body: LayoutBuilder(
          builder: (context, constraints) {
            // Get the device screen width
            double screenWidth = constraints.maxWidth;

            // Determine the font size based on the device screen width
            double fontSize = screenWidth < 600 ? 18 : 20;

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Start of welcome text
                  WelcomeText(fontSize: fontSize),

                  // Start of search field
                  const SizedBox(height: 15),
                  const SearchInputWidget(),

                  // Start of Banner screen
                  const SizedBox(height: 2),
                  const BannerWidget(),
                  //featured category
                  const SizedBox(
                    height: 6,
                  ),
                  const FeaturedCategory(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
