const Nexmo = require('nexmo');

const nexmo = new Nexmo({
  apiKey: '',
  apiSecret: '',
  applicationId: '',
  privateKey: 'private.key',
});

// const ncco = [
//     {
//       action: 'talk',
//       voiceName: 'Joey',
//       text:
//         'This is a text-to-speech test message.',
//     },
//   ];

const ncco = [
    {
        "action": "stream",
        "streamUrl": [
            // "https://nexmo-community.github.io/ncco-examples/assets/voice_api_audio_streaming.mp3"
            "https://dl19.freemp3downloads.online/file/youtubeFM7MFYoylVs320.mp3?fn=The%20Chainsmokers%20%26%20Coldplay%20-%20Something%20Just%20Like%20This%20(Lyric).mp3"
        ]
    }
]

  nexmo.calls.create(
    {
      to: [{ type: 'phone', number: '919734793007' }],
      from: { type: 'phone', number: '919734793007' },
      ncco,
    },
    (err, result) => {
      console.log(err || result);
    },
  );