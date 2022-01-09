// ignore_for_file: deprecated_member_use

import 'package:appartement/db.dart';
import 'package:appartement/main.dart';
import 'package:flutter/material.dart';

// ignore: camel_case_types
class Profil_appart extends StatefulWidget {
  const Profil_appart({Key? key}) : super(key: key);

  @override
  State<Profil_appart> createState() => _Profil_appartState();
}

// ignore: camel_case_types
class _Profil_appartState extends State<Profil_appart> {
  // tous les calcule de retabilité

  double prix = double.parse(profil_appart.prix);
  double loyer = double.parse(profil_appart.revenu_locatif);
  double surface = double.parse(profil_appart.surface);

  double impot = double.parse(profil_appart.impot_foncier);
  double frais = double.parse(profil_appart.frais);
  double assurance = double.parse(profil_appart.assurance);

  @override
  Widget build(BuildContext context) {
    // tous les calcule de retabilité

    calcule(int mois) {
      double resultat = (loyer * mois) - (impot + frais + assurance);
      double renboursement = prix / resultat;
      double prixAchat = 15 * resultat;
      return Column(
        children: [
          Row(
            children: [
              Text("Résulta sur " +
                  mois.toString() +
                  " mois : " +
                  resultat.toString()),
            ],
          ),
          GestureDetector(
            onDoubleTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) =>
                    _fiche_techinque(context, mois),
              );
            },
            child: Card(
              child: Column(
                children: [
                  const Text("fiche technique "),
                  Text(renboursement.toString()),
                  Text(prixAchat.toString())
                ],
              ),
            ),
          )
        ],
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, '/list_appart', (Route<dynamic> route) => false);
            }),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Text("id: " + profil_appart.id.toString()),
              Text("nom: " + profil_appart.nom),
              Text("adresse: " + profil_appart.adresse),
              Text("postal_code: " + profil_appart.postal_code),
              Text("ville: " + profil_appart.ville),
              Text(
                "prix: " + profil_appart.prix,
                style: Theme.of(context).textTheme.bodyText1,
              ),
              Text(
                "revenu_locatif: " + profil_appart.revenu_locatif,
                style: Theme.of(context).textTheme.bodyText1,
              ),
              Text(
                "impot_foncier: " + profil_appart.impot_foncier,
                style: Theme.of(context).textTheme.bodyText1,
              ),
              Text("assurance: " + profil_appart.assurance),
              Text("frais: " + profil_appart.frais),
              Text("surface: " + profil_appart.surface),
              const Divider(color: Colors.white),
            ],
          ),
          calcule(12),
          calcule(11),
          calcule(10),
          const Divider(color: Colors.white),
          Center(
            child: FlatButton(
                onPressed: () async {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                        _buildPopupDialog(context),
                  );
                },
                child: Text(
                  'Supprimer',
                  style: Theme.of(context).textTheme.headline6,
                )),
          ),
        ],
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget _fiche_techinque(BuildContext context, int mois) {
    // calcule
    double resultat = (loyer * mois) - (impot + frais + assurance);
    double prixAchat = 15 * resultat;
    return AlertDialog(
      title: Text('Fiche technique sur ' + mois.toString() + " mois"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("Rebourser (15 ans) : " + prixAchat.toString() + "euro"),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('Fermer'),
        ),
      ],
    );
  }

  Widget _buildPopupDialog(BuildContext context) {
    return AlertDialog(
      title: const Text('Supprimer'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const <Widget>[
          Text("Veux-tu vraiment supprimer cette appartement"),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () async {
            await Baselocal().delete_appart(profil_appart.id);
            Navigator.pushNamedAndRemoveUntil(
                context, '/list_appart', (Route<dynamic> route) => false);
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('Oui vraiment'),
        ),
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('Fermer'),
        ),
      ],
    );
  }
}
