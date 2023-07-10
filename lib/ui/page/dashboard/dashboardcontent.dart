import 'package:flutter/material.dart';
import 'package:flutter_datamaster/ui/page/dashboard/top_referal.dart';
import 'package:flutter_datamaster/ui/page/dashboard/vented%C3%A9tails.dart';
import 'package:flutter_datamaster/ui/page/dashboard/viewers.dart';
import 'package:provider/provider.dart';

import '../../../constants/constants.dart';
import '../../../constants/responsive.dart';
import '../../../state/order_provider.dart';
import '../../../state/product_provider.dart';
import 'analytic_cards.dart';
import 'outofstocklist1.dart';

class DashboardContent extends StatefulWidget {
  const DashboardContent({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _DashboardContentState createState() => _DashboardContentState();
}

class _DashboardContentState extends State<DashboardContent> {
  bool _showBarChart = true;
  late OrderProvider provider;
  late ProductProvider productProvider;

  @override
  void initState() {
    provider = Provider.of<OrderProvider>(context, listen: false);
    productProvider = Provider.of<ProductProvider>(context, listen: false);
    provider.getTickets();
    productProvider.fetchTopSellingProducts();
    productProvider.fetchProductsoutofstock(1);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(appPadding),
        child: Column(
          children: [
            Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 5,
                      child: Column(
                        children: const [
                          AnalyticCards(),
                          SizedBox(
                            height: appPadding,
                          ),
                        ],
                      ),
                    ),
                    if (!Responsive.isMobile(context))
                      const SizedBox(
                        width: appPadding,
                      ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 5,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: appPadding,
                          ),
                          ToggleButtons(
                              isSelected: [_showBarChart, !_showBarChart],
                              borderColor: Colors.blue,
                              borderRadius: BorderRadius.circular(4),
                              onPressed: (int index) {
                                setState(() {
                                  _showBarChart = index == 0;
                                });
                              },
                              children: const [
                                Icon(Icons.show_chart),
                                Icon(Icons.group)
                              ]),
                          const SizedBox(height: appPadding),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (!Responsive.isMobile(context))
                                Expanded(
                                  flex: 5,
                                  child: _showBarChart
                                      ? const BarChartSample3()
                                      : const TopReferals(),
                                ),
                            ],
                          ),
                          const SizedBox(
                            height: appPadding,
                          ),
                          if (Responsive.isMobile(context))
                            const SizedBox(
                              height: appPadding,
                            ),
                          if (Responsive.isMobile(context))
                            const SizedBox(
                              height: appPadding,
                            ),
                        ],
                      ),
                    ),
                    if (!Responsive.isMobile(context))
                      const SizedBox(
                        width: appPadding,
                      ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 5,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: appPadding,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (!Responsive.isMobile(context))
                                const Expanded(
                                  flex: 2,
                                  child: OutOfStock(),
                                ),
                              if (!Responsive.isMobile(context))
                                const SizedBox(
                                  width: appPadding,
                                ),
                              const Expanded(
                                flex: 3,
                                child: Viewers(),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: appPadding,
                          ),
                          if (Responsive.isMobile(context))
                            const SizedBox(
                              height: appPadding,
                            ),
                          if (Responsive.isMobile(context)) const OutOfStock(),
                          if (Responsive.isMobile(context))
                            const SizedBox(
                              height: appPadding,
                            ),
                        ],
                      ),
                    ),
                    if (!Responsive.isMobile(context))
                      const SizedBox(
                        width: appPadding,
                      ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
