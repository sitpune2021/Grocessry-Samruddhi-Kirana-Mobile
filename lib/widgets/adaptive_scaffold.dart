import 'package:flutter/material.dart';
import 'package:samruddha_kirana/responsive/device_type.dart';
import 'package:samruddha_kirana/responsive/responsive.dart';


class AdaptiveScaffold extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? drawer;
  final Widget? navigationRail;
  final Widget? bottomNavigationBar;

  const AdaptiveScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.drawer,
    this.navigationRail,
    this.bottomNavigationBar,
  });

  @override
  Widget build(BuildContext context) {
    final info = Responsive.fromContext(context);

    // Desktop layout
    if (info.deviceType == DeviceType.desktop) {
      return Scaffold(
        appBar: appBar,
        body: Row(
          children: [
            if (navigationRail != null)
              SizedBox(width: 72, child: navigationRail),
            Expanded(child: body),
          ],
        ),
      );
    }

    // Tablet layout
    if (info.deviceType == DeviceType.tablet) {
      return Scaffold(
        appBar: appBar,
        drawer: drawer,
        body: body,
        bottomNavigationBar: bottomNavigationBar,
      );
    }

    // Phone layout
    return Scaffold(
      appBar: appBar,
      drawer: drawer,
      body: body,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}
