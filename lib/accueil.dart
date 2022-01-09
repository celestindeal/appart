// ignore_for_file: file_names, deprecated_member_use

import 'package:appartement/main.dart';
import 'package:flutter/material.dart';

class Accueil extends StatefulWidget {
  const Accueil({Key? key}) : super(key: key);

  @override
  State<Accueil> createState() => _AccueilState();
}

class _AccueilState extends State<Accueil> {
  @override
  Widget build(BuildContext context) {
    hauteurApp = MediaQuery.of(context).size.height;
    largueurApp = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            IconButton(
              onPressed: () async {
                Navigator.pushNamedAndRemoveUntil(context, '/ajouter_apparte',
                    (Route<dynamic> route) => false);
              },
              icon: const Icon(Icons.golf_course),
            ),
            Center(
              child: FlatButton(
                  onPressed: () async {
                    Navigator.pushNamed(context, '/list_appart');
                  },
                  child: Text(
                    'Affihage',
                    style: Theme.of(context).textTheme.headline6,
                  )),
            )
          ],
        ),
      ),
    );
  }
}
