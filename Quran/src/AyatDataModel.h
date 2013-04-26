/*
 * AyatDataModel.h
 *
 *  Created on: Nov 17, 2012
 *      Author: hakim
 */

#ifndef AYATDATAMODEL_H_
#define AYATDATAMODEL_H_


#include <bb/cascades/GroupDataModel>
#include <bb/data/DataAccessReply.hpp>
#include <bb/data/SqlConnection.hpp>
#include <QVariantList>

using namespace bb::data;
using namespace bb::cascades;

class AyatDataModel: public GroupDataModel {
	Q_OBJECT
	//connection name for db connection, hopefully conflict will never occur
	//Q_PROPERTY(QString& connectionName READ connectionName NOTIFY connectionNameChanged)

public:
	static const char* const mQuranDatabase;
	AyatDataModel();
	virtual ~AyatDataModel();

	// Implementing the DataModel class
//	Q_INVOKABLE
//	int childCount(const QVariantList &indexPath);Q_INVOKABLE
//	bool hasChildren(const QVariantList &indexPath);Q_INVOKABLE
//	QVariant data(const QVariantList &indexPath);

	Q_INVOKABLE
	bool addBookmark(QVariantList indexPath, QString surah, QString ayat);
	Q_INVOKABLE bool removeBookmark(QVariantList indexPath, QString surah,
			QString ayat);
	Q_INVOKABLE bool deleteBookmark(QVariantList indexPath, QString surah,
				QString ayat);
	Q_INVOKABLE bool updateNote(QVariantList indexPath, QString surah,
				QString ayat, QString note);
	Q_INVOKABLE bool deleteNote(QVariantList indexPath, QString surah,
			QString ayat);

	/*!
	 * @brief load data ayat pada surah nomor tertentu
	 * @param surahNumber nomor surah
	*/
	Q_INVOKABLE void loadData(QString surahNumber);
	Q_INVOKABLE void loadBookmarks();
	Q_INVOKABLE
	void loadNotes();
	/*!
	 * @brief full text search ayat al-Quran with query
	 * @param keywords text or sentence keywords
	 */
	Q_INVOKABLE void searchAyat(const QString keywords);

	// siqnal ketika item mulai di load
		Q_SIGNAL void startLoadData();
	// signal ketika item selesai di lod
	Q_SIGNAL
	void allItemLoaded(QString message);

	// Signals and slots used for initiating the SQL request
	Q_SIGNAL
	void loadSQLData(const QString&);
	Q_SLOT
	void onLoadData(const QString& sql);

	// A slot that asynchronously receives the reply data from the
	// SQL request
	Q_SIGNAL void connectionNameChanged();

public slots:
	void onReply(const bb::data::DataAccessReply& dar);
	void onReloadDatabase();
private:
	QString surahNumber;
	QString mQuery;
	SqlWorker *m_pSqlWorker;
	SqlConnection *m_pSqlConnection;
	QString mConnectionName;
	bool isArabicText(const QString text);
};

#endif /* AYATDATAMODEL_H_ */
