import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../helper/responsive.dart';
import '../../state/auth_provider.dart';
import 'custom_appbar.dart';

/// See bottomNavigationBarItem or NavigationRailDestination
class AdaptiveScaffoldDestination {
  final String title;
  final String icon;

  const AdaptiveScaffoldDestination({
    required this.title,
    required this.icon,
  });
}

/// A widget that adapts to the current display size, displaying a [Sidemenu],
/// [NavigationRail], or [Drawer]. Navigation destinations are
/// defined in the [destinations] parameter.
class AdaptiveScaffold extends StatefulWidget {
  final Widget? header;
  final List<Widget> actions;
  final Widget? body;
  int? currentIndex;
  final List<AdaptiveScaffoldDestination> destinations;
  final ValueChanged<int>? onNavigationIndexChange;
  final GlobalKey<ScaffoldState>? scaffoldKey;

  AdaptiveScaffold({
    this.scaffoldKey,
    this.header,
    this.body,
    this.actions = const [],
    this.currentIndex,
    required this.destinations,
    this.onNavigationIndexChange,
    super.key,
  });

  @override
  State<AdaptiveScaffold> createState() => _AdaptiveScaffoldState();
}

class _AdaptiveScaffoldState extends State<AdaptiveScaffold> {
  Widget? selectedProduct;
  late AuthenticationProvider authProvider;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthenticationProvider>(context);
    // Show a Drawer
    if (isLargeScreen(context)) {
      return Row(
        children: [
          Drawer(
            backgroundColor: Colors.blue,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    DrawerHeader(
                      child: Center(
                        child: widget.header,
                      ),
                    ),
                    for (var d in widget.destinations)
                      ListTile(
                        textColor: Colors.white,
                        selectedColor: Colors.blue,
                        selectedTileColor: Colors.white,
                        leading: SvgPicture.asset(
                          d.icon,
                          color: widget.destinations.indexOf(d) ==
                                  widget.currentIndex
                              ? Colors.blue
                              : Colors.white,
                          height: 20,
                        ),
                        title: Text(d.title),
                        selected: widget.destinations.indexOf(d) ==
                            widget.currentIndex,
                        onTap: () => _destinationTapped(d),
                      ),
                  ],
                ),
                ListTile(
                    textColor: Colors.white,
                    iconColor: Colors.white,
                    selectedColor: Colors.blue,
                    selectedTileColor: Colors.white,
                    leading: const Icon(
                      Icons.logout,
                    ),
                    title: const Text('Déconnexion'),
                    onTap: () {
                      authProvider.logOut(context);
                    }),
              ],
            ),
          ),
          Expanded(
            child: Scaffold(
              key: widget.scaffoldKey,
              appBar: CustomAppBar(indexCallback: _indexCallback),
              body: selectedProduct ?? widget.body,
            ),
          ),
        ],
      );
    }

    // Show a navigation rail
    if (isMediumScreen(context)) {
      return Row(
        children: [
          NavigationRail(
            useIndicator: widget.currentIndex == 7 ? false : true,
            indicatorColor: Colors.white,
            backgroundColor: Colors.blue,
            destinations: [
              ...widget.destinations.map(
                (d) => NavigationRailDestination(
                  icon: SvgPicture.asset(
                    d.icon,
                    color: widget.destinations.indexOf(d) == widget.currentIndex
                        ? Colors.blue
                        : Colors.white,
                    height: 20,
                  ),
                  label: Text(d.title),
                ),
              ),
              const NavigationRailDestination(
                icon: Icon(Icons.logout_outlined, color: Colors.white),
                label: Text('Logout'),
              ),
            ],
            selectedIndex: widget.currentIndex,
            onDestinationSelected: (int index) {
              if (index == widget.destinations.length) {
                // Logout destination selected
                authProvider.logOut(context);
              } else {
                widget.onNavigationIndexChange?.call(index);
              }
            },
          ),
          Expanded(
            child: Scaffold(
              key: widget.scaffoldKey,
              appBar: CustomAppBar(indexCallback: _indexCallback),
              body: selectedProduct ?? widget.body,
            ),
          ),
        ],
      );
    }

    // Show a hamburger menu on the appbar
    return Scaffold(
      key: widget.scaffoldKey,
      appBar: CustomAppBar(indexCallback: _indexCallback),
      body: selectedProduct ?? widget.body,
      drawer: Drawer(
        backgroundColor: Colors.blue,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                DrawerHeader(
                  child: Center(
                    child: widget.header,
                  ),
                ),
                for (var d in widget.destinations)
                  ListTile(
                    textColor: Colors.white,
                    selectedColor: Colors.blue,
                    selectedTileColor: Colors.white,
                    leading: SvgPicture.asset(
                      d.icon,
                      color:
                          widget.destinations.indexOf(d) == widget.currentIndex
                              ? Colors.blue
                              : Colors.white,
                      height: 20,
                    ),
                    title: Text(d.title),
                    selected:
                        widget.destinations.indexOf(d) == widget.currentIndex,
                    onTap: () => _destinationTapped(d),
                  ),
              ],
            ),
            ListTile(
                textColor: Colors.white,
                iconColor: Colors.white,
                selectedColor: Colors.blue,
                selectedTileColor: Colors.white,
                leading: const Icon(
                  Icons.logout,
                ),
                title: const Text('Déconnexion'),
                onTap: () {
                  authProvider.logOut(context);
                }),
          ],
        ),
      ),
    );
  }

  void _destinationTapped(AdaptiveScaffoldDestination destination) {
    var idx = widget.destinations.indexOf(destination);
    if (idx != widget.currentIndex) {
      widget.onNavigationIndexChange!(idx);
    }
  }

  void _indexCallback(int index) {
    setState(() {
      widget.currentIndex = index;
      widget.onNavigationIndexChange!.call(index);
    });
  }
}
