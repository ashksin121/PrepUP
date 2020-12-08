import React, { Component } from "react";
import { withStyles } from "@material-ui/core/styles";
import mascot from '../assests/mascot.png';

const styles = () => ({
    sideBar: {
        height: "calc(100vh - 60px)",
        width: "20%",
        backgroundColor: "#619f9a",
        display: "flex",
        direction: "column"
    }
});

class SideBar extends Component {

    render() {
        const { classes, theme } = this.props;
        return (
            <div className={classes.sideBar}>
                <img src={mascot} alt="mascot" style={{width: "90%"}} />
            </div>
        );
    }
}

export default withStyles(styles, { withTheme: true })(SideBar);