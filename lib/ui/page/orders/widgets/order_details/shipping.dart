import 'package:flutter/material.dart';

class Preparation extends StatefulWidget {
  final VoidCallback goToNextStep;
  final Function(int, int) setModes;

  const Preparation(
      {super.key, required this.goToNextStep, required this.setModes});

  @override
  State<Preparation> createState() => _PreparationState();
}

class _PreparationState extends State<Preparation> {
  int? modeLiv = 0;
  int? modePrep = 4;
  bool rOnly = false;
  final TextEditingController adresseLiv = TextEditingController();

  @override
  void dispose() {
    adresseLiv.dispose();
    super.dispose();
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
            'Préparation',
            style: TextStyle(
              fontSize: 22,
            ),
          ),
          RadioListTile(
            title: const Text("Immédiate"),
            value: 4,
            groupValue: modePrep,
            onChanged: (value) {
              setState(() {
                modePrep = value;
              });
            },
          ),
          RadioListTile(
            title: const Text("Ultérieure"),
            value: 3,
            groupValue: modePrep,
            onChanged: (value) {
              setState(() {
                modePrep = value;
              });
            },
          ),
          const Text('Mode de livraison'),
          RadioListTile(
            title: const Text('Retrait'),
            value: 0,
            groupValue: modeLiv,
            onChanged: (value) {
              setState(() {
                rOnly = false;
                modeLiv = value;
              });
            },
          ),
          RadioListTile(
            title: const Text('À domicile'),
            value: 1,
            groupValue: modeLiv,
            onChanged: (value) {
              setState(() {
                rOnly = true;
                modeLiv = value;
              });
            },
          ),
          Text(
            'Adresse de livraison',
            style: TextStyle(
              color: rOnly ? Colors.black : Colors.black.withOpacity(0.5),
            ),
          ),
          TextFormField(
            controller: adresseLiv,
            enabled: rOnly,
            decoration: const InputDecoration(
              hintText: 'Saisissez une adresse de livraison',
              border: OutlineInputBorder(),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    widget.setModes(modeLiv!, modePrep!);
                    widget.goToNextStep();
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
