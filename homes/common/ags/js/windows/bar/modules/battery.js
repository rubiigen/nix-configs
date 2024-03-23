import { Widget, Battery } from "../../../imports.js";
import { getBatteryTime, getBatteryIcon, getBatteryTooltip } from "../../../utils/battery.js";
const { Box, Label } = Widget;

const BatIcon = () =>
    Label({ className: "batIcon" })
        // NOTE: label needs to be used instead of icon here
        .bind("label", Battery, "percent", getBatteryIcon)
        .bind("label", Battery, "charging", getBatteryIcon)
        .bind("tooltip-text", Battery, "percent", getBatteryTooltip); // TODO: add battery percentage in here

export const BatteryWidget = () =>
    Box({
        className: "battery",
        cursor: "pointer",
        child: BatIcon(),
        visible: Battery.bind("available"),
    });
