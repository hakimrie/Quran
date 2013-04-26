import bb.cascades 1.0
import custom 1.0
import dbutils 1.0

NavigationPane {
    id: navPage
    objectName: "notePage"
    Page {

        //property string surah
        attachedObjects: [
            AyatDataModel {
                id: sqldata
                sortingKeys: [
                    "surah",
                    "ayat"
                ]
                onStartLoadData: {
                    loadingIndicator.visible = true
                    loadingIndicator.running = true;
                }
                onAllItemLoaded: {
                    loadingIndicator.visible = false
                    loadingIndicator.running = false;
                }
                //            onAllItemLoaded: {
                //                console.log("surah number: " + surah + " ayat: " + ayat);
                //                if (ayat > 0) listAyat.scrollToItem([
                //                        0,
                //                        ayat
                //                    ], ScrollAnimation.Default);
                //            }
            },
            ComponentDefinition {
                id: ayahview
                source: "AyahPage.qml"
            },
            ComponentDefinition {
                id: searchpage
                source: "SearchPage.qml"
            }
        ]
        actions: [
            ActionItem {
                ActionBar.placement: ActionBarPlacement.OnBar
                title: "Search"
                onTriggered: {
                    var search = searchpage.createObject();
                    search.displayAyat = app.getValueFor("AyatChecked", "true") == "true";
                    search.displayTranslation = app.getValueFor("TranslationChecked", "true") == "true";
                    navPage.push(search);
                }
                imageSource: "images/ic_search.png"
            }
        ]
        content: Container {
            //            SurahHeader {
            //                surah: ""
            //                title: "Notes"
            //                verticalAlignment: VerticalAlignment.Center
            //                horizontalAlignment: HorizontalAlignment.Center
            //            }
            ActivityIndicator {
                id: loadingIndicator
                preferredHeight: 120
                preferredWidth: 120
                running: true
                verticalAlignment: VerticalAlignment.Center
                horizontalAlignment: HorizontalAlignment.Center
            }
            ListView {
                id: listNote
                signal reloadDatabase()
                signal deleteNote(string surah, string ayat)
                objectName: "listNote"
                dataModel: sqldata
                /*XmlDataModel {
                 * source: "text/alfatihah.xml"
                 * }*/
                layout: StackListLayout {
                    headerMode: ListHeaderMode.Sticky
                }
                listItemComponents: [
                    ListItemComponent {
                        type: "header"
                        SurahHeader {
                            id: headerSurahName
                            surah: "images/sname_" + ListItemData + ".png"
                            verticalAlignment: VerticalAlignment.Center
                            horizontalAlignment: HorizontalAlignment.Center
                        }
                    },
                    ListItemComponent {
                        type: "item"
                        NoteItem {
                            id: noteitem
                            textNote: ListItemData.note
                            locationNote: /*"Surah " + ListItemData.surah + */ "verse " + ListItemData.ayat
                            contextActions: [
                                ActionSet {
                                    DeleteActionItem {
                                        title: "delete"
                                        //imageSource: "images/delete.png"
                                        onTriggered: {
                                            noteitem.ListItem.view.deleteNote(ListItemData.surah, ListItemData.ayat);
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
                                            //console.log("action bbm triggered: " + ListItemData.ayatText + " active item: " + ListItemData.ayatNumber)
                                            data = ListItemData.note + "\n\n" + ListItemData.ayatText + "\n" + ListItemData.translationText + " Al-Qur'an[" + ListItemData.surah + "]:" + ListItemData.ayat
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
                                            data = ListItemData.note + "\n\n" + ListItemData.ayatText + "\n" + ListItemData.translationText + " Al-Qur'an[" + ListItemData.surah + "]:" + ListItemData.ayat
                                        }
                                    }
                                }
                            ]
                        }
                    }
                ]
                onDeleteNote: {
                    sqldata.deleteNote(listNote.selected(), surah, ayat);
                }
                onReloadDatabase: {
                    //console.log("ayat number: " + ayatnumber);
                    //bookmarkPage.ayat = parseInt(ayatnumber)-1;
                    sqldata.onReloadDatabase();
                }
                onTriggered: {
                    var page = ayahview.createObject();
                    var choosenItem = sqldata.data(indexPath);
                    page.surah = qsTr("" + choosenItem.surah);
                    page.ayat = parseInt(choosenItem.ayat) - 1;
                    page.displayAyat = app.getValueFor("AyatChecked", "true") == "true";
                    page.displayTranslation = app.getValueFor("TranslationChecked", "true") == "true";
                    page.ayahFontSize = parseFloat(app.getValueFor("AyatFontSize", "11.0"));
                    page.translationFontSize = parseFloat(app.getValueFor("TranslationFontSize", "10.0"));
                    page.loadData();
                    navPage.push(page);
                }
            }
        }
        /*onCreationCompleted: {
         * sqldata.loadBookmarks();
         * }*/
    }
    function loadData() {
        sqldata.loadNotes();
    }
}
