/*
 * Copyright (c) 2011-2014 BlackBerry Limited.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include "applicationui.hpp"

#include <bb/cascades/Application>
#include <bb/cascades/LocaleHandler>
#include <bb/platform/NotificationDefaultApplicationSettings.hpp>

#include "src/contacts/ContactListModel.h"
#include "src/contacts/ContactEditorModel.h"
#include "src/chat/ChatListModel.h"
#include "src/call/InCallModel.h"
#include "src/history/HistoryListModel.h"
#include "src/assistant/AssistantModel.h"
#include "src/menu/MenuModel.h"
#include "src/linphone/LinphoneManager.h"
#include "src/utils/ColorGallery.h"
#include "src/utils/BPSEventListener.h"
#include "src/settings/SettingsModel.h"

using namespace bb::cascades;
using namespace bb::platform;
ApplicationUI::ApplicationUI() :
        QObject()
{
    // prepare the localization
    _pTranslator = new QTranslator(this);
    _pLocaleHandler = new LocaleHandler(this);

    bool res = QObject::connect(_pLocaleHandler, SIGNAL(systemLanguageChanged()), this, SLOT(onSystemLanguageChanged()));
    // This is only available in Debug builds
    Q_ASSERT(res);
    // Since the variable is not used in the app, this is added to avoid a
    // compiler warning
    Q_UNUSED(res);

    // initial load
    onSystemLanguageChanged();

    // Create scene document from main.qml asset, the parent is set
    // to ensure the document gets destroyed properly at shut down.
    QmlDocument *qml = QmlDocument::create("asset:///main.qml").parent(this);

    NotificationDefaultApplicationSettings settings;
    settings.setPreview(NotificationPriorityPolicy::Allow);
    settings.apply();

    qml->setContextProperty("linphoneManager", LinphoneManager::getInstance());

    BPSEventListener *bpsEventListener = new BPSEventListener();
    qml->setContextProperty("bps", bpsEventListener);

    ColorGallery *colors = new ColorGallery(this);
    qml->setContextProperty("colors", colors);

    SettingsModel *settingsModel = new SettingsModel(this);
    qml->setContextProperty("settingsModel", settingsModel);

    MenuModel *menuModel = new MenuModel(this);
    qml->setContextProperty("menuModel", menuModel);

    ContactListModel *contactListModel = new ContactListModel(this);
    qml->setContextProperty("contactListModel", contactListModel);

    ContactEditorModel *contactEditorModel = new ContactEditorModel(this);
    qml->setContextProperty("contactEditorModel", contactEditorModel);

    ChatListModel *chatListModel = new ChatListModel(this);
    qml->setContextProperty("chatListModel", chatListModel);

    InCallModel *inCallModel = new InCallModel(this);
    qml->setContextProperty("inCallModel", inCallModel);

    HistoryListModel *historyListModel = new HistoryListModel(this);
    qml->setContextProperty("historyListModel", historyListModel);

    AssistantModel *assistantModel = new AssistantModel(this);
    qml->setContextProperty("assistantModel", assistantModel);

    // Create root object for the UI
    AbstractPane *root = qml->createRootObject<AbstractPane>();

    // Set created root object as the application scene
    Application::instance()->setScene(root);
}

void ApplicationUI::onSystemLanguageChanged()
{
    QCoreApplication::instance()->removeTranslator(_pTranslator);
    // Initiate, load and install the application translation files.
    QString locale_string = QLocale().name();
    QString file_name = QString("LinphoneBB10_%1").arg(locale_string);
    if (_pTranslator->load(file_name, "app/native/qm")) {
        QCoreApplication::instance()->installTranslator(_pTranslator);
    }
}
