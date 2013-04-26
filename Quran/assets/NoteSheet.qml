import bb.cascades 1.0

Page {
    id: notePage
    property string surahNumber: ayat.surah
    property alias ayatText: ayat.ayahText
    property alias translationText: ayat.translationText
    property alias ayatNumber: ayat.ayah
    property alias note: noteField.text
    property double ayahFontSize
    property double translationFontSize
    
    signal notePageClose()
    signal saveNote(string surah, string ayah, string note)
    titleBar: TitleBar {
        id: addBar
        title: "Notes"
        visibility: ChromeVisibility.Visible
        dismissAction: ActionItem {
            title: "Cancel"
            onTriggered: {
                notePage.notePageClose();
            }
        }
        acceptAction: ActionItem {
            title: "Save"
            //enabled: false
            onTriggered: {
                // save quote
                //dbhelper.updateNote(surahNumber, ayatNumber, note);
                notePage.saveNote(surahNumber, ayatNumber, note);
                notePage.notePageClose();
            }
        }
    } // TitleBar
    Container {
        id: editPane
        property real margins: 40
        background: Color.create("#f8f8f8")
        topPadding: editPane.margins
        leftPadding: editPane.margins
        rightPadding: editPane.margins
        layout: StackLayout {
        }
        Container {
            layout: StackLayout {
            }

            // The quote text area
            TextArea {
                id: noteField
                hintText: "Write note"
                topMargin: editPane.margins
                bottomMargin: topMargin
                enabled: true
                preferredHeight: 450
                maxHeight: 450
                horizontalAlignment: HorizontalAlignment.Fill
            }
        } //Total text Container (name text + quote text)
        ScrollView {
            AyahItem {
                id: ayat
                displayAyat: true
                displayTranslation: true//ListItem.view.displayTranslation
                ayahFontSize : notePage.ayahFontSize //parseFloat(app.getValueFor("AyatFontSize", "11.0"));
                translationFontSize : notePage.translationFontSize //parseFloat(app.getValueFor("TranslationFontSize", "10.0"));
//                ayahFontSize : ListItem.view.ayahFontSize
//                translationFontSize : ListItem.view.translationFontSize
            }
        }
    } // Content Container
    function setAyatNumber(ayatNumber) {
        ayat.ayah = ayatNumber;
    }
    function setAyatText(ayatText) {
        ayat.ayahText = ayatText;
    }
    function setTranslationText(translation) {
        ayat.translationText = translation;
    }
    function setNote(note) {
        noteField.text = note;
    }
}
