import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ResponsiveFont {
  static double size(BuildContext context, double mobileSize) {
    final width = MediaQuery.of(context).size.width;

    double font;

    if (width >= 1200) {
      font = mobileSize * 1.1;
    } else if (width >= 600) {
      font = mobileSize * 0.9;
    } else {
      font = (mobileSize - 4).sp;
    }

    return font.clamp(
      mobileSize * 0.8,
      mobileSize * 1.2,
    );
  }
}
