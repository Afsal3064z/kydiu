// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:kydu/const/contants.dart';
import 'package:kydu/const/gap_manager.dart';
import 'package:kydu/const/text_manager.dart';
import 'package:kydu/persentation/screens/home_page/alerts_page/alerts_controller/alerts_controller.dart';

class AlertsPage extends StatelessWidget {
  const AlertsPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return _AlertsPageContent();
  }
}

class _AlertsPageContent extends StatefulWidget {
  @override
  _AlertsPageContentState createState() => _AlertsPageContentState();
}

class _AlertsPageContentState extends State<_AlertsPageContent> {
  late AlertController controller;

  @override
  void initState() {
    super.initState();
    controller = AlertController();
    controller.fetchAlerts();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Alert>>(
      stream: controller.alertsStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        final alerts = snapshot.data;

        if (alerts == null || alerts.isEmpty) {
          return _buildEmptyState();
        }

        return _buildAlertList(alerts);
      },
    );
  }

  Widget _buildAlertList(List<Alert> alerts) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: kgrey, width: 0.9),
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_rounded),
              onPressed: () {
                Get.back();
              },
            ),
          ),
        ),
        title: const Center(
          child: Text(
            "Notification",
            style: TextStyle(
                color: secodaryColor,
                fontSize: 20,
                fontWeight: FontWeight.w600),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    kwidth10,
                    const Text(
                      'Recent',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    kwidth10,
                    Container(
                      width: 30,
                      height: 30,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: mainColor),
                      child: Center(
                          child: Text(
                        '${alerts.length}',
                        style: const TextStyle(
                            color: kwhite,
                            fontSize: 15,
                            fontWeight: FontWeight.bold),
                      )),
                    )
                  ],
                ),
                TextButton(
                    onPressed: () {
                      // Need to implement the function to clear the list of alerts
                    },
                    child: const Text(
                      'Clear All',
                      style: TextStyle(
                          color: mainColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ))
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: alerts.length,
              itemBuilder: (context, index) {
                final alert = alerts[index];
                return CustomAlertTile(alert: alert);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          kheight20,
          kheight10,
          Image.asset("lib/assets/computer man, computer, man, workspace.png"),
          kheight20,
          const DefaultTitle(
            title: "No alerts available at this time.",
            color: mainColor,
          ),
          kheight20,
          const SubTitle(
            subtitle: "Any important alerts will appear here.",
            color: kgrey,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}

class CustomAlertTile extends StatelessWidget {
  final Alert alert;

  const CustomAlertTile({
    super.key,
    required this.alert,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: const CircleAvatar(
            radius: 44,
            backgroundColor: secodaryColor,
            child: Icon(
              Icons.message_rounded,
              color: kwhite,
              size: 22,
            ),
          ),
          title: Text(
            alert.title,
            style: const TextStyle(
                color: secodaryColor,
                fontSize: 15,
                fontWeight: FontWeight.w500),
          ),
          subtitle: const Text(
            "Tap to see the message",
            style: TextStyle(color: kgrey, fontSize: 15),
          ),
          trailing: Text(
            alert.timeAgo(),
            style: const TextStyle(color: kgrey, fontSize: 10),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(left: 30, right: 30),
          child: Divider(
            color: kgrey,
          ),
        )
      ],
    );
  }
}
