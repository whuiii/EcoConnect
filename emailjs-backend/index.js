const express = require("express");
const app = express();
const cors = require("cors");

// ✅ Define your router
const otpRoutes = require("./routes/app.routes"); // or otp.route.js if that's your file

// ✅ Middleware
app.use(cors());
app.use(express.json());

// ✅ Mount your router ONCE
app.use("/emailjs-backend", otpRoutes);

// ✅ Listen on all interfaces
const PORT = 4500;
app.listen(PORT, '0.0.0.0', () => {
  console.log(`Server Started on port ${PORT}`);
});


//const express = require("express");
//const app = express();
//app.use(express.json());
//app.use("/emailjs-backend", require("./routes/app.routes"));
//
//app.listen(4500, '0.0.0.0', function(){
//    console.log("Server Started")
//
//})


//const express = require('express');
//const nodemailer = require('nodemailer');
//const bodyParser = require('body-parser');
//const cors = require('cors');
//
//const app = express();
//app.use(bodyParser.json());
//app.use(cors());
//
//// Secret key to verify requests (same as serverKey in Flutter)
//const SERVER_KEY = 'mySuperSecretKey';
//
//// Replace with your Gmail or SMTP credentials
//const transporter = nodemailer.createTransport({
//  service: 'gmail',
//  auth: {
//    user: 'ecoconnect100@gmail.com',
//    pass: 'EcoConnect$+1' // Use App Password if using Gmail!
//  }
//});
//
//// Route to send OTP
//app.post('/send-otp', async (req, res) => {
//  const { serverKey, recipientMail, otp } = req.body;
//
//  if (serverKey !== SERVER_KEY) {
//    return res.status(403).json({ message: 'Invalid server key' });
//  }
//
//  const mailOptions = {
//    from: 'yourgmail@gmail.com',
//    to: recipientMail,
//    subject: 'Your OTP Code',
//    text: `Your OTP is: ${otp}`
//  };
//
//  try {
//    await transporter.sendMail(mailOptions);
//    res.json({ success: true });
//  } catch (error) {
//    console.error(error);
//    res.status(500).json({ success: false, message: error.toString() });
//  }
//});
//
//// Start server
//const PORT = process.env.PORT || 3000;
//app.listen(PORT, () => {
//  console.log(`Server listening on port ${PORT}`);
//});
