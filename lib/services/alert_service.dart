import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class AlertService {
  void showSignOut(BuildContext context, String title, String desc,
      Function onSignout, Function onCancel) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) => new CupertinoAlertDialog(
              title: new Text("$title"),
              content: new Text("$desc"),
              actions: <Widget>[
                FlatButton(
                  child: Text(
                    "YES",
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                  ),
                  onPressed: onSignout,
                ),
                FlatButton(
                  child: Text(
                    "NO",
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                  ),
                  onPressed: onCancel,
                )
              ],
            ));
  }

  void showSuccess(
      BuildContext context, String title, String desc, Function onCancel) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) => new CupertinoAlertDialog(
              title: new Text("$title"),
              content: new Text("$desc"),
              actions: <Widget>[
                FlatButton(
                  child: Text(
                    "Done",
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                  ),
                  onPressed: onCancel
                ),
              ],
            ));
  }

  void showError(
      BuildContext context, String title, String desc, Function onCancel) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) => new CupertinoAlertDialog(
              title: new Text("$title"),
              content: new Text("$desc"),
              actions: <Widget>[
                FlatButton(
                  child: Text(
                    "DONE",
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                  ),
                  onPressed: onCancel,
                )
              ],
            )
    );
  }

  void showWarning(
      BuildContext context, String title, String desc, Function onCancel) {
    showCupertinoDialog(
        context: context,
          builder: (BuildContext context) => new CupertinoAlertDialog(
              title: new Text("$title"),
              content: new Text("$desc"),
              actions: <Widget>[
                FlatButton(
                  child: Text(
                    "DONE",
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                  ),
                  onPressed: onCancel,
                )
              ],
            ));
  }
}
