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
      _isSipContact(false),
      _selectedHistoryLog(NULL)
{

}

void HistoryModel::setSelectedHistoryLog(LinphoneCallLog *log) {
    if (!log) {
        return;
    }
    _selectedHistoryLog = log;

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

    _logs.clear();

    LinphoneManager *manager = LinphoneManager::getInstance();
    LinphoneCore *lc = manager->getLc();
    MSList *callLogs = linphone_core_get_call_history_for_address(lc, linphone_call_log_get_remote_address(_selectedHistoryLog));

    while (callLogs && _logs.size() < 10) {
        LinphoneCallLog *callLog = (LinphoneCallLog *) callLogs->data;

        time_t start = linphone_call_log_get_start_date(callLog);
        int duration = linphone_call_log_get_duration(callLog);
        QString date = FormatDateForHistoryLog(start);
        QString time = FormatCallDuration(duration);
        QString displayValue = date + " - " + time;

        if (linphone_call_log_get_status(callLog) == LinphoneCallMissed) {
            _logs[displayValue] = "/images/history/call_missed.png";
        } else {
            LinphoneCallDir direction = linphone_call_log_get_dir(callLog);
            if (direction == LinphoneCallIncoming) {
                _logs[displayValue] = "/images/history/call_incoming.png";
            } else {
                _logs[displayValue] = "/images/history/call_outgoing.png";
            }
        }

        callLogs = ms_list_next(callLogs);
    }
    ms_list_free_with_data(callLogs, (void (*)(void*))linphone_call_log_unref);

    _isSipContact = true;
    emit historyLogUpdated();
}
