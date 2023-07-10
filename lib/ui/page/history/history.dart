import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../state/history_provider.dart';
import 'det_datatable.dart';
import 'ent_datatable.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  int _selectedIndex = 0;
  late HistoryProvider provider;

  @override
  void initState() {
    provider = Provider.of<HistoryProvider>(context, listen: false);
    provider.getEntHistory();
    provider.getDetHistory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 16,
            ),
            BottomNavigationBar(
              elevation: 0,
              useLegacyColorScheme: false,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    "./assets/icons/product.svg",
                    color: Colors.blue,
                  ),
                  label: 'Tickets/Commandes',
                ),
                BottomNavigationBarItem(
                  icon: SvgPicture.asset(
                    "./assets/icons/order.svg",
                    color: Colors.blue,
                  ),
                  label: 'Produits',
                ),
              ],
              currentIndex: _selectedIndex,
              onTap: (index) {
                setState(
                  () {
                    _selectedIndex = index;
                  },
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child:
                        _selectedIndex == 0 ? const EntList() : const DetList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
