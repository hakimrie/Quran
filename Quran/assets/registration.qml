import bb.cascades 1.0

NavigationPane {
    id: navigationPane
    Page {
        id: page
        Container {
            onCreationCompleted: {
                _registrationHandler.stateChanged.connect(gotoMainPage);
                // jika sudah berhasil registrasi, langsung ke main app
                if (_registrationHandler.allowed) {
                    _registrationHandler.finishRegistration();
                    navigationPane.pop();
                } else { // jika belum, tampilkan halaman registrasi
                    navigationPane.push(page);
                    _registrationHandler.registerApplication();
                }
            }
            function gotoMainPage() {
                if (_registrationHandler.allowed) { // langsung ke mainpage
                    console.log("goto main page");
                    _registrationHandler.finishRegistration();
                    navigationPane.pop();
                }
            }
            layout: DockLayout {
            }
            ImageView {
                horizontalAlignment: HorizontalAlignment.Fill
                verticalAlignment: VerticalAlignment.Fill
                imageSource: "asset:///images/background.png"
            }
            Container {
                horizontalAlignment: HorizontalAlignment.Center
                verticalAlignment: VerticalAlignment.Center
                Label {
                    horizontalAlignment: HorizontalAlignment.Center
                    text: _registrationHandler.statusMessage
                    textStyle {
                        base: SystemDefaults.TextStyles.BodyText
                        color: Color.White
                    }
                    multiline: true
                }
                Button {
                    horizontalAlignment: HorizontalAlignment.Center
                    visible: _registrationHandler.temporaryError
                    text: qsTr("Connect to BBM")
                    onClicked: {
                        _registrationHandler.registerApplication()
                    }
                }
                // Display the main page if the user chooses to Continue
                Button {
                    horizontalAlignment: HorizontalAlignment.Center
                    //visible: _registrationHandler.allowed
                    text: qsTr("Not Now")
                    onClicked: {
                        _registrationHandler.finishRegistration()
                    }
                }
            }
        }
//        onCreationCompleted: {
//            OrientationSupport.supportedDisplayOrientation = SupportedDisplayOrientation.DisplayPortrait;
//        }
    }
    onCreationCompleted: {
        OrientationSupport.supportedDisplayOrientation = SupportedDisplayOrientation.DisplayPortrait;
    }
}
