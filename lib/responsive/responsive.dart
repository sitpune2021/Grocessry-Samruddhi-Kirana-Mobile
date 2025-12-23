import 'package:flutter/widgets.dart';
import 'package:samruddha_kirana/responsive/device_type.dart';

class ResponsiveInfo {
  final DeviceType deviceType;
  final Size size;
  final Orientation orientation;
  final double shortestSide;

  ResponsiveInfo({
    required this.deviceType,
    required this.size,
    required this.orientation,
    required this.shortestSide,
  });

  bool get isPhone => deviceType == DeviceType.phone;
  bool get isTablet => deviceType == DeviceType.tablet;
  bool get isDesktop => deviceType == DeviceType.desktop;
}

class Responsive {
  Responsive._();

  static DeviceType deviceTypeFromWidth(
    double width, {
    double phoneMax = Breakpoints.phoneMax,
    double tabletMax = Breakpoints.tabletMax,
  }) {
    if (width <= phoneMax) return DeviceType.phone;
    if (width <= tabletMax) return DeviceType.tablet;
    return DeviceType.desktop;
  }

  static ResponsiveInfo fromContext(
    BuildContext context, {
    double phoneMax = Breakpoints.phoneMax,
    double tabletMax = Breakpoints.tabletMax,
  }) {
    final mq = MediaQuery.of(context);
    final width = mq.size.width;

    final deviceType = deviceTypeFromWidth(
      width,
      phoneMax: phoneMax,
      tabletMax: tabletMax,
    );

    return ResponsiveInfo(
      deviceType: deviceType,
      size: mq.size,
      orientation: mq.orientation,
      shortestSide: mq.size.shortestSide,
    );
  }
}
