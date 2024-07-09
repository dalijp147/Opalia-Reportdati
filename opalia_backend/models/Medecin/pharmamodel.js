const moogoose = require("mongoose");
const FarmaSchema = moogoose.Schema({
  nompatient: {
    type: String,
  },
  prenompatient: {
    type: String,
  },
  villepatient: {
    type: String,
  },
  codepostal: {
    type: Number,
  },
  DateNaissance: {
    type: Date,
    default: Date.now,
  },
  poids: {
    type: Number,
  },
  age: {
    type: Number,
  },
  taille: {
    type: Number,
  },
  sexe: {
    type: String,
  },
  nouveunéé: {
    type: String,
  },
  produit: {
    type: String,
  },
  grosses: {
    type: String,
  },
  arret: {
    type: String,
  },
  disparition: {
    type: String,
  },
  réintroduits: {
    type: String,
  },
  réapparition: {
    type: String,
  },

  //////
  nomdeclarent: {
    type: String,
  },
  prenomdeclarent: {
    type: String,
  },
  villedeclarent: {
    type: String,
  },
  codepostaldeclarent: {
    type: Number,
  },
  telephonedeclarent: {
    type: Number,
  },
  Qualité: {
    type: String,
  },
  /////
  medcineclarent: {
    type: String,
  },

  nomdeclarentmedecoin: {
    type: String,
  },
  prenomdeclarentmedecoin: {
    type: String,
  },
  telephonedeclarentmedein: {
    type: Number,
  },
  qualitemedecindeclartent: {
    type: String,
  },

  /////

  villeeffet: {
    type: String,
  },
  dateeffet: {
    type: Date,
    default: Date.now,
  },
  duree: {
    type: Number,
  },
  description: {
    type: String,
  },

  ////
  gravité: {
    type: String,
  },

  ////
  evolution: {
    type: String,
  },
});
module.exports = moogoose.model("pharma", FarmaSchema);
