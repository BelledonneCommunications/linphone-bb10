/*
 * CustomGroupDataModel.cpp
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
 *  Created on: 24 juil. 2015
 *      Author: Sylvain Berfini
 */

#include "CustomHistoryGroupDataModel.h"

using namespace bb::cascades;

CustomHistoryGroupDataModel::CustomHistoryGroupDataModel(QObject *parent) : GroupDataModel(parent)
{

}

QVariant CustomHistoryGroupDataModel::data(const QVariantList& indexPath) {
    // if it is a header
    if (this->hasChildren(indexPath)){
        QDate date = GroupDataModel::data(indexPath).toDate();
        QDate now(QDate::currentDate());
        int daysTo = date.daysTo(now);

        QString headerFormatted;
        if (daysTo == 0) {
            headerFormatted = QObject::tr("TODAY");
        } else if (daysTo == 1) {
            headerFormatted = QObject::tr("YESTERDAY");
        } else {
            headerFormatted = date.toString("ddd d MMM");
        }

        return QVariant(headerFormatted);
    } else {
        QVariant mData = GroupDataModel::data(indexPath);
        return mData;
    }
}

