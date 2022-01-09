import 'dart:developer';

import 'package:appartement/model.dart/Model_apparte.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

class Baselocal {
  static connexion() async {
    final Future<Database> database = openDatabase(
      join(await getDatabasesPath(), 'imobilier.db'),
      onCreate: (db, version) async {
        db.execute(
          "CREATE TABLE appartement (id INTEGER PRIMARY KEY autoincrement, nom TEXT, ville TEXT, code_postal TEXT, adresse TEXT, revenu_locatif TEXT, prix TEXT, impot_foncier TEXT, assurance TEXT, frais TEXT,surface TEXT)",
        );
      },
      version: 1,
    );
    return await database;
  }

  new_apparte(Appartement_Model appartement) async {
    final Database db = await connexion();
    Map<String, dynamic> apparte = {
      "nom": appartement.nom,
      "adresse": appartement.adresse,
      "code_postal": appartement.postal_code,
      "ville": appartement.ville,
      "revenu_locatif": appartement.revenu_locatif,
      "prix": appartement.prix,
      "impot_foncier": appartement.impot_foncier,
      "assurance": appartement.assurance,
      "frais": appartement.frais,
      "surface": appartement.surface
    };
    await db.insert("appartement", apparte);
  }

  delete_appart(int id) async {
    final Database db = await connexion();

    db.delete('appartement', where: 'id = $id');
  }

  Future<List<Appartement_Model>> apparte() async {
    final Database db = await connexion();

    List tkt = await db.query('appartement');
    List<Appartement_Model> list_appart = [];

    for (var i = 0; i < tkt.length; i++) {
      Appartement_Model appartement = Appartement_Model();
      appartement.id = tkt[i]['id'];
      appartement.nom = tkt[i]['nom'];
      appartement.adresse = tkt[i]['adresse'];
      appartement.postal_code = tkt[i]['code_postal'];
      appartement.ville = tkt[i]['ville'];
      appartement.revenu_locatif = tkt[i]['revenu_locatif'];
      appartement.prix = tkt[i]['prix'];
      appartement.impot_foncier = tkt[i]['impot_foncier'];
      appartement.assurance = tkt[i]['assurance'];
      appartement.frais = tkt[i]['frais'];
      appartement.surface = tkt[i]['surface'];

      list_appart.add(appartement);
    }
    log(list_appart.toString());
    return list_appart;
  }
}
