// Default empty project template
import bb.cascades 1.0

TabbedPane {

//    attachedObjects: [
//        Sheet {
//            id: settingsSheet
//            content: SettingsPage {
//                id: settingsPage
//                index: app.getValueFor("LanguageSettings", 0)
//                onSettingsPageClose: {
//                    settingsSheet.close();
//                }
//            }
//        }
//    ]
    sidebarState: SidebarState.Hidden
    Tab {
        title: "Surah"
        imageSource: "images/sura_mark.png"
        content: SurahPage {
        }
    }
    Tab {
        title: "Juz"
        imageSource: "images/juzzbig.png"
        content: JuzPage {
        }
    }
    Tab {
        title: "Bookmarks"
        imageSource: "images/bookmark.png"
        content: BookmarkPage {
            id: bookmarkPage
        }
        onTriggered: {
            bookmarkPage.loadData();
        }
    }
    Tab {
        title: "Notes"
        imageSource: "images/note2.png"
        content: NotePage {
            id: notePage
        }
        onTriggered: {
            notePage.loadData();
        }
    }
    
//    Tab{
//        title : "Settings"
//        content : SettingsPage{
//            objectName: "settingspage"
//            }
//    }
    onCreationCompleted: {
        OrientationSupport.supportedDisplayOrientation = SupportedDisplayOrientation.All;
        
    }
            
}
