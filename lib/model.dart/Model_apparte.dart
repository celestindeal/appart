// ignore: file_names
// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'dart:developer';

class Appartement_Model {
  int id = 0;
  String nom = '';
  String adresse = '';
  String postal_code = '0';
  String ville = '';
  String revenu_locatif = '0';
  String prix = '0';
  String impot_foncier = '0';
  String assurance = '0';
  String frais = '0';
  String surface = '0';

  Terrain_Model(
    String nom,
    String adresse,
    String postalCode,
    String ville,
    String revenuLocatif,
    String prix,
    String impotFoncier,
    String assurence,
    String frais,
    String surface,
  ) {
    this.nom = nom;
    this.adresse = adresse;
    this.postal_code = postalCode;
    this.ville = ville;
    this.revenu_locatif = revenuLocatif;
    this.prix = prix;
    this.impot_foncier = impotFoncier;
    assurance = assurence;
    this.frais = frais;
    this.surface = surface;
  }

  imprimer() {
    log(nom);
    log(adresse);
    log(postal_code);
    log(ville);
    log(revenu_locatif.toString());
    log(prix.toString());
    log(impot_foncier.toString());
    log(assurance.toString());
    log(frais.toString());
    log(surface.toString());
  }
}
