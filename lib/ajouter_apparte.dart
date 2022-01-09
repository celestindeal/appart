// ignore_for_file: file_names, deprecated_member_use
import 'dart:developer';

import 'package:appartement/db.dart';
import 'package:appartement/model.dart/Model_apparte.dart';
import 'package:flutter/material.dart';

// ignore: camel_case_types
class Ajouter_apparte extends StatefulWidget {
  const Ajouter_apparte({Key? key}) : super(key: key);

  @override
  State<Ajouter_apparte> createState() => _Ajouter_apparteState();
}

final _formKey = GlobalKey<FormState>();
Appartement_Model apparte = Appartement_Model();

// ignore: camel_case_types
class _Ajouter_apparteState extends State<Ajouter_apparte> {
  Widget _buildPopupDialog(BuildContext context) {
    return new AlertDialog(
      title: const Text('Problème'),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text("Tu n'as pas rempli de formulaire correctement"),
        ],
      ),
      actions: <Widget>[
        new FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('Fermer'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, '/', (Route<dynamic> route) => false);
            }),
      ),
      body: Center(
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
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Theme(
                        data: Theme.of(context)
                            .copyWith(splashColor: Colors.transparent),
                        child: TextFormField(
                          autofocus: false,
                          style: const TextStyle(
                              fontSize: 22.0, color: Colors.white),
                          decoration: InputDecoration(
                            filled: true,
                            hintText: "nom",
                            contentPadding: const EdgeInsets.only(
                                left: 14.0, bottom: 8.0, top: 8.0),
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
                            apparte.nom = value;
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Theme(
                        data: Theme.of(context)
                            .copyWith(splashColor: Colors.transparent),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          autofocus: false,
                          style: const TextStyle(
                              fontSize: 22.0, color: Colors.white),
                          decoration: InputDecoration(
                            filled: true,
                            hintText: "code postal",
                            contentPadding: const EdgeInsets.only(
                                left: 14.0, bottom: 8.0, top: 8.0),
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
                            if (value.isNotEmpty) {
                              apparte.postal_code = value;
                            } else {
                              apparte.postal_code = '0';
                            }
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Theme(
                        data: Theme.of(context)
                            .copyWith(splashColor: Colors.transparent),
                        child: TextFormField(
                          autofocus: false,
                          style: const TextStyle(
                              fontSize: 22.0, color: Colors.white),
                          decoration: InputDecoration(
                            filled: true,
                            hintText: "ville",
                            contentPadding: const EdgeInsets.only(
                                left: 14.0, bottom: 8.0, top: 8.0),
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
                            if (value.isNotEmpty) {
                              apparte.ville = value;
                            } else {
                              apparte.ville = '0';
                            }
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Theme(
                        data: Theme.of(context)
                            .copyWith(splashColor: Colors.transparent),
                        child: TextFormField(
                          autofocus: false,
                          style: const TextStyle(
                              fontSize: 22.0, color: Colors.white),
                          decoration: InputDecoration(
                            filled: true,
                            hintText: "adresse",
                            contentPadding: const EdgeInsets.only(
                                left: 14.0, bottom: 8.0, top: 8.0),
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
                            if (value.isNotEmpty) {
                              apparte.adresse = value;
                            } else {
                              apparte.adresse = '0';
                            }
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Theme(
                        data: Theme.of(context)
                            .copyWith(splashColor: Colors.transparent),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          autofocus: false,
                          style: const TextStyle(
                              fontSize: 22.0, color: Colors.white),
                          decoration: InputDecoration(
                            filled: true,
                            hintText: "prix",
                            contentPadding: const EdgeInsets.only(
                                left: 14.0, bottom: 8.0, top: 8.0),
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
                            if (value.isNotEmpty) {
                              apparte.prix = value;
                            } else {
                              apparte.prix = '0';
                            }
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Theme(
                        data: Theme.of(context)
                            .copyWith(splashColor: Colors.transparent),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          autofocus: false,
                          style: const TextStyle(
                              fontSize: 22.0, color: Colors.white),
                          decoration: InputDecoration(
                            filled: true,
                            hintText: "surface",
                            contentPadding: const EdgeInsets.only(
                                left: 14.0, bottom: 8.0, top: 8.0),
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
                            if (value.isNotEmpty) {
                              apparte.surface = value;
                            } else {
                              apparte.surface = '0';
                            }
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Theme(
                        data: Theme.of(context)
                            .copyWith(splashColor: Colors.transparent),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          autofocus: false,
                          style: const TextStyle(
                              fontSize: 22.0, color: Colors.white),
                          decoration: InputDecoration(
                            filled: true,
                            hintText: "loyer",
                            contentPadding: const EdgeInsets.only(
                                left: 14.0, bottom: 8.0, top: 8.0),
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
                            if (value.isNotEmpty) {
                              apparte.revenu_locatif = value;
                            } else {
                              apparte.revenu_locatif = '0';
                            }
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Theme(
                        data: Theme.of(context)
                            .copyWith(splashColor: Colors.transparent),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          autofocus: false,
                          style: const TextStyle(
                              fontSize: 22.0, color: Colors.white),
                          decoration: InputDecoration(
                            filled: true,
                            hintText: "impot foncié",
                            contentPadding: const EdgeInsets.only(
                                left: 14.0, bottom: 8.0, top: 8.0),
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
                            if (value.isNotEmpty) {
                              apparte.impot_foncier = value;
                            } else {
                              apparte.impot_foncier = '0';
                            }
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Theme(
                        data: Theme.of(context)
                            .copyWith(splashColor: Colors.transparent),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          autofocus: false,
                          style: const TextStyle(
                              fontSize: 22.0, color: Colors.white),
                          decoration: InputDecoration(
                            filled: true,
                            hintText: "assurance",
                            contentPadding: const EdgeInsets.only(
                                left: 14.0, bottom: 8.0, top: 8.0),
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
                            if (value.isNotEmpty) {
                              apparte.assurance = value;
                            } else {
                              apparte.assurance = '0';
                            }
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Theme(
                        data: Theme.of(context)
                            .copyWith(splashColor: Colors.transparent),
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          autofocus: false,
                          style: const TextStyle(
                              fontSize: 22.0, color: Colors.white),
                          decoration: InputDecoration(
                            filled: true,
                            hintText: "frais",
                            contentPadding: const EdgeInsets.only(
                                left: 14.0, bottom: 8.0, top: 8.0),
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
                            if (value.isNotEmpty) {
                              apparte.frais = value;
                            } else {
                              apparte.frais = '0';
                            }
                          },
                        ),
                      ),
                    ),
                    Center(
                      child: FlatButton(
                          onPressed: () async {
                            log('début de la fonction');
                            if (apparte.frais == '0' ||
                                apparte.assurance == '0' ||
                                apparte.impot_foncier == '0' ||
                                apparte.surface == '0' ||
                                apparte.revenu_locatif == '0' ||
                                apparte.nom == '' ||
                                apparte.prix == '0') {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    _buildPopupDialog(context),
                              );
                            } else {
                              log('validation des critère');
                              await Baselocal().new_apparte(apparte);
                              Navigator.pushNamedAndRemoveUntil(context, '/',
                                  (Route<dynamic> route) => false);
                            }
                          },
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
    );
  }
}
