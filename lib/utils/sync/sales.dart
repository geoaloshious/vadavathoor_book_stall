import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:vadavathoor_book_stall/db/models/sales.dart';

downSyncSales(
    Map<String, dynamic> jsonResult, String key, Box<SaleModel> box) async {
  for (var itm in jsonResult['data'][key]) {
    bool exists = box.values.where((i) => i.saleID == itm['saleID']).isNotEmpty;
    if (exists) {
      for (int key in box.keys) {
        var existingData = box.get(key);
        if (existingData != null && existingData.saleID == itm['saleID']) {
          existingData.books = List<SaleItemModel>.from(jsonDecode(itm['books'])
              .map((item) => SaleItemModel.fromJson(item)));
          existingData.stationaryItems = List<SaleItemModel>.from(
              jsonDecode(itm['stationaryItems'])
                  .map((item) => SaleItemModel.fromJson(item)));
          existingData.grandTotal = double.tryParse(itm['grandTotal']) ?? 0;
          existingData.customerID = itm['customerID'];
          existingData.paymentMode = itm['paymentMode'];
          existingData.createdDate = int.tryParse(itm['createdDate']) ?? 0;
          existingData.createdBy = itm['createdBy'];
          existingData.modifiedDate = int.tryParse(itm['modifiedDate']) ?? 0;
          existingData.modifiedBy = itm['modifiedBy'];
          existingData.status = itm['status'];

          await box.put(key, existingData);
          break;
        }
      }
    } else {
      await box.add(SaleModel(
          saleID: itm['saleID'],
          books: List<SaleItemModel>.from(jsonDecode(itm['books'])
              .map((item) => SaleItemModel.fromJson(item))),
          stationaryItems: List<SaleItemModel>.from(
              jsonDecode(itm['stationaryItems'])
                  .map((item) => SaleItemModel.fromJson(item))),
          grandTotal: double.tryParse(itm['grandTotal']) ?? 0,
          customerID: itm['customerID'],
          paymentMode: itm['paymentMode'],
          createdDate: int.tryParse(itm['createdDate']) ?? 0,
          createdBy: itm['createdBy'],
          modifiedDate: int.tryParse(itm['modifiedDate']) ?? 0,
          modifiedBy: itm['modifiedBy'],
          status: itm['status']));
    }
  }
}
