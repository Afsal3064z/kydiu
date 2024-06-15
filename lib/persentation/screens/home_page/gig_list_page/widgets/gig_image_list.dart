import 'package:flutter/material.dart';

class GigImageList extends StatelessWidget {
  const GigImageList({
    super.key,
    required this.photos,
  });

  final List<String>? photos;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: photos?.map((photoPath) {
            // Check if the photoPath already contains the scheme (http/https)
            final imageUrl = photoPath.startsWith('http')
                ? photoPath // If it already contains the scheme, use as is
                : 'http://10.0.2.2:3000/uploads/gigs/$photoPath';
    
            return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Image.network(
                    imageUrl,
                    width: 400,
                    height: 250,
                    fit: BoxFit
                        .fill, // Use BoxFit.cover to maintain aspect ratio
                  ),
                ));
          }).toList() ??
          [],
    );
  }
}