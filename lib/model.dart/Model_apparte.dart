import 'package:flutter/material.dart';
import 'dart:developer';

class Appartement_Model {
  int id = 0;
  String nom = 'nom';
  String adresse = '';
  String postal_code = '';
  String ville = '';
  String revenu_locatif = '';
  String prix = '';
  String impot_foncier = '';
  String assurance = '';
  String frais = '';
  String surface = '';

  Terrain_Model(
    String nom,
    String adresse,
    String postal_code,
    String ville,
    String revenu_locatif,
    String prix,
    String impot_foncier,
    String assurence,
    String frais,
    String surface,
  ) {
    this.nom = nom;
    this.adresse = adresse;
    this.postal_code = postal_code;
    this.ville = ville;
    this.revenu_locatif = revenu_locatif;
    this.prix = prix;
    this.impot_foncier = impot_foncier;
    this.assurance = assurence;
    this.frais = frais;
    this.surface = surface;
  }

  imprimer() {
    log(this.nom);
    log(this.adresse);
    log(this.postal_code);
    log(this.ville);
    log(this.revenu_locatif.toString());
    log(this.prix.toString());
    log(this.impot_foncier.toString());
    log(this.assurance.toString());
    log(this.frais.toString());
    log(this.surface.toString());
  }
}
