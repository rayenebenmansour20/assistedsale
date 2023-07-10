import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../data/model/client.dart';
import '../../../../state/client_provider.dart';

class EditProfil extends StatelessWidget {
  final Client client;

  const EditProfil({super.key, required this.client});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    final TextEditingController firstNameController =
        TextEditingController(text: client.firstName);
    final TextEditingController lastNameController =
        TextEditingController(text: client.lastName);
    final TextEditingController addressController =
        TextEditingController(text: client.address);
    final TextEditingController cityController =
        TextEditingController(text: client.city);
    final TextEditingController countryController =
        TextEditingController(text: client.countryIndicator);
    final TextEditingController mobilePhoneController =
        TextEditingController(text: client.mobileNumber);
    final TextEditingController phoneController =
        TextEditingController(text: client.phoneNumber);
    final TextEditingController emailController =
        TextEditingController(text: client.email);
    return Consumer<ClientProvider>(
      builder: (context, provider, child) => Container(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                const Text(
                  'Modifier Client',
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
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.grey[100]),
                        ),
                        child: const Text(
                          'Annuler',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Client client = Client(
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
                          provider.updateClient(client);
                          Navigator.pop(context);
                        },
                        child: const Text('Modifier'),
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
