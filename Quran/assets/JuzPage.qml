import bb.cascades 1.0

NavigationPane {
    id: navPage
    objectName: "juzPage"
    Page {
        attachedObjects: [
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
        Container {
            layout: StackLayout {
            }
            SurahHeader {
                id: headerSurahName
                surah: ""
//                title: "Al-Qur'an"
                verticalAlignment: VerticalAlignment.Center
                horizontalAlignment: HorizontalAlignment.Center
            }
            ListView {
                dataModel: XmlDataModel {
                    source: "text/juz.xml"
                }
                listItemComponents: [
                    ListItemComponent {
                        type: "juz"
                        JuzItem {
                            //index: ListItemData.index
                            juzName: "Juz " + ListItemData.index
                            position: "Surah " + ListItemData.surahName + " Verse " + ListItemData.aya
                        }
                    }
                ]
                onTriggered: {
                    var page = ayahview.createObject();
                    var choosenItem = dataModel.data(indexPath);
                    page.surah = qsTr(choosenItem.sura);
                    page.ayat = parseInt(choosenItem.aya) - 1;
                    page.displayAyat = app.getValueFor("AyatChecked", "true") == "true";
                    page.displayTranslation = app.getValueFor("TranslationChecked", "true") == "true";
                    page.ayahFontSize = parseFloat(app.getValueFor("AyatFontSize", "11.0"));
                    page.translationFontSize = parseFloat(app.getValueFor("TranslationFontSize", "10.0"));
                    app.addProfileBoxItem("I'm reading al-Qur'an Juz " + choosenItem.index + " (surah " + choosenItem.surahName + " verse " + choosenItem.aya + ")", 1);
                    page.loadData();
                    navPage.push(page);
                }
            }
        }
    }
}
