/*
 * QuranDbHelper.h
 *
 *  Created on: Nov 16, 2012
 *      Author: hakim
 */

#ifndef QURANDBHELPER_H_
#define QURANDBHELPER_H_
#include <QtSql/QtSql>
#include <bb/data/SqlDataAccess>

using namespace bb::data;

class QuranDbHelper : public QObject{
    Q_OBJECT
public:
	QuranDbHelper();
	virtual ~QuranDbHelper();

	Q_INVOKABLE void loadDataBookmarks();
	Q_INVOKABLE void addBookmark(QString surah, QString ayat);
	Q_INVOKABLE void removeBookmark(QString surah, QString ayat);

	Q_INVOKABLE QString loadDataNote();
	Q_INVOKABLE void updateNote(QString surah, QString ayat, QString note);

	void loadTranslationLanguages();
private:
    /**
     * In order to write to a file in a signed application, the file must
     * reside in the apps data folder(assets). This function copies the bundled
     * database file to that folder.
     *
     * @param databaseName The name of the database (in assets/sql).
     * @return True on success, false on failure
     */
	bool initDatabase();
    /**
     * This helper function is for running a specific query on the database.
     *
     * @param query The hardcoded query to run.
     * @return True on success, false on failure
     */
    bool queryDatabase(const QString query);

    // The database is opened in the loadDatabase function.
    QSqlDatabase mDb;

    // The name of the table loaded in the loadDatabase function
    //QString mTable;
    QString mDbNameWithPath;
};

#endif /* QURANDBHELPER_H_ */
