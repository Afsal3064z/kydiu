import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kydu/const/contants.dart';
import 'package:kydu/const/gap_manager.dart';
import 'package:kydu/persentation/screens/home_page/gig_list_page/gig_data_class/gig_data_class.dart';
import 'package:kydu/persentation/screens/home_page/gig_list_page/indepth_detail_page.dart';
import 'package:kydu/persentation/screens/home_page/gig_list_page/widgets/clock_icon.dart';
import 'package:kydu/persentation/screens/home_page/gig_list_page/widgets/custom_avatar.dart';
import 'package:kydu/persentation/screens/home_page/gig_list_page/widgets/location_icon.dart';

class CustomGigTile extends StatelessWidget {
  const CustomGigTile({
    super.key,
    required this.gig,
  });

  final Gig gig;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.to(() => IndepthDetailPage(
              title: gig.title,
              category: gig.category,
              createdBy: gig.createdBy,
              time: gig.formattedCreatedAt(),
              locaiton: gig.locationName,
              description: gig.description,
              photos: gig.photos,
              offer: gig.offer.toString(),
              id: gig.id,
              userId: gig.userId,
            ));
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Container(
          decoration: BoxDecoration(
            color: kwhite,
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
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    gig.category,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: mainColor,
                        fontSize: 25),
                  ),
                  Text(
                    '\$ ${gig.offer}',
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Text(
                gig.title,
                style: const TextStyle(color: mainColor, fontSize: 25),
              ),
              Text(
                gig.description,
                style: const TextStyle(color: kgrey, fontSize: 20),
              ),
              kheight10,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      const CustomAvatar(),
                      kwidth10,
                      Text(
                        gig.createdBy.length > 5
                            ? '${gig.createdBy.substring(0, 5)}...'
                            : gig.createdBy,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: const TextStyle(color: kgrey, fontSize: 15),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const LocationIcon(
                        size: 30,
                      ),
                      kwidth10,
                      Text(
                        gig.locationName.length > 10
                            ? '${gig.locationName.substring(0, 10)}...'
                            : gig.locationName,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                        style: const TextStyle(color: kgrey, fontSize: 15),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const ClockIcon(
                        size: 30,
                      ),
                      kwidth10,
                      Text(
                        gig.formattedCreatedAt(),
                        style: const TextStyle(color: kgrey, fontSize: 15),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
