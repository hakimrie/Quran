import bb.cascades 1.0

Page {
    id: settingsPage
    property int index: translations.selectedIndex
    signal settingsPageClose()
    signal saveSettings(string languageId, string ayatChecked, string translationChecked, double ayahFontSize, double translationFotSize)
    titleBar: TitleBar {
        id: addBar
        title: "Settings"
        visibility: ChromeVisibility.Visible
        dismissAction: ActionItem {
            title: "Cancel"
            onTriggered: {
                settingsPage.settingsPageClose();
            }
        }
        acceptAction: ActionItem {
            title: "Save"
            //enabled: false
            onTriggered: {
                // save quote
                //notePage.saveNote(surahNumber, ayatNumber, note);
                //var translationID = "101";
                switch (translations.selectedIndex) {
                    case 0:
                        settingsPage.saveSettings("100", checkAyat.checked, checkTranslation.checked, arabicFontSize.value, transFontSize.value);
                        break;
                    case 1:
                        settingsPage.saveSettings("58", checkAyat.checked, checkTranslation.checked, arabicFontSize.value, transFontSize.value);
                        break;
                    case 2:
                        settingsPage.saveSettings("101", checkAyat.checked, checkTranslation.checked, arabicFontSize.value, transFontSize.value);
                        break;
                    case 3:
                        settingsPage.saveSettings("68", checkAyat.checked, checkTranslation.checked, arabicFontSize.value, transFontSize.value);
                        break;
                    case 4:
                        settingsPage.saveSettings("102", checkAyat.checked, checkTranslation.checked, arabicFontSize.value, transFontSize.value);
                        break
                }
                settingsPage.settingsPageClose();
            }
        }
    }
    ScrollView {
        Container {

            Container {
                horizontalAlignment: HorizontalAlignment.Center
                Divider {
                }
                Label {
                    leftMargin: 10
                    leftPadding: 10
                    text: "Select what to display: ayat, translation or both"
                    multiline: true
                    //subtitle: "display ayat & translation"
                }
                CheckBox {
                    leftMargin: 10
                    leftPadding: 10
                    id: checkAyat
                    objectName: "checkAyat"
                    checked: app.getValueFor("AyatChecked", "true") == "true"
                    text: "Ayat"
                    onCheckedChanged: {
                        console.log("check status: " + checkAyat.checked);
                        if (! checkAyat.checked) {
                            checkTranslation.enabled = false;
                        } else {
                            checkTranslation.enabled = true;
                        }
                        //app.setValueFor("AyatChecked", checkAyat.checked ? "true" : "false");
                    }
                }
                CheckBox {
                    leftMargin: 10
                    leftPadding: 10
                    id: checkTranslation
                    checked: app.getValueFor("TranslationChecked", "true") == "true"
                    text: "Translation"
                    onCheckedChanged: {
                        console.log("check status: " + checkTranslation.checked);
                        if (! checkTranslation.checked) {
                            checkAyat.enabled = false;
                        } else {
                            checkAyat.enabled = true;
                        }
                        //app.setValueFor("TranslationChecked", checkAyat.checked ? "true" : "false");
                    }
                }
                Divider {
                }
                Label {
                    leftMargin: 10
                    leftPadding: 10
                    text: "Select al-Qur'an translation"
                    //subtitle: "translation of al-Qur'an"
                }
                DropDown {
                    horizontalAlignment: HorizontalAlignment.Center
                    id: translations
                    objectName: "translations"
                    options: [
                        Option {
                            text: "English"
                            description: "Shaheeh International" // 100
                        },
                        Option {
                            text: "English"
                            description: "Mohammad Habib Shakir" // 58
                        },
                        Option {
                            text: "French"
                            description: "Muhammad Hamidullah" // 101
                        },
                        Option {
                            text: "Indonesian"
                            description: "Departemen Agama RI" // 68
                        },
                        Option {
                            text: "Malay"
                            description: "Abdullah Muhammad Basmeih" // 102
                        }
                    ]
                    selectedIndex: parseInt(app.getValueFor("LanguageSettings", "0"))
                    title: "Translation"
                }
                Divider {
                }
                Label {
                    text: "Font Settings"
                }
                Label {
                    id: previewAyat
                    text: "بسم الله الرحمن الرحيم"
                    horizontalAlignment: HorizontalAlignment.Right
                    textStyle.fontSize: FontSize.PointValue
                    textStyle.fontSizeValue: arabicFontSize.value
                    multiline: true
                }
                Label {
                    id: previewTranslation
                    text: "In The Name of Allah, The Beneficient, The Merciful"
                    horizontalAlignment: HorizontalAlignment.Left
                    textStyle.fontSize: FontSize.PointValue
                    textStyle.fontSizeValue: transFontSize.value
                    multiline: true
                }
                Label {
                    text: "arabic verse font size"
                }
                Slider {
                    id: arabicFontSize
                    value: parseFloat(app.getValueFor("AyatFontSize", "11.0"))
                    fromValue: 8.0
                    toValue: 20
                }
                Label {
                    text: "translation font size"
                }
                Slider {
                    id: transFontSize
                    value: parseFloat(app.getValueFor("TranslationFontSize", "10.0"))
                    fromValue: 6.0
                    toValue: 15
                }
            }

            // about us
            Container {
                horizontalAlignment: HorizontalAlignment.Center
                verticalAlignment: VerticalAlignment.Bottom
                Label {
                    horizontalAlignment: HorizontalAlignment.Center
                    text: "Quran version 2.0"
                    textStyle.color: Color.create("#ff35004d")
                    textStyle.fontWeight: FontWeight.Bold

                }
                Label {
                    horizontalAlignment: HorizontalAlignment.Center
                    text: "<html><a href='http://hakimlabs.com'>Muhammad Hakim Asy'ari (Developer)</a></html>"
                }
                Label {
                    horizontalAlignment: HorizontalAlignment.Center
                    text: "<html><a href='http://riswanrais.com/'>Riswan Rais (Graphic Designer)</a></html>"
                }
            }
        }
    }    // TitleBar
    
    
    
}
