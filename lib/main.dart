import 'package:flutter/material.dart';
import 'package:flutter_datamaster/state/auth_provider.dart';
import 'package:flutter_datamaster/ui/widgets/splash.dart';
import 'package:provider/provider.dart';

import 'state/client_provider.dart';
import 'state/order_provider.dart';
import 'state/product_provider.dart';
import 'state/settings_provider.dart';
import 'state/history_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthenticationProvider()),
        ChangeNotifierProvider(create: (_) => ClientProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => ToggleProvider()),
        ChangeNotifierProvider(create: (_) => HistoryProvider()),
      ],
      child: const MaterialApp(
        title: 'eVendor',
        debugShowCheckedModeBanner: false,
        home: Splash(),
      ),
    );
  }
}
