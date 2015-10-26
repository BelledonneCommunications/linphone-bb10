/*
 * ContactListModel.cpp
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
 *  Created on: 15 févr. 2015
 *      Author: Sylvain Berfini
 */

#include <bb/pim/contacts/ContactSearchFilters.hpp>

#include "ContactListModel.h"
#include "ContactModel.h"

using namespace bb::cascades;
using namespace bb::pim::contacts;

ContactListModel::ContactListModel(QObject *parent) :
        QObject(parent),
        _contactFetcher(ContactFetcher::getInstance()),
        _selectedContactId(-1),
        _allContactsDataModel(new GroupDataModel(this)),
        _sipContactsDataModel(new GroupDataModel(this)),
        _searchContactsDataModel(new GroupDataModel(this)),
        _searchFilter(""),
        _listEditorHelper(new ListEditorHelper(_allContactsDataModel)),
        _isSipFilterEnabled(false),
        _contactModel(new ContactModel(this))
{
    QStringList sortingKeys;
    sortingKeys << "displayName" << "contactId";

    _allContactsDataModel->setGrouping(ItemGrouping::ByFirstChar);
    _allContactsDataModel->setSortingKeys(sortingKeys);

    _sipContactsDataModel->setGrouping(ItemGrouping::ByFirstChar);
    _sipContactsDataModel->setSortingKeys(sortingKeys);

    _searchContactsDataModel->setGrouping(ItemGrouping::ByFirstChar);
    _searchContactsDataModel->setSortingKeys(sortingKeys);

    ContactService *contactService = _contactFetcher->getContactService();
    // It is not needed to list for contactsAdded signal, because it will also trigger the contactsChanged one which is enough for us.
    bool result = connect(contactService, SIGNAL(contactsChanged(QList<int>)), this, SLOT(updateContacts(QList<int>)));
    Q_ASSERT(result);
    result = connect(contactService, SIGNAL(contactsDeleted(QList<int>)), this, SLOT(removeContacts(QList<int>)));
    Q_ASSERT(result);

    result = connect(_contactFetcher, SIGNAL(contactFetched(QVariantMap, bool, bool)), this, SLOT(contactFetched(QVariantMap, bool, bool)));
    Q_ASSERT(result);

    result = connect(_listEditorHelper, SIGNAL(deleteRequested(QList<QVariantList>)), this, SLOT(deleteItems(QList<QVariantList>)));
    Q_ASSERT(result);

    getContacts();
}

void ContactListModel::viewContact()
{
    if (_contactModel == NULL)
        return;

    _contactModel->setSelectedContactId(_selectedContactId);
}

void ContactListModel::setSelectedContact(const QVariantList &indexPath)
{
    _lastSelectedItemIndexPath = indexPath;

    if (indexPath.isEmpty()) {
        _selectedContactId = -1;
    } else {
        const QVariantMap entry = dataModel()->data(indexPath).toMap();
        _selectedContactId = entry.value("contactId").toInt();
    }
}

void ContactListModel::getContacts()
{
    if (_contactFetcher) {
        if (_contactFetcher->isRunning()) {
            _contactFetcher->exit();
        }

        if (_allContactsDataModel && _sipContactsDataModel) {
            _allContactsDataModel->clear();
            _sipContactsDataModel->clear();
        }

        _contactFetcher->start(QThread::HighPriority);
    }
}

void ContactListModel::updateContacts(QList<int> contactsToUpdate)
{
    if (_contactFetcher) {
        if (_contactFetcher->isRunning()) {
            _contactFetcher->exit();
        }

        _contactFetcher->setContactsToUpdate(contactsToUpdate);
        _contactFetcher->start(QThread::HighPriority);
    }
}

void ContactListModel::removeContacts(QList<int> contactsToRemove)
{
    foreach (QVariantMap entry, _allContactsDataModel->toListOfMaps()) {
        int contactId = entry.value("contactId").toInt();
        if (contactsToRemove.contains(contactId)) {
            _allContactsDataModel->remove(entry);
        }
    }
    foreach (QVariantMap entry, _sipContactsDataModel->toListOfMaps()) {
        int contactId = entry.value("contactId").toInt();
        if (contactsToRemove.contains(contactId)) {
            _sipContactsDataModel->remove(entry);
        }
    }
    emit contactListUpdated();
}

void ContactListModel::contactFetched(QVariantMap entry, bool isSipContact, bool isLinphoneContact)
{
    if (_allContactsDataModel == NULL) {
        return;
    }

    int id = entry.value("contactId").toInt();
    bool found = false;
    foreach (QVariantMap variant, _allContactsDataModel->toListOfMaps()) {
        int contactId = variant.value("contactId").toInt();
        if (id == contactId) {
            QVariantList indexPath = _allContactsDataModel->find(variant);
            _allContactsDataModel->updateItem(indexPath, entry);

            if (isSipContact && _sipContactsDataModel) {
                indexPath = _sipContactsDataModel->find(variant);
                if (indexPath.isEmpty()) {
                    _sipContactsDataModel->insert(entry);
                } else {
                    _sipContactsDataModel->updateItem(indexPath, entry);
                }
            }
            found = true;
            break;
        }
    }

    if (!found) {
        _allContactsDataModel->insert(entry);
        if (isSipContact && _sipContactsDataModel) {
            _sipContactsDataModel->insert(entry);
        }
    }

    emit contactListUpdated();

    Q_UNUSED(isLinphoneContact);
}

void ContactListModel::setSipFilter(bool enable)
{
    _isSipFilterEnabled = enable;
    emit sipFilterUpdated();

    if (_searchFilter.length() > 0) {
        setContactSearchFilter(_searchFilter);
    } else {
        if (_listEditorHelper) {
            _listEditorHelper->setDataModel(dataModel());
        }
        emit contactListUpdated();
    }
}

void ContactListModel::resetLastSelectedItemPath()
{
    _lastSelectedItemIndexPath.clear();
}

void ContactListModel::deleteItems(QList<QVariantList> indexPaths)
{
    foreach(QVariantList indexPath, indexPaths) {
        QVariantMap entry = dataModel()->data(indexPath).toMap();
        ContactId id = entry.value("contactId").toInt();
        _contactFetcher->getContactService()->deleteContact(id);
    }
}

void ContactListModel::setContactSearchFilter(const QString& filter) {
    _searchFilter = filter;

    if (_searchFilter.length() > 0) {
        GroupDataModel *contacts = isSipFilterEnabled() ? _sipContactsDataModel : _allContactsDataModel;
        _searchContactsDataModel->clear();

        foreach (QVariantMap variant, contacts->toListOfMaps()) {
            if (variant.value("displayName").toString().contains(_searchFilter, Qt::CaseInsensitive)) {
                _searchContactsDataModel->insert(variant);
            }
        }
    }

    if (_listEditorHelper) {
        _listEditorHelper->setDataModel(dataModel());
    }
    emit contactListUpdated();
}
