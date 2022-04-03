import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';

class MyDialog {
  static ProgressDialog showProgressDialog(BuildContext context) {
    var pr = ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      isDismissible: false,

      /// your body here
      customBody: new Container(
        width: 70.0,
        height: 70.0,
        child: new Padding(
            padding: const EdgeInsets.all(5.0),
            child: new Center(child: new CircularProgressIndicator())),
      ),
    );
    pr.style(
      backgroundColor: Colors.transparent,
      elevation: 0,
    );
    pr.show();
    return pr;
  }
}
