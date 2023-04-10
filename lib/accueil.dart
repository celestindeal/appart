// ignore_for_file: file_names, deprecated_member_use

import 'package:appartement/main.dart';
import 'package:appartement/model.dart/Model_apparte.dart';
import 'package:flutter/material.dart';
import 'package:appartement/MyFooter.dart';

class Accueil extends StatefulWidget {
  const Accueil({Key? key}) : super(key: key);

  @override
  State<Accueil> createState() => _AccueilState();
}

Appartement_Model apparte = Appartement_Model();
// ignore: non_constant_identifier_names
bool def_prix_achat = false;
// ignore: non_constant_identifier_names
bool def_renbourser = false;

class _AccueilState extends State<Accueil> {
  @override
  Widget build(BuildContext context) {
    hauteurApp = MediaQuery.of(context).size.height;
    largueurApp = MediaQuery.of(context).size.width;

    double prix = double.parse(apparte.prix);
    double loyer = double.parse(apparte.revenu_locatif);

    double impot = double.parse(apparte.impot_foncier);
    double frais = double.parse(apparte.frais);
    double assurance = double.parse(apparte.assurance);

    calcule(int mois) {
      double resultat = (loyer * mois) - impot - frais - assurance;
      double renboursement = prix / resultat;
      double prixAchat = 15 * resultat;
      double prixAchat20 = 20 * resultat;

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
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text("année pour renbourser = " +
                            renboursement.toStringAsFixed(1)),
                      ),
                      onLongPress: () {
                        setState(() {
                          def_renbourser = true;
                        });
                      },
                      onLongPressUp: () {
                        setState(() {
                          def_renbourser = false;
                        });
                      }),
                  GestureDetector(
                      child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Text("prix d'achat = " +
                              prixAchat.toStringAsFixed(0))),
                      onLongPress: () {
                        setState(() {
                          def_prix_achat = true;
                        });
                      },
                      onLongPressUp: () {
                        setState(() {
                          def_prix_achat = false;
                        });
                      }),
                  Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Text(
                          "prix d'achat = " + prixAchat20.toStringAsFixed(0))),
                ],
              ),
            ),
          ),
        ],
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.15,
                ),
                Center(
                  child: TextButton(
                      onPressed: () async {
                        Navigator.pushNamed(context, '/bank');
                      },
                      child: Text(
                        "Calcule d'un prêt",
                        style: Theme.of(context).textTheme.headline6,
                      )),
                ),
                Center(
                  child: TextButton(
                      onPressed: () async {
                        Navigator.pushNamed(context, '/ajouter_apparte');
                      },
                      child: Text(
                        'Ajouter un apparte',
                        style: Theme.of(context).textTheme.headline6,
                      )),
                ),
                Center(
                  child: TextButton(
                      onPressed: () async {
                        Navigator.pushNamed(context, '/list_appart');
                      },
                      child: Text(
                        'Affihage',
                        style: Theme.of(context).textTheme.headline6,
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Theme(
                    data: Theme.of(context)
                        .copyWith(splashColor: Colors.transparent),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      autofocus: false,
                      style:
                          const TextStyle(fontSize: 22.0, color: Colors.white),
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
                        setState(() {
                          setState(() {
                            if (value.isNotEmpty) {
                              apparte.prix = value;
                            } else {
                              apparte.prix = '0';
                            }
                          });
                        });
                      },
                    ),
                  ),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Theme(
                        data: Theme.of(context)
                            .copyWith(splashColor: Colors.transparent),
                        child: SizedBox(
                          width: largueurApp * 0.4,
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            autofocus: false,
                            style: const TextStyle(
                                fontSize: 12.0, color: Colors.white),
                            decoration: InputDecoration(
                                filled: true,
                                hintText: "Revenu locatif",
                                contentPadding: const EdgeInsets.only(
                                    left: 14.0, bottom: 8.0, top: 8.0),
                                focusedBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(25.7),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.white),
                                  borderRadius: BorderRadius.circular(25.7),
                                )),
                            onChanged: (value) {
                              setState(() {
                                if (value.isNotEmpty) {
                                  apparte.revenu_locatif = value;
                                } else {
                                  apparte.revenu_locatif = '0';
                                }
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Theme(
                        data: Theme.of(context)
                            .copyWith(splashColor: Colors.transparent),
                        child: SizedBox(
                          width: largueurApp * 0.4,
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            autofocus: false,
                            style: const TextStyle(
                                fontSize: 12.0, color: Colors.white),
                            decoration: InputDecoration(
                              filled: true,
                              hintText: "Impôt foncier",
                              contentPadding: const EdgeInsets.only(
                                  left: 14.0, bottom: 8.0, top: 8.0),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(25.7),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(25.7),
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {
                                if (value.isNotEmpty) {
                                  apparte.impot_foncier = value;
                                } else {
                                  apparte.impot_foncier = '0';
                                }
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Theme(
                        data: Theme.of(context)
                            .copyWith(splashColor: Colors.transparent),
                        child: SizedBox(
                          width: largueurApp * 0.4,
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            autofocus: false,
                            style: const TextStyle(
                                fontSize: 12.0, color: Colors.white),
                            decoration: InputDecoration(
                              filled: true,
                              hintText: "Assurance",
                              contentPadding: const EdgeInsets.only(
                                  left: 14.0, bottom: 8.0, top: 8.0),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(25.7),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(25.7),
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {
                                if (value.isNotEmpty) {
                                  apparte.assurance = value;
                                } else {
                                  apparte.assurance = '0';
                                }
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Theme(
                        data: Theme.of(context)
                            .copyWith(splashColor: Colors.transparent),
                        child: SizedBox(
                          width: largueurApp * 0.4,
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            autofocus: false,
                            style: const TextStyle(
                                fontSize: 12.0, color: Colors.white),
                            decoration: InputDecoration(
                              filled: true,
                              hintText: "Frais",
                              contentPadding: const EdgeInsets.only(
                                  left: 14.0, bottom: 8.0, top: 8.0),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(25.7),
                              ),
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(25.7),
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {
                                if (value.isNotEmpty) {
                                  apparte.frais = value;
                                } else {
                                  apparte.frais = '0';
                                }
                              });
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                calcule(10)
              ],
            ),
          ),
          def_prix_achat
              ? Padding(
                  padding: const EdgeInsets.only(
                    top: (100),
                    left: 25,
                    right: 25,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.black,
                    ),
                    width: largueurApp,
                    height: hauteurApp * 0.3,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            Text(
                                'Prix pour renbourser l emprunt sur 15 en auto fiancement (frais des la banque non pris en compte et taux 0) \n',
                                style: Theme.of(context).textTheme.subtitle1,
                                overflow: TextOverflow.fade),
                            Text(
                              """ prixAchat = 15 * resultat  \n resultat = (loyer * mois) - (impot + frais + assurance)  
                                """,
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              : Container(),
          def_renbourser
              ? Padding(
                  padding: const EdgeInsets.only(
                    top: (100),
                    left: 25,
                    right: 25,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.black,
                    ),
                    width: largueurApp,
                    height: hauteurApp * 0.3,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            Text(
                                "Nombre d'année pour rembourser au prix donné  \n",
                                style: Theme.of(context).textTheme.subtitle1,
                                overflow: TextOverflow.fade),
                            Text(
                              """ renboursement = prix / resultat   \n resultat = (loyer * mois) - (impot + frais + assurance)  
                                """,
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              : Container()
        ],
      ),
      bottomNavigationBar: MyFooter(),
    );
  }
}
