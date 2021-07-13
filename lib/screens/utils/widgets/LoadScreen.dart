import 'package:flutter/material.dart';
import 'package:masjidkita/screens/utils/MKColors.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: mkWhite,
      child: Center(
        child: CircularProgressIndicator(
          color: mkColorPrimary,
        ),
      ),
    );
  }
}
