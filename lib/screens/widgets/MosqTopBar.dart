import 'package:flutter/material.dart';
import 'package:mosq/main.dart';
import 'package:mosq/main/utils/AppWidget.dart';
import 'package:mosq/screens/utils/MKConstant.dart';
import 'package:nb_utils/nb_utils.dart';

class MosqTopBar extends StatefulWidget {
  var titleName;

  MosqTopBar(var this.titleName);

  @override
  State<StatefulWidget> createState() {
    return MosqTopBarState();
  }
}

class MosqTopBarState extends State<MosqTopBar> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        height: 60,
        width: MediaQuery.of(context).size.width,
        color: appStore.appBarColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.arrow_back),
              color: appStore.iconColor,
              onPressed: () {
                finish(context);
              },
            ),
            Center(
              child: text(
                widget.titleName,
                fontFamily: fontBold,
                textColor: appStore.textPrimaryColor,
                fontSize: textSizeLargeMedium,
              ),
            ),
            // SvgPicture.network(
            //         "https://upload.wikimedia.org/wikipedia/commons/0/0b/Search_Icon.svg",
            //         color: appStore.iconColor)
            //     .paddingOnly(right: 16),
          ],
        ),
      ),
    );
  }
}
