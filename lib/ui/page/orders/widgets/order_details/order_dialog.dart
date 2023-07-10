import 'package:flutter/material.dart';
import '../../../../../data/model/client.dart';
import 'payment.dart';
import 'info_check.dart';
import 'order_status.dart';
import 'shipping.dart';

class CheckoutDialog extends StatefulWidget {
  final Function(int) ticketCallback;
  final bool sale;
  final Client? currentClient;

  const CheckoutDialog({
    super.key,
    required this.ticketCallback,
    required this.sale,
    this.currentClient,
  });

  @override
  State<CheckoutDialog> createState() => _CheckoutDialogState();
}

class _CheckoutDialogState extends State<CheckoutDialog> {
  late PageController _pageController;
  int _currentPageIndex = 0;
  int? _modeLiv = 0;
  int? _modePrep = 4;
  int _pages = 3;

  @override
  void initState() {
    _pageController = PageController();
    widget.sale ? _pages = 4 : _pages = 3;
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      height: 500,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (int i = 0; i < _pages; i++)
                _buildStepIndicator(i == _currentPageIndex),
            ],
          ),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPageIndex = index;
                });
              },
              children: [
                Preparation(
                  goToNextStep: _goToNextStep,
                  setModes: _setModes,
                ),
                OrderBody(
                  goToNextStep: _goToNextStep,
                  client: widget.currentClient,
                  isSale: widget.sale,
                  modeLiv: _modeLiv,
                  modePrep: _modePrep,
                ),
                if (widget.sale)
                  Payment(
                    goToNextStep: _goToNextStep,
                  ),
                ConfirmOrder(ticketCallback: widget.ticketCallback),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepIndicator(bool isActive) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: isActive ? Colors.blue : Colors.grey,
        border:
            Border.all(color: isActive ? Colors.blue : Colors.grey, width: 2),
      ),
    );
  }

  void _goToNextStep() {
    if (_currentPageIndex < _pages - 1) {
      setState(() {
        _currentPageIndex++;
        _pageController.nextPage(
            duration: const Duration(milliseconds: 300), curve: Curves.ease);
      });
    }
  }

  void _setModes(int? modeLiv, int? modePrep) {
    setState(() {
      _modeLiv = modeLiv;
      _modePrep = modePrep;
    });
  }
}
