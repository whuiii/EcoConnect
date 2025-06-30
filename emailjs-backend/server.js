import express from 'express';
import cors from 'cors';
import bodyParser from 'body-parser';
import fetch from 'node-fetch';

const app = express();
const PORT = 3000;

app.use(cors()); // allow requests from your Flutter app
app.use(bodyParser.json());

app.post('/send-otp', async (req, res) => {
  const { to_email, otp } = req.body;

  const EMAILJS_SERVICE_ID = 'service_nzk63ba';
  const EMAILJS_TEMPLATE_ID = 'template_upwippp';
  const EMAILJS_USER_ID = '1XSRmgvpz1J7WLK0W';

  const payload = {
    service_id: EMAILJS_SERVICE_ID,
    template_id: EMAILJS_TEMPLATE_ID,
    user_id: EMAILJS_USER_ID,
    template_params: {
      to_email,
      otp
    }
  };

  try {
    const response = await fetch('https://api.emailjs.com/api/v1.0/email/send', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(payload)
    });

    const result = await response.json();
    console.log('EmailJS response:', result);

    if (response.status === 200) {
      res.status(200).json({ success: true, message: 'OTP sent successfully' });
    } else {
      res.status(response.status).json({ success: false, error: result });
    }
  } catch (err) {
    console.error('Error sending OTP:', err);
    res.status(500).json({ success: false, error: 'Internal server error' });
  }
});

app.listen(PORT, () => {
  console.log(`Server listening on http://localhost:${PORT}`);
});
