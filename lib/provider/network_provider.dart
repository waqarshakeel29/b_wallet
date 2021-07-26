import 'package:b_wallet/model/transaction_history.dart';
import 'package:b_wallet/shared/constants.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';

import '../constants.dart';

class NetworkProvider {
  Client httpClient;
  Web3Client ethClient;

  init() {
    httpClient = new Client();
    ethClient = new Web3Client(
        "https://ropsten.infura.io/v3/7ec9253359884d2e81ee5d1cef71c330",
        httpClient);
    // ethClient = new Web3Client(
    // "https://ropsten.infura.io/v3/06f24ed76b204d98a4543e04cded9f6c",
    // httpClient);
    // ethClient = new Web3Client("HTTP://10.0.2.2:7545", httpClient);
  }

  Future<bool> addUserInCompany(String companyId, String name, String balance,
      String phoneNumber, String pin) async {
    var cId = BigInt.parse(companyId);
    var numb = BigInt.parse(phoneNumber);
    var bal = BigInt.parse("10000");
    var pinc = BigInt.parse(pin);

    // var response =
    //     await submit("addUserinCompany", [cId, name, bal, numb, pinc]);
    var response = await submit("addUserinCompany", [cId, name, numb, pinc]);
    var isTransactionConfirm = false;
    while (!isTransactionConfirm) {
      var res = await ethClient.getTransactionReceipt(response);
      if (res != null) {
        print(res);
        isTransactionConfirm = res.status;
      } else {
        print("waiting");
      }
    }
    //var response = await submit("sendTo", [senderId, receiverId, amount]);
    // hash of the transaction
    print("RESPONSE ------- " + response);
    return isTransactionConfirm;
  }

  Future<bool> sendTo(BigInt senderId, BigInt receiverId, BigInt amount) async {
    // EthereumAddress address = EthereumAddress.fromHex(targetAddressHex);

    var response = await submit(
        "dopayment", [BigInt.parse(COMPANY_ID), senderId, receiverId, amount]);

    var isTransactionConfirm = false;
    while (!isTransactionConfirm) {
      var res = await ethClient.getTransactionReceipt(response);
      if (res != null) {
        print(res);
        isTransactionConfirm = res.status;
      } else {
        print("waiting");
      }
    }
    //var response = await submit("sendTo", [senderId, receiverId, amount]);
    // hash of the transaction
    print("RESPONSE ------- " + response);
    return isTransactionConfirm;
  }

  Future<List<dynamic>> getBalance(BigInt id) async {
    // EthereumAddress address = EthereumAddress.fromHex(targetAddressHex);
    // getBalance transaction
    List<dynamic> result = await query("getBalance", [id]);
    // returns list of results, in this case a list with only the balance
    return result;
  }

  Future<List<dynamic>> getUserName(String userId) async {
    var comp_id = BigInt.parse(COMPANY_ID);
    var u_id = BigInt.parse(userId);

    List<dynamic> result = await query("getUserName", [comp_id, u_id]);

    return result;
  }

  Future<List<dynamic>> getTransactions(String userId) async {
    var comp_id = BigInt.parse(COMPANY_ID);
    var u_id = BigInt.parse(userId);

    List<dynamic> result = await query("getTransactions", [comp_id, u_id]);

    var result_array = result[0];
    List<TransactionHistory> l = [];
    for (var i in result_array) {
      // l.add(TransactionHistory(
      //     i[0], i[1], i[2], i[3], i[4], i[5], i[6], i[7], i[8], i[9]));
      l.add(TransactionHistory(
          int.parse(i[0].toString()),
          int.parse(i[1].toString()),
          int.parse(i[2].toString()),
          int.parse(i[3].toString()),
          int.parse(i[4].toString()),
          int.parse(i[5].toString()),
          int.parse(i[6].toString()),
          int.parse(i[7].toString()),
          int.parse(i[8].toString()),
          int.parse(i[9].toString())));
    }

    return l;
  }

  Future<List<dynamic>> getTrustedRequest(String userId) async {
    var comp_id = BigInt.parse(COMPANY_ID);
    var u_id = BigInt.parse(userId);

    List<dynamic> result = await query("getTransactions", [comp_id, u_id]);

    var result_array = result[0];
    List<TransactionHistory> l = [];
    for (var i in result_array) {
      // l.add(TransactionHistory(
      //     i[0], i[1], i[2], i[3], i[4], i[5], i[6], i[7], i[8], i[9]));
      l.add(TransactionHistory(
          int.parse(i[0].toString()),
          int.parse(i[1].toString()),
          int.parse(i[2].toString()),
          int.parse(i[3].toString()),
          int.parse(i[4].toString()),
          int.parse(i[5].toString()),
          int.parse(i[6].toString()),
          int.parse(i[7].toString()),
          int.parse(i[8].toString()),
          int.parse(i[9].toString())));
    }

    return l;
  }

  Future<List<dynamic>> isUserPresent(String cid, String userId) async {
    var comp_id = BigInt.parse(cid);
    var u_id = BigInt.parse(userId);
    List<dynamic> result = await query("isUserPresent", [comp_id, u_id]);

    return result;
  }

  Future<List<dynamic>> getTrustedList(String userId) async {
    var comp_id = BigInt.parse(COMPANY_ID);
    var u_id = BigInt.parse(userId);
    List<dynamic> result = await query("getTrustedList", [comp_id, u_id]);

    return result;
  }


  Future<List<dynamic>> getTrusteeList(String userId) async {
    var comp_id = BigInt.parse(COMPANY_ID);
    var u_id = BigInt.parse(userId);
    List<dynamic> result = await query("getTrusteeList", [comp_id, u_id]);

    return result;
  }


  Future<List<dynamic>> getTrustedContLimit(
      String userId, String benificaryId) async {
    var comp_id = BigInt.parse(COMPANY_ID);
    var u_id = BigInt.parse(userId);
    var b_id = BigInt.parse(benificaryId);

    print("IN trusted conl lit");
    print(u_id);
    print(b_id);
    List<dynamic> result =
        await query("getTrustedContLimit", [comp_id, u_id, b_id]);

    print("RESPONSE");

    print(result);
    return result;
  }

  Future<List<dynamic>> isPinCorrect(
      String cid, String userId, String pin) async {
    var comp_id = BigInt.parse(cid);
    var u_id = BigInt.parse(userId);
    var p_in = BigInt.parse(pin);
    List<dynamic> result = await query("isPinCorrect", [comp_id, u_id, p_in]);

    return result;
  }

  Future<List<dynamic>> getBalance2(BigInt id, BigInt numb) async {
    // EthereumAddress address = EthereumAddress.fromHex(targetAddressHex);
    // getBalance transaction
    print(id.toString() + " ----- " + numb.toString());
    //await addTrustedContact(id, numb, BigInt.parse("334"));

    print(id.toString() + " ----- " + numb.toString());
    print("-------------");
    //var result = await submit("dopayment",
    //    [id, BigInt.parse("3341334747"), numb, BigInt.parse("500")]);
    var result = await query("getBalance", [id, numb]);
    // returns list of results, in this case a list with only the balance
    print("RESPONSE ------- ");
    print("RESPONSE ------- " + result.toString());
    return result;
  }

  Future<bool> addTrustedContact(String userId, String benificaryId) async {
    var comp_id = BigInt.parse(COMPANY_ID);
    var u_id = BigInt.parse(userId);
    var b_id = BigInt.parse(benificaryId);
    var limit = BigInt.parse("0");

    var response =
        await submit("addTrustedContact", [comp_id, u_id, b_id, limit]);

    var isTransactionConfirm = false;
    while (!isTransactionConfirm) {
      var res = await ethClient.getTransactionReceipt(response);
      if (res != null) {
        print(res);
        isTransactionConfirm = res.status;
      } else {
        print("waiting");
      }
    }
    //var response = await submit("sendTo", [senderId, receiverId, amount]);
    // hash of the transaction
    print("RESPONSE ------- " + response);
    return isTransactionConfirm;
  }

  Future<bool> removeTrustedContact(String userId, String benificaryId) async {
    var comp_id = BigInt.parse(COMPANY_ID);
    var u_id = BigInt.parse(userId);
    var b_id = BigInt.parse(benificaryId);

    var response = await submit("removeTrustedUser", [comp_id, u_id, b_id]);

    var isTransactionConfirm = false;
    while (!isTransactionConfirm) {
      var res = await ethClient.getTransactionReceipt(response);
      if (res != null) {
        print(res);
        isTransactionConfirm = res.status;
      } else {
        print("waiting");
      }
    }
    //var response = await submit("sendTo", [senderId, receiverId, amount]);
    // hash of the transaction
    print("RESPONSE ------- " + response);
    return isTransactionConfirm;
  }

  Future<String> submit(String functionName, List<dynamic> args) async {
    EthPrivateKey credentials = EthPrivateKey.fromHex(PRIVATE_ADDRESS);

    DeployedContract contract = await loadContract();

    final ethFunction = contract.function(functionName);

    var result = await ethClient.sendTransaction(
        credentials,
        Transaction.callContract(
          contract: contract,
          function: ethFunction,
          parameters: args,
          maxGas: 3000000,
        ),
        fetchChainIdFromNetworkId: true);
    return result;
  }

  Future<List<dynamic>> query(String functionName, List<dynamic> args) async {
    final contract = await loadContract();
    print(contract.address);
    final ethFunction = contract.function(functionName);
    print(ethFunction.name);
    final data = await ethClient.call(
        contract: contract, function: ethFunction, params: args);
    return data;
  }

  Future<DeployedContract> loadContract() async {
    String abiCode = await rootBundle.loadString("assets/abi.json");
    String contractAddress = CONTRACT_ADDRESS;

    final contract = DeployedContract(
        ContractAbi.fromJson(abiCode, "Customers"),
        EthereumAddress.fromHex(contractAddress));
    return contract;
  }
}
