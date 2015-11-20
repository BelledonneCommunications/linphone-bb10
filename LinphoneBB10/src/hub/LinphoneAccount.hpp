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

#ifndef LINPHONEACCOUNT_HPP
#define LINPHONEACCOUNT_HPP

#include "HubAccount.hpp"

class LinphoneAccount: public HubAccount {

Q_OBJECT

public:
LinphoneAccount(UDSUtil* udsUtil, HubCache* hubCache);
	virtual ~LinphoneAccount();

    /*
     * Account ID of the Hub account.
     *
     * @returns qint64 account Id
     */
    qint64 accountId();

    /*
     * Category ID of the Hub account.
     *
     * @returns qint64 last category Id
     */
    qint64 callHistoryCategoryId();
    qint64 chatMessageCategoryId();

    void initializeCategories(QVariantList categories);

//public Q_SLOTS:

private:
    qint64 _categoryId;
};

#endif /* LINPHONEACCOUNT_HPP */
