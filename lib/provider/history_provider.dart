import 'package:b_wallet/model/transaction_history.dart';
import 'package:b_wallet/provider/wallet_provider.dart';
import 'package:get_it/get_it.dart';

import 'LoginProvider.dart';

class HistoryProvider {
  List<TransactionHistory> historyList = [];

  final walletProvider = GetIt.I<WalletProvider>();
  final loginProvider = GetIt.I<LoginProvider>();

  getListTrnsactionHistory(DateTime s, DateTime e, int type) async {
    List<TransactionHistory> res = await walletProvider
        .getTransactions(loginProvider.appUser.value.phoneNo.split("+92")[1]);

    historyList = res.reversed.toList();
    List<TransactionHistory> filterList = [];
    for (int i = 0; i < historyList.length; i++) {
      if (type == 0) {
        var isRec = walletProvider.isReceived(historyList[i]);
        if (isRec) {
          var c = DateTime(
            historyList[i].year,
            historyList[i].month,
            historyList[i].day,
          );
          if (c.compareTo(s) <= 0 && c.compareTo(e) >= 0) {
            filterList.add(historyList[i]);
          }
        }
      } else if (type == 1) {
        var isRec = walletProvider.isReceived(historyList[i]);
        if (!isRec) {
          var c = DateTime(
            historyList[i].year,
            historyList[i].month,
            historyList[i].day,
          );
          if (c.compareTo(s) <= 0 && c.compareTo(e) >= 0) {
            filterList.add(historyList[i]);
          }
        }
      } else {
        var c = DateTime(
          historyList[i].year,
          historyList[i].month,
          historyList[i].day,
        );
        if (c.compareTo(s) <= 0 && c.compareTo(e) >= 0) {
          filterList.add(historyList[i]);
        }
      }
    }

    return filterList;
  }

  // getListTrnsactionHistory(
  //     var sday, var smonth, var syear, var eday, var emonth, var eyear) async {
  //   List<TransactionHistory> res = await walletProvider
  //       .getTransactions(loginProvider.appUser.value.phoneNo.split("+92")[1]);

  //   historyList = res.reversed.toList();
  //   List<TransactionHistory> filterList = [];
  //   for (int i = 0; i < historyList.length; i++) {
  //     if (historyList[i].day <= sday && historyList[i].day >= sday) {
  //       print("OK1");
  //       if (historyList[i].month <= smonth && historyList[i].month >= emonth) {
  //         print("OK2");
  //         if (historyList[i].year <= syear && historyList[i].year >= eyear) {
  //           print("OK3");
  //           filterList.add(historyList[i]);
  //         }
  //       }
  //     }
  //   }

  //   return filterList;
  // }

  getUserName(TransactionHistory transactionHistory) async {
    var b = walletProvider.isReceived(transactionHistory);
    var res = [];
    if (b) {
      res = await walletProvider
          .getUserName(transactionHistory.sender.toString());
    } else {
      res = await walletProvider
          .getUserName(transactionHistory.reciver.toString());
    }

    return res;
  }
}
