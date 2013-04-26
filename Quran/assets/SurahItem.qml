import bb.cascades 1.0

Container {
    id: surahitem
    property alias index: surahIndex.text
    property alias surahName: surahNameLatin.text
    property alias numOfVerses: numberOfVerses.text
    property alias surahNameAr: surahNameArabic.text
    Container {
        layout: StackLayout {
            orientation: LayoutOrientation.LeftToRight
        }
        Container {
            layout: DockLayout {
            }
            ImageView {
                horizontalAlignment: HorizontalAlignment.Center
//                imageSource: "images/sura_mark.png"
                imageSource: "images/index_juz_mark.png"
                preferredHeight: 110
                preferredWidth: 110
                scalingMethod: ScalingMethod.Fill
            }
            Label {
                translationX : 2
                id: surahIndex
                horizontalAlignment: HorizontalAlignment.Center
                verticalAlignment: VerticalAlignment.Center

                textStyle.color: Color.White
                textStyle {
                    base: SystemDefaults.TextStyles.SmallText
                    fontWeight: FontWeight.Bold
                    fontSize: FontSize.Default
                }
            }
        }
        Container {
            leftMargin: 20
            rightMargin: 20
            layout: StackLayout {
            }
            Label {
                id: surahNameLatin
                textStyle {
                    base: SystemDefaults.TextStyles.BigText
                    fontWeight: FontWeight.Bold
                    fontSize: FontSize.Large
                }
            }
            Label {
                id: numberOfVerses
                verticalAlignment: VerticalAlignment.Top
            }
            layoutProperties: StackLayoutProperties {
                spaceQuota: 1
            }
        }
        Label {
            id: surahNameArabic
            rightMargin: 20
            horizontalAlignment: HorizontalAlignment.Right
            verticalAlignment: VerticalAlignment.Center
            textStyle {
                base: SystemDefaults.TextStyles.BigText
                fontWeight: FontWeight.Bold
                fontSize: FontSize.Large
            }
        }
    }
    Divider {
    }
    function setHighlight(highlighted) {
        if (highlighted) {
            surahitem.background = Color.Yellow
        } else {
            surahitem.background = Color.White
        }
    }
    ListItem.onActivationChanged: {
        setHighlight(ListItem.active);
    }
}
