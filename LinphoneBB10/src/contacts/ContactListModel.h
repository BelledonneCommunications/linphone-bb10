/*
 * ContactListModel.h
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
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 *
 *  Created on: 15 févr. 2015
 *      Author: Sylvain Berfini
 */

#ifndef CONTACTLISTMODEL_H_
#define CONTACTLISTMODEL_H_

#include <bb/cascades/GroupDataModel>
#include <bb/pim/contacts/ContactService>

#include <QObject>

#include "ContactModel.h"
#include "ContactFetcher.h"
#include "src/utils/ListEditorHelper.h"

class ContactListModel : public QObject
{
    Q_OBJECT

    Q_PROPERTY(ContactModel* contactModel READ contactModel CONSTANT);
    Q_PROPERTY(bb::cascades::GroupDataModel* dataModel READ dataModel NOTIFY contactListUpdated);
    Q_PROPERTY(bool sipFilterEnabled READ isSipFilterEnabled NOTIFY sipFilterUpdated);
    Q_PROPERTY(QVariantList lastSelectedItemIndexPath READ lastSelectedItemIndexPath);
    Q_PROPERTY(ListEditorHelper* editor READ editor CONSTANT);
    Q_PROPERTY(QString contactSearchFilter WRITE setContactSearchFilter NOTIFY contactListUpdated)

public:
    ContactListModel(QObject *parent = NULL);

public Q_SLOTS:
    void getContacts();
    void updateContacts(QList<int> contactsToUpdate);
    void removeContacts(QList<int> contactsToRemove);
    void setSipFilter(bool enable);
    void setSelectedContact(const QVariantList &indexPath);
    void viewContact();
    void resetLastSelectedItemPath();
    void contactFetched(QVariantMap entry, bool isSipContact, bool isLinphoneContact);
    void deleteItems(QList<QVariantList> indexPaths);

Q_SIGNALS:
    void contactListUpdated();
    void sipFilterUpdated();

private:
    ContactFetcher *_contactFetcher;
    bb::pim::contacts::ContactId _selectedContactId;

    QVariantList lastSelectedItemIndexPath() const {
        return _lastSelectedItemIndexPath;
    }

    QVariantList _lastSelectedItemIndexPath;

    bb::cascades::GroupDataModel* dataModel() const {
        if (_searchFilter.length() > 0) {
            return _searchContactsDataModel;
        }
        if (isSipFilterEnabled()) {
            return _sipContactsDataModel;
        }
        return _allContactsDataModel;
    }

    bb::cascades::GroupDataModel* _allContactsDataModel;
    bb::cascades::GroupDataModel* _sipContactsDataModel;
    bb::cascades::GroupDataModel* _searchContactsDataModel;

    void setContactSearchFilter(const QString& filter);
    QString _searchFilter;

    ListEditorHelper *editor() const {
        return _listEditorHelper;
    }
    ListEditorHelper *_listEditorHelper;

    bool isSipFilterEnabled() const {
        return _isSipFilterEnabled;
    }
    bool _isSipFilterEnabled;

    ContactModel *contactModel() const {
        return _contactModel;
    }
    ContactModel *_contactModel;
};

#endif /* CONTACTLISTMODEL_H_ */
