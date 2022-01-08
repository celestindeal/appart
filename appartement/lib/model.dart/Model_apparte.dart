import 'package:flutter/material.dart';
import 'dart:developer';

class Appartement_Model {
  String nom = 'nom';
  String adresse = '';
  int postal_code = 10;
  String ville = '';
  int revenu_locatif = 0;
  int prix = 0;
  int impot_foncier = 0;
  int assurence = 0;
  int frais = 0;
  int surface = 0;

  Terrain_Model(
    String nom,
    String adresse,
    int postal_code,
    String ville,
    int revenu_locatif,
    int prix,
    int impot_foncier,
    int assurence,
    int frais,
    int surface,
  ) {
    this.nom = nom;
    this.adresse = adresse;
    this.postal_code = postal_code;
    this.ville = ville;
    this.revenu_locatif = revenu_locatif;
    this.prix = prix;
    this.impot_foncier = impot_foncier;
    this.assurence = assurence;
    this.frais = frais;
    this.surface = surface;
  }

  imprimer() {
    log(this.nom);
    log('opef');
    log(this.adresse);
    log(this.postal_code.toString());
    log(this.ville);
    log(this.revenu_locatif.toString());
    log(this.prix.toString());
    log(this.impot_foncier.toString());
    log(this.assurence.toString());
    log(this.frais.toString());
    log(this.surface.toString());
  }
}
