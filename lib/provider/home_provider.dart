import 'package:b_wallet/model/transaction_history.dart';
import 'package:b_wallet/provider/wallet_provider.dart';
import 'package:get_it/get_it.dart';

import 'LoginProvider.dart';

class HomeProvider {
  List<TransactionHistory> historyList = [];

  final walletProvider = GetIt.I<WalletProvider>();
  final loginProvider = GetIt.I<LoginProvider>();

  getListTrnsactionHistory() async {
    List<TransactionHistory> res = await walletProvider
        .getTransactions(loginProvider.appUser.value.phoneNo.split("+92")[1]);
    if (res.toList().length >= 4) {
      historyList = res.reversed.toList().sublist(0, 4);
    } else {
      historyList = res.reversed.toList();
    }

    List<TransactionHistory> data = historyList;
    for (int i = 0; i < data.length; i++) {
      if (walletProvider.isReceived(data[i])) {
        var d = await walletProvider.getUserName('${data[i].sender}');
        data[i].name = d[0];
      } else {
        var d = await walletProvider.getUserName('${data[i].reciver}');
        data[i].name = d[0];
      }
    }
    // print("DATA");
    // print(data);

    return data;
  }

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
