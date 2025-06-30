var nodemailer = require('nodemailer');

async function sendEmail(params, callback){
    const transport = nodemailer.createTransport({
        host: 'imap.gmail.com',
        port: 993,
        auth: {
            user: 'ecoconnect100@gmail.com',
            pass: 'EcoConnect$+1'
        }
        }
    );

    var mailOptions = {
        from: 'tan_22003586@utp.edu.my'
        to: params.email,
        subject: params.subject,
        text: params.body,
    };

    transporter.sendMail(mailOptions, function(error, info){
        if(error){
            return  callback(error);
        }else{
            return callback(null, info.response);
        }
    });
}

module.exports = {
    sendEmail
}