/*
 * ContactFetcher.cpp
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
 *  Created on: 1 août 2015
 *      Author: Sylvain Berfini
 */

#include "ContactFetcher.h"

#include <bb/pim/contacts/ContactListFilters.hpp>
#include <bb/pim/contacts/ContactSearchFilters.hpp>
#include "src/linphone/LinphoneManager.h"

using namespace bb::pim::contacts;

ContactFetcher::ContactFetcher()
    : _contactService(new ContactService(this)),
      _sipDomainToLookForToDisplayLinphoneLogo("")
{
    LinphoneManager *manager = LinphoneManager::getInstance();
    LinphoneCore *lc = manager->getLc();
    LpConfig *lpc = linphone_core_get_config(lc);
    _sipDomainToLookForToDisplayLinphoneLogo = lp_config_get_string(lpc, "wizard", "default_sip_domain", "sip.linphone.org");
}

void ContactFetcher::setContactsToUpdate(QList<int> contactsToUpdate)
{
    _contactsToUpdate = contactsToUpdate;
}

void ContactFetcher::run()
{
    ContactListFilters filter;
    filter.setLimit(200);
    if (_contactsToUpdate.size() > 0) {
        filter.setContactIds(_contactsToUpdate);
        _contactsToUpdate.clear();
    }
    QList<Contact> contacts = _contactService->contacts(filter);

    if (contacts.size() > 0) {
        foreach (const Contact &idContact, contacts) {
            const Contact contact = _contactService->contactDetails(idContact.id());

            QVariantMap entry;
            entry["contactId"] = contact.id();
            entry["displayName"] = contact.displayName();

            entry["contactPhoto"] = "/images/avatar.png";
            if (contact.primaryPhoto().isValid()) {
                entry["contactPhoto"] = contact.primaryPhoto().smallPhoto();
            }

            // Only if a contact contains a SIP address with our domain in it it is a linphone contact
            QList<ContactAttribute> attributes = contact.filteredAttributes(AttributeKind::VideoChat);
            bool isSipContact = attributes.size() > 0;
            bool isLinphoneContact = false;
            foreach (ContactAttribute attr, attributes) {
                if (attr.value().endsWith(_sipDomainToLookForToDisplayLinphoneLogo)) {
                    isLinphoneContact = true;
                    break;
                }
            }
            entry["isLinphoneContact"] = isLinphoneContact;
            entry["selected"] = false;

            emit contactFetched(entry, isSipContact, isLinphoneContact);
        }
    }
}

ContactFound ContactFetcher::findContact(QString searchValue)
{
    ContactFound contactFound;
    contactFound.id = -1;
    contactFound.picturePath = "/images/avatar.png";
    contactFound.smallPicturePath = "/images/avatar.png";

    ContactSearchFilters options;
    QList<SearchField::Type> fields;
    fields.append(SearchField::VideoChat);
    fields.append(SearchField::Phone);
    options.setSearchFields(fields);
    options.setIncludePhotos(true);
    options.setSearchValue(searchValue);

    QList<Contact> contacts = _contactService->searchContacts(options);
    if (contacts.size() > 0) {
        Contact contact = contacts.first();
        contactFound.id = contact.id();
        contactFound.displayName = contact.displayName();
        if (contact.primaryPhoto().isValid()) {
            contactFound.picturePath = contact.primaryPhoto().largePhoto();
            contactFound.smallPicturePath = contact.primaryPhoto().smallPhoto();
        }
    }
    return contactFound;
}

ContactFetcher* ContactFetcher::getInstance()
{
    if (!_contactFetcherInstance) {
        _contactFetcherInstance = new ContactFetcher();
    }

    return _contactFetcherInstance;
}

ContactService* ContactFetcher::getContactService()
{
    return _contactService;
}
