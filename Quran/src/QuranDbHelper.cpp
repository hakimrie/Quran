/*
 * QuranDbHelper.cpp
 *
 *  Created on: Nov 16, 2012
 *      Author: hakim
 */

#include "QuranDbHelper.h"
#include "AyatDataModel.h"

QuranDbHelper::QuranDbHelper() {

}

QuranDbHelper::~QuranDbHelper() {
	qDebug() << "destructor, close db";
	if (mDb.isOpen()) {
		QSqlDatabase::removeDatabase(AyatDataModel::mQuranDatabase);
		mDb.removeDatabase("QSQLITE");
	}
}

bool QuranDbHelper::initDatabase() {

	// Open the database to enable update/insert/delete functionality (via SQL queries) using
	// a non-default connection, so we don't conflict with the database connection already setup by SqlDataAccess.
	mDb = QSqlDatabase::addDatabase("QSQLITE", "database_helper_connection");
	mDb.setDatabaseName(AyatDataModel::mQuranDatabase);

	if (!mDb.isValid()) {
		qWarning()
				<< "Could not set data base name probably due to invalid driver.";
		return false;
	}

	bool success = mDb.open();

	if (!success) {
		qWarning() << "Could not open database we are in trouble";
		return false;
	}

	return true;
}
// update bookmarked value query:

void QuranDbHelper::loadDataBookmarks() {
}
void QuranDbHelper::addBookmark(QString surah, QString ayat) {
	QString query = "update Quran set bookmarked='true'  where SuraID = "
			+ surah + " and VerseID = " + ayat;

	// execute query
	queryDatabase(query);
}
void QuranDbHelper::removeBookmark(QString surah, QString ayat) {
	QString query = "update Quran set bookmarked='false'  where SuraID ="
			+ surah + " and VerseID = " + ayat;

	// execute query
	queryDatabase(query);
}

QString QuranDbHelper::loadDataNote() {
	return "";
}
void QuranDbHelper::updateNote(QString surah, QString ayat, QString note) {
	QString query = "update Quran set note= '"+note+"' where SuraID = "
				+ surah + " and VerseID = " + ayat;

		// execute query
		queryDatabase(query);
}

bool QuranDbHelper::queryDatabase(const QString query) {

	if (!mDb.isOpen()){
		if (!initDatabase()) {
			qDebug() << "fail to open database " << AyatDataModel::mQuranDatabase;
		} else {
			qDebug() << "succes open database " << AyatDataModel::mQuranDatabase;
		}
	}
	// Execute the query.
	QSqlQuery sqlQuery(query, mDb);


	QSqlError err = sqlQuery.lastError();

	if (err.isValid()) {
		qWarning() << "SQL reported an error for query: " << query << " error: "
				<< mDb.lastError().text();
		return false;
	}

	return true;
}

void QuranDbHelper::loadTranslationLanguages(){
	QString query = "SELECT * from translations";
	if (!mDb.isOpen()){
			if (!initDatabase()) {
				qDebug() << "fail to open database " << AyatDataModel::mQuranDatabase;
			} else {
				qDebug() << "succes open database " << AyatDataModel::mQuranDatabase;
			}
		}
		// Execute the query.
		QSqlQuery sqlQuery(query, mDb);


		QSqlError err = sqlQuery.lastError();

		if (err.isValid()) {
			qWarning() << "SQL reported an error for query: " << query << " error: "
					<< mDb.lastError().text();
			return;
		}else{ // tidak ada error
			while(sqlQuery.next()){
				qDebug() << "Result: " << sqlQuery.value(0).toString() << sqlQuery.value(1).toString();
			}
		}
}
