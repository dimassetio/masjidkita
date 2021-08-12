import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:mosq/main.dart';
import 'package:mosq/main/utils/AppWidget.dart';
import 'package:mosq/main/utils/AppConstant.dart';
import 'package:mosq/integrations/controllers.dart';

class DetailsPage extends StatelessWidget {
  const DetailsPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
        kegiatanC.kegiatan.nama ?? '',
        style: primaryTextStyle(),
      )),
      body: ListView(
        children: [
          // Image.network(SampleImageUrl, fit: BoxFit.cover),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Title', style: primaryTextStyle(size: 30)),
                const SizedBox(height: 10),
                Text("loremIpsumParagraph Details vulputate diam ut venenatis",
                    style: secondaryTextStyle(size: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DetailsListTile extends StatelessWidget {
  const _DetailsListTile({this.openContainer});

  final VoidCallback? openContainer;

  @override
  Widget build(BuildContext context) {
    const height = 120.0;

    return _InkWellOverlay(
      openContainer: openContainer,
      height: height,
      child: Container(
        color: appStore.appBarColor,
        child: Row(
          children: [
            Image.network(SampleImageUrl, height: height, fit: BoxFit.cover)
                .expand(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Title', style: primaryTextStyle(size: 16)),
                    6.height,
                    Expanded(
                      child: Text(
                        'Lorem ipsum dolor sit amet, consectetur '
                        'adipiscing elit,',
                        style: secondaryTextStyle(size: 12),
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InkWellOverlay extends StatelessWidget {
  const _InkWellOverlay({
    this.openContainer,
    this.width,
    this.height,
    this.child,
  });

  final VoidCallback? openContainer;
  final double? width;
  final double? height;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: InkWell(onTap: openContainer, child: child),
    );
  }
}
