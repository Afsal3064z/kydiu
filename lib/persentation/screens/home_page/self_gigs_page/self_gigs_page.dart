import 'package:flutter/material.dart';
import 'package:kydu/const/contants.dart';
import 'package:kydu/const/gap_manager.dart';
import 'package:kydu/const/text_manager.dart';
import 'package:kydu/persentation/screens/home_page/gig_list_page/gig_data_class/gig_data_class.dart';
import 'package:kydu/persentation/screens/home_page/gig_list_page/widgets/custom_gig_list.dart';
import 'package:kydu/persentation/screens/home_page/self_gigs_page/self_gig_list_controller/self_gig_controller.dart';

//This is the page where the user can see the gig post by themselves
class SelfGigPage extends StatefulWidget {
  const SelfGigPage({super.key});

  @override
  SelfGigPageState createState() => SelfGigPageState();
}

class SelfGigPageState extends State<SelfGigPage> {
  late SelfGigListController controller;

  @override
  void initState() {
    super.initState();
    controller = SelfGigListController();
    controller.fetchGigs();
  }

  @override
  Widget build(BuildContext context) {
    return _SelfGigPageContent(controller: controller);
  }
}

class _SelfGigPageContent extends StatelessWidget {
  final SelfGigListController controller;

  const _SelfGigPageContent({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Center(
          child: StreamBuilder<List<Gig>>(
            stream: controller.gigsStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
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
          ),
        ),
      ),
    );
  }

  Widget _buildGigList(List<Gig> gigs) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
}
