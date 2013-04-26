import bb.cascades 1.0
import custom 1.0
import bb.system 1.0

Page {
    property alias displayAyat: listAyat.displayAyat
    property alias displayTranslation: listAyat.displayTranslation
    attachedObjects: [
        SystemToast {
            id: toast
        },
        AyatDataModel {
            id: sqldata
            sortingKeys: [
                "surahNumber",
                "ayatNumber"
            ]
            //            connectionName : "ayatpage"
            onAllItemLoaded: {
                toast.body = message;
                toast.show();
                //                console.log("surah number: " + surah + " ayat: " + ayat);
                //                if (ayat > 0) listAyat.scrollToItem([
                //                        0,
                //                        ayat
                //                    ], ScrollAnimation.Default);
            }
        },
        Sheet {
            id: noteSheet
            // The edit screen is launched when adding a new quote record.
            NoteSheet {
                id: note
                onNotePageClose: {
                    noteSheet.close();
                }
            }
        },
        ComponentDefinition {
            id: ayahview
            source: "AyahPage.qml"
        }
    ]
    Container {
        Container {
            layout: StackLayout {
                orientation: LayoutOrientation.LeftToRight
            }
            topPadding: 10
            bottomPadding: 10
            Container { // dummy for left margin
                preferredWidth: 12
            }
            TextField {
                id: queryText
                input.submitKey: SubmitKey.Search
                hintText: "Search here"
                layoutProperties: StackLayoutProperties {
                    spaceQuota: 1
                }
                input {
                    onSubmitted: {
                        // search
                        toast.body = "Searching, Please wait..."
                        toast.show();
                        sqldata.searchAyat(queryText.text);
                    }
                }
                verticalAlignment: VerticalAlignment.Center
                horizontalAlignment: HorizontalAlignment.Center
                leftMargin: 68
                rightMargin: 68
                backgroundVisible: false
            }
            Container { // dumy for right margin, since textbox margin doesnt work
                preferredWidth: 12
            }
            background: backgroundPaint.imagePaint
            attachedObjects: [
                ImagePaintDefinition {
                    id: backgroundPaint
                    imageSource: "asset:///images/searchbox.amd"
                    repeatPattern: RepeatPattern.XY
                }
            ]
        }

        // result
        ListView {
            id: listAyat
            dataModel: sqldata
            property bool displayAyat
            property bool displayTranslation
            signal reloadDatabase(string ayatnumber)
            signal addBookmark(string surahNumber, string ayahNumber)
            signal removeBookmark(string surahNumber, string ayahNumber)
            signal updateNote(string surahNumber, string ayahNumber, string ayahText, string translationText, string textnote)
            property double ayahFontSize : parseFloat(app.getValueFor("AyatFontSize", "11.0"));
            property double translationFontSize : parseFloat(app.getValueFor("TranslationFontSize", "10.0"));
            layout: StackListLayout {
                headerMode: ListHeaderMode.Sticky
            }
            listItemComponents: [
                ListItemComponent {
                    type: "header"
                    SurahHeader {
                        surah: "images/sname_" + ListItemData + ".png"
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
                        ayahFontSize : ListItem.view.ayahFontSize
                        translationFontSize : ListItem.view.translationFontSize
                        contextActions: [
                            ActionSet {
                                ActionItem {
                                    title: ListItemData.bookmarked == 'true' ? "remove bookmark" : "bookmark"
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
                                    title: "note"
                                    onTriggered: {
                                        ayahitem.ListItem.view.updateNote(ListItemData.surahNumber, ListItemData.ayatNumber, ListItemData.ayatText, ListItemData.translationText, ListItemData.note);
                                        // define action handler here
                                        //console.log("action triggered: " + title + " active item note: " + ListItemData.note)
                                    }
                                    imageSource: "images/edit.png"
                                }
                                InvokeActionItem {
                                    title: "Share via BBM"
                                    imageSource: "images/bbm.png"
                                    query {
                                        mimeType: "text/plain"
                                        invokeTargetId: "sys.bbm.sharehandler"
                                        invokeActionId: "bb.action.SHARE"
                                        data: ListItemData.ayatText + "\n" + ListItemData.translationText
                                    }
                                    onTriggered: {
                                        data = ListItemData.ayatText + "\n" + ListItemData.translationText
                                    }
                                }
                                InvokeActionItem {
                                    title: "share"
                                    query {
                                        mimeType: "text/plain"
                                        invokeActionId: "bb.action.SHARE"
                                        data: ListItemData.ayatText + "\n" + ListItemData.translationText
                                        // define action handler here
                                        //console.log("action triggered: " + title + " active item: " + ListItemData.ayatNumber)
                                    }
                                    onTriggered: {
                                        data = ListItemData.ayatText + "\n" + ListItemData.translationText
                                    }
                                }
                            }
                        ]
                    }
                }
            ]
            // need to test and update again
            onTriggered: {
                var page = ayahview.createObject();
                var choosenItem = sqldata.data(indexPath);
                page.surah = qsTr("" + choosenItem.surahNumber);
                page.ayat = parseInt(choosenItem.ayatNumber) - 1;
                page.displayAyat = app.getValueFor("AyatChecked", "true") == "true";
                page.displayTranslation = app.getValueFor("TranslationChecked", "true") == "true";
                page.ayahFontSize = parseFloat(app.getValueFor("AyatFontSize", "11.0"));
                page.translationFontSize = parseFloat(app.getValueFor("TranslationFontSize", "10.0"));
                page.loadData();
                navPage.push(page);
            }
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
}
