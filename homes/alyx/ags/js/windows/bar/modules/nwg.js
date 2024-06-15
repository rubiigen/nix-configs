import { Widget, Utils } from "../../../imports.js";
const { Button, Label } = Widget;

export const nwggrid = () =>
    Button({
        className: "nwg",
        cursor: "pointer",
        child: Label("󰕰"),
        onClicked: () => Utils.exec("nwggrid"),
    });
