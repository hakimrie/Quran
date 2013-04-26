/*
 * AyatDataModel.cpp
 *
 *  Created on: Nov 17, 2012
 *      Author: hakim
 */

#include "AyatDataModel.h"
#include <QRegExp>

const char* const AyatDataModel::mQuranDatabase = "data/quran.db";

AyatDataModel::AyatDataModel() :
		m_pSqlConnection(NULL), m_pSqlWorker(NULL), mQuery(""), mConnectionName("quran") {

	connect(this, SIGNAL(loadSQLData(const QString&)), this,
			SLOT(onLoadData(const QString&)), Qt::QueuedConnection);
//	qDebug() << "arabictext: " << isArabicText(QString("وتولى")) << "campur arabuc: " << isArabicText(QString("وتولى adfadf")) << "bukan arabic: " << isArabicText(QString("abc"));
}

AyatDataModel::~AyatDataModel() {
	m_pSqlWorker->disconnect();

	if (m_pSqlConnection->isRunning()) {
		m_pSqlConnection->stop();
	}
}

bool AyatDataModel::addBookmark(QVariantList indexPath, QString surah,
		QString ayat) {
	QString query = "update Quran set bookmarked='true'  where SuraID = "
			+ surah + " and VerseID = " + ayat;
	// execute query
	DataAccessReply reply = m_pSqlConnection->executeAndWait(query);

	if (!reply.hasError()) {
		if (!indexPath.isEmpty()) {
			// Get the data item for the selected item so it can be updated.
			QVariantMap itemMapAtIndex = this->data(indexPath).toMap();

			// Update the data.
			itemMapAtIndex["bookmarked"] = QString("true");

			this->updateItem(indexPath, itemMapAtIndex);
		} else {
			qDebug() << "error, indexpath empty";

		}
		return true;
	} else {
		return false;
	}

}

bool AyatDataModel::removeBookmark(QVariantList indexPath, QString surah,
		QString ayat) {
	QString query = "update Quran set bookmarked='false'  where SuraID ="
				+ surah + " and VerseID = " + ayat;
	// execute query
	DataAccessReply reply = m_pSqlConnection->executeAndWait(query);

	if (!reply.hasError()) {
		if (!indexPath.isEmpty()) {
			// Get the data item for the selected item so it can be updated.
			QVariantMap itemMapAtIndex = this->data(indexPath).toMap();

			// Update the data.
			itemMapAtIndex["bookmarked"] = QString("false");

			this->updateItem(indexPath, itemMapAtIndex);
		} else {
			qDebug() << "error, indexpath empty";

		}
		return true;
	} else {
		return false;
	}

}

bool AyatDataModel::deleteBookmark(QVariantList indexPath, QString surah,
		QString ayat) {
	QString query = "update Quran set bookmarked='false'  where SuraID ="
				+ surah + " and VerseID = " + ayat;
	// execute query
	DataAccessReply reply = m_pSqlConnection->executeAndWait(query);

	if (!reply.hasError()) {
		if (!indexPath.isEmpty()) {
			// Get the data item for the selected item so it can be updated.
			QVariantMap itemMapAtIndex = this->data(indexPath).toMap();

			// Update the data.
			itemMapAtIndex["bookmarked"] = QString("false");

			this->removeAt(indexPath);
		} else {
			qDebug() << "error, indexpath empty";

		}
		return true;
	} else {
		return false;
	}

}


bool AyatDataModel::updateNote(QVariantList indexPath, QString surah,
				QString ayat, QString note){
	QString query = "update Quran set note= '"+note+"' where SuraID = "
					+ surah + " and VerseID = " + ayat;
		// execute query
		DataAccessReply reply = m_pSqlConnection->executeAndWait(query);

		if (!reply.hasError()) {
			if (!indexPath.isEmpty()) {
				// Get the data item for the selected item so it can be updated.
				QVariantMap itemMapAtIndex = this->data(indexPath).toMap();

				// Update the data.
				itemMapAtIndex["note"] = note;

				this->updateItem(indexPath, itemMapAtIndex);
			} else {
				qDebug() << "error, indexpath empty";
			}
			return true;
		} else {
			return false;
		}
}

bool AyatDataModel::deleteNote(QVariantList indexPath, QString surah,
		QString ayat){
	QString query = "update Quran set note= '' where SuraID = "
						+ surah + " and VerseID = " + ayat;
			// execute query
			DataAccessReply reply = m_pSqlConnection->executeAndWait(query);

			if (!reply.hasError()) {
				if (!indexPath.isEmpty()) {
					// Get the data item for the selected item so it can be updated.
					QVariantMap itemMapAtIndex = this->data(indexPath).toMap();

					// Update the data.
					itemMapAtIndex["note"] = "";
					this->removeAt(indexPath);
				} else {
					qDebug() << "error, indexpath empty";
				}
				return true;
			} else {
				return false;
			}
}
void AyatDataModel::loadData(QString surahNumber) {
	this->surahNumber = surahNumber;
	QSettings settings;
	QString translationId = "58";
	    // If no value has been saved, return the default value.
	    if (!settings.value("LanguageSettings").isNull()) {
	        translationId = settings.value("LanguageSettings").toString();
	    }


	mQuery = "select surah.bookmarked as bookmarked, surah.note as note, surah.SuraID as surahNumber, surah.VerseID as ayatNumber, surah.AyahText as ayatText, translationsdata.TranslationText as translationText from \
	        		(select * from Quran where Quran.SuraID = "
					+ surahNumber
					+ "  ) as surah \
	        		left join (select * from translationsdata where languageID = "+translationId+" and CAST(SuraID as INTEGER) = "+surahNumber+") as translationsdata on surah.SuraID = CAST(translationsdata.SuraID as INTEGER)  and surah.VerseID = CAST(translationsdata.VerseID as INTEGER) order by surah.VerseID desc";
	qDebug() << "query = " + mQuery;
	QString query2 = "select * from Quran where SuraID = " + surahNumber
			+ " order by VerseID desc";
	emit loadSQLData(mQuery);
}

void AyatDataModel::loadBookmarks() {
	mQuery = //"select SuraID as surah, VerseID as ayat, ayahText as ayahText, bookmarked from Quran where Quran.bookmarked = 'true'";
			"select Quran.SuraID as surah, Quran.VerseID as ayat, Quran.AyahText as ayahText, Quran.bookmarked as bookmarked, Surah.SuraName as surahName from Quran  left join Surah on Quran.SuraID = Surah.SuraID where bookmarked = 'true' ";
	this->mConnectionName = "bookmarks";
	emit loadSQLData(mQuery);
}

void AyatDataModel::loadNotes() {
	QSettings settings;
	QString translationId = "58";
	// If no value has been saved, return the default value.
	if (!settings.value("LanguageSettings").isNull()) {
		translationId = settings.value("LanguageSettings").toString();
	}
	mQuery = "SELECT Quran.SuraID as surah, Quran.VerseID as ayat, AyahText as ayatText, note, TranslationText as translationText \
			 FROM Quran join (select * from translationsdata where languageID = " + translationId+ ") as translationsdata \
			 on Quran.SuraID = CAST(translationsdata.SuraID as INTEGER)  and Quran.VerseID = CAST(translationsdata.VerseID as INTEGER) \
			 WHERE TRIM(note) <> '' and note IS NOT NULL ";
	this->mConnectionName = "notes";
	emit loadSQLData(mQuery);
}
//void AyatDataModel::removeLoadingItem() {
//	modelList.removeLast();
//	QVariantList indexPath;
//	indexPath.append(modelList.size());
//	emit itemRemoved(indexPath);
//}

// Creates the SQL connection used for requesting SQL data and connects
// the SqlConnection::reply() signal to a custom clot used for handling the reply data.
void AyatDataModel::onLoadData(const QString& sql) {
	if (!m_pSqlWorker && !m_pSqlConnection) {

		m_pSqlWorker = new SqlWorker(mQuranDatabase, this->mConnectionName, this);
		m_pSqlConnection = new SqlConnection(m_pSqlWorker, this);
		bool res = connect(m_pSqlConnection,
				SIGNAL(reply(const bb::data::DataAccessReply&)), this,
				SLOT(onReply(const bb::data::DataAccessReply&)));

		Q_ASSERT(res);

		// Indicate that the variable success isn't used in the rest of the app, to
		// prevent a compiler warning
		Q_UNUSED(res);
	}


	// emit start load
	emit startLoadData();

	m_pSqlConnection->execute(sql);

}

// Receives the data returned by the asynchronous
// SQL request.
void AyatDataModel::onReply(const bb::data::DataAccessReply& dar) {
	qDebug() << "error query : " << dar.errorType() << " message " + dar.errorMessage();

	QVariantList resultList = dar.result().value<QVariantList>();


	//insert(resultList);
	//qDebug() << "jumlah data: " + resultList.size() << " data: " << resultList.count();

	this->clear(); // clear data
	if (resultList.size() > 0) {
		//this->clear(); // clear data
		this->insertList(resultList);

	}
//	QVariantMap addedItem = resultList.first().toMap();
//	if (find(addedItem).isEmpty()) {
//		insert(addedItem);
//	}

	// data selesai di insert
	int count = resultList.count();
	QString message = QString("found %1 ayat").arg(resultList.count());
	if (count == 0) message = "search not found";
	emit allItemLoaded(message);
}

void AyatDataModel::onReloadDatabase() {
	this->clear();
	QSettings settings;
	QString translationId = "58";
	// If no value has been saved, return the default value.
	if (!settings.value("LanguageSettings").isNull()) {
		translationId = settings.value("LanguageSettings").toString();
	}

	mQuery ="select surah.bookmarked as bookmarked, surah.note as note, surah.SuraID as surahNumber, surah.VerseID as ayatNumber, surah.AyahText as ayatText, translationsdata.TranslationText as translationText from \
			(select * from Quran where Quran.SuraID = "+ surahNumber + "  ) as surah \
		    left join (select * from translationsdata where languageID = "+translationId+" and CAST(SuraID as INTEGER) = "+surahNumber+") as translationsdata on surah.SuraID = CAST(translationsdata.SuraID as INTEGER)  and surah.VerseID = CAST(translationsdata.VerseID as INTEGER) order by surah.VerseID desc";
	qDebug() << "requery = " + mQuery;

	emit loadSQLData(mQuery);
}

void AyatDataModel::searchAyat(const QString keywords){
	QSettings settings;
	QString translationId = "58";
	// If no value has been saved, return the default value.
	if (!settings.value("LanguageSettings").isNull()) {
		translationId = settings.value("LanguageSettings").toString();
	}

	mQuery = "select surah.bookmarked as bookmarked, surah.note as note, surah.SuraID as surahNumber, surah.VerseID as ayatNumber, surah.AyahText as ayatText, translationsdata.TranslationText as translationText from \
	        	(select * from translationsdata where translationsdata.TranslationText match '"+keywords+"' and translationsdata.languageID = "+translationId+" ) as translationsdata \
	        		left join (select * from Quran) as surah on surah.SuraID = CAST(translationsdata.SuraID as INTEGER)  and surah.VerseID = CAST(translationsdata.VerseID as INTEGER)";
	if (isArabicText(keywords)){
		mQuery = "select surah.bookmarked as bookmarked, surah.note as note, surah.SuraID as surahNumber, surah.VerseID as ayatNumber, surah.AyahText as ayatText, translationsdata.TranslationText as translationText from \
			        		(select * from Quran where Quran.AyahTextWithoutTashkeel match '"+keywords+"'  ) as surah \
			        		left join (select * from translationsdata where languageID = "+translationId+") as translationsdata on surah.SuraID = CAST(translationsdata.SuraID as INTEGER)  and surah.VerseID = CAST(translationsdata.VerseID as INTEGER)";
	}

	mConnectionName = "searchAyat";
	emit loadSQLData(mQuery);
}

bool AyatDataModel::isArabicText(const QString text){
	QRegExp *regex = new QRegExp("[\u0600-\u06ff]|[\u0750-\u077f]|[\ufb50-\ufc3f]|[\ufe70-\ufefc]");
	return regex->indexIn(text) >= 0;
}
