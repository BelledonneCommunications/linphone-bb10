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

#include "HubIntegration.hpp"

#include <errno.h>
#include <malloc.h>
#include <spawn.h>
#include <unistd.h>
#include <QDebug>
#include <QStringList>
#include <bb/data/JsonDataAccess>
#include <bb/system/InvokeManager>
#include <bb/system/InvokeRequest>
#include <bb/system/InvokeTargetReply>

using namespace bb::data;

HubIntegration::HubIntegration(Application* app) :
    _linphoneAccount(NULL),
    _hubCache(NULL),
    _udsUtil(NULL),
    _settings(NULL),
    _itemCounter(0),
	_app(app)
{
	initialize();
}

HubIntegration::~HubIntegration()
{
	// don't need to delete _invokeManager since this is its parent it will be
	// killed appropriately by Qt

    if (_linphoneAccount) {
        delete _linphoneAccount;
    }
    if (_hubCache) {
        delete _hubCache;
    }
    if (_settings) {
        delete _settings;
    }
    if (_udsUtil) {
        delete _udsUtil;
    }
}

void HubIntegration::initialize()
{
    _initMutex.lock();

    // initialize UDS
    if (!_udsUtil) {
        _udsUtil = new UDSUtil(QString("LinphoneHub"), QString("hubassets"));
    }

    if (!_udsUtil->initialized()) {
        _udsUtil->initialize();
    }

    if (_udsUtil->initialized() && _udsUtil->registered()) {
        if (!_settings) {
            _settings = new QSettings("Linphone", "Hub Integration");
        }
        if (!_hubCache) {
            _hubCache = new HubCache(_settings);
        }
        if (!_linphoneAccount) {
            _linphoneAccount = new LinphoneAccount(_udsUtil, _hubCache);
        }
    }

    _initMutex.unlock();
}

void HubIntegration::markHubItemRead(QVariantMap itemProperties)
{
    qint64 itemId;

    if (itemProperties["sourceId"].toString().length() > 0) {
        itemId = itemProperties["sourceId"].toLongLong();
    } else if (itemProperties["messageid"].toString().length() > 0) {
        itemId = itemProperties["messageid"].toLongLong();
    }

    _linphoneAccount->markHubItemRead(itemProperties["categoryId"].toLongLong(), itemId);
}

void HubIntegration::markHubItemUnread(QVariantMap itemProperties)
{
    qint64 itemId;

    if (itemProperties["sourceId"].toString().length() > 0) {
        itemId = itemProperties["sourceId"].toLongLong();
    } else if (itemProperties["messageid"].toString().length() > 0) {
        itemId = itemProperties["messageid"].toLongLong();
    }

    _linphoneAccount->markHubItemUnread(itemProperties["categoryId"].toLongLong(), itemId);
}

void HubIntegration::removeHubItem(QVariantMap itemProperties)
{
    qint64 itemId;
    if (itemProperties["sourceId"].toString().length() > 0) {
        itemId = itemProperties["sourceId"].toLongLong();
    } else if (itemProperties["messageid"].toString().length() > 0) {
        itemId = itemProperties["messageid"].toLongLong();
    }

    _linphoneAccount->removeHubItem(itemProperties["categoryId"].toLongLong(), itemId);
}

void HubIntegration::addConversationInHub(QString from, QString title, QString body, bool read, bool notify) {
    QVariantMap* itemMap = new QVariantMap();
    (*itemMap)["body"] = body;

    _itemCounter++;
    _linphoneAccount->addHubItem(_linphoneAccount->chatMessageCategoryId(), *itemMap, from, title, QDateTime::currentDateTime().toMSecsSinceEpoch(), QString::number(_itemCounter), "", "", QString::null, read, notify);
}

void HubIntegration::updateConversationInHub(QString from, QString title, QVariantMap itemMap, bool read, bool notify) {
    itemMap["timestamp"] = QDateTime::currentDateTime().toMSecsSinceEpoch();
    itemMap["readCount"] = read ? 1 : 0;
    itemMap["name"] = from;
    itemMap["description"] = title;

    _linphoneAccount->updateHubItem(_linphoneAccount->chatMessageCategoryId(), itemMap["sourceId"].toLongLong(), itemMap, notify);
}

void HubIntegration::addCallHistoryInHub(QString from, QString title, QString body, QString icon, bool notify) {

    QVariantMap* itemMap = new QVariantMap();
    (*itemMap)["body"] = body;

    _itemCounter++;
    _linphoneAccount->addHubItem(_linphoneAccount->callHistoryCategoryId(), *itemMap, from, title, QDateTime::currentDateTime().toMSecsSinceEpoch(), QString::number(_itemCounter), "", "", icon, true, notify);
}

QVariantList HubIntegration::getItems() {
    return _hubCache->items();
}
