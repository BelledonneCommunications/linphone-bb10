/*
 * Misc.cpp
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
 *  Created on: 18 févr. 2015
 *      Author: Sylvain Berfini
 */

#include <QDateTime>
#include <math.h>

#include "Misc.h"
#include "src/linphone/LinphoneManager.h"

const char* GetDisplayNameFromLinphoneAddress(const LinphoneAddress *address)
{
    const char *displayName = linphone_address_get_display_name(address);
    if (!displayName)
        displayName = linphone_address_get_username(address);
    if (!displayName)
        displayName = linphone_address_as_string_uri_only(address);
    return displayName;
}

const char* GetAddressFromLinphoneAddress(const LinphoneAddress *address)
{
    char *addr = linphone_address_as_string_uri_only(address);
    return addr + 4;
}

QString GetTime(time_t time)
{
    QDateTime *dateTime = new QDateTime();
    dateTime->setTime_t(time);
    return dateTime->toString("hh:mm");
}

QString FormatDateForHistoryList(time_t time) {
    QDateTime now(QDateTime::currentDateTime());

    QDateTime *dateTime = new QDateTime();
    dateTime->setTime_t(time);

    int daysTo = dateTime->daysTo(now);
    if (daysTo == 0) {
        return QObject::tr("TODAY");
    } else if (daysTo == 1) {
        return QObject::tr("YESTERDAY");
    } else {
        return dateTime->toString("ddd d MMM");
    }
}

QString FormatDateForHistoryLog(time_t time) {
    QDateTime now(QDateTime::currentDateTime());

    QDateTime *dateTime = new QDateTime();
    dateTime->setTime_t(time);

    return dateTime->toString("dd/MM - hh'h'mm");
}

QString FormatDateForChat(time_t time) {
    QDateTime now(QDateTime::currentDateTime());

    QDateTime *dateTime = new QDateTime();
    dateTime->setTime_t(time);

    int daysTo = dateTime->daysTo(now);
    if (daysTo == 0) {
        return "";
    } else {
        return dateTime->toString(" dd/MM");
    }
}

QString FormatCallDuration(int seconds) {
    int minutes = 0;
    int hours = 0;

    if (seconds >= 3600) {
        hours = seconds / 3600;
        seconds = seconds % 3600;
    }
    if (seconds >= 60) {
        minutes = seconds / 60;
        seconds = seconds % 60;
    }

    QTime *time = new QTime();
    time->setHMS(hours, minutes, seconds, 0);
    return time->toString("hh:mm:ss");
}

bool AreProxyConfigsTheSame(LinphoneProxyConfig *lpc1, LinphoneProxyConfig *lpc2) {
    if (!lpc1 || !lpc2) {
        return false;
    }

    QString proxyConfigIdentity1(linphone_proxy_config_get_identity(lpc1));
    QString proxyConfigIdentity2(linphone_proxy_config_get_identity(lpc2));
    return QString::compare(proxyConfigIdentity1, proxyConfigIdentity2) == 0;
}

QString IceStateToString(LinphoneIceState ice) {
    switch (ice) {
        case LinphoneIceStateFailed:
            return QObject::tr("Failed");
        case LinphoneIceStateInProgress:
            return QObject::tr("In progress");
        case LinphoneIceStateHostConnection:
            return QObject::tr("Host");
        case LinphoneIceStateReflexiveConnection:
            return QObject::tr("Reflexive");
        case LinphoneIceStateRelayConnection:
            return QObject::tr("Relay");
        case LinphoneIceStateNotActivated:
            return QObject::tr("Not activated");
        default:
            return "";
    }
}

QString SizeToString(int size, bool si) {
    char buffer[16];
    int unit = si ? 1000 : 1024;

    if (size < unit) return size + " B";
    int exp = (int) (log(size) / log(unit));
    const char *ext = si ? "kMGTPE" : "KMGTPE";
    sprintf(buffer, "%.1f %c%sB", size / pow(unit, exp), ext[exp-1], si ? "" : "i");
    return buffer;
}
