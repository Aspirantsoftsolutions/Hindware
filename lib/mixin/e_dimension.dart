import 'package:SomanyHIL/style/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

mixin EDimension {
  double getWidthAsPerScreenRatio(BuildContext context, double ratio) {
    return (MediaQuery.of(context).size.width * ratio) / 100;
  }

  double getHeightAsPerScreenRatio(BuildContext context, double ratio) {
    return (MediaQuery.of(context).size.height * ratio) / 100;
  }

  BoxDecoration getOrangeButtonBg(BuildContext context) {
    return BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerRight,
          end: Alignment.centerLeft,
          colors: [
            const Color(0xFFEF4136),
            const Color(0xFFF46B29),
            const Color(0xFFF8931D),
          ],
        ),
        borderRadius: BorderRadius.all(Radius.circular(3.0)));
  }

  BoxDecoration getBlackButtonBg(BuildContext context) {
    return BoxDecoration(
        color: AppColor.textBlack,
        borderRadius: BorderRadius.all(Radius.circular(3.0)));
  }

  Color getStatusColor(String fgStatusCode) {
    Color color = AppColor.red.withOpacity(0.8);
    if (fgStatusCode == 'orange') {
      color = AppColor.orange.withOpacity(0.8);
    } else if (fgStatusCode == 'green') {
      color = Colors.green.withOpacity(0.8);
    }
    return color;
  }
}
