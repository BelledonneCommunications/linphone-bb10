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

#include <bb/pim/contacts/Contact>
#include <bb/pim/contacts/ContactBuilder>
#include <bb/pim/contacts/ContactAttributeBuilder>
#include <bb/pim/contacts/ContactPhotoBuilder>
#include <bb/pim/contacts/ContactConsts>

using namespace bb::pim::contacts;

ContactEditorModel::ContactEditorModel(QObject *parent)
    : QObject(parent),
      _contactService(new ContactService(this)),
      _contactId(-1),
      _previousPage("ContactsListView.qml"),
      _isNewContact(true),
      _firstName(""),
      _lastName(""),
      _sipAddress(""),
      _photo(""),
      _photoUrl(""),
      _nextEditSipAddress("")
{

}

void ContactEditorModel::setSelectedContactId(int contactId)
{
    _contactId = contactId;
    _isNewContact = _contactId == -1;
    _firstName = "";
    _lastName = "";
    _photo = "/images/avatar.png";
    _photoUrl = "";
    _sipAddress = "";

    if (!_isNewContact) {
        getContact();
    }

    if (!_nextEditSipAddress.isEmpty()) {
        _sipAddress = _nextEditSipAddress;
        _nextEditSipAddress = "";
    }

    emit contactUpdated();
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

    QList<ContactAttribute> attrs = contact.filteredAttributes(AttributeKind::VideoChat);
    foreach (ContactAttribute attr, attrs) {
        _sipAddress = attr.value();
    }
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

static void prepareSipAddressBuilder(ContactAttributeBuilder *builder, QString sipAddress) {
    builder->setKind(AttributeKind::VideoChat);
    builder->setSubKind(ContactAttributeBuilder::determineAttributeSubKind("Linphone"));
    builder->setLabel("Linphone");
    builder->setValue(sipAddress);
}

void ContactEditorModel::createContact() {
    if (!_contactService) {
        return;
    }

    ContactAttributeBuilder firstNameAttributeBuilder;
    prepareFirstNameBuilder(&firstNameAttributeBuilder, _firstName);

    ContactAttributeBuilder lastNameAttributeBuilder;
    prepareLastNameBuilder(&lastNameAttributeBuilder, _lastName);

    ContactAttributeBuilder sipAddressAttributeBuilder;
    prepareSipAddressBuilder(&sipAddressAttributeBuilder, _sipAddress);

    ContactBuilder contactBuilder;
    contactBuilder.addAttribute(firstNameAttributeBuilder);
    contactBuilder.addAttribute(lastNameAttributeBuilder);
    contactBuilder.addAttribute(sipAddressAttributeBuilder);

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

    Contact contact = _contactService->contactDetails(_contactId);
    bool existingSipAddressFound = false;

    QList<ContactAttribute> attrs = contact.attributes();
    foreach (ContactAttribute attr, attrs) {
        if (attr.kind() == AttributeKind::Name) {
            if (attr.subKind() == AttributeSubKind::NameSurname) {
                ContactAttributeBuilder builder = attr.edit();
                prepareLastNameBuilder(&builder, _lastName);
                _contactService->updateContact(contact);
            } else if (attr.subKind() == AttributeSubKind::NameGiven) {
                ContactAttributeBuilder builder = attr.edit();
                prepareFirstNameBuilder(&builder, _firstName);
                _contactService->updateContact(contact);
            }
        }
        if (attr.kind() == AttributeKind::VideoChat) {
            ContactAttributeBuilder builder = attr.edit();
            prepareSipAddressBuilder(&builder, _sipAddress);
            _contactService->updateContact(contact);
            existingSipAddressFound = true;
        }
    }

    if (!existingSipAddressFound) {
        ContactBuilder editor = contact.edit();

        ContactAttributeBuilder sipAddressAttributeBuilder;
        prepareSipAddressBuilder(&sipAddressAttributeBuilder, _sipAddress);
        editor.addAttribute(sipAddressAttributeBuilder);

        if (!_photoUrl.isEmpty()) {
            const ContactPhoto photo = ContactPhotoBuilder().setOriginalPhoto(_photoUrl);
            if (photo.isValid()) {
                editor.addPhoto(photo, true);
            }
        }

        _contactService->updateContact(editor);
    }
}

void ContactEditorModel::deleteContact() {
    if (!_contactService) {
        return;
    }

    _contactService->deleteContact(_contactId);
}
