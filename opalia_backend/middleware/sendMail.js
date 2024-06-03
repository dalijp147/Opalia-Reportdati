const nodemailer = require("nodemailer");
const dotenv = require("dotenv");
dotenv.config();

const sendEmail = async (email, subject, text) => {
  try {
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

    await transporter.sendMail({
      from: process.env.MAIL,
      to: email,
      subject: subject,
      text: text,
    });
    console.log("email sent sucessfully");
  } catch (error) {
    console.log("email not sent");
    console.log(error);
  }
};

module.exports = sendEmail;

// const transporter = nodemailer.createTransport({
//   service: "gmail",
//   // host: "smtp.gmail.email",
//   port: 587,
//   secure: false, // Use `true` for port 465, `false` for all other ports
//   auth: {
//     user: process.env.MAIL,
//     pass: process.env.PASS,
//   },
// });
// const mailOptions = {
//   from: {
//     name: "opalia",
//     address: process.env.MAIL,
//   }, // sender address
//   to: "dalybouderbela@gmail.com",
//   subject: "Hello ilyess", // Subject line
//   text: "Hello?", // plain text body
//   html: "<p>For clients that do not support AMP4EMAIL or amp content is not valid</p>",
//   amp: `<!doctype html>
//   <html ⚡4email>
//     <head>
//       <meta charset="utf-8">
//       <style amp4email-boilerplate>body{visibility:hidden}</style>
//       <script async src="https://cdn.ampproject.org/v0.js"></script>
//       <script async custom-element="amp-anim" src="https://cdn.ampproject.org/v0/amp-anim-0.1.js"></script>
//     </head>
//     <body>
//       <p>Image: <amp-img src="https://cldup.com/P0b1bUmEet.png" width="16" height="16"/></p>
//       <p>GIF (requires "amp-anim" script in header):<br/>
//         <amp-anim src="https://cldup.com/D72zpdwI-i.gif" width="500" height="350"/></p>
//     </body>
//   </html>`, // html body
// };

// const sendMail = async (transporter, mailOptions) => {
//   try {
//     await transporter.sendMail(mailOptions);
//     console.log("Email has been send");
//   } catch (error) {
//     console.error(error);
//   }
// };
// sendMail(transporter, mailOptions);
