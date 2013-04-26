import bb.cascades 1.0

Container {
    id: juzitem
    property alias index: juzIndex.text
    property alias juzName: juzNameLatin.text
    property alias position: numberOfVerses.text
    Container {
        layout: StackLayout {
            orientation: LayoutOrientation.LeftToRight
        }
        Container {
            verticalAlignment: VerticalAlignment.Center
            layout: DockLayout {
            }
            ImageView {
                imageSource: "images/juzzbig.png"
                preferredHeight: 110
                preferredWidth: 110
                scalingMethod: ScalingMethod.AspectFit
            }
            Label {
                id: juzIndex
                horizontalAlignment: HorizontalAlignment.Center
                verticalAlignment: VerticalAlignment.Center
                translationY: 30
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
                id: juzNameLatin
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
    }
    Divider {
    }
    function setHighlight(highlighted) {
        if (highlighted) {
            juzitem.background = Color.Yellow
        } else {
            juzitem.background = Color.White
        }
    }
    ListItem.onActivationChanged: {
        setHighlight(ListItem.active);
    }
}
