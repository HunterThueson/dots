// Minimal SDDM greeter: gray background, centered clock, typed username +
// password, session picker. Plain QtQuick.Controls.Basic — no SddmComponents
// (nixpkgs ships that module without its image assets, which breaks the stock
// themes on this stack). See system/login-manager/sddm.nix footnote [2].

import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts

Rectangle {
    id: root
    width: 1920                                   // SDDM resizes the root to the screen (SizeRootObjectToView)
    height: 1080
    color: "#3a3a3a"

    function doLogin() {
        errorText.text = ""
        sddm.login(username.text, password.text, sessionBox.currentIndex)
    }

    Connections {
        target: sddm
        function onLoginFailed() {
            errorText.text = "Login failed — check the username and password."
            password.selectAll()
            password.forceActiveFocus()
        }
        function onLoginSucceeded() {
            errorText.text = ""
        }
    }

    ColumnLayout {
        anchors.centerIn: parent
        width: 340
        spacing: 16

        Text {
            id: timeText
            Layout.alignment: Qt.AlignHCenter
            color: "#f0f0f0"
            font.pixelSize: 72
            font.weight: Font.Light
            text: Qt.formatTime(new Date(), "HH:mm")
        }

        Text {
            id: dateText
            Layout.alignment: Qt.AlignHCenter
            Layout.bottomMargin: 12
            color: "#b8b8b8"
            font.pixelSize: 16
            text: Qt.formatDate(new Date(), "dddd, d MMMM yyyy")
        }

        Timer {
            interval: 1000
            running: true
            repeat: true
            triggeredOnStart: true
            onTriggered: {
                var now = new Date()
                timeText.text = Qt.formatTime(now, "HH:mm")
                dateText.text = Qt.formatDate(now, "dddd, d MMMM yyyy")
            }
        }

        TextField {
            id: username
            Layout.fillWidth: true
            placeholderText: "Username"
            onAccepted: password.forceActiveFocus()
        }

        TextField {
            id: password
            Layout.fillWidth: true
            placeholderText: "Password"
            echoMode: TextInput.Password
            onAccepted: root.doLogin()
        }

        RowLayout {
            Layout.fillWidth: true
            spacing: 8

            ComboBox {
                id: sessionBox
                Layout.fillWidth: true
                model: sessionModel
                textRole: "name"
                currentIndex: sessionModel.lastIndex
            }

            Button {
                text: "Log In"
                onClicked: root.doLogin()
            }
        }

        Text {
            id: errorText
            Layout.fillWidth: true
            Layout.topMargin: 4
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
            color: "#ff8080"
            font.pixelSize: 13
            text: ""
        }
    }

    Component.onCompleted: username.forceActiveFocus()
}
