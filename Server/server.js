const express = require('express')
const bodyParser = require('body-parser')
const cors = require('cors')

const app = express()

const admin = require('firebase-admin')

const serviceAccount = require('./serviceAccountCredentials.json')

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount)
});

const db = admin.firestore()

app.use(bodyParser.json())
app.use(cors())

const port = process.env.PORT || 8080

app.get('/', (req, res)=> {
    res.json("GET working!!")
})

app.post('/', (req, res)=> {
    res.json("POST working!!")
})

app.get('/getAllCourses', (req, res) => {
    db.collection('prepup').doc('courses').get()
    .then(doc => {
        console.log(doc)
        res.json(doc)
    })
    .catch(err => {
        console.log("Error: ", err)
        res.json(err)
    })
})

///////////////////////                     CREATE PROFILE    /////////////////////////
// SAMPLE
// {
//     "uid": "aaa1a",
//     "data": {
//         "avatar": "",
//         "coursesCompleted": ["c201"],
//         "coursesIncomplete": ["c203","c204"],
//         "coursesUploaded": [],
//         "name": "Abhi",
//         "pepCoins": 1100
//     }
// }
app.post('/createProfile', (req,res) => {
    var prepRef = db.collection('prepup').doc('profiles');
    var uid = req.body.uid;
    var content={};
    content[uid]=req.body.data;
    var setWithMerge = prepRef.set(
        content, { merge: true }
    );
    // console.log(data)
    res.json("Profile created successfully!!")
})
//////////////////////////////////////////////////////////////////////////////////////////



///////////////////////                     FETCH PROFILE    /////////////////////////
// SAMPLE
// {
//     "uid": "aaa1a",
// }
app.get('/fetchProfile', (req,res) => {
    var uid = req.body.uid;
    db.collection('prepup').doc('profiles').get()
    .then(doc => {
        console.log(doc.data()[uid])
        res.json(doc.data()[uid])
    })
    .catch(err => {
        console.log("Error: ", err)
        res.json(err)
    })
})
//////////////////////////////////////////////////////////////////////////////////////////


app.listen(port, () => {
    console.log(`App running on port ${port}.`)
})