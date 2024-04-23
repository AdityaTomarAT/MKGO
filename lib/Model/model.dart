// ignore_for_file: prefer_void_to_null, unnecessary_question_mark, unnecessary_this, unnecessary_new, prefer_collection_literals

// import 'dart:convert';

// import 'package:flutter/services.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:http/http.dart' as http;

class model {
  int? totalCount;
  List<Courses>? courses;

  model({this.totalCount, this.courses});

  model.fromJson(Map<String, dynamic> json) {
    try {
      totalCount = json['totalCount'];
      if (json['courses'] != null) {
        courses = <Courses>[];
        if (json['courses'] is List) {
          json['courses'].forEach((v) {
            courses!.add(new Courses.fromJson(v));
          });
        } else if (json['courses'] is Map<String, dynamic>) {
          // Handle the case where 'courses' is a single course (not a list)
          courses!.add(new Courses.fromJson(json['courses']));
        }
      } else {
        print('Courses in JSON response are null');
      }
    } catch (e) {
      print('Error parsing JSON for model: $e');
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalCount'] = this.totalCount;
    if (this.courses != null) {
      data['courses'] = this.courses!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Courses {
  int? id;
  String? start;
  int? nombrePassager;
  String? commentaire;
  String? paiement;
  int? tarif;
  Null? medical;
  Null? kilometrage;
  Null? serie;
  String? filename1;
  String? filename2;
  String? destination;
  Null? typeDestination;
  Null? deletedAt;
  Null? motifSuppression;
  Null? deletedPar;
  Null? reference;
  String? backgroundColor;
  String? borderColor;
  String? textColor;
  Null? creerPar;
  Null? affectePar;
  Null? modifiePar;
  int? kmFacture;
  Null? panier;
  int? type;
  bool? isDeleted;
  InfoMedical? infoMedical;
  int? licence;
  int? region;
  int? client;
  Null? typeCourseName;
  String? chauffeur;
  int? statusCourse;
  List<AffectationCourses>? affectationCourses;

  Courses(
      {this.id,
      this.start,
      this.nombrePassager,
      this.commentaire,
      this.paiement,
      this.tarif,
      this.medical,
      this.kilometrage,
      this.serie,
      this.filename1,
      this.filename2,
      this.destination,
      this.typeDestination,
      this.deletedAt,
      this.motifSuppression,
      this.deletedPar,
      this.reference,
      this.backgroundColor,
      this.borderColor,
      this.textColor,
      this.creerPar,
      this.affectePar,
      this.modifiePar,
      this.kmFacture,
      this.panier,
      this.type,
      this.isDeleted,
      this.infoMedical,
      this.licence,
      this.region,
      this.client,
      this.typeCourseName,
      this.chauffeur,
      this.statusCourse,
      this.affectationCourses});

  Courses.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    start = json['start'];
    nombrePassager = json['nombrePassager'];
    commentaire = json['commentaire'];
    paiement = json['paiement'];
    tarif = json['tarif'];
    medical = json['medical'];
    kilometrage = json['kilometrage'];
    serie = json['serie'];
    filename1 = json['filename1'];
    filename2 = json['filename2'];
    destination = json['destination'];
    typeDestination = json['typeDestination'];
    deletedAt = json['deletedAt'];
    motifSuppression = json['motifSuppression'];
    deletedPar = json['deletedPar'];
    reference = json['reference'];
    backgroundColor = json['backgroundColor'];
    borderColor = json['borderColor'];
    textColor = json['textColor'];
    creerPar = json['creerPar'];
    affectePar = json['affectePar'];
    modifiePar = json['modifiePar'];
    kmFacture = json['kmFacture'];
    panier = json['panier'];
    type = json['type'];
    isDeleted = json['isDeleted'];
    infoMedical = json['infoMedical'] != null
        ? new InfoMedical.fromJson(json['infoMedical'])
        : null;
    licence = json['licence'];
    region = json['region'];
    client = json['client'];
    typeCourseName = json['typeCourseName'];
    chauffeur = json['chauffeur'];
    statusCourse = json['statusCourse'];
    if (json['affectationCourses'] != null) {
      affectationCourses = <AffectationCourses>[];
      json['affectationCourses'].forEach((v) {
        affectationCourses!.add(new AffectationCourses.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['start'] = this.start;
    data['nombrePassager'] = this.nombrePassager;
    data['commentaire'] = this.commentaire;
    data['paiement'] = this.paiement;
    data['tarif'] = this.tarif;
    data['medical'] = this.medical;
    data['kilometrage'] = this.kilometrage;
    data['serie'] = this.serie;
    data['filename1'] = this.filename1;
    data['filename2'] = this.filename2;
    data['destination'] = this.destination;
    data['typeDestination'] = this.typeDestination;
    data['deletedAt'] = this.deletedAt;
    data['motifSuppression'] = this.motifSuppression;
    data['deletedPar'] = this.deletedPar;
    data['reference'] = this.reference;
    data['backgroundColor'] = this.backgroundColor;
    data['borderColor'] = this.borderColor;
    data['textColor'] = this.textColor;
    data['creerPar'] = this.creerPar;
    data['affectePar'] = this.affectePar;
    data['modifiePar'] = this.modifiePar;
    data['kmFacture'] = this.kmFacture;
    data['panier'] = this.panier;
    data['type'] = this.type;
    data['isDeleted'] = this.isDeleted;
    if (this.infoMedical != null) {
      data['infoMedical'] = this.infoMedical!.toJson();
    }
    data['licence'] = this.licence;
    data['region'] = this.region;
    data['client'] = this.client;
    data['typeCourseName'] = this.typeCourseName;
    data['chauffeur'] = this.chauffeur;
    data['statusCourse'] = this.statusCourse;
    if (this.affectationCourses != null) {
      data['affectationCourses'] =
          this.affectationCourses!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class InfoMedical {
  int? id;
  String? nomTiersSoignant;
  Null? nomTiersDonneurOrdre;
  Null? nomTiersPayeur;
  Null? nomPrescripteur;
  Null? finessPrescripteur;

  InfoMedical(
      {this.id,
      this.nomTiersSoignant,
      this.nomTiersDonneurOrdre,
      this.nomTiersPayeur,
      this.nomPrescripteur,
      this.finessPrescripteur});

  InfoMedical.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    nomTiersSoignant = json['nom_tiers_soignant'];
    nomTiersDonneurOrdre = json['nom_tiers_donneur_ordre'];
    nomTiersPayeur = json['nom_tiers_payeur'];
    nomPrescripteur = json['nom_prescripteur'];
    finessPrescripteur = json['finess_prescripteur'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['nom_tiers_soignant'] = this.nomTiersSoignant;
    data['nom_tiers_donneur_ordre'] = this.nomTiersDonneurOrdre;
    data['nom_tiers_payeur'] = this.nomTiersPayeur;
    data['nom_prescripteur'] = this.nomPrescripteur;
    data['finess_prescripteur'] = this.finessPrescripteur;
    return data;
  }
}

class AffectationCourses {
  int? id;
  String? status1;
  String? status2;
  Null? deletedAt;
  Null? motifSuppression;
  Null? acceptePar;
  String? affectedAt;
  Null? affectePar;
  Null? refusePar;
  Null? annulerPar;
  String? motifAnnulation;
  String? annuleAt;
  Null? viewAdmin;
  String? date;
  Null? affectPour;

  AffectationCourses(
      {this.id,
      this.status1,
      this.status2,
      this.deletedAt,
      this.motifSuppression,
      this.acceptePar,
      this.affectedAt,
      this.affectePar,
      this.refusePar,
      this.annulerPar,
      this.motifAnnulation,
      this.annuleAt,
      this.viewAdmin,
      this.date,
      this.affectPour});

  AffectationCourses.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    status1 = json['status1'];
    status2 = json['status2'];
    deletedAt = json['deletedAt'];
    motifSuppression = json['motifSuppression'];
    acceptePar = json['acceptePar'];
    affectedAt = json['affectedAt'];
    affectePar = json['affectePar'];
    refusePar = json['refusePar'];
    annulerPar = json['annulerPar'];
    motifAnnulation = json['motifAnnulation'];
    annuleAt = json['annuleAt'];
    viewAdmin = json['viewAdmin'];
    date = json['date'];
    affectPour = json['affectPour'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['status1'] = this.status1;
    data['status2'] = this.status2;
    data['deletedAt'] = this.deletedAt;
    data['motifSuppression'] = this.motifSuppression;
    data['acceptePar'] = this.acceptePar;
    data['affectedAt'] = this.affectedAt;
    data['affectePar'] = this.affectePar;
    data['refusePar'] = this.refusePar;
    data['annulerPar'] = this.annulerPar;
    data['motifAnnulation'] = this.motifAnnulation;
    data['annuleAt'] = this.annuleAt;
    data['viewAdmin'] = this.viewAdmin;
    data['date'] = this.date;
    data['affectPour'] = this.affectPour;
    return data;
  }
}

