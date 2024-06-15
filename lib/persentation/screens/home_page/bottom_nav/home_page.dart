import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kydu/const/contants.dart';
import 'package:kydu/persentation/screens/login_page/login_page_controller.dart';
import 'package:kydu/persentation/screens/home_page/alerts_page/alerts_page.dart';
import 'package:kydu/persentation/screens/home_page/bottom_nav/floating_action_widget.dart';
import 'package:kydu/persentation/screens/home_page/bottom_nav/home_controller.dart';
import 'package:kydu/persentation/screens/home_page/self_gigs_page/self_gigs_page.dart';
import 'package:kydu/persentation/screens/home_page/message_page/message_page.dart';
import 'package:kydu/persentation/screens/home_page/gig_list_page/gig_list_page.dart';
import 'package:kydu/persentation/screens/profile/user_profile.dart';

class HomePage extends StatelessWidget {
  final HomeController controller = Get.put(HomeController());
  final LogInController loginController = Get.put(LogInController());

  // This is the list of title in the app bar of the app
  final List<String> pageTitles = ['Home', 'Gigs', 'Message', 'Profile'];

  // This is the list of pages in the bottom nav bar
  final List<Widget> pages = [
    const GigListPage(),
    const SelfGigPage(),
    const MessagePage(),
    const UserProfileScreen(),
  ];

  HomePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Obx(
          () {
            return Text(
              pageTitles[controller.selectedIndex.value],
              style: const TextStyle(
                color: secodaryColor,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
        actions: [
          Container(
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: kgrey, width: 0.9)),
              child: IconButton(
                  onPressed: () {
                    Get.to(() => const AlertsPage());
                  },
                  icon: const Icon(
                    Icons.notifications,
                    color: mainColor,
                  ))),

          const SizedBox(width: 16), // Add some spacing
        ],
      ),
      body: Obx(
        () {
          return pages[controller.selectedIndex.value];
        },
      ),
      bottomNavigationBar: Obx(
        () {
          //This is the bottom navigation bar in the home page
          return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      spreadRadius: 1,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: BottomNavigationBar(
                    currentIndex: controller.selectedIndex.value,
                    onTap: controller.onItemTapped,
                    selectedItemColor: mainColor,
                    unselectedItemColor: kgrey,
                    type: BottomNavigationBarType.fixed,
                    items: [
                      _buildBottomNavigationBarItem(Icons.explore, 'Home', 0),
                      _buildBottomNavigationBarItem(
                          Icons.assignment, 'Gigs', 1),
                      _buildBottomNavigationBarItem(
                        Icons.message,
                        'Message',
                        2,
                      ),
                      _buildBottomNavigationBarItem(
                          Icons.person_2_rounded, 'Profile', 3),
                    ],
                  ),
                ),
              ));
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: const FloatingActionWidget(),
    );
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem(
      IconData icon, String label, int index) {
    return BottomNavigationBarItem(
      icon: Icon(
        icon,
        size: 30,
        color: controller.selectedIndex.value == index ? mainColor : kgrey,
      ),
      label: label,
    );
  }
}
