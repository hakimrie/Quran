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

using namespace bb::data;
using namespace bb::cascades;

class AyatDataModel: public GroupDataModel {
	Q_OBJECT

public:
	static const char* const mQuranDatabase;
	AyatDataModel();
	virtual ~AyatDataModel();

	Q_INVOKABLE bool addBookmark(QVariantList indexPath, QString surah, QString ayat);
	Q_INVOKABLE bool removeBookmark(QVariantList indexPath, QString surah, QString ayat);
	Q_INVOKABLE bool deleteBookmark(QVariantList indexPath, QString surah, QString ayat);
	Q_INVOKABLE bool updateNote(QVariantList indexPath, QString surah, QString ayat, QString note);
	Q_INVOKABLE bool deleteNote(QVariantList indexPath, QString surah, QString ayat);

	/*!
	 * @brief load data ayat pada surah nomor tertentu
	 * @param surahNumber nomor surah
	*/
	Q_INVOKABLE void loadData(QString surahNumber);
	Q_INVOKABLE void loadBookmarks();
	Q_INVOKABLE void loadNotes();
	/*!
	 * @brief full text search ayat al-Quran with query
	 * @param keywords text or sentence keywords
	 */
	Q_INVOKABLE void searchAyat(const QString keywords);

	signals:
	// siqnal ketika item mulai di load
	void startLoadData();
	// signal ketika item selesai di lod
	void allItemLoaded(QString message);

	// Signals and slots used for initiating the SQL request
	void loadSQLData(const QString&);

	// A slot that asynchronously receives the reply data from the
	// SQL request
	void connectionNameChanged();

public slots:
	void onReply(const bb::data::DataAccessReply& dar);
	void onReloadDatabase();
	void onLoadData(const QString& sql);

private:
	QString surahNumber;
	QString mQuery;
	SqlWorker *m_pSqlWorker;
	SqlConnection *m_pSqlConnection;
	QString mConnectionName;
	bool isArabicText(const QString text);

	static const QString QUERY_SELECT_NOTES;
	static const QString QUERY_UPDATE_NOTES;
	static const QString QUERY_DELETE_NOTES;
	static const QString QUERY_SELECT_ALL_AYAT;
	static const QString QUERY_SELECT_ALL_BOOKMARK;
	static const QString QUERY_UPDATE_ADD_BOOKMARK;
	static const QString QUERY_UPDATE_REMOVE_BOOKMARK;
	static const QString QUERY_SEARCH_TRANSLATION;
	static const QString QUERY_SEARCH_AYAT; //arabic
};

#endif /* AYATDATAMODEL_H_ */
