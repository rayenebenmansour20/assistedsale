import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../state/auth_provider.dart';
import '../../state/settings_provider.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Function(int) indexCallback;

  const CustomAppBar({super.key, required this.indexCallback});

  final Size appBarHeight = const Size.fromHeight(56.0);

  @override
  Size get preferredSize => appBarHeight;

  Widget _userIcon(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: GestureDetector(
        onTap: () async {
          final authProvider =
              Provider.of<AuthenticationProvider>(context, listen: false);
          final userData = await authProvider.getUserData();
          // ignore: use_build_context_synchronously
          showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                insetPadding: const EdgeInsets.all(20),
                child: SizedBox(
                  width: 400,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        CircleAvatar(
                          backgroundImage:
                              NetworkImage('${userData['MUTPHOTOS']}'),
                          radius: 50,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '${userData['username']}',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '${authProvider.loggedUser!.email}',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          '${userData['MUTPROFID']['MPRLIBLONG']}',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            ElevatedButton(
                              style: TextButton.styleFrom(
                                  foregroundColor: Colors.white),
                              onPressed: () {
                                indexCallback(6);
                                Navigator.pop(context);
                              },
                              child: const Text('Consulter mon profil'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
        child: FutureBuilder<Map<String, dynamic>>(
          future: AuthenticationProvider().getUserData(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // While waiting for the future to complete, you can show a loading indicator or placeholder
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              // If an error occurs, you can show an error message
              return Text('Error: ${snapshot.error}');
            } else {
              // If the future completes successfully, you can access the user data from the snapshot
              final userData = snapshot.data;
              return CircleAvatar(
                backgroundImage: NetworkImage('${userData?['MUTPHOTOS']}'),
                radius: 20,
              );
            }
          },
        ),
      ),
    );
  }

  Widget _ticketsIcon() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: GestureDetector(
        onTap: () {
          indexCallback(7);
        },
        child: CircleAvatar(
          backgroundColor: Colors.grey[100],
          radius: 20,
          child: Stack(
            alignment: Alignment.center,
            children: const [
              Icon(
                Icons.shopping_cart_rounded,
                color: Colors.black,
                size: 22,
              ),
              Positioned(
                top: 0,
                right: 2,
                child: CircleAvatar(
                  backgroundColor: Colors.red,
                  radius: 4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _notifIcon() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: GestureDetector(
        onTap: () {},
        child: CircleAvatar(
          backgroundColor: Colors.grey[100],
          radius: 20,
          child: Stack(
            alignment: Alignment.center,
            children: const [
              Icon(
                Icons.notifications,
                color: Colors.black,
                size: 22,
              ),
              Positioned(
                top: 0,
                right: 2,
                child: CircleAvatar(
                  backgroundColor: Colors.red,
                  radius: 4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.grey[200],
        actions: [
          _ticketsIcon(),
          _notifIcon(),
          _userIcon(context),
        ]);
  }
}

class Ticketicon extends StatefulWidget {
  const Ticketicon({
    super.key,
    int counter = 0,
  });

  @override
  State<Ticketicon> createState() => _TicketiconState();
}

class _TicketiconState extends State<Ticketicon> {
  bool showSettingsTile = false;

  String? _imageUrl;

  @override
  void initState() {
    super.initState();
    _loadImageUrl();
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await ImagePicker().pickImage(source: source);
    if (pickedFile != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('image_url', pickedFile.path);
      setState(() {
        _imageUrl = pickedFile.path;
      });
    }
  }

  Future<void> _loadImageUrl() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _imageUrl = prefs.getString('image_url');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: <Widget>[
          const SizedBox(
            width: 5,
          ),
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Hello'),
                    content: const Text('You tapped the image!'),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('OK'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
            child: Provider.of<ToggleProvider>(context).toggleValue
                ? CircleAvatar(
                    backgroundColor: Colors.grey[100],
                    radius: 20,
                    child: Stack(
                      alignment: Alignment.center,
                      children: const [
                        Icon(
                          Icons.notifications,
                          color: Colors.black,
                          size: 22,
                        ),
                        Positioned(
                          top: 0,
                          right: 4,
                          child: CircleAvatar(
                            backgroundColor: Colors.red,
                            radius: 4,
                          ),
                        ),
                      ],
                    ),
                  )
                : Container(), // Empty container if the value is false
          ),
          const SizedBox(
            width: 5,
          ),
          GestureDetector(
            onTap: () async {
              await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Select an image'),
                    content: _imageUrl != null
                        ? Image.network(_imageUrl!)
                        : const Text('No image selected'),
                    actions: <Widget>[
                      TextButton(
                        child: const Text('Cancel'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: const Text('Gallery'),
                        onPressed: () async {
                          await _pickImage(ImageSource.gallery);
                          // ignore: use_build_context_synchronously
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                            // ignore: deprecated_member_use
                            primary: Colors.blue),
                        onPressed: () async {
                          await _pickImage(ImageSource.camera);
                          // ignore: use_build_context_synchronously
                          Navigator.of(context).pop();
                        },
                        child: const Text('Camera'),
                      ),
                    ],
                  );
                },
              );
            },
            child: CircleAvatar(
              backgroundColor: Colors.white30,
              radius: 20,
              backgroundImage: _imageUrl != null
                  ? NetworkImage(_imageUrl!) as ImageProvider
                  : const AssetImage("assets/images/datamasterlogo.png"),
              child: Stack(
                children: const [
                  Positioned(
                    right: 1,
                    bottom: 0,
                    child: CircleAvatar(
                      backgroundColor: Colors.green,
                      radius: 4,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
