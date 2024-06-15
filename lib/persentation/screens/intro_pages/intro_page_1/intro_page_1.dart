import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kydu/const/contants.dart';
import 'package:kydu/persentation/screens/login_page/login_page.dart';
import 'package:kydu/persentation/screens/signup_page/signup_controller.dart';
import 'package:kydu/persentation/screens/signup_page/signup_page.dart';

class IntroPage1 extends StatefulWidget {
  const IntroPage1({super.key});

  @override
  IntroPage1State createState() => IntroPage1State();
}

class IntroPage1State extends State<IntroPage1> {
  int _currentPage = 0;

  final List<Map<String, String>> slides = [
    {
      'image': 'lib/assets/undraw_collaborators_re_hont 1.png',
      'title': 'Do Something for Someone...',
      'content':
          'Kydu lets people in or around your area \ncomplete tasks for you as well as \nallows you to complete their tasks.',
    },
    {
      'image': 'lib/assets/undraw_secure_server_re_8wsq 1.png',
      'title': 'Safe and Secure Always',
      'content':
          'All runners are verified individually.\nYour privacy and safety matters a lot to us.',
    },
    {
      'image': 'lib/assets/undraw_authentication_re_svpt 1.png',
      'title': 'Welcome to Kydu',
      'content': 'Get started',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(52),
                  bottomRight: Radius.circular(52),
                ),
              ),
              height: 500,
              width: MediaQuery.of(context).size.width,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: PageView.builder(
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                  },
                  itemCount: slides.length,
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Image.asset(
                            "lib/assets/Ellipse 1.png",
                            width: 350,
                            height: 250,
                            fit: BoxFit.contain,
                          ),
                        ),
                        Stack(
                          alignment: Alignment.bottomCenter,
                          children: [
                            Positioned(
                              bottom: 0,
                              child: Image.asset(
                                slides[index]['image']!,
                                width: 350,
                                height: 250,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            Column(
              children: [
                Text(
                  slides[_currentPage]['title']!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  slides[_currentPage]['content']!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                slides.length,
                (index) => _buildDot(index),
              ),
            ),
            const SizedBox(height: 10),
            GetBuilder<SignUpController>(
              init: SignUpController(), // Initialize if required
              builder: (_) => ElevatedButton(
                  onPressed: () {
                    Get.to(() => SignUpPage());
                  },
                  style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(const Size(300, 50)),
                    fixedSize: MaterialStateProperty.all(const Size(300, 50)),
                    backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                      (Set<MaterialState> states) {
                        return states.contains(MaterialState.pressed)
                            ? secodaryColor
                            : secodaryColor;
                      },
                    ),
                  ),
                  child: const Text(
                    "Create Account",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  )),
            ),
            const SizedBox(height: 10),
            GetBuilder<SignUpController>(
              init: SignUpController(), // Initialize if required
              builder: (_) => ElevatedButton(
                onPressed: () {
                  Get.to(() => LogInPage());
                },
                style: ButtonStyle(
                  minimumSize: MaterialStateProperty.all(const Size(300, 50)),
                  fixedSize: MaterialStateProperty.all(const Size(300, 50)),
                  backgroundColor: MaterialStateProperty.resolveWith<Color?>(
                    (Set<MaterialState> states) {
                      return states.contains(MaterialState.pressed)
                          ? Colors.white
                          : Colors.white;
                    },
                  ),
                  side: MaterialStateProperty.resolveWith<BorderSide>(
                    (Set<MaterialState> states) {
                      return const BorderSide(
                        color: Colors.black,
                        width: 1.0,
                      );
                    },
                  ),
                ),
                child: const Text(
                  "Already a user? Login",
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildDot(int index) {
    return Container(
      margin: const EdgeInsets.all(4),
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _currentPage == index ? kblack : kgrey,
      ),
    );
  }
}
