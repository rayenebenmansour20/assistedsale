import 'package:flutter/material.dart';
import 'package:flutter_datamaster/ui/page/dashboard/dashboardcontent.dart';
import 'package:flutter_datamaster/ui/page/products/products.dart';
import 'package:flutter_datamaster/ui/page/listed_orders/orders.dart';
import 'package:flutter_datamaster/ui/page/settings/settings.dart';

import 'page/clients/clients.dart';
import 'page/orders/orders.dart';
import 'page/stock/stock.dart';
import 'page/history/history.dart';
import 'widgets/adaptive_scaffold.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _pageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => AdaptiveScaffold(
            scaffoldKey: _scaffoldKey,
            header: Image.asset(
              "./assets/images/logo.png",
              width: 100,
              height: 100,
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextButton(
                  style: TextButton.styleFrom(foregroundColor: Colors.white),
                  onPressed: () => {},
                  child: const Text('Sign Out'),
                ),
              ),
            ],
            currentIndex: _pageIndex,
            destinations: const [
              AdaptiveScaffoldDestination(
                  title: 'Dashboard', icon: "./assets/icons/home.svg"),
              AdaptiveScaffoldDestination(
                  title: 'Produits', icon: "./assets/icons/product.svg"),
              AdaptiveScaffoldDestination(
                  title: 'Commandes', icon: "./assets/icons/order.svg"),
              AdaptiveScaffoldDestination(
                  title: 'Clients', icon: "./assets/icons/useravatar.svg"),
              AdaptiveScaffoldDestination(
                  title: 'Stock', icon: "./assets/icons/icons8-box-128.svg"),
              AdaptiveScaffoldDestination(
                  title: 'Historique',
                  icon: "./assets/icons/menu_dashbord.svg"),
              AdaptiveScaffoldDestination(
                  title: 'Paramètres', icon: "./assets/icons/settings.svg"),
            ],
            body: _pageAtIndex(_pageIndex),
            onNavigationIndexChange: (newIndex) {
              setState(() {
                _pageIndex = newIndex;
              });
            },
          ),
        );
      },
    );
  }

  Widget _pageAtIndex(int index) {
    switch (index) {
      case 0:
        return const DashboardContent();
      case 1:
        return const Products();
      case 2:
        return const LOrders();
      case 3:
        return const Clients();
      case 4:
        return const Stock();
      case 5:
        return const History();
      case 6:
        return const Settings();
      case 7:
        return const Orders();
      default:
        return const Text('404');
    }
  }
}
