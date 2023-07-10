import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../state/order_provider.dart';

class Payment extends StatefulWidget {
  final VoidCallback goToNextStep;

  const Payment({super.key, required this.goToNextStep});

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  bool _rOnly = false;
  bool _rDisabled = false;
  int? _verstate = 0;
  int? _typePay = 0;
  bool _validate = false;
  final TextEditingController _sommePartiel = TextEditingController();

  late OrderProvider orderProvider;

  @override
  void dispose() {
    _sommePartiel.dispose();
    super.dispose();
  }

  @override
  void initState() {
    orderProvider = Provider.of<OrderProvider>(context, listen: false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Paiment',
            style: TextStyle(
              fontSize: 22,
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Radio(
                      value: 0,
                      groupValue: _verstate,
                      onChanged: (value) {
                        _rDisabled
                            ? null
                            : setState(
                                () {
                                  _rOnly = false;
                                  _verstate = value;
                                },
                              );
                      },
                    ),
                    const Expanded(
                      child: Text('Versement total'),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Radio(
                      value: 1,
                      groupValue: _verstate,
                      onChanged: (value) {
                        _rDisabled
                            ? null
                            : setState(
                                () {
                                  _rOnly = true;
                                  _verstate = value;
                                },
                              );
                      },
                    ),
                    const Expanded(
                      child: Text('Versement pratiel'),
                    )
                  ],
                ),
              ),
            ],
          ),
          Text(
            'Montant versé',
            style: TextStyle(
              color: _rOnly ? Colors.black : Colors.black.withOpacity(0.5),
            ),
          ),
          TextFormField(
            keyboardType: TextInputType.number,
            controller: _sommePartiel,
            enabled: _rOnly,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              errorText: _validate ? 'Veuillez entrer le montant versé' : null,
            ),
          ),
          const Text(
            'Type de paiement',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Radio(
                      value: 0,
                      groupValue: _typePay,
                      onChanged: (value) {
                        _rDisabled
                            ? null
                            : setState(
                                () {
                                  _typePay = value;
                                },
                              );
                      },
                    ),
                    const Expanded(
                      child: Text('Espéce'),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Radio(
                      value: 1,
                      groupValue: _typePay,
                      onChanged: (value) {
                        _rDisabled
                            ? null
                            : setState(
                                () {
                                  _typePay = value;
                                },
                              );
                      },
                    ),
                    const Expanded(
                      child: Text('Carte bancaire'),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Radio(
                      value: 2,
                      groupValue: _typePay,
                      onChanged: (value) {
                        setState(
                          () {
                            _typePay = value;
                          },
                        );
                      },
                    ),
                    const Expanded(
                      child: Text('Chèque'),
                    )
                  ],
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    if (_verstate == 1) {
                      setState(() {
                        _validate = _sommePartiel.text.isEmpty;
                      });
                      if (!_validate) {
                        orderProvider.addPayment(
                            _typePay, _verstate, orderProvider.ticket!.total,
                            partialSum: _sommePartiel.text);
                        widget.goToNextStep();
                      }
                    } else {
                      orderProvider.addPayment(
                          _typePay, _verstate, orderProvider.ticket!.total);
                      widget.goToNextStep();
                    }
                  },
                  child: const Text('Confirmer'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
