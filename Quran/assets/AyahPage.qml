import bb.cascades 1.0
import custom 1.0
import bb.system 1.0
//import dbutils 1.0

Page {
    //    Menu.definition: MenuDefinition {
    //        helpAction: HelpActionItem {
    //            onTriggered: {
    //            }
    //        }
    //        settingsAction: SettingsActionItem {
    //            onTriggered: {
    //                settingsSheet.open();
    //            }
    //        }
    //    }
    id: ayatPage
    objectName: "ayatPage"
    property alias surah: listAyat.surahNumber
    property alias displayAyat: listAyat.displayAyat
    property alias displayTranslation: listAyat.displayTranslation
    property alias ayahFontSize: listAyat.ayahFontSize
    property alias translationFontSize: listAyat.translationFontSize
    property int ayat
    actions: [
        ActionItem {
            ActionBar.placement: ActionBarPlacement.InOverflow
            imageSource: "images/ic_configicon.png"
            title: "Settings"
            onTriggered: {
                settingsSheet.open();
            }
        },
        ActionItem {
            ActionBar.placement: ActionBarPlacement.InOverflow
            imageSource: "images/ic_download.png"
            title: "Invite Download"
            onTriggered: {
                app.sendInvite();
            }
        },
        ActionItem {
            title: "Jump to verse"
            imageSource: "images/ic_nav_to.png"
            onTriggered: {
                jumpAyatPrompt.show();
            }
        }
    ]
    attachedObjects: [
        AyatDataModel {
            id: sqldata
            onStartLoadData: {
                loadingIndicator.visible = true
                loadingIndicator.running = true;
            }
            onAllItemLoaded: {
                loadingIndicator.visible = false
                loadingIndicator.running = false;
                console.log("surah number: " + surah + " ayat: " + ayat);
                if (ayat > 0) listAyat.scrollToItem([
                        0,
                        ayat
                    ], ScrollAnimation.Default);
            }
        },
        Sheet {
            id: noteSheet
            // The edit screen is launched when adding a new quote record.
            onOpenedChanged: {
                if (opened){
                    note.ayahFontSize = parseFloat(app.getValueFor("AyatFontSize", "11.0"));
                    note.translationFontSize = parseFloat(app.getValueFor("TranslationFontSize", "10.0"));
                }
            }
            NoteSheet {
                id: note
                
                onNotePageClose: {
                    noteSheet.close();
                }
            }
        },
        Sheet {
            id: settingsSheet
            content: SettingsPage {
                id: settingsPage
                objectName: "settingspage"
                index: app.getValueFor("LanguageSettings", 0)
                onSettingsPageClose: {
                    settingsSheet.close();
                }
            }
        },
        SystemPrompt {
            id: jumpAyatPrompt
            title: "Jump to verse"
            modality: SystemUiModality.Application
            inputField.inputMode: SystemUiInputMode.NumericKeypad
            confirmButton.label: "Ok"
            cancelButton.label: "Cancel"
            confirmButton.enabled: true
            cancelButton.enabled: true
            onFinished: {
                if (result == SystemUiResult.ConfirmButtonSelection) {
                    listAyat.scrollToItem([
                            0,
                            jumpAyatPrompt.inputFieldTextEntry() - 1
                        ], ScrollAnimation.Default);
                } else if (result == SystemUiResult.CancelButtonSelection) {
                }
            }
        }
    ]
    content: Container {
        SurahHeader {
            id: headerSurahName
            surah: "images/sname_" + listAyat.surahNumber + ".png"
            verticalAlignment: VerticalAlignment.Center
            horizontalAlignment: HorizontalAlignment.Center
        }
        ActivityIndicator {
            id: loadingIndicator
            preferredHeight: 120
            preferredWidth: 120
            running: true
            verticalAlignment: VerticalAlignment.Center
            horizontalAlignment: HorizontalAlignment.Center
        }
        ListView {
            id: listAyat
            // signals
            signal reloadDatabase(string ayatnumber)
            signal addBookmark(string surahNumber, string ayahNumber)
            signal removeBookmark(string surahNumber, string ayahNumber)
            signal updateNote(string surahNumber, string ayahNumber, string ayahText, string translationText, string textnote)
            signal setBBMStatus(string newstatus)
            signal setBBMPersonalMessage(string newPersonalMessage)
            property string surahNumber
            property bool displayAyat
            property bool displayTranslation
            property double ayahFontSize
            property double translationFontSize
            rootIndexPath: [
                0
            ]
            objectName: "listAyat"
            dataModel: sqldata
            layout: StackListLayout {
                headerMode: ListHeaderMode.Sticky
            }
            listItemComponents: [
                ListItemComponent {
                    type: "header"
                    SurahHeader {
                        surah: "images/sname_" + ListItem.view.surahNumber + ".png"
                        verticalAlignment: VerticalAlignment.Center
                        horizontalAlignment: HorizontalAlignment.Center
                    }
                },
                // jika user check
                ListItemComponent {
                    type: "item"
                    AyahItem {
                        id: ayahitem
                        ayah: ListItemData.ayatNumber
                        ayahText: ListItemData.ayatText
                        translationText: ListItemData.translationText
                        surah: ListItemData.surahNumber
                        bookmarked: ListItemData.bookmarked
                        displayAyat: ListItem.view.displayAyat
                        displayTranslation: ListItem.view.displayTranslation
                        ayahFontSize: ListItem.view.ayahFontSize
                        translationFontSize: ListItem.view.translationFontSize
                        contextActions: [
                            ActionSet {
                                ActionItem {
                                    title: ListItemData.bookmarked == 'true' ? "Remove Bookmark" : "Bookmark"
                                    onTriggered: {
                                        if (ListItemData.bookmarked == 'true') {
                                            //console.log("remove bookmark");
                                            ListItemData.bookmarked = 'false';
                                            ayahitem.ListItem.view.removeBookmark(ListItemData.surahNumber, ListItemData.ayatNumber);
                                        } else {
                                            //console.log("add to bookmark");
                                            ListItemData.bookmarked = 'true';
                                            ayahitem.ListItem.view.addBookmark(ListItemData.surahNumber, ListItemData.ayatNumber);
                                        }
                                        // define action handler here
                                        console.log("action triggered: " + title + " active item: " + ListItemData.ayatNumber);
                                    }
                                    imageSource: "images/bookmark.png"
                                }
                                ActionItem {
                                    title: "Note"
                                    onTriggered: {
                                        ayahitem.ListItem.view.updateNote(ListItemData.surahNumber, ListItemData.ayatNumber, ListItemData.ayatText, ListItemData.translationText, ListItemData.note);
                                        // define action handler here
                                        //console.log("action triggered: " + title + " active item note: " + ListItemData.note)
                                    }
                                    imageSource: "images/ic_edit.png"
                                }
                                ActionItem {
                                    title: "Set As Personal Message"
                                    imageSource: "images/ic_bbm.png"
                                    onTriggered: {
                                        ayahitem.ListItem.view.setBBMPersonalMessage(ListItemData.ayatText);
                                    }
                                }
                                ActionItem {
                                    title: "Set As Status"
                                    imageSource: "images/ic_bbm.png"
                                    onTriggered: {
                                        ayahitem.ListItem.view.setBBMStatus(ListItemData.ayatText);
                                    }
                                }
                                InvokeActionItem {
                                    id: sharebbm
                                    title: "Share via BBM"
                                    imageSource: "images/ic_bbm.png"
                                    query {
                                        mimeType: "text/plain"
                                        invokeTargetId: "sys.bbm.sharehandler"
                                        invokeActionId: "bb.action.SHARE"
                                        //data: ListItemData.ayatText + "\n" + ListItemData.translationText
                                    }
                                    onTriggered: {
                                        console.log("action bbm triggered: " + ListItemData.ayatText + " active item: " + ListItemData.ayatNumber)
                                        data = ListItemData.ayatText + "\n" + ListItemData.translationText
                                    }
                                }
                                InvokeActionItem {
                                    title: "Share"
                                    query {
                                        mimeType: "text/plain"
                                        invokeActionId: "bb.action.SHARE"
                                        //data: ListItemData.ayatText + "\n" + ListItemData.translationText

                                        // define action handler here
                                        //console.log("action triggered: " + title + " active item: " + ListItemData.ayatNumber)
                                    }
                                    onTriggered: {
                                        //console.log("action share triggered: " + ListItemData.ayatText + " active item: " + ListItemData.ayatNumber)
                                        data = ListItemData.ayatText + "\n" + ListItemData.translationText
                                    }
                                }
                            }
                        ]
                    }
                }
            ]
            onReloadDatabase: {
                console.log("ayat number: " + ayatnumber);
                ayatPage.ayat = parseInt(ayatnumber) - 1;
                sqldata.onReloadDatabase();
            }
            onAddBookmark: {
                var selectedItem = listAyat.selected();
                //console.log("surah number: " + surahNumber + " ayahNumber: " + ayahNumber + " selectedItem : " + selectedItem);
                if (! sqldata.addBookmark(selectedItem, surahNumber, ayahNumber)) {
                    console.log("add bookmark failed");
                }
            }
            onRemoveBookmark: {
                var selectedItem = listAyat.selected();
                console.log("surah number: " + surahNumber + " ayahNumber: " + ayahNumber + " selectedItem : " + selectedItem);
                if (! sqldata.removeBookmark(selectedItem, surahNumber, ayahNumber)) {
                    console.log("remove bookmark failed");
                }
            }
            onUpdateNote: {
                note.surahNumber = surahNumber
                note.ayatNumber = ayahNumber;
                note.ayatText = ayahText;
                note.translationText = translationText;
                note.note = textnote;
                noteSheet.open();
            }
            onSetBBMStatus: {
                app.setAsBBMStatus(newstatus);
            }
            onSetBBMPersonalMessage: {
                app.setAsPersonalMessage(newPersonalMessage);
            }
        }
        function saveNote(surah, ayah, note) {
            var selectedItem = [
                0,
                parseInt(ayah) - 1
            ] //listAyat.selected();
            //console.log("surah number: " + surahNumber + " ayahNumber: " + ayahNumber + " selectedItem : " + selectedItem);
            if (! sqldata.updateNote(selectedItem, surah, ayah, note)) {
                console.log("update Note failed");
            }
        }
        onCreationCompleted: {
            OrientationSupport.supportedDisplayOrientation = SupportedDisplayOrientation.All;
            note.saveNote.connect(saveNote);
            settingsPage.saveSettings.connect(saveSettings);
        }
    }
    function loadData() {
        sqldata.loadData(listAyat.surahNumber);
    }
    function saveSettings(languageId, ayatChecked, translationChecked, ayatFontSize, transFontSize) {
        app.saveValueFor("LanguageSettings", languageId);
        app.saveValueFor("AyatChecked", ayatChecked);
        app.saveValueFor("TranslationChecked", translationChecked);
        app.saveValueFor("AyatFontSize", ayatFontSize);
        app.saveValueFor("TranslationFontSize", transFontSize);
        displayAyat = ayatChecked;
        displayTranslation = translationChecked
        ayahFontSize = ayatFontSize
        translationFontSize = transFontSize
        //reload database
        sqldata.onReloadDatabase();
    }
}
