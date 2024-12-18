#include "hctablemodel.h"

HcTableModel::HcTableModel(QObject *parent) : QAbstractTableModel{parent} {
}

int HcTableModel::rowCount(const QModelIndex &parent) const {
    return _rows.count();
}


int HcTableModel::columnCount(const QModelIndex &parent) const {
    return this->_columnSource.size();
}

QVariant HcTableModel::data(const QModelIndex &index, int role) const {
    switch (role) {
        case HcTableModel::RowModel:
            return QVariant::fromValue(_rows.at(index.row()));
        case HcTableModel::ColumnModel:
            return QVariant::fromValue(_columnSource.at(index.column()));
        default:
            break;
    }
    return {};
}

QHash<int, QByteArray> HcTableModel::roleNames() const {
    return {
        {HcTableModel::RowModel,    "rowModel"   },
        {HcTableModel::ColumnModel, "columnModel"}
    };
}

void HcTableModel::clear() {
    beginResetModel();
    this->_rows.clear();
    endResetModel();
}

QVariant HcTableModel::getRow(int rowIndex) {
    return _rows.at(rowIndex);
}

void HcTableModel::setRow(int rowIndex, QVariant row) {
    _rows.replace(rowIndex, row.toMap());
    Q_EMIT dataChanged(index(rowIndex, 0), index(rowIndex, columnCount() - 1));
}

void HcTableModel::insertRow(int rowIndex, QVariant row) {
    beginInsertRows(QModelIndex(), rowIndex, rowIndex);
    _rows.insert(rowIndex, row.toMap());
    endInsertRows();
}

void HcTableModel::removeRow(int rowIndex, int rows) {
    beginRemoveRows(QModelIndex(), rowIndex, rowIndex + rows - 1);
    _rows = _rows.mid(0, rowIndex) + _rows.mid(rowIndex + rows);
    endRemoveRows();
}

void HcTableModel::appendRow(QVariant row) {
    insertRow(rowCount(), row);
}
