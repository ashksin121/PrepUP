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
            // res.status(200).send("Course added successfully")
            res.status(200).json(courseId);
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
    res.status(200).json("Profile created successfully!!")
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
        res.status(200).json(doc.data()[uid])
    })
    .catch(err => {
        console.log("Error: ", err)
        res.status(400).json(err)
    })
})
//////////////////////////////////////////////////////////////////////////////////////////


///////////////////////                     CREATE QUIZ    /////////////////////////
// SAMPLE
// {
//     "uid": "aaa1a",
//     "data": [
//         {
//             "answer": 1,
//             "options": ["Rahul Gandhi", "Narendra Modi", "Sonia Gandhi", "Amit Shah"],
//             "question": "PM of India"
//         },
//         {
//             "answer": 2,
//             "options": ["Rahul Gandhi", "Narendra Modi", "Mamata Banerjee", "Amit Shah"],
//             "question": "CM of West Bengal"
//         },
//         {
//             "answer": 0,
//             "options": ["1957", "1959", "1948", "1953"],
//             "question": "In which year did Ghana gain independence and ended colonialism?"
//         }
//     ]
// }
app.post('/createQuiz', (req,res) => {
    var prepRef = db.collection('prepup').doc('quiz');
    var uid = req.body.uid;
    var content={};
    content[uid]=req.body.data;
    var setWithMerge = prepRef.set(
        content, { merge: true }
    );
    // console.log(data)
    res.status(200).json("Quiz created successfully!!")
})
//////////////////////////////////////////////////////////////////////////////////////////


///////////////////////                     FETCH QUIZ    /////////////////////////
// SAMPLE
// {
//     "uid": "aaa1a",
// }
app.get('/fetchQuiz', (req,res) => {
    var uid = req.body.uid;
    db.collection('prepup').doc('quiz').get()
    .then(doc => {
        console.log(doc.data()[uid])
        res.status(200).json(doc.data()[uid])
    })
    .catch(err => {
        console.log("Error: ", err)
        res.status(400).json(err)
    })
})
//////////////////////////////////////////////////////////////////////////////////////////

///////////////////////                     FETCH RANDOM QUIZ    /////////////////////////
// SAMPLE
// {
//     "uid": "aaa1a",
// }
app.get('/fetchRandomQuiz', (req,res) => {
    var uid = req.body.uid;
    var docRef = db.collection("prepup").doc("profiles");
    docRef.get().then(function(doc) {
        if (doc.exists) {
            var coursesCompleted = doc.data()[uid].coursesCompleted;
            var resp=[];
            db.collection("prepup").doc("quiz").get().then(function(doc1) {
                if (doc1.exists) {
                    var quizzes=doc1.data();
                    var i=10;
                    
                    coursesCompleted.map(idx=>{
                        // console.log(quizzes[idx]);
                        // var quiz=quizzes[idx];
                        resp.push(quizzes[idx][Math.floor(Math.random() * quizzes[idx].length)]);
                        i--;
                    })
                    var GK = quizzes["general_knowledge"];
                    resp=resp.concat(GK.sort(() => Math.random() - Math.random()).slice(0, i));
                    res.status(200).json(resp);
                } else {
                    // doc.data() will be undefined in this case
                    res.status(400).json("Error");
                    console.log("No such document!");
                }
            }).catch(function(error) {
                console.log("Error getting document:", error);
                res.status(400).json("Error");
            });
            // res.status(200).json(resp);
        } else {
            // doc.data() will be undefined in this case
            console.log("No such document!");
        }
    }).catch(function(error) {
        console.log("Error getting document:", error);
    });
})
//////////////////////////////////////////////////////////////////////////////////////////

app.listen(port, () => {
    console.log(`App running on port ${port}.`)
})