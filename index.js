const express = require('express');
const bodyParser = require('body-parser');
const { Client, middleware } = require('@line/bot-sdk');

// ตั้งค่า LINE SDK
const config = {
  channelAccessToken: 'QVg/PXQg4HFX10Uqa5xRYedamPaBdXpJikd1yQGPwkGRPVyHkMTvci/jjt2Firjs85pW7/5yDEAm5/oup2Mo3pNxEeNjkF0KF8Lb3Xmz2Imj+/QJr+mjCO82VfJAzRCN3VD989jYyovZMV0jpIHGJgdB04t89/1O/w1cDnyilFU=',
  channelSecret: '10125471c8c179faea29bc5d7e44e559'
};

const app = express();

// ใช้ middleware ของ LINE เพื่อการยืนยันความถูกต้องของ webhook
app.use(middleware(config));
app.use(bodyParser.json());

// สร้าง Webhook endpoint
app.post('/webhook', (req, res) => {
  Promise
    .all(req.body.events.map(handleEvent))
    .then((result) => res.json(result))
    .catch((err) => {
      console.error(err);
      res.status(500).end();
    });
});

// ฟังก์ชันจัดการกับ event จาก LINE
function handleEvent(event) {
  if (event.type !== 'message' || event.message.type !== 'text') {
    // ถ้าไม่ใช่ข้อความให้ไม่ทำงาน
    return Promise.resolve(null);
  }

  // สร้างไคลเอนต์สำหรับการส่งข้อความ
  const client = new Client(config);
  const replyToken = event.replyToken;
  const userMessage = event.message.text;

  // ส่งข้อความตอบกลับ
  const responseMessage = { type: 'text', text: `คุณพูดว่า: ${userMessage}` };
  return client.replyMessage(replyToken, responseMessage);
}

// เริ่มเซิร์ฟเวอร์
app.listen(3000, () => {
  console.log('Server is running on port 3000');
});
