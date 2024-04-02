const UserModel = require("../models/user.model");
const jwt = require("jsonwebtoken");
class USerService {
  static async checkuser(email) {
    try {
      return await UserModel.findOne({ email });
    } catch (error) {
      throw error;
    }
  }
  static async generateAccessToken(tokenData, JWTSecret_Key, JWT_EXPIRE) {
    return jwt.sign(tokenData, JWTSecret_Key, { expiresIn: JWT_EXPIRE });
  }
}
module.exports = USerService;
