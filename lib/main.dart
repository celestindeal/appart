import 'package:appartement/accueil.dart';
import 'package:appartement/ajouter_apparte.dart';
import 'package:appartement/list_appart.dart';
import 'package:appartement/model.dart/Model_apparte.dart';
import 'package:appartement/profil_appart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const Main());
}

class Main extends StatefulWidget {
  const Main({Key? key}) : super(key: key);

  @override
  _MainState createState() => _MainState();
}

double hauteurApp = 0;
double largueurApp = 0;
Appartement_Model profil_appart = Appartement_Model();

class _MainState extends State<Main> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const Accueil(),
        '/ajouter_apparte': (context) => const Ajouter_apparte(),
        '/list_appart': (context) => const List_Appart(),
        '/profil_appart': (context) => Profil_appart(),
      },
      theme: ThemeData(
        // Define the default brightness and colors.
        brightness: Brightness.dark,
        primaryColor: Colors.deepOrange[300],
        fontFamily: 'Georgia',
        textTheme: const TextTheme(
          headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
          headline6: TextStyle(fontSize: 30.0, fontStyle: FontStyle.italic),
          bodyText1: TextStyle(
              fontSize: 14.0, fontFamily: 'Hind', color: Colors.deepOrange),
          bodyText2: TextStyle(
              fontSize: 14.0, fontFamily: 'Hind', color: Colors.white),
        ),
      ),
    );
  }
}
