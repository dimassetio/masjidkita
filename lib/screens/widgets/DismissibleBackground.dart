import 'package:flutter/material.dart';
import 'package:mosq/screens/utils/MKStrings.dart';
import 'package:nb_utils/nb_utils.dart';

Widget slideRightBackground() {
  return Container(
    color: Colors.green,
    child: Align(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          20.width,
          Icon(
            Icons.edit,
            color: Colors.white,
          ),
          Text(
            mk_lbl_edit,
            style: primaryTextStyle(
              color: Colors.white,
            ),
            textAlign: TextAlign.left,
          ),
        ],
      ),
      alignment: Alignment.centerLeft,
    ),
  );
}

Widget slideLeftBackground() {
  return Container(
    color: Colors.red,
    child: Align(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Icon(
            Icons.delete,
            color: Colors.white,
          ),
          Text(
            mk_lbl_delete,
            style: primaryTextStyle(
              color: Colors.white,
            ),
            textAlign: TextAlign.right,
          ),
          20.width,
        ],
      ),
      alignment: Alignment.centerRight,
    ),
  );
}
