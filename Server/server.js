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

app.listen(port, () => {
    console.log(`App running on port ${port}.`)
})