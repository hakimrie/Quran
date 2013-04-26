// Default empty project template
#ifndef Quran_HPP_
#define Quran_HPP_

#include <bb/cascades/Application>
#include <bb/cascades/DataModel>
#include <bb/data/SqlDataAccess>
#include <QtSql/QtSql>
#include <QObject>
#include <Qlist>
#include <QVariantlist>
#include "QuranDbHelper.h"
#include <bb/platform/bbm/ProfileBox>
#include <bb/platform/bbm/MessageService>
#include <bb/platform/bbm/UserProfile>

//namespace bb {
//namespace platform {
//namespace bbm {
//class Context;
//}
//}
//}
using namespace bb::cascades;
using namespace bb::data;

namespace bb {
namespace platform {
namespace bbm {
class Context;
class MessageService;
}
}
}

/*!
 * @brief Application pane object
 *
 *Use this object to create and init app UI, to create context objects, to register the new meta types etc.
 */
class Quran: public QObject {
Q_OBJECT
public:
	Quran(bb::platform::bbm::Context &context, bb::cascades::Application *app);
	virtual ~Quran() {
	}
	/**
	 * This Invokable function gets a value from the QSettings,
	 * if that value does not exist in the QSettings database, the default value is returned.
	 *
	 * @param objectName Index path to the item
	 * @param defaultValue Used to create the data in the database when adding
	 * @return If the objectName exists, the value of the QSettings object is returned.
	 *         If the objectName doesn't exist, the default value is returned.
	 */
	Q_INVOKABLE
	QString getValueFor(const QString objectName, const QString defaultValue);

	/**
	 * This function sets a value in the QSettings database. This function should to be called
	 * when a data value has been updated from QML
	 *
	 * @param objectName Index path to the item
	 * @param inputValue new value to the QSettings database
	 */
	Q_INVOKABLE
	void saveValueFor(const QString objectName, const QString inputValue);

	// This method is invoked to open the invitation dialog
	Q_INVOKABLE
	void sendInvite();

	/*!
	 * update status message
	 * @param message new status message, by default busy status will be assigned
	 */
	Q_INVOKABLE void setAsBBMStatus(const QString message);

	/*!
	 * set message/ayat as personal message
	 * @param message new personal message
	 */
	Q_INVOKABLE void setAsPersonalMessage(const QString message);

public Q_SLOTS:
	void show();

	void addProfileBoxItem(const QString &text, int iconId = 1);
	void removeProfileBoxItem(const QString &itemId);

private Q_SLOTS:
	void loadProfileBoxes();
	void itemAdded(const QString &itemId);
	void itemRemoved(const QString &itemId);
	void iconRetrieved(int iconId, bb::platform::bbm::ImageType::Type type,
			const QByteArray &imageData);

private:
	bool copyDbToDataFolder(const QString databaseName);
	bool queryDatabase(const QString query);
	// The database is opened in the loadDatabase function.
	QSqlDatabase mDb;

	bb::platform::bbm::ProfileBox* m_profileBox;
	bb::platform::bbm::UserProfile *mUserProfile;
	bb::platform::bbm::Context *m_context;
	// The service object to send BBM messages
	bb::platform::bbm::MessageService* m_messageService;

	void registerIcons();
	void registerIcon(const QString &path, int iconId);
};

#endif /* Quran_HPP_ */
