import bb.cascades 1.0
import custom 1.0
import dbutils 1.0

NavigationPane {
    id: navPage
    objectName: "bookmarkPage"
    Page {
        //property string surah
        attachedObjects: [
            AyatDataModel {
                id: sqldata
                //                connectionName : "bookmarkpage"
                sortingKeys: [
                    "surah",
                    "ayat"
                ]
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
            //                title: "Bookmarks"
            //                verticalAlignment: VerticalAlignment.Center
            //                horizontalAlignment: HorizontalAlignment.Center
            //            }
            ListView {
                id: listBookmark
                signal reloadDatabase()
                signal deleteBookmark(string surah, string ayat)
                objectName: "listBookmark"
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
                        AyahItemAyatOnly {
                            id: bookmarkitem
                            ayah: ListItemData.ayat
                            ayahText: ListItemData.ayahText
                            bookmarked: 'false' //ListItemData.bookmarked // we don't want to highlight the item
                            surah: ListItemData.surah
                            contextActions: [
                                ActionSet {
                                    DeleteActionItem {
                                        title: "delete"
                                        //imageSource: "images/delete.png"
                                        onTriggered: {
                                            bookmarkitem.ListItem.view.deleteBookmark(ListItemData.surah, ListItemData.ayat);
                                        }
                                    }
                                }
                            ]
                        }
                    }
                ]
                onDeleteBookmark: {
                    sqldata.deleteBookmark(listBookmark.selected(), surah, ayat);
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
                    app.addProfileBoxItem("I'm reading al-Qur'an surah " + choosenItem.surahName + " verse " + choosenItem.ayat + ")", 1);
                    navPage.push(page);
                }
            }
        }
        onCreationCompleted: {
            console.log("on creation complete");
            sqldata.loadBookmarks();
        }
    }
    function loadData() {
        sqldata.loadBookmarks();
    }
}
