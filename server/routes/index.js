var express = require('express');
var router = express.Router();
const { RtcTokenBuilder, RtmTokenBuilder, RtcRole, RtmRole } = require('agora-access-token')
const axios = require('axios');
const admin = require('firebase-admin');

const serviceAccount = require('');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

const db = admin.firestore();

router.get('/hello', async (req, res) => {
  let pushToken = '';
  let serverToken =
    '';
  axios.post('https://fcm.googleapis.com/fcm/send', {
    'notification': {
      'body': 'this is a body',
      'title': 'this is a title'
    },
    'priority': 'high',
    'data': {
      'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      'id': '1',
      'status': 'done'
    },
    'to': pushToken,
  }, {
    headers: {
      'Content-Type': 'application/json',
      'Authorization': 'key=' + serverToken,
    }
  })
    .then(function (response) {
      // handle success
      console.log('done');
    })
    .catch(function (error) {
      // handle error
      console.log(error);
    })
    .then(function () {
      // always executed
    });
  res.json({ "msg": 'okay' })
})

router.get('/', async (req, res) => {
  // Rtc Examples
  const { uid, channelName } = req.query;

  const appID = '';
  const appCertificate = '';
  const role = RtcRole.PUBLISHER;

  const expirationTimeInSeconds = 3600

  const currentTimestamp = Math.floor(Date.now() / 1000)

  const privilegeExpiredTs = currentTimestamp + expirationTimeInSeconds

  const tokenA = RtcTokenBuilder.buildTokenWithUid(appID, appCertificate, channelName, uid, role, privilegeExpiredTs);
  res.json({ token: tokenA })
})



module.exports = router;