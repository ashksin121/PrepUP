const express = require('express')
const bodyParser = require('body-parser')
const cors = require('cors')
const runMiddleware = require('run-middleware');

const app = express()
runMiddleware(app);

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
        "links": [],
        "quizzes": [],
        "summary": "Demo Course",
        "tags": "demo course",
        "title": "Demo"
    }
*/

app.post('/createCourse/:uid', (req, res) => {
    db.collection('prepup').doc('courses').get()
    .then(doc => {
        let len = Object.keys(doc.data()).length + 1
        let course = {}
        let courseId = req.params.uid + "-" + len.toString()
        let courseBody = req.body
        console.log(req.body)
        courseBody['status'] = "REVIEW"
        courseBody['instructorId'] = req.params.uid
        courseBody['numberOfStudents'] = 0
        course[courseId] = courseBody
        console.log(course)
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
        console.log("Err: ", err);
        res.status(400).json(err)
    })
})

const increaseCoins = async (id, newCoins) => {
    const doc = await db.collection('prepup').doc('profiles').get()
    let profile = doc.data()[id]
    profile['pepCoins'] = profile['pepCoins'] + newCoins
    const res = await db.collection('prepup').doc('profiles').update({[id]: profile})
}

const acceptCourseAndReward = async (userId, newCoins, courseId) => {
    const doc = await db.collection('prepup').doc('profiles').get()
    let profile = doc.data()[userId]
    profile['pepCoins'] = profile['pepCoins'] + newCoins
    profile['coursesUploaded'].push(courseId)
    const res = await db.collection('prepup').doc('profiles').update({[userId]: profile})
}

/*
    ACCEPT COURSE
    req.body = {
        "pepCoins": 7
    }
*/

app.patch('/acceptCourse/:id', (req, res) => {
    const courseId = req.params.id
    const newCoins = req.body.pepCoins
    let instructorId = ""
    db.collection('prepup').doc('courses').get()
    .then(doc => {
        let course = doc.data()[courseId]
        instructorId = course['instructorId']
        course['status'] = "ACCEPTED"
        db.collection('prepup').doc('courses').update({[courseId]: course})
        .then(doc => {
            // console.log(doc)
        })
        .then(() => {
            acceptCourseAndReward(instructorId, newCoins, courseId)
            .then((doc) => {
                res.status(200).send("Course Accepted")
            })
            .catch(err => {
                console.log(err)
                res.status(400).send("Some error occured in accepting course")
            })
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

/*
    REJECT COURSE
    req.body = {
        "comments": "Very poorly written"
    }
*/

app.patch('/rejectCourse/:id', (req, res) => {
    const courseId = req.params.id
    const comments = req.body.comments
    db.collection('prepup').doc('courses').get()
    .then(doc => {
        let course = doc.data()[courseId]
        course['status'] = "REJECTED"
        course['comments'] = comments
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

/*
    ADD COINS
    req.body = {
        "pepCoins": 100
    }
*/

app.patch('/addCoins/:id', (req, res) => {
    const userId = req.params.id
    const newCoins = req.body.pepCoins
    increaseCoins(userId, newCoins)
    .then(doc => {
        res.status(200).send("Coins Increased")
    })
    .catch(err => {
        console.log(err)
        res.status(400).send("Some error occured")
    })
})

/*
    ADD PENDING COURSE
    req.body = {
        "courseId": "c102"
    }
*/

app.patch('/addPendingCourse/:userId', (req, res) => {
    const userId = req.params.userId
    const courseId = req.body.courseId
    db.collection('prepup').doc('profiles').get()
    .then(doc => {
        let profile = doc.data()[userId]
        profile['coursesIncomplete'].push(courseId)
        db.collection('prepup').doc('profiles').update({ [userId]: profile })
        .then((doc) => {
            res.status(200).send("Pending Course Added")
        })
        .catch(err => {
            res.status(400).send("Some error occured in update")
        })
    })
    .catch(err => {
        res.status(400).send("Some error occured in accessing profile")
    })
})

/*
    ADD COMPLETED COURSE
    req.body = {
        "courseId": "c102",
        "pepCoins": 100
    }
*/

app.patch('/addCompletedCourse/:userId', (req, res) => {
    const userId = req.params.userId
    const courseId = req.body.courseId
    const newCoins = req.body.pepCoins
    db.collection('prepup').doc('profiles').get()
    .then(doc => {
        let profile = doc.data()[userId]
        const index = profile['coursesIncomplete'].indexOf(courseId);
        if (index > -1) {
            profile['coursesIncomplete'].splice(index, 1);
        }
        profile['coursesCompleted'].push(courseId)
        profile['pepCoins'] = profile['pepCoins'] + newCoins
        db.collection('prepup').doc('profiles').update({ [userId]: profile })
        .then((doc) => {
            res.status(200).send("Completed Course Added")
        })
        .catch(err => {
            res.status(400).send("Some error occured in update")
        })
    })
    .catch(err => {
        res.status(400).send("Some error occured in accessing profile")
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
//         "prepCoins": 1100
//     }
// }
app.post('/createProfile', (req,res) => {
    console.log(req.body)
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
//     "name": "abhi",
//     "email": "aa@aa"
// }
app.post('/fetchProfile', (req,res) => {
    var uid = req.body.uid;
    var email = req.body.email;
    var Name = req.body.name;
    db.collection('prepup').doc('profiles').get()
    .then(doc => {
        console.log(doc.data()[uid])
        
        var body = {
                        "uid": uid,
                        "data": {
                            "avatar": "",
                            "coursesCompleted": [],
                            "coursesIncomplete": [],
                            "coursesUploaded": [],
                            "name": Name,
                            "email": email,
                            "prepCoins": 100
                        }
                }
        if(doc.data()[uid]==undefined)
        {
            req.runMiddleware("/createProfile",{method:'post',body:body});
            res.status(200).json("profile created");
        }
        else
        res.status(200).json(doc.data()[uid])
    })
    .catch(err => {
        console.log("Error: ", err)
        res.status(400).json(err)
    })
})
//////////////////////////////////////////////////////////////////////////////////////////


// GET AVATARS

app.get('/getAvatars', (req, res) => {
    db.collection('prepup').doc('profiles').get()
    .then(doc => {
        const data = doc.data()
        let dataToSend = {}
        for(key in data) {
            dataToSend[key] = data[key]['avatar']
        }
        res.status(200).json(dataToSend)
    })
    .catch(err => {
        res.status(400).json(err)
    })
})


///////////////////////                     CREATE QUIZ    /////////////////////////
// SAMPLE
// {
//     "uid": "aaa1a",      //course id
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
//     "uid": "aaa1a",      //course id
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
//     "uid": "aaa1a",      //user id
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