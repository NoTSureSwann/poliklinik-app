import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget? tablet;
  final Widget desktop;

  const ResponsiveLayout({
    Key? key,
    required this.mobile,
    this.tablet,
    required this.desktop,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        if (sizingInformation.deviceScreenType == DeviceScreenType.desktop) {
          return desktop;
        }
        if (sizingInformation.deviceScreenType == DeviceScreenType.tablet) {
          return tablet ?? mobile;
        }
        return mobile;
      },
    );
  }
}

// Extensi pembantu
extension ResponsiveExt on BuildContext {
  bool get isMobile => MediaQuery.of(this).size.width < 768;
  bool get isTablet => MediaQuery.of(this).size.width >= 768 && MediaQuery.of(this).size.width < 1200;
  bool get isDesktop => MediaQuery.of(this).size.width >= 1200;
}
