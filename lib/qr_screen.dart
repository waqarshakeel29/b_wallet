import 'dart:convert';

import 'package:b_wallet/constants.dart';
import 'package:b_wallet/paint.dart';
import 'package:b_wallet/provider/LoginProvider.dart';
import 'package:b_wallet/provider/wallet_provider.dart';
import 'package:b_wallet/scan_qr.dart';
import 'package:b_wallet/send_screen.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRScreen extends StatefulWidget {
  final BuildContext menuScreenContext;
  final Function onScreenHideButtonPressed;
  final bool hideStatus;
  QRScreen(
      {Key key,
      this.menuScreenContext,
      this.onScreenHideButtonPressed,
      this.hideStatus = false})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return QRScreenState();
  }
}

class QRScreenState extends State<QRScreen> {
  List usageList = [];

  final walletProvider = GetIt.I<WalletProvider>();
  final loginProvider = GetIt.I<LoginProvider>();

  @override
  Widget build(BuildContext context) {
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
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
                        "QR Details",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                        ),
                      ),
                      Expanded(child: SizedBox()),
                      GestureDetector(
                        onTap: () async {
                          // showDialog(
                          //     context: context,
                          //     builder: (BuildContext context) {
                          //       return AlertDialog(
                          //         title: Center(child: Text("Waqar Shakeel")),
                          //         content: TextField(),
                          //         actions: <Widget>[
                          //           MaterialButton(
                          //               child: Text('Ok'), onPressed: () {})
                          //         ],
                          //       );
                          //     });

                          final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => QRViewScreen()));

                          print("result captured is " + result.toString());

                          String decoded =
                              stringToBase64.decode(result.toString());

                          print("result Decoded is " + decoded);
                          print(
                              "result name is :" + decoded.split("=")[0] + ":");
                          print("result number is :" +
                              decoded.split("=")[1] +
                              ":");

                          if (decoded.contains("=")) {
                            if (decoded.split("=").length == 2) {
                              var recName = decoded.split("=")[0];
                              var recNumber = decoded.split("=")[1];
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SendScreen(
                                            senderId: loginProvider
                                                .appUser.value.phoneNo
                                                .split("+92")[1],
                                            receiverId: recNumber,
                                            receiverName: recName,
                                          )));
                            } else if (decoded.split("=").length == 3) {
                              var recName = decoded.split("=")[0];
                              var recNumber = decoded.split("=")[1];
                              var amount = decoded.split("=")[2];
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SendScreen(
                                            senderId: loginProvider
                                                .appUser.value.phoneNo
                                                .split("+92")[1],
                                            receiverId: recNumber,
                                            receiverName: recName,
                                            amount: amount,
                                          )));
                            } else {
                              Fluttertoast.showToast(
                                  msg: "Wrong QR",
                                  backgroundColor:
                                      Colors.black.withOpacity(0.6),
                                  textColor: Colors.white,
                                  toastLength: Toast.LENGTH_LONG);
                            }
                          } else {
                            Fluttertoast.showToast(
                                msg: "Wrong QR",
                                backgroundColor: Colors.black.withOpacity(0.6),
                                textColor: Colors.white,
                                toastLength: Toast.LENGTH_LONG);
                          }
                        },
                        child: Icon(
                          Icons.qr_code_scanner,
                          size: 35,
                          color: Colors.white,
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
                              return Column(
                                children: [
                                  Text(
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
                    height: size.height * 0.01,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Current Balance",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.05,
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
                            child: Container(
                              child: Center(
                                child: Text(
                                  loginProvider.appUser.value.name
                                          .split(" ")[0] +
                                      "'s QR",
                                  style: TextStyle(
                                      color: Colors.black.withOpacity(0.5),
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            )),
                      )),
                  SizedBox(
                    height: size.height * 0.07,
                  ),
                  Expanded(
                    child: Container(
                      child: QrImage(
                        data: stringToBase64.encode(
                            loginProvider.appUser.value.name +
                                '=' +
                                loginProvider.appUser.value.phoneNo
                                    .split("+92")[1]),
                        version: QrVersions.auto,
                        size: MediaQuery.of(context).size.height * 0.4,
                        gapless: false,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
