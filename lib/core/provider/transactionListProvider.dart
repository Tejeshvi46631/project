
import 'package:egrocer/core/constant/apiAndParams.dart';
import 'package:egrocer/core/constant/constant.dart';
import 'package:egrocer/core/model/transaction.dart';
import 'package:egrocer/core/webservices/transactionApi.dart';
import 'package:egrocer/core/widgets/generalMethods.dart';
import 'package:flutter/material.dart';

enum TransactionState {
  initial,
  loading,
  loaded,
  loadingMore,
  error,
}

class TransactionProvider extends ChangeNotifier {
  TransactionState itemsState = TransactionState.initial;
  String message = '';
  late Transaction transactionData;
  List<TransactionData> transactions = [];
  bool hasMoreData = false;
  int totalData = 0;
  int offset = 0;

  Future<void> getTransactionProvider({
    required Map<String, dynamic> params,
    required BuildContext context,
  }) async {
    // Set state to loading or loading more based on offset
    if (offset == 0) {
      itemsState = TransactionState.loading;
    } else {
      itemsState = TransactionState.loadingMore;
    }
    notifyListeners();

    try {
      // Set parameters for API call
      params[ApiAndParams.limit] = Constant.defaultDataLoadLimitAtOnce.toString();
      params[ApiAndParams.offset] = offset.toString();

      // Fetch data from API
      Map<String, dynamic> getData = await getTransactionApi(context: context, params: params);

      // Check API status
      if (getData[ApiAndParams.status].toString() == "1") {
        // Safely parse totalData
        final totalDataString = getData[ApiAndParams.total.toString()];
        if (totalDataString is String) {
          totalData = int.parse(totalDataString);
        } else if (totalDataString is int) {
          totalData = totalDataString;
        } else {
          // Handle unexpected data type for totalData
          totalData = 0; // Or handle as needed
        }

        // Parse transactions
        List<TransactionData> tempTransactions = (getData['data'] as List)
            .map((e) => TransactionData.fromJson(Map.from(e)))
            .toList();

        // Update transactions list
        transactions.addAll(tempTransactions);

        // Check if more data is available
        hasMoreData = totalData > transactions.length;
        if (hasMoreData) {
          offset += Constant.defaultDataLoadLimitAtOnce;
        }

        // Update state to loaded
        itemsState = TransactionState.loaded;
      } else {
        // Handle API error status
        message = 'Failed to load transactions';
        itemsState = TransactionState.error;
        GeneralMethods.showSnackBarMsg(context, message);
      }
    } catch (e) {
      // Handle exceptions
      message = e.toString();
      itemsState = TransactionState.error;
      GeneralMethods.showSnackBarMsg(context, message);
    } finally {
      notifyListeners();
    }
  }
}

