/*
 * ListEditorHelper.cpp
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
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 *
 *  Created on: 3 août 2015
 *      Author: Sylvain Berfini
 */

#include "ListEditorHelper.h"

ListEditorHelper::ListEditorHelper(bb::cascades::GroupDataModel *dataModel)
    : _isEditMode(false),
    _dataModel(dataModel)
{

}

void ListEditorHelper::updateSelection(const QVariantList &indexPath, bool checked)
{
    bool ok = false;
    if (checked && !_selection.contains(indexPath)) {
        _selection.append(indexPath);
        ok = true;
    } else if (!checked && _selection.contains(indexPath)) {
        _selection.removeOne(indexPath);
        ok = true;
    }

    if (ok) {
        QVariantMap entry = _dataModel->data(indexPath).toMap();
        entry["selected"] = checked;
        _dataModel->updateItem(indexPath, entry);
    }

    emit editModeUpdated();
}

static bool indexPathComparator(const QVariantList &v1, const QVariantList &v2)
{
    if (v1.size() == v2.size()) {
        if (v1.size() == 2) {
            if (v1.first() == v2.first()) {
                return v1.last().toInt() > v2.last().toInt();
            } else {
                return v1.first().toInt() > v2.first().toInt();
            }
        } else if (v1.size() == 1) {
            return v1.first().toInt() > v2.first().toInt();
        } else {
            return true;
        }
    } else {
        return v1.size() > v2.size();
    }
}

void ListEditorHelper::deleteSelection()
{
    if (_selection.size() > 0) {
        // First let's sort it in decreasing order, this way each class getting the deleteRequested signal can iterate on the datamodel and safely call removeAt without breaking the next calls
        qSort(_selection.begin(), _selection.end(), indexPathComparator);

        emit deleteRequested(_selection);
    }
    setEditMode(false);
}

void ListEditorHelper::selectAll(bool select)
{
    foreach (QVariantMap entry, _dataModel->toListOfMaps()) {
        QVariantList indexPath = _dataModel->findExact(entry);
        updateSelection(indexPath, select);
    }
}

void ListEditorHelper::setEditMode(const bool &editModeEnabled)
{
    _isEditMode = editModeEnabled;
    if (editModeEnabled) {
        selectAll(false);
        _selection.clear();
    }
    emit editModeUpdated();
}

void ListEditorHelper::setDataModel(bb::cascades::GroupDataModel *dataModel)
{
    foreach (QVariantList indexPath, _selection) {
        QVariantMap entry = _dataModel->data(indexPath).toMap();
        entry["selected"] = false;
        _dataModel->updateItem(indexPath, entry);
    }

    _selection.clear();
    _dataModel = dataModel;
    emit editModeUpdated();
}
