// Default empty project template
#include "Quran.hpp"
#include <bb/cascades/Application>
#include <bb/cascades/QmlDocument>
#include <bb/cascades/AbstractPane>
#include <QSettings>
#include <bb/cascades/Image>
#include <bb/cascades/DropDown>
#include <bb/cascades/Page>
#include <bb/cascades/GroupDataModel>
#include <bb/platform/bbm/ProfileBoxItem>
#include <bb/platform/bbm/UserProfile>
#include <bb/platform/bbm/UserStatus>
#include "AyatDataModel.h"
#include "QuranDbHelper.h"

using namespace bb::cascades;


Quran::Quran(bb::platform::bbm::Context &context, bb::cascades::Application *app)
: QObject(app),
  m_profileBox(0),
  m_context(&context),
  mUserProfile(0),
  m_messageService(0)
{
	qmlRegisterType<AyatDataModel>("custom",1,0,"AyatDataModel");
    // create scene document from main.qml asset
    // set parent to created document to ensure it exists for the whole application lifetime
    //QmlDocument *qml = QmlDocument::create("asset:///main.qml").parent(this);
//    QTextCodec::setCodecForCStrings(QTextCodec::codecForName("UTF-8"));
//    qml->setContextProperty("app", this);
//
//    // create root object for the UI
//    AbstractPane *root = qml->createRootObject<AbstractPane>();

    if (!copyDbToDataFolder("quran.db")){
    	qDebug() << "failed to copy database into folder /data/";
    }
    //QmlDocument *qmlayahpage = QmlDocument::create("asset:///AyahPage.qml");

    // coba load data translation
//    QuranDbHelper qdb;
//    qdb.loadTranslationLanguages();
//    QmlDocument *qml = QmlDocument::create("asset:///SettingsPage.qml");
//
//    Page *page = qml->createRootObject<Page>();
//    DropDown *dropDownTranslation = page->findChild<DropDown*>("translations");
//
//    dropDownTranslation->add(Option::create().text("Bahasa 1"));
//    dropDownTranslation->add(Option::create().text("Bahasa 2"));
//    dropDownTranslation->add(Option::create().text("Bahasa 3"));
//    dropDownTranslation->add(Option::create().text("Bahasa 4"));
    // set created root object as a scene
//    app->setScene(root);
}


bool Quran::copyDbToDataFolder(const QString databaseName) {
	// Since we need read and write access to the database, it has
	// to be moved to a folder where we have access to it. First,
	// we check if the file already exists (previously copied).
	QString dataFolder = QDir::homePath();
	QString newFileName = dataFolder + "/" + databaseName;
	QFile newFile(newFileName);

	if (!newFile.exists()) {
		// delete old database, if exist
		QFile oldFile(dataFolder+"/quran_db.sqlite");
		if (oldFile.exists()){// jika masih ada, delete {kita ga melakukan backup/import karena user masih sedikit}
			oldFile.remove();
		}else{
			qDebug() << "old file is not exist";
		}

		// If the file is not already in the data folder, we copy it from the
		// assets folder (read only) to the data folder (read and write).
		// Note: On a debug build, you will be able to write to a data base
		// in the assets folder but that is not possible on a signed application.
		QString appFolder(QDir::homePath());
		appFolder.chop(4);
		QString originalFileName = appFolder + "app/native/assets/db/"
				+ databaseName;
		QFile originalFile(originalFileName);


		if (originalFile.exists()) {
			return originalFile.copy(newFileName);
		} else {
			qDebug() << "Failed to copy file data base file does not exists.";
			return false;
		}

	}

	return true;
}


QString Quran::getValueFor(const QString objectName, const QString defaultValue)
{
    QSettings settings;

    // If no value has been saved, return the default value.
    if (settings.value(objectName).isNull()) {
        return defaultValue;
    }

    if (objectName == "LanguageSettings"){
    	QString stringVal = settings.value(objectName).toString();
    	if (stringVal == "100"){ return "0";}
    	else if (stringVal == "58") return "1";
    	else if (stringVal == "101") return "2";
    	else if (stringVal == "68") return "3";
    	else if (stringVal == "102") return "4";
    }


//    else if (objectName == "AyatChecked"){
//
//    }else if (objectName == "TranslationChecked"){
//
//    }
    // Otherwise, return the value stored in the settings object.
    return settings.value(objectName).toString();
}

void Quran::saveValueFor(const QString objectName, const QString inputValue)
{
    // A new value is saved to the application settings object.
    QSettings settings;
    settings.setValue(objectName, QVariant(inputValue));
}


//! [1]
void Quran::addProfileBoxItem(const QString &text, int iconId)
{
    m_profileBox->requestAddItem(text, iconId);
}
//! [1]

//! [2]
void Quran::removeProfileBoxItem(const QString &itemId)
{
    m_profileBox->requestRemoveItem(itemId);
}
//! [2]

//! [3]
void Quran::show()
{
    // Create the UI
    QmlDocument *qml = QmlDocument::create("asset:///main.qml").parent(this);
    QTextCodec::setCodecForCStrings(QTextCodec::codecForName("UTF-8"));
    qml->setContextProperty("app", this);

    //qml->setContextProperty("_profileBoxManager", this);



    AbstractPane *root = qml->createRootObject<AbstractPane>();


    Application::instance()->setScene(root);


    // Delay the loading of ProfileBox a bit
    QMetaObject::invokeMethod(this, "loadProfileBoxes", Qt::QueuedConnection);
}
//! [3]

//! [4]
void Quran::loadProfileBoxes()
{
    // Create the profile box object
    m_profileBox = new bb::platform::bbm::ProfileBox(m_context, this);
    mUserProfile = new bb::platform::bbm::UserProfile(m_context, this);
    // Connect all signals to get informed about updates to the profile box
    connect(m_profileBox, SIGNAL(itemAdded(QString)), this, SLOT(itemAdded(QString)));
    connect(m_profileBox, SIGNAL(itemRemoved(QString)), this, SLOT(itemRemoved(QString)));
    connect(m_profileBox, SIGNAL(iconRetrieved(int, bb::platform::bbm::ImageType::Type, QByteArray)),
            this, SLOT(iconRetrieved(int, bb::platform::bbm::ImageType::Type, QByteArray)));

    registerIcons();

    // Fill the model with the initial data
    foreach (const bb::platform::bbm::ProfileBoxItem &item, m_profileBox->items()) {
        // Create a model entry
        const int iconId = item.iconId();

        QVariantMap entry;
        entry["id"] = item.id();
        entry["text"] = item.text();
        entry["iconId"] = iconId;

        // Append the entry to the model
        //m_model->append(entry);

        // Request the icon for this icon ID asynchronously
        m_profileBox->requestRetrieveIcon(iconId);
    }

    // update user profile status
    //mUserProfile->requestUpdateStatus(bb::platform::bbm::UserStatus::Busy, "I'm Reading al-Qur'an using Quran app: http://appworld.blackberry.com/webstore/content/19964407");
    // hanya update profile box jika first time usage
    QSettings settings;
    QString stringVal = settings.value("firsttime").toString();
    if (stringVal == ""){
    	mUserProfile->requestUpdatePersonalMessage(/*bb::platform::bbm::UserStatus::Busy,*/ "I'm Reading al-Qur'an using Quran app: http://appworld.blackberry.com/webstore/content/19964407");
    	settings.setValue("firsttime", "false");
    }
}
//! [4]

//! [5]
void Quran::itemAdded(const QString &itemId)
{
    // Retrieve the new item
    const bb::platform::bbm::ProfileBoxItem item = m_profileBox->item(itemId);

    // Create a model entry for it
    const int iconId = item.iconId();

    QVariantMap entry;
    entry["id"] = itemId;
    entry["text"] = item.text();
    entry["iconId"] = iconId;

    // Append the entry to the model
    //m_model->append(entry);

    // Request the icon for this icon ID asynchronously
    m_profileBox->requestRetrieveIcon(iconId);
}
//! [5]

//! [6]
void Quran::itemRemoved(const QString &itemId)
{
    // Search the corresponding entry in the model
//    for (int pos = 0; pos < m_model->size(); ++pos) {
//        if (m_model->value(pos).toMap().value("id").toString() == itemId) {
//            // Remove the corresponding entry from the model
//            m_model->removeAt(pos);
//            return;
//        }
//    }
}
//! [6]

//! [7]
void Quran::iconRetrieved(int iconId, bb::platform::bbm::ImageType::Type, const QByteArray &imageData)
{
    const bb::cascades::Image image(imageData);

//    for (int pos = 0; pos < m_model->size(); ++pos) {
//        QVariantMap entry = m_model->value(pos).toMap();
//        if (entry.value("iconId").toInt() == iconId) {
//            entry["icon"] = QVariant::fromValue(image);
//            m_model->replace(pos, entry);
//        }
//    }
}
//! [7]

//! [8]
void Quran::registerIcons()
{
    const QString imageDir(QDir::currentPath() + QLatin1String("/app/native/assets/images/"));
    registerIcon(imageDir + QLatin1String("quran_icon2.png"), 1);
    //registerIcon(imageDir + QLatin1String("pear.png"), 2);
    //registerIcon(imageDir + QLatin1String("orange.png"), 3);
}
//! [8]

//! [9]
void Quran::registerIcon(const QString& path, int iconId)
{
    // Read the icon from the file
    QFile file(path);
    if (!file.open(QIODevice::ReadOnly))
        return;

    const QByteArray imageData = file.readAll();

    // Create the icon object and register the icon
    m_profileBox->requestRegisterIcon(iconId, bb::platform::bbm::ImageType::Png, imageData);

    // coba nambahin item
    //m_profileBox->requestAddItem("Start Reading al-Qur'an", 1, "abcdefg");
}

//! [1]
void Quran::sendInvite()
{
    if (!m_messageService) {
        // Instantiate the MessageService.
        m_messageService = new bb::platform::bbm::MessageService(m_context, this);
    }

    // Trigger the invite to download process.
    m_messageService->sendDownloadInvitation();
}

void Quran::setAsBBMStatus(const QString message){
	mUserProfile->requestUpdateStatus(bb::platform::bbm::UserStatus::Busy, message);

}

void Quran::setAsPersonalMessage(const QString messsage){
	mUserProfile->requestUpdatePersonalMessage(messsage/* "I'm Reading al-Qur'an using Quran app: http://appworld.blackberry.com/webstore/content/19964407"*/);
}
