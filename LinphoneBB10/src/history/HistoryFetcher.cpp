/*
 * HistoryFetcher.cpp
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
 *  Created on: 2 août 2015
 *      Author: Sylvain Berfini
 */

#include "HistoryFetcher.h"
#include "src/contacts/ContactFetcher.h"
#include "src/linphone/LinphoneManager.h"
#include "src/utils/Misc.h"

HistoryFetcher::HistoryFetcher()
{

}

static QVariantMap LogToQVariantMap(LinphoneCallLog *log)
{
    QVariantMap entry;
    entry["log"] = QVariant::fromValue<LinphoneCallLog*>(log);

    LinphoneAddress *addr = linphone_call_log_get_remote_address(log);
    entry["linphoneAddress"] = linphone_address_as_string_uri_only(addr);
    entry["remote"] = GetAddressFromLinphoneAddress(addr);

    entry["displayName"] = GetDisplayNameFromLinphoneAddress(addr);
    entry["contactPhoto"] = "/images/avatar.png";

    ContactFound cf = ContactFetcher::getInstance()->findContact(linphone_address_get_username(addr));
    if (cf.id >= 0) {
        entry["displayName"] = cf.displayName;
        entry["contactPhoto"] = cf.smallPicturePath;
    }

    time_t time = linphone_call_log_get_start_date(log);
    QDateTime *dateTime = new QDateTime();
    dateTime->setTime_t(time);
    QDate date = dateTime->date();
    entry["day"] = date;
    entry["time"] = dateTime->toTime_t();

    QString directionPicture = "/images/history/call_status_outgoing.png";
    if (linphone_call_log_get_dir(log) == LinphoneCallIncoming) {
        directionPicture = "/images/history/call_status_incoming.png";
    }
    if (linphone_call_log_get_status(log) == LinphoneCallMissed) {
        directionPicture = "/images/history/call_status_missed.png";
    }
    entry["directionPicture"] = directionPicture;

    entry["selected"] = false;

    return entry;
}

void HistoryFetcher::run()
{
    LinphoneManager *manager = LinphoneManager::getInstance();
    if (manager) {
        LinphoneCore *lc = manager->getLc();
        if (lc) {
            const MSList* logs = linphone_core_get_call_logs(lc);
            while (logs) {
                LinphoneCallLog *log = (LinphoneCallLog *)logs->data;
                QVariantMap entry = LogToQVariantMap(log);
                emit historyFetched(entry, linphone_call_log_get_status(log) == LinphoneCallMissed);
                logs = ms_list_next(logs);
            }
        }
    }
}
