/*
 * HistoryModel.cpp
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

#include "HistoryModel.h"
#include "src/contacts/ContactFetcher.h"
#include "src/utils/Misc.h"

HistoryModel::HistoryModel(QObject *parent)
    : QObject(parent),
      _displayName(""),
      _sipUri(""),
      _linphoneAddress(""),
      _photo(""),
      _direction(""),
      _details(""),
      _isSipContact(false),
      _selectedHistoryLog(NULL)
{

}

void HistoryModel::setSelectedHistoryLog(LinphoneCallLog *log) {
    if (!log) {
        return;
    }

    LinphoneAddress *addr = linphone_call_log_get_remote_address(log);
    ContactFound contact = ContactFetcher::getInstance()->findContact(linphone_address_get_username(addr));
    if (contact.id >= 0) {
        _displayName = contact.displayName;
        _photo = contact.picturePath;
    } else {
        _displayName = GetDisplayNameFromLinphoneAddress(addr);
        _photo = "/images/avatar.png";
    }

    _sipUri = GetAddressFromLinphoneAddress(addr);
    _linphoneAddress = linphone_address_as_string(addr);

    if (linphone_call_log_get_status(log) == LinphoneCallMissed) {
        _direction = tr("MISSED CALL");
    } else {
        LinphoneCallDir direction = linphone_call_log_get_dir(log);
        if (direction == LinphoneCallIncoming) {
            _direction = tr("INCOMING CALL");
        } else {
            _direction = tr("OUTGOING CALL");
        }
    }

    time_t start = linphone_call_log_get_start_date(log);
    int duration = linphone_call_log_get_duration(log);
    QString date = FormatDateForHistoryLog(start);
    QString time = FormatCallDuration(duration);
    _details = date + " - " + time;

    _isSipContact = true;
    emit historyLogUpdated();
}
