import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path_provider/path_provider.dart';

class EImage {
  static CachedNetworkImage loadImage(
      {@required String imageUrl,
      String placeholder,
      String errorPlaceHolder}) {
    if (errorPlaceHolder == null && placeholder != null) {
      errorPlaceHolder = placeholder;
    }
    return CachedNetworkImage(
      fit: BoxFit.cover,
      imageUrl: imageUrl ?? '',
      placeholder: (context, url) => placeholder != null
          ? Image(fit: BoxFit.cover, image: AssetImage(placeholder))
          : null,
      errorWidget: (context, url, error) => errorPlaceHolder != null
          ? Image(fit: BoxFit.cover, image: AssetImage(errorPlaceHolder))
          : null,
    );
  }

  static CachedNetworkImage loadImageWithGradient(
      {@required String imageUrl,
      String placeholder,
      String errorPlaceHolder}) {
    if (errorPlaceHolder == null && placeholder != null) {
      errorPlaceHolder = placeholder;
    }
    return CachedNetworkImage(
      imageUrl: imageUrl,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: <Color>[Colors.white24,Colors.transparent]),
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
            // colorFilter: ColorFilter.mode(Colors.red, BlendMode.colorBurn),
          ),
        ),
      ),
      placeholder: (context, url) => placeholder != null
          ? Image(fit: BoxFit.cover, image: AssetImage(placeholder))
          : null,
      errorWidget: (context, url, error) => errorPlaceHolder != null
          ? Image(fit: BoxFit.cover, image: AssetImage(errorPlaceHolder))
          : null,
    );
  }

  static CachedNetworkImage loadCircularImage(
      {@required String imageUrl,
      String placeholder,
      String errorPlaceHolder,
      bool showBorder}) {
    if (errorPlaceHolder == null && placeholder != null) {
      errorPlaceHolder = placeholder;
    }
    return CachedNetworkImage(
      imageUrl: imageUrl,
      imageBuilder: (context, imageProvider) => Container(
        decoration: BoxDecoration(
          borderRadius: new BorderRadius.all(new Radius.circular(50.0)),
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
            // colorFilter: ColorFilter.mode(Colors.red, BlendMode.colorBurn),
          ),
          border: showBorder == true
              ? new Border.all(
                  color: Colors.red,
                  width: 1.0,
                )
              : null,
        ),
      ),
      placeholder: (context, url) => placeholder != null
          ? Image(fit: BoxFit.contain, image: AssetImage(placeholder))
          : null,
      errorWidget: (context, url, error) => errorPlaceHolder != null
          ? Image(fit: BoxFit.contain, image: AssetImage(errorPlaceHolder))
          : null,
    );
  }

  static SvgPicture getSvgImage(String fileName, {Color fColor}) {
    // 'assets/images/students-menus.svg'
    return SvgPicture.asset(
      'assets/images/$fileName',
      color: fColor,

    );
  }

  static String getImagePath(String fileName) {
    return 'assets/images/$fileName';
  }

  static Future<dynamic> readFileAsync() async {
    // String xmlString = await rootBundle.loadString(filePath);
    final data = await rootBundle.load("assets/images/detail_top_bg.png");
    final buffer = data.buffer;
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    var filePath =
        tempPath + '/file_01.png'; // file_01.tmp is dump file, can be anything
    await File(filePath).writeAsBytes(
        buffer.asUint8List(data.offsetInBytes, data.lengthInBytes));
    return filePath;
  }
}
