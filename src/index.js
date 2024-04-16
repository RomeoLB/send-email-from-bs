//npx webpack --config webpack.config.js
const express = require('express');
const nodemailer = require('nodemailer');
const bodyParser = require('body-parser');

const app = express();
const port = 8000;

app.use(bodyParser.urlencoded({ extended: false }));

// Nodemailer configuration
const transporter = nodemailer.createTransport({
    service: 'gmail',
    auth: {
        user: 'your-email@googlemail.com',
        pass: 'put-your-password-there' //https://nodemailer.com/usage/using-gmail/
    }
});

// Route to handle form submission
app.post('/send-email', (req, res) => {
    const { name, phoneNumber, message, recipientEmail } = req.body;

    const mailOptions = {
        from: 'your-email@gmail.com',
        to: recipientEmail,
        subject: 'Message from your app',
        text: `Name: ${name}\nPhone Number: ${phoneNumber}\nMessage: ${message}`
    };

    transporter.sendMail(mailOptions, (error, info) => {
        if (error) {
            console.log(error);
            res.send('Error occurred, email not sent.');
        } else {
            console.log('Email sent: ' + info.response);
            res.send('Email sent successfully!');
        }
    });
});

app.listen(port, () => {
    console.log(`App listening at http://localhost:${port}`);
});
