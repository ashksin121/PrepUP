import React, { Component } from "react";
import { withStyles } from "@material-ui/core/styles";

const styles = () => ({
    header: {
        height: "60px",
        width: "100%",
        backgroundColor: "#EBEBEB",
        display: "flex",
        alignItems: "center",
        paddingLeft: "20px",
        boxSizing: "border-box"
    },
    prepUp: {
        fontFamily: 'East Sea Dokdo, cursive',
        fontSize: "40px"
    },
    curator: {
        fontFamily: 'Pacifico, cursive',
        fontSize: "40px"
    }
});

class Header extends Component {

    render() {
        const { classes, theme } = this.props;
        return (
            <div className={classes.header}>
                <span className={classes.prepUp}>prepUP</span>
                <span className={classes.curator} style={{margin: "0 20px"}}>-</span>
                <span className={classes.curator}>Curator</span>
            </div>
        );
    }
}

export default withStyles(styles, { withTheme: true })(Header);