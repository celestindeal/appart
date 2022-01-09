import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

class Baselocal {
  static connexion() async {
    final Future<Database> database = openDatabase(
      join(await getDatabasesPath(), 'meetball.db'),
      onCreate: (db, version) async {
        db.execute(
          "CREATE TABLE appartement (nom TEXT, ville TEXT, code_postal INTEGER, adresse TEXT, revenu_locatif INTEGER, prix INTEGER, impot foncier INTEGER, assurance INTEGER, frais INTEGER,surface INTEGER)",
        );
      },
      version: 1,
    );
    return await database;
  }

  new_apparte(
      String nom,
      String adresse,
      int code_postal,
      String ville,
      int revenu_locatif,
      int prix,
      int impot_foncier,
      int assurence,
      int frais,
      int surface) async {
    final Database db = await connexion();
    Map<String, dynamic> apparte = {
      "nom": nom,
      "adresse": adresse,
      "code_postal": code_postal,
      "ville": ville,
      "revenu_locatif": revenu_locatif,
      "prix": prix,
      "impot_foncier": impot_foncier,
      "assurence": assurence,
      "frais": frais,
      "surface": surface
    };
    await db.insert("appartement", apparte);
  }

  apparte() async {
    final Database db = await connexion();

    List tkt = await db.query('appartement');

    return tkt;
  }
}
