// Default empty project template
#include <bb/cascades/Application>
#include <bb/cascades/QmlDocument>
#include <bb/cascades/AbstractPane>

#include <QLocale>
#include <QTranslator>
#include <Qt/qdeclarativedebug.h>
#include "Quran.hpp"
#include "QuranDbHelper.h"
#include "RegistrationHandler.hpp"

using namespace bb::cascades;
Q_DECL_EXPORT int main(int argc, char **argv) {
	qmlRegisterType<QuranDbHelper>("dbutils", 1, 0, "QuranDbHelper");
	// this is where the server is started etc
	Application app(argc, argv);

	// localization support
	QTranslator translator;
	QString locale_string = QLocale().name();
	QString filename = QString("Quran_%1").arg(locale_string);
	if (translator.load(filename, "app/native/qm")) {
		app.installTranslator(&translator);
	}

	//new Quran(&app);
	// 2b078efb-bf88-4038-aa36-5f52ae35eeac
	const QString uuid(QLatin1String("348ccad0-411f-11e2-a25f-0800200c9a66"));

	//! [0]
	RegistrationHandler *registrationHandler = new RegistrationHandler(uuid,
			&app);

	Quran *quranApp = new Quran(registrationHandler->context(), &app);

	//Whenever the registration has finished successfully, we continue to the main UI
	QObject::connect(registrationHandler, SIGNAL(registered()), quranApp,
			SLOT(show()));

	// we complete the transaction started in the app constructor and start the client event loop here
	return Application::exec();
	// when loop is exited the Application deletes the scene which deletes all its children (per qt rules for children)
}
