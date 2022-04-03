import 'dart:io';

import 'package:SomanyHIL/rest/eightfolds_retrofit.dart';
import 'package:SomanyHIL/style/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:photo_view/photo_view.dart';

class ExpandedImageView extends StatelessWidget {
  static const String routeName = '/expanded_imageview';

  final String image;
  final bool refImage;

  ExpandedImageView({@required this.image, this.refImage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.black,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: PhotoView(
                imageProvider: image.contains('/')
                    ? FileImage(File(image))
                    : CachedNetworkImageProvider(
                        refImage?EightFoldsRetrofit.GET_REFERENCE_FILE_URL + image:EightFoldsRetrofit.GET_CAPTURED_FILE_URL + image,
                        cacheManager: DefaultCacheManager(),
                      ),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                    icon: Icon(
                      Icons.close,
                      size: 30,
                      color: Colors.white,
                    ),
                    onPressed: () => Navigator.pop(context)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
