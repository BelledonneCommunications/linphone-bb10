/*
 * Misc.h
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

#ifndef MISC_H_
#define MISC_H_

#include <QString>

#include "linphone/linphonecore.h"

const char* GetDisplayNameFromLinphoneAddress(const LinphoneAddress *address);
const char* GetAddressFromLinphoneAddress(const LinphoneAddress *address);
QString GetTime(time_t time);
QString FormatDateForHistoryList(time_t time);
QString FormatDateForHistoryLog(time_t time);
QString FormatDateForChat(time_t time);
QString FormatCallDuration(int duration);
bool AreProxyConfigsTheSame(LinphoneProxyConfig *lpc1, LinphoneProxyConfig *lpc2);
QString IceStateToString(LinphoneIceState ice);
QString SizeToString(int size, bool si = false);

#endif /* MISC_H_ */
