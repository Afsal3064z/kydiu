import 'package:flutter/material.dart';
import 'package:kydu/const/contants.dart';
import 'package:kydu/const/gap_manager.dart';
import 'package:kydu/const/text_manager.dart';
import 'package:kydu/persentation/screens/home_page/gig_list_page/gig_data_class/gig_data_class.dart';
import 'package:kydu/persentation/screens/home_page/gig_list_page/gig_list_controller/gig_list_controller.dart';
import 'package:kydu/persentation/screens/home_page/gig_list_page/widgets/custom_gig_list.dart';

class GigListPage extends StatelessWidget {
  const GigListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _GigListPageContent();
  }
}

class _GigListPageContent extends StatefulWidget {
  @override
  _GigListPageContentState createState() => _GigListPageContentState();
}

class _GigListPageContentState extends State<_GigListPageContent> {
  late GigListController controller;

  @override
  void initState() {
    super.initState();
    controller = GigListController();
    controller.fetchGigs();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Gig>>(
      stream: controller.gigsStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator()); // Loading state
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        final gigs = snapshot.data;

        if (gigs == null || gigs.isEmpty) {
          return _buildEmptyState();
        }

        return _buildGigList(gigs);
      },
    );
  }

  Widget _buildGigList(List<Gig> gigs) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                'Welcome back,',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: kgrey,
                ),
              ),
              Text(
                'have a great day',
                style: TextStyle(fontSize: 20, color: kgrey),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: gigs.length,
            itemBuilder: (context, index) {
              final gig = gigs[index];
              return CustomGigTile(gig: gig);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        kheight20,
        kheight10,
        Image.asset(
            "lib/assets/paper airplane woman, paper, airplane, woman.png"),
        kheight20,
        const DefaultTitle(
          title: "No gigs available at this time.",
          color: mainColor,
        ),
        kheight20,
        const SubTitle(
          subtitle:
              "The gigs posted by the user will appear here after fetching.",
          color: kgrey,
        ),
      ],
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
