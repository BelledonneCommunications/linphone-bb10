/*
 * ContactEditorModel.cpp
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
 *  Created on: 29 juil. 2015
 *      Author: Sylvain Berfini
 */

#include "ContactEditorModel.h"
#include "linphone/linphonecore.h"

#include <bb/pim/contacts/Contact>
#include <bb/pim/contacts/ContactBuilder>
#include <bb/pim/contacts/ContactAttributeBuilder>
#include <bb/pim/contacts/ContactPhotoBuilder>
#include <bb/pim/contacts/ContactConsts>

using namespace bb::cascades;
using namespace bb::pim::contacts;

ContactEditorModel::ContactEditorModel(QObject *parent)
    : QObject(parent),
      _contactService(new ContactService(this)),
      _contactId(-1),
      _previousPage("ContactsListView.qml"),
      _sipAddresses(new GroupDataModel(this)),
      _isNewContact(true),
      _firstName(""),
      _lastName(""),
      _photo(""),
      _photoUrl(""),
      _nextEditSipAddress("")
{
    QStringList sortingKeys;
    sortingKeys << "id";
    _sipAddresses->setGrouping(ItemGrouping::ByFullValue);
    _sipAddresses->setSortingKeys(sortingKeys);
}

void ContactEditorModel::setSelectedContactId(int contactId)
{
    _contactId = contactId;
    _isNewContact = _contactId == -1;
    _firstName = "";
    _lastName = "";
    _photo = "/images/avatar.png";
    _photoUrl = "";
    _sipAddresses->clear();

    if (!_isNewContact) {
        getContact();
    } else {
        // Always display at least an empty SIP address field, else there won't be anything to be displayed because other informations are the header of the first group in the list
        QVariantMap entry;
        entry["value"] = _nextEditSipAddress;
        entry["id"] = 0;
        entry["first"] = TRUE;
        _sipAddresses->insert(entry);
    }
}

void ContactEditorModel::getContact() {
    if (!_contactService) {
        return;
    }

    const Contact contact = _contactService->contactDetails(_contactId);
    _lastName = contact.lastName();
    _firstName = contact.firstName();
    if (contact.primaryPhoto().isValid()) {
        _photo = contact.primaryPhoto().largePhoto();
    }

    emit contactUpdated();

    if (!_sipAddresses) {
        return;
    }

    QList<ContactAttribute> attrs = contact.filteredAttributes(AttributeKind::VideoChat);
    if (attrs.isEmpty()) { // Always display at least an empty SIP address field, else there won't be anything to be displayed because other informations are the header of the first group in the list
        QVariantMap entry;
        entry["value"] = _nextEditSipAddress;
        entry["id"] = 0;
        entry["first"] = TRUE;
        _sipAddresses->insert(entry);
    } else {
        int i = 0;
        foreach (ContactAttribute attr, attrs) {
            QVariantMap entry;
            entry["value"] = attr.value();
            entry["id"] = i;
            entry["first"] = i == 0;
            _sipAddresses->insert(entry);
            i++;
        }

        if (!_nextEditSipAddress.isEmpty()) {
            QVariantMap entry;
            entry["value"] = _nextEditSipAddress;
            entry["id"] = i;
            entry["first"] = FALSE;
            _sipAddresses->insert(entry);
        }
    }

    _nextEditSipAddress = "";

    emit sipAddressesUpdated();
}

void ContactEditorModel::editPicture(const QStringList &filePicked) {
    if (filePicked.size() > 0) {
        _photoUrl = filePicked.first();
        _photo = "file:///" + _photoUrl;
    }
    emit contactUpdated();
}

void ContactEditorModel::saveChanges() {
    if (!_isNewContact) {
        updateContact();
    } else {
        createContact();
    }
}

static void prepareFirstNameBuilder(ContactAttributeBuilder *builder, QString firstName) {
    builder->setKind(AttributeKind::Name);
    builder->setSubKind(AttributeSubKind::NameGiven);
    builder->setValue(firstName);
}

static void prepareLastNameBuilder(ContactAttributeBuilder *builder, QString lastName) {
    builder->setKind(AttributeKind::Name);
    builder->setSubKind(AttributeSubKind::NameSurname);
    builder->setValue(lastName);
}

static void prepareSipAddressBuilder(ContactAttributeBuilder *builder, QString sipAddress, AttributeSubKind::Type subKind) {
    builder->setKind(AttributeKind::VideoChat);
    builder->setSubKind(subKind);
    builder->setLabel("Linphone");
    builder->setValue(sipAddress);
}

void ContactEditorModel::createContact() {
    if (!_contactService) {
        return;
    }

    ContactBuilder contactBuilder;

    ContactAttributeBuilder firstNameAttributeBuilder;
    prepareFirstNameBuilder(&firstNameAttributeBuilder, _firstName);
    contactBuilder.addAttribute(firstNameAttributeBuilder);

    ContactAttributeBuilder lastNameAttributeBuilder;
    prepareLastNameBuilder(&lastNameAttributeBuilder, _lastName);
    contactBuilder.addAttribute(lastNameAttributeBuilder);

    foreach (QVariantMap entry, _sipAddresses->toListOfMaps()) {
        ContactAttributeBuilder sipAddressAttributeBuilder;
        QString sipAddress = entry.value("value").toString();
        prepareSipAddressBuilder(&sipAddressAttributeBuilder, sipAddress, ContactAttributeBuilder::determineAttributeSubKind("Linphone"));
        contactBuilder.addAttribute(sipAddressAttributeBuilder);
    }

    if (!_photoUrl.isEmpty()) {
        const ContactPhoto photo = ContactPhotoBuilder().setOriginalPhoto(_photoUrl);
        if (photo.isValid()) {
            contactBuilder.addPhoto(photo, true);
        }
    }
    _contactService->createContact(contactBuilder, false);
}

void ContactEditorModel::updateContact() {
    if (!_contactService) {
        return;
    }

    bool need_to_update = FALSE;
    Contact contact = _contactService->contactDetails(_contactId);
    ContactBuilder editor = contact.edit();

    bool nameSurnameFound = FALSE;
    bool nameGivenFound = FALSE;
    foreach (ContactAttribute attr, contact.filteredAttributes(AttributeKind::Name)) {
        if (attr.subKind() == AttributeSubKind::NameSurname) {
            if (attr.value() != _lastName) {
                ContactAttributeBuilder builder = attr.edit();
                prepareLastNameBuilder(&builder, _lastName);
                need_to_update = TRUE;
            }
            nameSurnameFound = TRUE;
        } else if (attr.subKind() == AttributeSubKind::NameGiven) {
            if (attr.value() != _firstName) {
                ContactAttributeBuilder builder = attr.edit();
                prepareFirstNameBuilder(&builder, _firstName);
                need_to_update = TRUE;
            }
            nameGivenFound = TRUE;
        }
    }

    if (!nameSurnameFound) {
        ContactAttributeBuilder lastNameAttributeBuilder;
        prepareLastNameBuilder(&lastNameAttributeBuilder, _lastName);
        editor.addAttribute(lastNameAttributeBuilder);
        need_to_update = TRUE;
    }
    if (!nameGivenFound) {
        ContactAttributeBuilder firstNameAttributeBuilder;
        prepareFirstNameBuilder(&firstNameAttributeBuilder, _firstName);
        editor.addAttribute(firstNameAttributeBuilder);
        need_to_update = TRUE;
    }

    QList<ContactAttribute> videoChatAttributes = contact.filteredAttributes(AttributeKind::VideoChat);
    int i = 0;
    foreach (ContactAttribute attr, videoChatAttributes) {
        bool found = FALSE;
        foreach (QVariantMap entry, _sipAddresses->toListOfMaps()) {
            int id = entry.value("id").toInt();
            QString value = entry.value("value").toString();
            if (i == id && !value.isEmpty()) {
                found = TRUE;
                break;
            }
        }

        if (!found) {
            ContactAttributeBuilder builder = attr.edit();
            editor.deleteAttribute(attr);
            need_to_update = TRUE;
        }
        i++;
    }

    foreach (QVariantMap entry, _sipAddresses->toListOfMaps()) {
        QString value = entry["value"].toString();
        int id = entry.value("id").toInt();
        bool found = FALSE;
        i = 0;
        foreach (ContactAttribute attr, videoChatAttributes) {
            if (i == id) {
                if (attr.value() != value) {
                    ContactAttributeBuilder builder = attr.edit();
                    prepareSipAddressBuilder(&builder, value, attr.subKind());
                    need_to_update = TRUE;
                }
                found = TRUE;
                break;
            }
            i++;
        }

        if (!found) {
            ContactAttributeBuilder sipAddressAttributeBuilder;
            prepareSipAddressBuilder(&sipAddressAttributeBuilder, value, ContactAttributeBuilder::determineAttributeSubKind("Linphone"));
            editor.addAttribute(sipAddressAttributeBuilder);
            need_to_update = TRUE;
        }
    }

    if (!_photoUrl.isEmpty()) {
        const ContactPhoto photo = ContactPhotoBuilder().setOriginalPhoto(_photoUrl);
        if (photo.isValid()) {
            editor.addPhoto(photo, true);
            need_to_update = TRUE;
        }
    }

    if (need_to_update) {
        _contactService->updateContact(contact);
    }
}

void ContactEditorModel::deleteContact() {
    if (!_contactService) {
        return;
    }

    _contactService->deleteContact(_contactId);
}

void ContactEditorModel::updateSipAddressForIndex(int index, QString sipAddress) {
    foreach (QVariantMap entry, _sipAddresses->toListOfMaps()) {
        int id = entry.value("id").toInt();
        if (id == index) {
            QVariantList indexPath = _sipAddresses->findExact(entry);
            entry["value"] = sipAddress;
            _sipAddresses->updateItem(indexPath, entry);
        }
    }
}

void ContactEditorModel::addNewSipAddressRow() {
    int i = 0;
    foreach (QVariantMap entry, _sipAddresses->toListOfMaps()) {
        i = entry.value("id").toInt() + 1;
    }

    QVariantMap newEntry;
    newEntry["value"] = "";
    newEntry["id"] = i;
    newEntry["first"] = FALSE;
    _sipAddresses->insert(newEntry);

    emit sipAddressesUpdated();
}

void ContactEditorModel::deleteSipAddressRowAtIndex(int index) {
    foreach (QVariantMap entry, _sipAddresses->toListOfMaps()) {
        int i = entry.value("id").toInt();
        if (i == index) {
            _sipAddresses->remove(entry);
            break;
        }
    }

    emit sipAddressesUpdated();
}
