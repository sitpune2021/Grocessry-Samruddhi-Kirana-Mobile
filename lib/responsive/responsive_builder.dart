import 'package:flutter/widgets.dart';
import 'package:samruddha_kirana/responsive/device_type.dart';
import 'package:samruddha_kirana/responsive/responsive.dart';

typedef ResponsiveWidgetBuilder =
    Widget Function(BuildContext context, ResponsiveInfo info);

class ResponsiveBuilder extends StatelessWidget {
  final ResponsiveWidgetBuilder builder;
  final double? phoneMax;
  final double? tabletMax;

  const ResponsiveBuilder({
    super.key,
    required this.builder,
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
    return builder(context, info);
  }
}
