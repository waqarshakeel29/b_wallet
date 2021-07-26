import 'package:b_wallet/model/transaction_history.dart';
import 'package:b_wallet/shared/constants.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'LoginProvider.dart';
import 'network_provider.dart';

class WalletProvider {
  final networkProvider = GetIt.I<NetworkProvider>();
  final loginProvider = GetIt.I<LoginProvider>();

  ValueNotifier<BigInt> balance = ValueNotifier(BigInt.parse("0"));

  getBalance(String userId) {
    // setBalance(userId);
    return networkProvider.getBalance2(
        BigInt.parse(COMPANY_ID), BigInt.parse(userId));
  }

  // setBalance(String userId) async {
  //   var bal = await networkProvider.getBalance2(
  //       BigInt.parse(COMPANY_ID), BigInt.parse(userId));
  //   balance.value = bal[0];
  //   balance.notifyListeners();
  // }

  sendAmount(String senderId, String receiverId, String amount) async {
    var sid = BigInt.parse(senderId);
    var rid = BigInt.parse(receiverId);
    var amt = BigInt.parse(amount);
    return await networkProvider.sendTo(sid, rid, amt);
  }

  getTransactions(String userId) async {
    return await networkProvider.getTransactions(userId);
  }

  getTrustedList(String userId) async {
    return await networkProvider.getTrustedList(userId);
  }

  getTrusteeList(String userId) async {
    return await networkProvider.getTrusteeList(userId);
  }

  addtrustedContract(String userId, String benificaryId) async {
    return await networkProvider.addTrustedContact(userId, benificaryId);
  }

  removeTrustedContract(String userId, String benificaryId) async {
    return await networkProvider.removeTrustedContact(userId, benificaryId);
  }

  gettrustedContLimit(String userId, String benificaryId) async {
    return await networkProvider.getTrustedContLimit(userId, benificaryId);
  }

  getUserName(String userId) async {
    return await networkProvider.getUserName(userId);
  }

  isReceived(TransactionHistory transactionHistory) {
    if (transactionHistory.reciver ==
        int.parse(loginProvider.appUser.value.phoneNo.split("+92")[1])) {
      return true;
    }
    return false;
  }
}
