/*
 * HistoryListModel.cpp
 * Copyright (C) 2015  Belledonne Communications, Grenoble, France
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
 *
 *  Created on: 19 mars 2015
 *      Author: Sylvain Berfini
 */

#include <bb/pim/contacts/ContactService>

#include "HistoryListModel.h"
#include "src/contacts/ContactFetcher.h"
#include "src/linphone/LinphoneManager.h"
#include "src/utils/Misc.h"

using namespace bb::cascades;

HistoryListModel::HistoryListModel(QObject *parent) :
        QObject(parent),
        _historyFetcher(new HistoryFetcher()),
        _allCallsDataModel(new CustomHistoryGroupDataModel(this)),
        _missedCallsDataModel(new CustomHistoryGroupDataModel(this)),
        _listEditorHelper(new ListEditorHelper(_allCallsDataModel)),
        _historyModel(new HistoryModel(this)),
        _isMissedFilterEnabled(false)
{
    QStringList sortingKeys;
    sortingKeys << "day" << "time";

    _allCallsDataModel->setGrouping(ItemGrouping::ByFullValue);
    _allCallsDataModel->setSortingKeys(sortingKeys);
    _allCallsDataModel->setSortedAscending(false);

    _missedCallsDataModel->setGrouping(ItemGrouping::ByFullValue);
    _missedCallsDataModel->setSortingKeys(sortingKeys);
    _missedCallsDataModel->setSortedAscending(false);

    bool result = QObject::connect(LinphoneManager::getInstance(), SIGNAL(callEnded(LinphoneCall*)), this, SLOT(getHistory()));
    Q_ASSERT(result);

    result = connect(_historyFetcher, SIGNAL(historyFetched(QVariantMap, bool)), this, SLOT(historyFetched(QVariantMap, bool)));
    Q_ASSERT(result);

    result = connect(_listEditorHelper, SIGNAL(deleteRequested(QList<QVariantList>)), this, SLOT(deleteItems(QList<QVariantList>)));
    Q_ASSERT(result);

    bb::pim::contacts::ContactService *contactService = ContactFetcher::getInstance()->getContactService();
    result = connect(contactService, SIGNAL(contactsChanged(QList<int>)), this, SLOT(getHistory()));
    Q_ASSERT(result);
    result = connect(contactService, SIGNAL(contactsDeleted(QList<int>)), this, SLOT(getHistory()));
    Q_ASSERT(result);

    getHistory();
}

void HistoryListModel::viewHistory(const QVariantList &indexPath, LinphoneCallLog *log)
{
    _lastSelectedItemIndexPath = indexPath;
    _historyModel->setSelectedHistoryLog(log);
}

void HistoryListModel::viewHistory(QString callID)
{
    LinphoneCallLog *log = linphone_core_find_call_log_from_call_id(LinphoneManager::getInstance()->getLc(), callID.toUtf8().constData());
    _historyModel->setSelectedHistoryLog(log);
}

void HistoryListModel::getHistory()
{
    if (_historyFetcher) {
        if (_historyFetcher->isRunning()) {
            _historyFetcher->exit();
        }

        if (_allCallsDataModel && _missedCallsDataModel) {
            _allCallsDataModel->clear();
            _missedCallsDataModel->clear();
        }

        _historyFetcher->start(QThread::HighPriority);
    }
}

void HistoryListModel::historyFetched(QVariantMap entry, bool isMissed)
{
    if (_allCallsDataModel == NULL) {
        return;
    }

    _allCallsDataModel->insert(entry);
    if (isMissed && _missedCallsDataModel) {
        _missedCallsDataModel->insert(entry);
    }

    emit historyListUpdated();
}

void HistoryListModel::resetLastSelectedItemPath()
{
    _lastSelectedItemIndexPath.clear();
}

void HistoryListModel::setMissedFilter(bool enable)
{
    _isMissedFilterEnabled = enable;

    if (_listEditorHelper) {
        _listEditorHelper->setDataModel(dataModel());
    }

    emit missedFilterUpdated();
    emit historyListUpdated();
}

void HistoryListModel::deleteItems(QList<QVariantList> indexPaths)
{
    LinphoneManager *manager = LinphoneManager::getInstance();
    LinphoneCore *core = manager->getLc();

    foreach(QVariantList indexPath, indexPaths) {
        QVariantMap entry = dataModel()->data(indexPath).toMap();
        LinphoneCallLog *log = entry.value("log").value<LinphoneCallLog*>();

        if (!log) {
            continue;
        }
        dataModel()->remove(entry);

        GroupDataModel *altDataModel = _missedCallsDataModel;
        if (dataModel() == _missedCallsDataModel) {
            altDataModel = _allCallsDataModel;
        }
        foreach (QVariantMap variant, altDataModel->toListOfMaps()) {
            LinphoneCallLog *callLog = variant.value("log").value<LinphoneCallLog*>();
            if (callLog == log) {
                altDataModel->remove(variant);
                break;
            }
        }

        linphone_core_remove_call_log(core, log);
    }
    emit historyListUpdated();
}

QString HistoryListModel::getLatestOutgoingCallAddress()
{
    QString result = "";
    LinphoneManager *manager = LinphoneManager::getInstance();
    LinphoneCore *lc = manager->getLc();
    LinphoneCallLog *log = linphone_core_get_last_outgoing_call_log(lc);

    if (log) {
        LinphoneAddress *addr = linphone_call_log_get_remote_address(log);
        result = linphone_address_as_string_uri_only(addr);
        linphone_call_log_unref(log);
    }

    return result;
}
