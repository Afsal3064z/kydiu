import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kydu/const/contants.dart';
import 'package:kydu/const/gap_manager.dart';
import 'package:kydu/const/text_manager.dart';
import 'package:kydu/persentation/screens/chat_page/chat_page.dart';
import 'package:kydu/persentation/screens/home_page/gig_list_page/widgets/custom_avatar.dart';
import 'package:kydu/persentation/screens/home_page/message_page/member_controller/member_controller.dart';
import 'package:kydu/persentation/screens/home_page/message_page/member_data/member_data.dart';

class MessagePage extends StatelessWidget {
  const MessagePage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return _MessagePageContent();
  }
}

class _MessagePageContent extends StatefulWidget {
  @override
  _MessagePageContentState createState() => _MessagePageContentState();
}

class _MessagePageContentState extends State<_MessagePageContent> {
  late MemberController controller;

  @override
  void initState() {
    super.initState();
    controller = MemberController();
    controller.fetchMembers();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Member>>(
      stream: controller.membersStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Check if the stream is in waiting state
          log('StreamBuilder is waiting...');
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          log('Error in StreamBuilder: ${snapshot.error}');
          return Text('Error: ${snapshot.error}');
        }

        final members = snapshot.data;

        if (members == null || members.isEmpty) {
          return _buildEmptyState();
        }

        return _buildMembersList(members);
      },
    );
  }

  Widget _buildMembersList(List<Member> members) {
    return ListView.builder(
      itemCount: members.length,
      itemBuilder: (context, index) {
        final member = members[index];
        return CustomMemberTile(member: member);
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          kheight20,
          kheight10,
          Image.asset("lib/assets/atm woman, atm, woman, female, person.png"),
          kheight20,
          const DefaultTitle(
            title: "You're all caught up.",
            color: mainColor,
          ),
          kheight20,
          const SubTitle(
            subtitle: "Chats with others will show up here",
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

class CustomMemberTile extends StatelessWidget {
  final Member member;

  const CustomMemberTile({
    super.key,
    required this.member,
  });

  @override
  Widget build(BuildContext context) {
    // Similar to how you did in CustomAlertTile for alerts
    return Column(
      children: [
        ListTile(
          leading: const CustomAvatar(
            radius: 40,
            childSize: 30,
          ),
          title: Text(
            member.receiver,
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
            member.createdAt,
            style: const TextStyle(color: kgrey, fontSize: 10),
          ),
          onTap: () => Get.to(() => ChatPage(
                userName: member.receiver,
                receiverId: member.reciverId,
              )),
        ),
        const Padding(
          padding: EdgeInsets.only(left: 30, right: 30, top: 0, bottom: 0),
          child: Divider(
            color: kgrey,
          ),
        )
      ],
    );
  }
}
