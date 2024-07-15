const UserModel = require("../models/Patient/user.model");
const MedicinModel = require("../models/Medecin/Medecin.model");
const jwt = require("jsonwebtoken");
const crypto = require("crypto");
const nodemailer = require("nodemailer");
const dotenv = require("dotenv");

dotenv.config();
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
  static async generateResetToken() {
    return crypto.randomBytes(20).toString("hex");
  }

  static async sendResetEmail(email, token) {
    const transporter = nodemailer.createTransport({
      service: "gmail",
      host: "smtp.gmail.email",
      port: 587,
      secure: false,
      auth: {
        user: process.env.MAIL,
        pass: process.env.PASS,
      },
    });
    const resetUrl = `http://localhost:3001/medecin/reset?token=${token}`;
    const mailOptions = {
      from: process.env.MAIL,
      to: email,
      subject: "Password Reset",
      html: `
      <h1>Password Reset Request</h1>
      <p>You are receiving this because you (or someone else) have requested the reset of the password for your account.</p>
      <p>Please click on the following link, or paste this into your browser to complete the process:</p>
      <a href="${resetUrl}">Reset password</a>
      <p>If you did not request this, please ignore this email and your password will remain unchanged.</p>
    `,
    };

    return transporter.sendMail(mailOptions);
  }


  static async sendResetEmailUser(email, token) {
    const transporter = nodemailer.createTransport({
      service: "gmail",
      host: "smtp.gmail.email",
      port: 587,
      secure: false,
      auth: {
        user: process.env.MAIL,
        pass: process.env.PASS,
      },
    });
    const resetUrl = `http://localhost:3001/user/reset?token=${token}`;
    const mailOptions = {
      from: process.env.MAIL,
      to: email,
      subject: "Password Reset",
      html: `
      <h1>Password Reset Request</h1>
      <p>You are receiving this because you (or someone else) have requested the reset of the password for your account.</p>
      <p>Please click on the following link, or paste this into your browser to complete the process:</p>
      <a href="${resetUrl}">Reset password</a>
      <p>If you did not request this, please ignore this email and your password will remain unchanged.</p>
    `,
    };

    return transporter.sendMail(mailOptions);
  }
}
module.exports = USerService;
