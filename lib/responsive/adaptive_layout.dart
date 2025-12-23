import 'package:flutter/widgets.dart';
import 'package:samruddha_kirana/responsive/device_type.dart';
import 'package:samruddha_kirana/responsive/responsive.dart';

typedef DeviceWidgetBuilder = Widget Function(BuildContext context);

class AdaptiveLayout extends StatelessWidget {
  final DeviceWidgetBuilder mobile;
  final DeviceWidgetBuilder? tablet;
  final DeviceWidgetBuilder? desktop;
  final double? phoneMax;
  final double? tabletMax;

  const AdaptiveLayout({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
    this.phoneMax,
    this.tabletMax,
  });

  @override
  Widget build(BuildContext context) {
    final info = Responsive.fromContext(
      context,
      phoneMax: phoneMax ?? Breakpoints.phoneMax,
      tabletMax: tabletMax ?? Breakpoints.tabletMax,
    );

    switch (info.deviceType) {
      case DeviceType.phone:
        return mobile(context);
      case DeviceType.tablet:
        return (tablet ?? mobile)(context);
      case DeviceType.desktop:
        return (desktop ?? tablet ?? mobile)(context);
    }
  }
}
