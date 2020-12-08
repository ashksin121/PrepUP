import React, { Component } from "react";
import { withStyles } from "@material-ui/core/styles";
import TextField from '@material-ui/core/TextField';
import Paper from '@material-ui/core/Paper';
import InputAdornment from '@material-ui/core/InputAdornment';
import CheckIcon from '@material-ui/icons/Check';
import ClearIcon from '@material-ui/icons/Clear';
import Dialog from '@material-ui/core/Dialog';
import DialogActions from '@material-ui/core/DialogActions';
import DialogContent from '@material-ui/core/DialogContent';
import DialogContentText from '@material-ui/core/DialogContentText';
import DialogTitle from '@material-ui/core/DialogTitle';
import Button from '@material-ui/core/Button';
import FormControl from "@material-ui/core/FormControl";
import FormHelperText from "@material-ui/core/FormHelperText";
import Input from '@material-ui/core/Input';
import InputLabel from '@material-ui/core/InputLabel';
import CircularProgress from '@material-ui/core/CircularProgress';

import {db} from '../firebase';

const axios = require('axios');

const styles = () => ({
    dashboard: {
        height: "calc(100vh - 60px)",
        width: "80%",
        padding: "20px",
        boxSizing: "border-box",
        overflow: "auto"
    },
    searchBar: {
        '& .MuiOutlinedInput-root': {
            '&.Mui-focused fieldset': {
                borderColor: '#619f9a',
            },
        },
        '& label.Mui-focused': {
            color: '#619f9a',
            fontWeight: "bold"
        }
    },
    mainBody: {
        marginTop: "20px",
        width: "100%"
    },
    card: {
        padding: "20px",
        width: "100%",
        boxSizing: "border-box",
        marginBottom: "20px"
    },
    courseTitle: {
        fontSize: "20px",
        fontWeight: "bold",
        marginBottom: "10px"
    },
    fieldValue: {
        fontWeight: "bold",
        fontSize: "15px"
    },
    filedTag: {
        fontWeight: "bold",
        fontSize: "10px",
        color: "#8d8d8d"
    },
    courseSummary: {
        fontSize: "15px",
        marginBottom: "10px",
        marginTop: "10px"
    },
    courseLink: {
        fontSize: "15px",
        color: "blue",
        cursor: "pointer"
    },
    acceptButton: {
        margin: "10px 10px 10px 0",
        boxSizing: "border-box",
        width: "50%",
        height: "30px",
        borderRadius: "4px",
        display: "flex",
        justifyContent: "center",
        alignItems: "center",
        backgroundColor: "#36BE73",
        padding: "10px",
        cursor: "pointer",
        fontWeight: "bold",
        color: "white"
    },
    rejectButton: {
        margin: "10px 0 10px 10px",
        boxSizing: "border-box",
        width: "50%",
        height: "30px",
        borderRadius: "4px",
        display: "flex",
        justifyContent: "center",
        alignItems: "center",
        backgroundColor: "#EA4D23",
        padding: "10px",
        cursor: "pointer",
        fontWeight: "bold",
        color: "white"
    }
});

class Dashboard extends Component {

    constructor(props) {
        super(props);
        this.state = {
            searchValue: "", 
            courses: [],
            acceptOpen: false,
            selectedCourseId: "",
            rejectOpen: false,
            acceptCoins: 0,
            errorAccept: false,
            rejectComments: "",
            errorReject: false,
            loading: false
        }
    }

    componentDidMount() {
        db.collection('prepup').doc('courses')
        .onSnapshot(doc => {
            const data = doc.data()
            let courses = []
            for (const key in data) {
                if(data[key]['status']==="REVIEW") {
                    data[key]['courseId'] = key
                    courses.push(data[key])
                }
            }
            this.setState({ courses: courses })
        })
    }

    handleCloseAccept = () => {
        this.setState({ acceptOpen: false, acceptCoins: 0, errorAccept: false, loading: true })
    }

    handleCloseReject = () => {
        this.setState({ rejectOpen: false, rejectComments: "", errorReject: false, loading: true })
    }

    handleAcceptCourse = () => {
        if(!this.state.errorAccept && parseInt(this.state.acceptCoins)>=0 && parseInt(this.state.acceptCoins)<=10) {
            this.setState({ loading: true })
            let data = {
                "pepCoins": parseInt(this.state.acceptCoins)
            }
            axios.patch('http://localhost:8080/acceptCourse/'+this.state.selectedCourseId, data)
            .then(response => {
                console.log(response.data)
                this.handleCloseAccept()
            })
            .catch(err => {
                this.setState({ loading: false })
                console.log("Error: ", err)
            })
        }
    }

    handleRejectCourse = () => {
        if(!this.state.errorReject && this.state.rejectComments!=="") {
            this.setState({ loading: true })
            let data = {
                "comments": this.state.rejectComments
            }
            axios.patch('http://localhost:8080/rejectCourse/'+this.state.selectedCourseId, data)
            .then(response => {
                console.log(response.data)
                this.handleCloseReject()
            })
            .catch(err => {
                this.setState({ loading: false })
                console.log("Error: ", err)
            })
        }
    }

    handleSearch = (course) => {
        if(this.state.searchValue==="") {
            return true;
        } else {
            let re = new RegExp(this.state.searchValue, "gi");
            let searchBool = re.test(course.title) || re.test(course.tags)
            return searchBool;
        }
    }

    render() {
        const { classes, theme } = this.props;

        console.log(this.state.courses)

        return (
            <div className={classes.dashboard}>
                <TextField 
                label="Search" 
                variant="outlined"
                fullWidth
                className={classes.searchBar}
                value={this.state.searchValue}
                onChange={(e) => {
                    this.setState({ searchValue: e.target.value });
                }} />
                <div className={classes.mainBody}>
                    {
                        this.state.courses.map((course, key) => {
                            if(this.handleSearch(course)) {
                                return (
                                    <Paper elevation={3} className={classes.card}>
                                        <div className={classes.courseTitle}>{course.title}</div>
                                        <div style={{display: "flex", justifyContent: "space-between"}}>
                                            <div>
                                                <div className={classes.fieldValue}>{course.courseId}</div>
                                                <div className={classes.filedTag}>Course ID</div>
                                            </div>
                                            <div>
                                                <div className={classes.fieldValue}>{course.instructorId || "No Instructor"}</div>
                                                <div className={classes.filedTag}>Instructor ID</div>
                                            </div>
                                        </div>
                                        <div className={classes.courseSummary}>{course.summary}</div>
                                        <div className={classes.fieldValue}>{course.tags}</div>
                                        <div className={classes.filedTag}>Tags</div>
                                        <div className={classes.filedTag} style={{marginTop: "10px"}}>Links for documents uploaded</div>
                                        {
                                            course.links.map((link, key) => (
                                                <div className={classes.courseLink} onClick={() => {
                                                    window.open(link)
                                                }}>{link}</div>
                                            ))
                                        }
                                        <div style={{display: "flex", width: "100%"}}>
                                            <div className={classes.acceptButton} onClick={() => {
                                                this.setState({ acceptOpen: true, selectedCourseId: course.courseId })
                                            }}>
                                                <CheckIcon /> ACCEPT
                                            </div>
                                            <div className={classes.rejectButton} onClick={() => {
                                                this.setState({ rejectOpen: true, selectedCourseId: course.courseId })
                                            }}>
                                                <ClearIcon /> REJECT
                                            </div>
                                        </div>
                                    </Paper>
                                )
                            }
                        })
                    }
                </div>
                <Dialog open={this.state.acceptOpen} onClose={this.handleCloseAccept} aria-labelledby="form-dialog-title">
                    <DialogTitle id="form-dialog-title">Accept Course</DialogTitle>
                    <DialogContent>
                        <DialogContentText>
                            Give extra points to the instructor based on the quality of the course uploaded!
                        </DialogContentText>
                        <FormControl error={this.state.errorAccept}>
                            <InputLabel htmlFor="component-error">Extra coins for acceptance</InputLabel>
                            <Input
                            id="component-error"
                            value={this.state.acceptCoins}
                            autoFocus
                            type="number"
                            aria-describedby="component-error-text"
                            onChange={(e) => {
                                let coins = parseInt(e.target.value)
                                this.setState({ acceptCoins: e.target.value })
                                if(e.target.value==="" || coins>10) {
                                    this.setState({ errorAccept: true })
                                } else {
                                    this.setState({ errorAccept: false })
                                }
                            }}
                            endAdornment={<InputAdornment position="end">/10</InputAdornment>}
                            />
                            {
                                this.state.errorAccept ?
                                <FormHelperText id="component-error-text">Value should be between 0 and 10 inclusive</FormHelperText>
                                : null
                            }
                        </FormControl>
                    </DialogContent>
                    {
                        this.state.loading ?
                        <CircularProgress /> :
                        <DialogActions>
                            <Button onClick={this.handleCloseAccept} color="primary">
                                Cancel
                            </Button>
                            <Button onClick={this.handleAcceptCourse} color="primary">
                                Accept
                            </Button>
                        </DialogActions>
                    }
                </Dialog>
                <Dialog open={this.state.rejectOpen} onClose={this.handleCloseReject} aria-labelledby="form-dialog-title">
                    <DialogTitle id="form-dialog-title">Reject Course</DialogTitle>
                    <DialogContent>
                        <DialogContentText>
                            Give comments to the instructor stating the reason(s) for rejection!
                        </DialogContentText>
                        <FormControl error={this.state.errorReject} style={{width: "100%"}}>
                            <TextField
                                id="outlined-multiline-static"
                                label="Comments for rejection"
                                multiline
                                rows={4}
                                variant="outlined"
                                value={this.state.rejectComments}
                                onChange={(e) => {
                                    this.setState({ rejectComments: e.target.value })
                                    if(e.target.value==="") {
                                        this.setState({ errorReject: true })
                                    } else {
                                        this.setState({ errorReject: false })
                                    }
                                }}
                                fullWidth
                            />
                            {
                                this.state.errorReject ?
                                <FormHelperText id="component-error-text">Include some comments</FormHelperText>
                                : null
                            }
                        </FormControl>
                    </DialogContent>
                    {
                        this.state.loading ?
                        <CircularProgress /> :
                        <DialogActions>
                            <Button onClick={this.handleCloseReject} color="primary">
                                Cancel
                            </Button>
                            <Button onClick={this.handleRejectCourse} color="primary">
                                Reject
                            </Button>
                        </DialogActions>
                    }
                </Dialog>
            </div>
        );
    }
}

export default withStyles(styles, { withTheme: true })(Dashboard);