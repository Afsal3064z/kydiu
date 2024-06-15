import 'package:flutter/material.dart';
import 'package:kydu/const/contants.dart';
import 'package:kydu/persentation/screens/home_page/category_page/gig_details_page/category_page/category_page.dart';

//This is the floating action button in app to post gig
class FloatingActionWidget extends StatelessWidget {
  const FloatingActionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: mainColor,
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => CategoryPage()),
        );
        // ignore: avoid_print
        print('Floating Action Button pressed');
      },
      shape: const CircleBorder(),
      child: const Icon(
        Icons.add,
        color: kwhite,
        size: 30,
      ),
    );
  }
}
