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

#include <math.h>

#include "LinphoneAccount.hpp"

#include <QDebug>

LinphoneAccount::LinphoneAccount(UDSUtil* udsUtil, HubCache* hubCache) : HubAccount(udsUtil, hubCache)
{
	qDebug()  << "TestAccount::TestAccount " << udsUtil;

	_categoryId = 0;

    _name = "Linphone";
    _displayName = "Linphone";
    _description = "";
    _serverName = "linphone.org";
    _iconFilename = "Hub.png";
    _appTarget = "org.linphone.HubIntegration";
    _itemMessageMimeType = "hub/vnd.linphone.chat";
    _itemCallMimeType = "hub/vnd.linphone.history";
    _itemMessageReadIconFilename = "chatRead.png";
    _itemMessageUnreadIconFilename = "chatUnread.png";

    // on device restart / update, it may be necessary to reload the Hub
    if (_udsUtil->reloadHub()) {
        _udsUtil->cleanupAccountsExcept(-1, _displayName);
        _udsUtil->initNextIds();
    }

    initialize();

    QVariantList categories;
    QVariantMap category_history;
    category_history["categoryId"] = 1; // categories are created with sequential category Ids starting at 1 so number your predefined categories
                                // accordingly
    category_history["name"] = "Call history";
    category_history["parentCategoryId"] = 0; // default parent category ID for root categories

    QVariantMap category_messages;
    category_messages["categoryId"] = 2;
    category_messages["name"] = "Chat messages";
    category_messages["parentCategoryId"] = 0; // default parent category ID for root categories
    categories << category_history << category_messages;
    initializeCategories(categories);

    // reload existing hub items if required
    if (_udsUtil->reloadHub()) {
        repopulateHub();

        _udsUtil->resetReloadHub();
    }
}

LinphoneAccount::~LinphoneAccount()
{
}

qint64 LinphoneAccount::accountId()
{
    return _accountId;
}

qint64 LinphoneAccount::callHistoryCategoryId()
{
    return 1;
}

qint64 LinphoneAccount::chatMessageCategoryId()
{
    return 2;
}

void LinphoneAccount::initializeCategories(QVariantList newCategories)
{
    HubAccount::initializeCategories(newCategories);
}
