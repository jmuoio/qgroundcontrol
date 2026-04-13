import QtQuick
import QtQuick.Layouts

import QGroundControl
import QGroundControl.Controls

Item {
    id:             control
    anchors.top:    parent.top
    anchors.bottom: parent.bottom
    width:          cellIcon.width * 1.1

    // Only show when we have received at least one message
    property bool showIndicator: _activeVehicle ? _activeVehicle.radio !== 0 : false

    property var _activeVehicle: QGroundControl.multiVehicleManager.activeVehicle

    QGCColoredImage {
        id:                 cellIcon
        anchors.top:        parent.top
        anchors.bottom:     parent.bottom
        width:              height
        sourceSize.height:  height
        source:             "/qmlimages/TelemRSSI.svg"   // reuse telemetry icon for now
        fillMode:           Image.PreserveAspectFit
        color:              _signalColor
    }

    // Color-code the icon by signal strength
    property color _signalColor: {
        if (!_activeVehicle) return qgcPal.buttonText
        var r = _activeVehicle.radioRSSI
        if (r === 0)    return qgcPal.buttonText  // no data
        if (r >= -70)   return "green"             // strong
        if (r >= -85)   return "orange"            // marginal
        return "red"                               // poor
    }

    MouseArea {
        anchors.fill: parent
        onClicked:    mainWindow.showIndicatorDrawer(radioInfoPage, control)
    }

    Component {
        id: radioInfoPage

        ToolIndicatorPage {
            showExpand: false

            contentComponent: SettingsGroupLayout {
                heading: qsTr("L3Harris Radio Status")

                LabelledLabel {
                    label:      qsTr("RSSI:")
                    labelText:  _activeVehicle ? _activeVehicle.radioRSSI + " " + qsTr("dBm") : qsTr("N/A")
                }

                LabelledLabel {
                    label:      qsTr("SNR:")
                    labelText:  _activeVehicle ? _activeVehicle.radioSNR + " " + qsTr("dB") : qsTr("N/A")
                }

                LabelledLabel {
                    label:      qsTr("HW Temp:")
                    labelText:  _activeVehicle ? (_activeVehicle.radioHWTemp / 100).toFixed(1) + " °C" : qsTr("N/A")
                }
            }
        }
    }
}
