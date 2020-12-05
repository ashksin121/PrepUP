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
        console.log(doc.data())
        res.json(doc.data())
    })
    .catch(err => {
        console.log("Error: ", err)
        res.json(err)
    })
})

/*
    CREATE COURSE
    req.body = {
        "uid": "aaa1a",
        "data": {
            "links": [],
            "quizzes": [],
            "summary": "Demo Course",
            "tags": "demo course",
            "title": "Demo"
        }
    }
*/

app.post('/createCourse', (req, res) => {
    db.collection('prepup').doc('courses').get()
    .then(doc => {
        let len = Object.keys(doc.data()).length + 1
        let course = {}
        let courseId = req.body.uid + "-" + len.toString()
        let courseBody = req.body.data
        courseBody['status'] = "REVIEW"
        courseBody['instructorId'] = req.body.uid
        courseBody['numberOfStudents'] = 0
        course[courseId] = courseBody
        db.collection('prepup').doc('courses').set(
            course, { merge: true }
        ).then(doc => {
            console.log("Course added successfully")
            res.status(200).send("Course added successfully")
        })
        .catch(err => {
            console.log("Error: ", err)
            res.status(400).json(err)
        })
    })
    .catch(err => {
        console.log("Error: ", err);
        res.status(400).json(err)
    })
})

app.patch('/acceptCourse/:id', (req, res) => {
    const courseId = req.params.id
    db.collection('prepup').doc('courses').get()
    .then(doc => {
        let course = doc.data()[courseId]
        course['status'] = "ACCEPTED"
        db.collection('prepup').doc('courses').update({[courseId]: course})
        .then(doc=> {
            console.log(doc)
            res.status(200).json(doc)
        })
        .catch(err => {
            console.log("Error: ", err)
            res.status(400).json(err)
        })
    })
    .catch(err => {
        console.log("Error: ", err)
        res.status(400).json(err)
    })
})

app.patch('/rejectCourse/:id', (req, res) => {
    const courseId = req.params.id
    db.collection('prepup').doc('courses').get()
    .then(doc => {
        let course = doc.data()[courseId]
        course['status'] = "REJECTED"
        db.collection('prepup').doc('courses').update({[courseId]: course})
        .then(doc=> {
            console.log(doc)
            res.status(200).json(doc)
        })
        .catch(err => {
            console.log("Error: ", err)
            res.status(400).json(err)
        })
    })
    .catch(err => {
        console.log("Error: ", err)
        res.status(400).json(err)
    })
})

app.listen(port, () => {
    console.log(`App running on port ${port}.`)
})