import 'package:b_wallet/constants.dart';
import 'package:b_wallet/home_screen.dart';
import 'package:b_wallet/paint.dart';
import 'package:b_wallet/provider/LoginProvider.dart';
import 'package:b_wallet/provider/network_provider.dart';
import 'package:b_wallet/provider/wallet_provider.dart';
import 'package:b_wallet/qr_screen.dart';
import 'package:b_wallet/scan_qr.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:qr_flutter/qr_flutter.dart';

class SendScreen extends StatefulWidget {
  final BuildContext menuScreenContext;
  final Function onScreenHideButtonPressed;
  final bool hideStatus;
  final String receiverId;
  final String senderId;
  final String receiverName;
  final String amount;
  SendScreen(
      {Key key,
      this.menuScreenContext,
      this.onScreenHideButtonPressed,
      this.receiverName,
      this.receiverId,
      this.senderId,
      this.amount,
      this.hideStatus = false})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return SendScreenState();
  }
}

class SendScreenState extends State<SendScreen> {
  List usageList = [];

  final walletProvider = GetIt.I<WalletProvider>();
  final loginProvider = GetIt.I<LoginProvider>();

  int balance = 0;

  var selectedIndex = 0;
  TextEditingController amountController = TextEditingController(text: "50");
  @override
  void initState() {
    super.initState();

    loginProvider.appUser.addListener(() {
      setState(() {});
    });
  }

  showAlertDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: new Row(
        children: [
          Theme(
              data: ThemeData(accentColor: AppColor.primary),
              child: CircularProgressIndicator()),
          Container(
              margin: EdgeInsets.only(left: 5),
              child: Text(" Waiting for Response")),
        ],
      ),
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.transparent,
            child: CustomPaint(
              painter: CurvePainter(),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.transparent,
            child: CustomPaint(
              painter: CurvePainter1(),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.35,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: AppColor.primary.withOpacity(0.5),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                left: size.width * 0.1, right: size.width * 0.1),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(
                    height: size.height * 0.09,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        "My Balance",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: size.height * 0.05,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        FutureBuilder(
                          future: walletProvider.getBalance(loginProvider
                                  .appUser.value.phoneNo
                                  .split("+92")[
                              1]), //networkProvider.getBalance(BigInt.parse("2")),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              // walletProvider.balance.value = snapshot.data[0];
                              // walletProvider.balance.notifyListeners();
                              balance = int.parse('${snapshot.data[0]}');
                              return Column(
                                children: [
                                  Text(
                                    // 'Rs. ${walletProvider.balance.value}',
                                    'Rs. ${snapshot.data[0]}',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              );
                            } else
                              return Row(
                                children: [
                                  Text(
                                    'Rs. ',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    '${0}',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              );
                          },
                        ),
                        GestureDetector(
                          onTap: () {
                            setState(() {});
                          },
                          child: Icon(
                            Icons.refresh,
                            size: 35,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.05,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Receiver: ${widget.receiverName}",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.01,
                  ),
                  Container(
                      height: size.height * 0.11,
                      width: size.width * 0.8,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                  child: TextField(
                                controller: amountController,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold,
                                    color: AppColor.primary),
                                decoration: new InputDecoration(
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                ),
                              )),
                              Text(
                                "Amount (PKR)",
                                style: TextStyle(
                                    color: Colors.black.withOpacity(0.4),
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                      )),
                  SizedBox(
                    height: size.height * 0.025,
                  ),
                  MaterialButton(
                    color: AppColor.primary,
                    child: Padding(
                        padding: const EdgeInsets.all(17.0),
                        child:
                            // codeSent
                            // ?
                            Text(
                          "SEND MONEY",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontSize: 18),
                        )),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      side: BorderSide(color: AppColor.primary),
                    ),
                    onPressed: () async {
                      print(balance);
                      if (int.parse(amountController.text) <= balance) {
                        showAlertDialog(context);
                        var response = null;
                        try {
                          response = await walletProvider.sendAmount(
                              widget.senderId,
                              widget.receiverId,
                              amountController.text);
                          // Navigator.pop(context);

                        } catch (e) {
                          Navigator.pop(context);
                          print("OK");
                          Fluttertoast.showToast(
                              msg: "Transaction Will Complete Soon",
                              backgroundColor: Colors.black.withOpacity(0.6),
                              textColor: Colors.white,
                              toastLength: Toast.LENGTH_LONG);
                          Get.offAll(HomeScreen());
                          print(e);
                        }
                        if (response == true) {
                          Navigator.pop(context);
                          print("OK");
                          Fluttertoast.showToast(
                              msg: "Transaction Complated",
                              backgroundColor: Colors.black.withOpacity(0.6),
                              textColor: Colors.white,
                              toastLength: Toast.LENGTH_LONG);
                          Get.offAll(HomeScreen());
                        } else if (response == false) {
                          Fluttertoast.showToast(
                              msg: "Transaction Failed",
                              backgroundColor: Colors.black.withOpacity(0.6),
                              textColor: Colors.white,
                              toastLength: Toast.LENGTH_LONG);
                          Get.offAll(HomeScreen());
                          print("NO");
                        }

                        if (response != null) {
                          Get.offAll(HomeScreen());
                        }
                      } else {
                        Fluttertoast.showToast(
                            msg: "Balance is Less than entered Amount",
                            backgroundColor: Colors.black.withOpacity(0.6),
                            textColor: Colors.white,
                            toastLength: Toast.LENGTH_LONG);
                        // Get.offAll(HomeScreen());
                      }
                    },
                  ),
                  SizedBox(
                    height: size.height * 0.025,
                  ),
                  Container(
                      height: size.height * 0.44,
                      width: size.width * 0.8,
                      color: Colors.transparent,
                      child: Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GridView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 20.0,
                              mainAxisSpacing: 20.0,
                            ),
                            itemCount: 9,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  if (index == 0) {
                                    amountController.text = '50';
                                    selectedIndex = index;
                                  } else if (index == 1) {
                                    amountController.text = "100";
                                    selectedIndex = index;
                                  } else if (index == 2) {
                                    amountController.text = "200";
                                    selectedIndex = index;
                                  } else if (index == 3) {
                                    amountController.text = "500";
                                    selectedIndex = index;
                                  } else if (index == 4) {
                                    amountController.text = "1000";
                                    selectedIndex = index;
                                  } else if (index == 5) {
                                    amountController.text = "1500";
                                    selectedIndex = index;
                                  } else if (index == 6) {
                                    amountController.text = "2000";
                                    selectedIndex = index;
                                  } else if (index == 7) {
                                    amountController.text = "3000";
                                    selectedIndex = index;
                                  } else if (index == 8) {
                                    amountController.text = "5000";
                                    selectedIndex = index;
                                  }
                                  setState(() {});
                                },
                                child: Container(
                                  decoration: new BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: selectedIndex == index
                                        ? AppColor.primary
                                        : Colors.black.withOpacity(0.1),
                                    boxShadow: [],
                                  ),
                                  child: Center(
                                      child: Text(
                                    (() {
                                      if (index == 0) {
                                        return "50";
                                      } else if (index == 1) {
                                        return "100";
                                      } else if (index == 2) {
                                        return "200";
                                      } else if (index == 3) {
                                        return "500";
                                      } else if (index == 4) {
                                        return "1000";
                                      } else if (index == 5) {
                                        return "1500";
                                      } else if (index == 6) {
                                        return "2000";
                                      } else if (index == 7) {
                                        return "3000";
                                      } else if (index == 8) {
                                        return "5000";
                                      }
                                    }()),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                        color: selectedIndex == index
                                            ? Colors.white
                                            : AppColor.primary),
                                  )),
                                ),
                              );
                            },
                          ),
                        ),
                      )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
