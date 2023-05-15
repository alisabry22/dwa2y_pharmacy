

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class EnlargePhoto extends StatelessWidget {
 final String photoUrl;
 final String tag;
  const EnlargePhoto({super.key,required this.photoUrl,required this.tag});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width*0.8,
      height: MediaQuery.of(context).size.height*0.8,
      child: Hero(tag: tag, child: CachedNetworkImage(imageUrl: photoUrl,)),
    );
  }
}