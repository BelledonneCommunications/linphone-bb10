/*
 * ContactModel.cpp
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
 *  Created on: 16 févr. 2015
 *      Author: Sylvain Berfini
 */

#include "ContactModel.h"
#include "ContactFetcher.h"
#include <bb/pim/contacts/Contact>

using namespace bb::cascades;
using namespace bb::pim::contacts;

ContactModel::ContactModel(QObject *parent)
    : QObject(parent),
      _contactId(-1),
      _displayName(""),
      _photo(""),
      _isSipContact(false),
      _dataModel(new GroupDataModel(this))
{
    bool result = connect(ContactFetcher::getInstance()->getContactService(), SIGNAL(contactsChanged(QList<int>)), SLOT(contactsChanged(QList<int>)));
    Q_ASSERT(result);

    QStringList sortingKeys;
    sortingKeys << "priority";
    _dataModel->setGrouping(ItemGrouping::ByFullValue);
    _dataModel->setSortingKeys(sortingKeys);
}

void ContactModel::setSelectedContactId(ContactId contactId)
{
    if (_contactId == contactId)
        return;

    _contactId = contactId;
    updateContact();
}

void ContactModel::updateContact()
{
    const Contact contact = ContactFetcher::getInstance()->getContactService()->contactDetails(_contactId);
    _displayName = contact.displayName();

    if (contact.primaryPhoto().isValid()) {
        _photo = contact.primaryPhoto().largePhoto();
    } else {
        _photo = "/images/avatar.png";
    }

    _dataModel->clear();
    _isSipContact = false;

    QList<ContactAttribute> attrs = contact.attributes();
    if (!attrs.isEmpty()) {
        foreach (ContactAttribute attr, attrs) {
            if (attr.kind() == AttributeKind::VideoChat || attr.kind() == AttributeKind::Phone) {
                QVariantMap entry;
                if (attr.kind() == AttributeKind::VideoChat) {
                    _isSipContact = true;
                    entry["priority"] = 0;
                } else {
                    entry["priority"] = 1;
                }

                entry["number"] = attr.value();
                entry["label"] = attr.attributeDisplayLabel();
                _dataModel->insert(entry);
            }
        }
    }

    emit contactUpdated();
}

void ContactModel::contactsChanged(const QList<int> &contactIds)
{
    if (contactIds.contains(_contactId))
        updateContact();
}

void ContactModel::deleteContact() {
    ContactFetcher::getInstance()->getContactService()->deleteContact(_contactId);
}
