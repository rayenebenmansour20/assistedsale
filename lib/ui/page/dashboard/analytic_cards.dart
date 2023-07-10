import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants/constants.dart';
import '../../../constants/responsive.dart';
import '../../../state/order_provider.dart';
import 'analytic_info_card.dart';

class AnalyticCards extends StatelessWidget {
  const AnalyticCards({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Responsive(
      mobile: AnalyticInfoCardGridView(
        crossAxisCount: size.width < 650 ? 2 : 4,
        childAspectRatio: size.width < 650 ? 2 : 1.5,
      ),
      tablet: const AnalyticInfoCardGridView(),
      desktop: AnalyticInfoCardGridView(
        childAspectRatio: size.width < 1400 ? 2.4 : 3,
      ),
    );
  }
}

class AnalyticInfoCardGridView extends StatefulWidget {
  const AnalyticInfoCardGridView({
    Key? key,
    this.crossAxisCount = 4,
    this.childAspectRatio = 2,
  }) : super(key: key);

  final int crossAxisCount;
  final double childAspectRatio;

  @override
  State<AnalyticInfoCardGridView> createState() =>
      _AnalyticInfoCardGridViewState();
}

class _AnalyticInfoCardGridViewState extends State<AnalyticInfoCardGridView> {
  late OrderProvider provider;

  @override
  Widget build(BuildContext context) {
    provider = Provider.of<OrderProvider>(context, listen: true);
    provider.getTickets();
    List analyticData = [
      AnalyticInfo(
        title: "Tickets en attente",
        count: provider.stats[0],
        svgSrc: const Icon(Icons.people),
        color: primaryColor,
      ),
      AnalyticInfo(
        title: "Précommandes",
        count: provider.stats[1],
        svgSrc: const Icon(Icons.post_add),
        color: purple,
      ),
      AnalyticInfo(
        title: "Commandes en préparation",
        count: provider.stats[2],
        svgSrc: const Icon(Icons.pages),
        color: orange,
      ),
      AnalyticInfo(
        title: "Commandes prêtes",
        count: provider.stats[3],
        svgSrc: const Icon(Icons.comment),
        color: green,
      ),
    ];
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 4,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: widget.crossAxisCount,
        crossAxisSpacing: appPadding,
        mainAxisSpacing: appPadding,
        childAspectRatio: widget.childAspectRatio,
      ),
      itemBuilder: (context, index) => AnalyticInfoCard(
        info: analyticData[index],
      ),
    );
  }
}
