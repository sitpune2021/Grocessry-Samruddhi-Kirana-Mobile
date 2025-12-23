import 'package:flutter/material.dart';
import 'package:samruddha_kirana/responsive/adaptive_layout.dart';
import 'package:samruddha_kirana/responsive/responsive_builder.dart';
import 'package:samruddha_kirana/widgets/adaptive_scaffold.dart';

class BaseResponsiveScreen extends StatelessWidget {
  final String title;
  final Widget Function(BuildContext) mobile;
  final Widget Function(BuildContext)? tablet;
  final Widget Function(BuildContext)? desktop;

  const BaseResponsiveScreen({
    super.key,
    required this.title,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (ctx, info) {
        return AdaptiveScaffold(
          appBar: AppBar(
            title: Text('$title - ${info.deviceType.name.toUpperCase()}'),
          ),
          navigationRail: info.isDesktop ? _rail() : null,
          drawer: !info.isDesktop ? _drawer() : null,
          bottomNavigationBar: info.isPhone ? _bottomNav() : null,
          body: AdaptiveLayout(
            mobile: (_) => mobile(ctx),
            tablet: tablet != null ? (_) => tablet!(ctx) : null,
            desktop: desktop != null ? (_) => desktop!(ctx) : null,
          ),
        );
      },
    );
  }

  Widget _drawer() {
    return Drawer(
      child: ListView(
        children: const [
          DrawerHeader(child: Text('Menu')),
          ListTile(title: Text('Home')),
          ListTile(title: Text('Settings')),
        ],
      ),
    );
  }

  Widget _bottomNav() {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
      ],
    );
  }

  Widget _rail() {
    return NavigationRail(
      selectedIndex: 0,
      destinations: [
        NavigationRailDestination(icon: Icon(Icons.home), label: Text('Home')),
        NavigationRailDestination(
          icon: Icon(Icons.settings),
          label: Text('Settings'),
        ),
      ],
    );
  }
}
