import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:mobile_unity/src/models/financial.dart';
import 'package:mobile_unity/src/services/financial_database.dart';
import 'package:mobile_unity/src/services/task_database.dart';

class FinancialProvider extends ChangeNotifier{
  List<Financial> financials;

  Future<void> getFinancialBasedChildId({childId: String}) async{
    var financials = await FinancialDatabase().getFinancialsBasesChildId(childId);
    this.financials = financials;
    notifyListeners();
  }
}