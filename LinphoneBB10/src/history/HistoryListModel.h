/*
 * HistoryListModel.h
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

#ifndef HISTORYLISTMODEL_H_
#define HISTORYLISTMODEL_H_

#include <QObject>
#include <bb/cascades/GroupDataModel>

#include "HistoryModel.h"
#include "HistoryFetcher.h"
#include "CustomHistoryGroupDataModel.h"
#include "src/utils/ListEditorHelper.h"

class HistoryListModel : public QObject
{
    Q_OBJECT

    Q_PROPERTY(HistoryModel* historyModel READ historyModel CONSTANT);
    Q_PROPERTY(bb::cascades::GroupDataModel* dataModel READ dataModel NOTIFY historyListUpdated);
    Q_PROPERTY(bool missedFilterEnabled READ isMissedFilterEnabled NOTIFY missedFilterUpdated);
    Q_PROPERTY(QVariantList lastSelectedItemIndexPath READ lastSelectedItemIndexPath);
    Q_PROPERTY(ListEditorHelper* editor READ editor CONSTANT);

public:
    HistoryListModel(QObject *parent = NULL);
    bb::cascades::GroupDataModel* getAllCallsDataModel() {
        return _allCallsDataModel;
    }
    bb::cascades::GroupDataModel* getMissedCallsDataModel() {
        return _missedCallsDataModel;
    }

public Q_SLOTS:
    void viewHistory(const QVariantList &indexPath, LinphoneCallLog *log);
    void viewHistory(QString callID);
    void getHistory();
    void resetLastSelectedItemPath();
    void setMissedFilter(bool enable);
    void historyFetched(QVariantMap entry, bool isMissed);
    void deleteItems(QList<QVariantList> indexPaths);
    QString getLatestOutgoingCallAddress();

Q_SIGNALS:
    void historyListUpdated();
    void missedFilterUpdated();

private:
    HistoryFetcher *_historyFetcher;

    CustomHistoryGroupDataModel* dataModel() const {
        if (isMissedFilterEnabled()) {
            return _missedCallsDataModel;
        }
        return _allCallsDataModel;
    }

    CustomHistoryGroupDataModel* _allCallsDataModel;
    CustomHistoryGroupDataModel* _missedCallsDataModel;

    ListEditorHelper *editor() const {
        return _listEditorHelper;
    }
    ListEditorHelper *_listEditorHelper;

    HistoryModel *historyModel() const {
        return _historyModel;
    }
    HistoryModel *_historyModel;

    QVariantList lastSelectedItemIndexPath() const {
        return _lastSelectedItemIndexPath;
    }

    QVariantList _lastSelectedItemIndexPath;

    bool isMissedFilterEnabled() const {
        return _isMissedFilterEnabled;
    }
    bool _isMissedFilterEnabled;
};

#endif /* HISTORYLISTMODEL_H_ */
