// ignore_for_file: file_names, deprecated_member_use
import 'dart:developer';

import 'package:appartement/MyFooter.dart';

import 'package:appartement/model.dart/Model_apparte.dart';
import 'package:flutter/material.dart';

import 'main.dart';

// ignore: camel_case_types
class Ajouter_apparte extends StatefulWidget {
  const Ajouter_apparte({Key? key}) : super(key: key);

  @override
  State<Ajouter_apparte> createState() => _Ajouter_apparteState();
}

// Appartement_Model apparte = Appartement_Model();

// ignore: camel_case_types
class _Ajouter_apparteState extends State<Ajouter_apparte> {
  var nom;

  var prix;

  var frais;

  var revenu_locatif;

  var surface;

  var assurance;

  var impot_foncier;
  final _formKey = GlobalKey<FormState>();
  Widget _buildPopupDialog(BuildContext context) {
    return AlertDialog(
      title: const Text('Problème'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const <Widget>[
          Text("Tu n'as pas rempli de formulaire correctement"),
        ],
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Fermer'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
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
                            nom = value;
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
                              prix = value;
                            } else {
                              prix = '0';
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
                              surface = value;
                            } else {
                              surface = '0';
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
                              revenu_locatif = value;
                            } else {
                              revenu_locatif = '0';
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
                              impot_foncier = value;
                            } else {
                              impot_foncier = '0';
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
                              assurance = value;
                            } else {
                              assurance = '0';
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
                              frais = value;
                            } else {
                              frais = '0';
                            }
                          },
                        ),
                      ),
                    ),
                    Center(
                      child: TextButton(
                          onPressed: () async {
                            log('début de la fonction');
                            if (frais == '0' ||
                                assurance == '0' ||
                                impot_foncier == '0' ||
                                surface == '0' ||
                                revenu_locatif == '0' ||
                                nom == '' ||
                                prix == '0') {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    _buildPopupDialog(context),
                              );
                            } else {
                              log('validation des critère');
                              Appartement_Model apparte = Appartement_Model();
                              apparte.nom = nom;
                              apparte.prix = prix;
                              apparte.surface = surface;
                              apparte.revenu_locatif = revenu_locatif;
                              apparte.impot_foncier = impot_foncier;
                              apparte.assurance = assurance;
                              apparte.frais = frais;
                              await baselocal.new_apparte(apparte);
                              Navigator.pushNamedAndRemoveUntil(context, '/',
                                  (Route<dynamic> route) => false);
                            }
                          },
                          child: Text(
                            'Ajouter',
                            style: Theme.of(context).textTheme.titleLarge,
                          )),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: MyFooter(),
    );
  }
}
