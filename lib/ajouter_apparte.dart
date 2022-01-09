// ignore_for_file: file_names
import 'package:appartement/main.dart';
import 'package:appartement/model.dart/Model_apparte.dart';
import 'package:flutter/material.dart';

bool _passwordVisible = false;

class Ajouter_apparte extends StatefulWidget {
  const Ajouter_apparte({Key? key}) : super(key: key);

  @override
  State<Ajouter_apparte> createState() => _Ajouter_apparteState();
}

final _formKey = GlobalKey<FormState>();

class _Ajouter_apparteState extends State<Ajouter_apparte> {
  @override
  Widget build(BuildContext context) {
    Appartement_Model apparte = Appartement_Model();

    form_text(String titre, String text) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Theme(
          data: Theme.of(context).copyWith(splashColor: Colors.transparent),
          child: TextFormField(
            autofocus: false,
            style: const TextStyle(fontSize: 22.0, color: Colors.white),
            decoration: InputDecoration(
              filled: true,
              hintText: titre,
              contentPadding:
                  const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white),
                borderRadius: BorderRadius.circular(25.7),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: const BorderSide(color: Colors.white),
                borderRadius: BorderRadius.circular(25.7),
              ),
            ),
            onChanged: (value) {
              text = value;
            },
          ),
        ),
      );
    }

    form_int(String titre, int valeur) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Theme(
          data: Theme.of(context).copyWith(splashColor: Colors.transparent),
          child: TextFormField(
            keyboardType: TextInputType.number,
            autofocus: false,
            style: const TextStyle(fontSize: 22.0, color: Colors.white),
            decoration: InputDecoration(
              filled: true,
              hintText: titre,
              contentPadding:
                  const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white),
                borderRadius: BorderRadius.circular(25.7),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: const BorderSide(color: Colors.white),
                borderRadius: BorderRadius.circular(25.7),
              ),
            ),
            onChanged: (value) {
              valeur = int.parse(value);
            },
          ),
        ),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Container(
              height: MediaQuery.of(context).size.height * 0.85,
              width: MediaQuery.of(context).size.width * 0.85,
              child: ListView(
                scrollDirection: Axis.vertical,
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        form_text("nom", apparte.nom),
                        form_int("code postal", apparte.postal_code),
                        form_text("ville ", apparte.nom),
                        form_text("adresse", apparte.nom),
                        form_int("prix", apparte.prix),
                        form_int("surface", apparte.surface),
                        form_int("loyer", apparte.revenu_locatif),
                        form_int("impot foncié", apparte.impot_foncier),
                        form_int("frais", apparte.frais),
                        Center(
                          child: FlatButton(
                              onPressed: () {},
                              child: Text(
                                'Ajouter',
                                style: Theme.of(context).textTheme.headline6,
                              )),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

//bouton de retour a la page Accueil
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              IconButton(
                onPressed: () async {
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/', (Route<dynamic> route) => false);
                },
                icon: const Icon(Icons.arrow_back),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
