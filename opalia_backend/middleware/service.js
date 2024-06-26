const UserModel = require("../models/Patient/user.model");
const MedicinModel = require("../models/Medecin/Medecin.model");
const jwt = require("jsonwebtoken");
class USerService {
  static async checkuser(email) {
    try {
      return await UserModel.findOne({ email });
    } catch (error) {
      throw error;
    }
  }
  static async checkuserMedecin(email) {
    try {
      return await MedicinModel.findOne({ email });
    } catch (error) {
      throw error;
    }
  }
  static async generateAccessToken(tokenData, JWTSecret_Key, JWT_EXPIRE) {
    return jwt.sign(tokenData, JWTSecret_Key, { expiresIn: JWT_EXPIRE });
  }
  // static async checkuser(email) {
  //   try {
  //     return await UserModel.findOne({ email });
  //   } catch (error) {
  //     throw error;
  //   }
  // }
}
module.exports = USerService;
