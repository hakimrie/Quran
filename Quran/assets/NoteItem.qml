import bb.cascades 1.0

Container {
    id: noteItem
    property alias textNote: note.text
    property alias locationNote: location.text
    Label {
        id: note
        multiline: true
    }
    Label {
        id: location
        horizontalAlignment: HorizontalAlignment.Right
        text: "test"
        textStyle.fontStyle: FontStyle.Italic

        //        layoutProperties: StackLayoutProperties {
//            spaceQuota: 1
//        }
    }
    rightMargin: 20.0
    Divider {
    }
    function setHighlight(highlighted) {
        if (highlighted) {
            noteItem.background = Color.Yellow
        } else {
            noteItem.background = Color.White
        }
    }
    ListItem.onActivationChanged: {
        setHighlight(ListItem.active);
    }
}
