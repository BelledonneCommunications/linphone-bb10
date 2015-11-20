/*
 * Copyright (c) 2013 BlackBerry Limited.
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

#ifndef HUB_INTEGRATION_HPP_
#define HUB_INTEGRATION_HPP_

#include <bb/Application>
#include <QObject>
#include <QSettings>
#include "UDSUtil.hpp"
#include <bb/pim/unified/unified_data_source.h>

#include "UDSUtil.hpp"
#include "HubCache.hpp"
#include "LinphoneAccount.hpp"

using bb::Application;

class HubIntegration : public QObject {
    Q_OBJECT

public:
    HubIntegration(Application* app);
    virtual ~HubIntegration();

    void initialize();
    void processNewMessage(QString from, QString title, QString body, bool unread, bool notify);
    void processNewCall(QString from, QString title, QString body, QString icon, bool notify);

private slots:
    void markHubItemRead(QVariantMap itemProperties);
    void markHubItemUnread(QVariantMap itemProperties);
    void removeHubItem(QVariantMap itemProperties);

private:
    LinphoneAccount* _linphoneAccount;
    HubCache*     _hubCache;
    UDSUtil*      _udsUtil;
    QSettings*    _settings;

    int  _itemCounter;
    Application* _app;
    QMutex _initMutex;
};

#endif /* HUB_INTEGRATION_HPP_ */
