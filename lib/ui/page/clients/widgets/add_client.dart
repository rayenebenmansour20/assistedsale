import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../data/model/client.dart';
import '../../../../state/client_provider.dart';

class AddClient extends StatelessWidget {
  AddClient({super.key});

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController mobilePhoneController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    return Consumer<ClientProvider>(
      builder: (context, provider, child) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        child: ElevatedButton.icon(
          onPressed: () {
            AwesomeDialog(
              context: context,
              width: 500,
              isDense: true,
              showCloseIcon: true,
              dialogType: DialogType.noHeader,
              animType: AnimType.scale,
              body: Container(
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        const Text(
                          'Nouveau Client',
                          style: TextStyle(fontSize: 22),
                        ),
                        const SizedBox(
                          height: 32,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: lastNameController,
                                decoration: const InputDecoration(
                                  hintText: 'Nom',
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Veuillez remplir ce champ';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextFormField(
                                controller: firstNameController,
                                decoration: const InputDecoration(
                                  hintText: 'Prénom',
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Veuillez remplir ce champ';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: addressController,
                                decoration: const InputDecoration(
                                  hintText: 'Adresse',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: cityController,
                                decoration: const InputDecoration(
                                  hintText: 'Ville',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextFormField(
                                controller: countryController,
                                decoration: const InputDecoration(
                                  hintText: 'Indicateur de pays',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: mobilePhoneController,
                                decoration: const InputDecoration(
                                  hintText: 'Numéro de mobile',
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Veuillez remplir ce champ';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: TextFormField(
                                controller: phoneController,
                                decoration: const InputDecoration(
                                  hintText: 'Numéro de téléphone',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: emailController,
                                decoration: const InputDecoration(
                                  hintText: 'Adresse email',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),
              btnOk: ElevatedButton(
                onPressed: () {
                  Client newClient = Client(
                    firstName: firstNameController.text,
                    lastName: lastNameController.text,
                    email: emailController.text,
                    address: addressController.text,
                    countryIndicator: countryController.text,
                    mobileNumber: mobilePhoneController.text,
                    phoneNumber: phoneController.text,
                    type: 1,
                    indic: true,
                  );
                  if (formKey.currentState!.validate()) {
                    provider.addClient(newClient);
                    Navigator.pop(context);
                  }
                },
                child: const Text('Ajouter'),
              ),
              btnCancel: ElevatedButton(
                onPressed: () {},
                style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.grey[100]),
                ),
                child: const Text(
                  'Annuler',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ).show();
          },
          icon: const Icon(Icons.add),
          label: const Text('Nouveau Client'),
        ),
      ),
    );
  }
}
