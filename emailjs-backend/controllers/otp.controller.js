const otpService = require("../services/otp.service");

exports.otpLogin = (req, res, next) => {
    console.log('Received OTP Login:', req.body);
    otpService.sendOTP(req.body, (error, results) => {
        if(error){
            console.error('Error in sendOTP:', error);
            return res.status(400).send({
                message: "error",
                data: error,
            });
        }
        console.log('sendOTP results:', results);
        return res.status(200).send({
            message: "result",
            data: results,
        });
    });

};


exports.verifyOTP = (req, res, next) => {
    otpService.verifyOTP(req.body, (error, results) => {
        if(error){
            return res.status(400).send({
                message: "error",
                data: error,
            });
        }
        return res.status(200).send({
            message: "Success",
            data: results,
        });
    });

};