import bb.cascades 1.0

NavigationPane {
    id: navPage
    objectName: "surahPage"
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
    Page {
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
                //title: "Al-Qur'an"
                verticalAlignment: VerticalAlignment.Center
                horizontalAlignment: HorizontalAlignment.Center
            }
            ListView {
                id: surahList
                objectName: "surahList"
                dataModel: XmlDataModel {
                    source: "text/quran_properties_extendedenglish.xml"
                }
                listItemComponents: [
                    ListItemComponent {
                        type: "sura"
                        SurahItem {
                            index: ListItemData.index
                            surahName: ListItemData.tname
                            numOfVerses: ListItemData.descent + " - " + ListItemData.ayaCount + " verses"
                            surahNameAr: ListItemData.name
                        }
                    }
                ]
                onTriggered: {
                    var page = ayahview.createObject();
                    page.surah = qsTr("" + (indexPath[0] + 1));
                    page.displayAyat = app.getValueFor("AyatChecked", "true") == "true";
                    page.displayTranslation = app.getValueFor("TranslationChecked", "true") == "true";
                    page.ayahFontSize = parseFloat(app.getValueFor("AyatFontSize", "11.0"));
                    page.translationFontSize = parseFloat(app.getValueFor("TranslationFontSize" , "10.0"));
                    page.ayat = 0;
                    page.loadData();
                    var choosenItem = dataModel.data(indexPath);
                    app.addProfileBoxItem("I'm reading al-Qur'an Surah " + choosenItem.tname, 1);
                    navPage.push(page);
                }
            }
        }
    }
}
