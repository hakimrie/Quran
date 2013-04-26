import bb.cascades 1.0

Container {
    property alias ayah: ayahIndex.text
//    property alias ayahText: ayahArabic.text
    property alias translationText: translation.text
    property string bookmarked
    property string surah
    
    id: ayahitem
    background: bookmarked == 'true' ? Color.create("#dbce93") : Color.White
    Container {
        layout: StackLayout {
            orientation: LayoutOrientation.LeftToRight
        }
        Container {
            Container { // tanda juz, jika ayat pas juz
                preferredWidth: 110
                layout: DockLayout {
                }
                ImageView {
                    imageSource: "images/index_juz_mark.png"
                    preferredHeight: 110
                    preferredWidth: 110
                    scalingMethod: ScalingMethod.Fill
                }
                Label {
                    id: juzIndex
                    horizontalAlignment: HorizontalAlignment.Center
                    verticalAlignment: VerticalAlignment.Center
                    
                    textStyle {
                        base: SystemDefaults.TextStyles.SmallText
                        fontWeight: FontWeight.Bold
                        fontSize: FontSize.Default
                        color : Color.White
                    }
                    text: numberOfJuz(surah, ayah);
                }
                rightMargin: 12
                visible: isJuzStart(surah, ayah);
            }
            Container { // nomor ayat
                preferredWidth: 110
                layout: DockLayout {
                }
                ImageView {
                    imageSource: bookmarked == 'true' ? "images/bookmark.png" : "images/ayah.png"
                    preferredHeight: 110
                    preferredWidth: 110
                    scalingMethod: ScalingMethod.Fill
                }
                Label {
                    id: ayahIndex
                    horizontalAlignment: HorizontalAlignment.Center
                    verticalAlignment: VerticalAlignment.Center
                    textStyle {
                        base: SystemDefaults.TextStyles.SmallText
                        fontWeight: FontWeight.Bold
                        fontSize: FontSize.Default
                    }
                }
                rightMargin: 12
            }
            ImageView {
                horizontalAlignment: HorizontalAlignment.Center
                imageSource: "images/sajdah.png"
                visible: isSajdah(surah, ayah)
            }
        }
        Container { // ayat dan terjemahnya
            //preferredWidth: orientation == Orientation.Landscape ? 646 :
            layout: StackLayout {
                orientation: LayoutOrientation.TopToBottom
            }
//            Label {
//                id: ayahArabic
//                rightMargin: 20
//                rightPadding: 20
//                horizontalAlignment: HorizontalAlignment.Right
//                verticalAlignment: VerticalAlignment.Top
//                textStyle {
//                    base: SystemDefaults.TextStyles.BodyText
//                    fontWeight: FontWeight.Default
//                    fontSize: FontSize.Large
//                    textAlign: TextAlign.Right
//                    fontFamily: "Arial"
//                }
//                multiline: true
//            }
            Label {
                id: translation
                horizontalAlignment: HorizontalAlignment.Left
                verticalAlignment: VerticalAlignment.Top
                multiline: true
                text: "Dengan Menyebut Nama Allah Yang Maha Pengasih lagi Maha Penyayang"
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
            ayahitem.background = Color.Yellow;
        } else {
            ayahitem.background = ListItemData.bookmarked == 'true' ? Color.create("#dbce93") : Color.White;
        }
    }
    ListItem.onActivationChanged: {
        setHighlight(ListItem.active);
    }
    ListItem.onSelectionChanged: {
        setHighlight(ListItem.selected);
    }
    onCreationCompleted: {
        OrientationSupport.supportedDisplayOrientation = SupportedDisplayOrientation.All;
    }
    function isSajdah(surat, ayat) {
        //        <sajda-detail>
        //        		<!-- Mustahab Sajda -->
        //        		<sajda index="1" sura="7" aya="206" type="recommended" />
        //        		<sajda index="2" sura="13" aya="15" type="recommended" />
        //        		<sajda index="3" sura="16" aya="50" type="recommended" />
        //        		<sajda index="4" sura="17" aya="109" type="recommended" />
        //        		<sajda index="5" sura="19" aya="58" type="recommended" />
        //        		<sajda index="6" sura="22" aya="18" type="recommended" />
        //        		<sajda index="7" sura="22" aya="77" type="recommended" />
        //        		<sajda index="8" sura="25" aya="60" type="recommended" />
        //        		<sajda index="9" sura="27" aya="26" type="recommended" />
        //        		<sajda index="11" sura="38" aya="24" type="recommended" />
        //        		<sajda index="14" sura="84" aya="21" type="recommended" />
        //        		<!-- Wajib Sajda -->
        //        		<sajda index="10" sura="32" aya="15" type="mandatory" /><!--سجدة-->
        //        		<sajda index="12" sura="41" aya="38" type="mandatory" /><!--فصلت-->
        //        		<sajda index="13" sura="53" aya="62" type="mandatory" /><!--نجم-->
        //        		<sajda index="15" sura="96" aya="19" type="mandatory" /><!--علق-->
        //        	</sajda-detail>
        return (surat == '7' && ayat == '206') || (surat == '13' && ayat == '15') || (surat == '16' && ayat == '50') || 
        (surat == '17' && ayat == '109') || (surat == '19' && ayat == '58') || (surat == '22' && ayat == '18') || 
        (surat == '22' && ayat == '77') || (surat == '25' && ayat == '60') || (surat == '27' && ayat == '26') || 
        (surat == '38' && ayat == '24') || (surat == '84' && ayat == '21') || (surat == '32' && ayat == '15') || 
        (surat == '41' && ayat == '38') || (surat == '53' && ayat == '62') || (surat == '96' && ayat == '19');
    }
    
    function isJuzStart(surat, ayat){
//        		<juz index="1" surahName="Al-Fātiḥaħ" sura="1" aya="1" />
//        		<juz index="2" surahName="Al-Baqaraħ" sura="2" aya="142" />
//        		<juz index="3" surahName="Al-Baqaraħ" sura="2" aya="253" />
//        		<juz index="4" surahName="'Āli `Imrān" sura="3" aya="93" />
//        		<juz index="5" surahName="An-Nisā'" sura="4" aya="24" />
//        		<juz index="6" surahName="An-Nisā'" sura="4" aya="148" />
//        		<juz index="7" surahName="Al-Mā'idaħ" sura="5" aya="82" />
//        		<juz index="8" surahName="Al-'An`ām" sura="6" aya="111" />
//        		<juz index="9" surahName="Al-'A`rāf" sura="7" aya="88" />
//        		<juz index="10" surahName="Al-'Anfāl" sura="8" aya="41" />
//        		<juz index="11" surahName="At-Tawbaħ" sura="9" aya="93" />
//        		<juz index="12" surahName="Hūd" sura="11" aya="6" />
//        		<juz index="13" surahName="Yūsuf" sura="12" aya="53" />
//        		<juz index="14" surahName="Al-Ḥijr" sura="15" aya="1" />
//        		<juz index="15" surahName="Al-'Isrā'" sura="17" aya="1" />
//        		<juz index="16" surahName="Al-Kahf" sura="18" aya="75" />
//        		<juz index="17" surahName="Al-'Aɱbiyā'" sura="21" aya="1" />
//        		<juz index="18" surahName="Al-Mu'minūn" sura="23" aya="1" />
//        		<juz index="19" surahName="Al-Furqān" sura="25" aya="21" />
//        		<juz index="20" surahName="An-Naml" sura="27" aya="56" />
//        		<juz index="21" surahName="Al-`Ankabūt" sura="29" aya="46" />
//        		<juz index="22" surahName="Al-'Aḥzāb" sura="33" aya="31" />
//        		<juz index="23" surahName="Yā-Sīn" sura="36" aya="28" />
//        		<juz index="24" surahName="Az-Zumar" sura="39" aya="32" />
//        		<juz index="25" surahName="Fuṣṣilat" sura="41" aya="47" />
//        		<juz index="26" surahName="Al-'Aḥqāf" sura="46" aya="1" />
//        		<juz index="27" surahName="Adh-Dhāriyāt" sura="51" aya="31" />
//        		<juz index="28" surahName="Al-Mujādalaħ" sura="58" aya="1" />
//        		<juz index="29" surahName="Al-Mulk" sura="67" aya="1" />
//        		<juz index="30" surahName="An-Naba'" sura="78" aya="1" />
        return (surat == '1' && ayat == '1') || (surat == '2' && ayat == '142') || (surat == '2' && ayat == '253') || 
        (surat == '3' && ayat == '93') || (surat == '4' && ayat == '24') || (surat == '4' && ayat == '148') || 
        (surat == '5' && ayat == '82') || (surat == '6' && ayat == '111') || (surat == '11' && ayat == '6') || 
        (surat == '8' && ayat == '41') || (surat == '9' && ayat == '93') || (surat == '32' && ayat == '15') || 
        (surat == '12' && ayat == '53') || (surat == '15' && ayat == '1') || (surat == '17' && ayat == '1') ||
        (surat == '18' && ayat == '75') || (surat == '21' && ayat == '1') || (surat == '23' && ayat == '1') || 
                (surat == '25' && ayat == '21') || (surat == '27' && ayat == '56') || (surat == '29' && ayat == '46') || 
                (surat == '33' && ayat == '31') || (surat == '36' && ayat == '28') || (surat == '39' && ayat == '32') || 
                (surat == '41' && ayat == '47') || (surat == '46' && ayat == '1') || (surat == '51' && ayat == '31') || 
                (surat == '58' && ayat == '1') || (surat == '67' && ayat == '1') || (surat == '78' && ayat == '1');
    }
    
    function numberOfJuz(surat, ayat){
        if (surat == '1' && ayat == '1') return 1;
        else if (surat == '2' && ayat == '142') return 2;
        else if (surat == '2' && ayat == '253') return 3;
        else if (surat == '3' && ayat == '93') return 4;
        else if (surat == '4' && ayat == '24') return 5;
        else if (surat == '4' && ayat == '148') return 6;
        else if (surat == '5' && ayat == '82') return 7;
        else if (surat == '6' && ayat == '111') return 8;
        else if (surat == '11' && ayat == '6') return 9;
        else if (surat == '8' && ayat == '41') return 10;
        else if (surat == '9' && ayat == '93') return 11;
        else if (surat == '32' && ayat == '15') return 12;
        else if (surat == '12' && ayat == '53') return 13;
        else if (surat == '15' && ayat == '1') return 14;
        else if (surat == '17' && ayat == '1') return 15;
        else if (surat == '18' && ayat == '75') return 16;
        else if (surat == '21' && ayat == '1') return 17;
        else if (surat == '23' && ayat == '1') return 18;
        else if (surat == '25' && ayat == '21') return 19;
        else if (surat == '27' && ayat == '56') return 20;
        else if (surat == '29' && ayat == '46') return 21;
        else if (surat == '33' && ayat == '31') return 22;
        else if (surat == '36' && ayat == '28') return 23;
        else if (surat == '39' && ayat == '32') return 24;
        else if (surat == '41' && ayat == '47') return 25;
        else if (surat == '46' && ayat == '1') return 26;
        else if (surat == '51' && ayat == '31') return 27;
        else if (surat == '58' && ayat == '1') return 28;
        else if (surat == '67' && ayat == '1') return 29;
        else if (surat == '78' && ayat == '1') return 30;
        else return 0;
    }
}
