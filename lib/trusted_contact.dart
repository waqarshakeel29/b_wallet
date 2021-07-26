import 'dart:convert';

import 'package:b_wallet/constants.dart';
import 'package:b_wallet/model/transaction_history.dart';
import 'package:b_wallet/paint.dart';
import 'package:b_wallet/provider/LoginProvider.dart';
import 'package:b_wallet/provider/wallet_provider.dart';
import 'package:b_wallet/qr_screen.dart';
import 'package:b_wallet/scan_qr.dart';
import 'package:b_wallet/send_screen.dart';
import 'package:b_wallet/shared/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:qr_flutter/qr_flutter.dart';

class TrustedContactScreen extends StatefulWidget {
  final BuildContext menuScreenContext;
  final Function onScreenHideButtonPressed;
  final bool hideStatus;
  TrustedContactScreen(
      {Key key,
      this.menuScreenContext,
      this.onScreenHideButtonPressed,
      this.hideStatus = false})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TrustedContactScreenState();
  }
}

class TrustedContactScreenState extends State<TrustedContactScreen> {
  List trustedList = [];

  final walletProvider = GetIt.I<WalletProvider>();
  final loginProvider = GetIt.I<LoginProvider>();

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
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    var size = MediaQuery.of(context).size;
    return Scaffold(
      drawer: Drawer(),
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
                        "Trusted List",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                        ),
                      ),
                      Expanded(child: SizedBox()),
                      // GestureDetector(
                      //   onTap: () async {
                      //     final result = await Navigator.push(
                      //         context,
                      //         MaterialPageRoute(
                      //             builder: (context) => QRViewScreen()));
                      //     print("result captured is " + result.toString());
                      //   },
                      //   child: Icon(
                      //     Icons.qr_code_scanner,
                      //     size: 35,
                      //     color: Colors.white,
                      //   ),
                      // ),
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
                      width: size.width * 0.8,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 5,
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: MaterialButton(
                                  color: AppColor.primary,
                                  child: Padding(
                                      padding: const EdgeInsets.all(17.0),
                                      child:
                                          // codeSent
                                          // ?
                                          Text(
                                        "Add \nContact",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            fontSize: 15),
                                      )),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    side: BorderSide(color: AppColor.primary),
                                  ),
                                  onPressed: () async {
                                    final result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                QRViewScreen()));
                                    print("result captured is " +
                                        result.toString());

                                    String decoded = stringToBase64
                                        .decode(result.toString());

                                    print("result Decoded is " + decoded);
                                    print("result name is :" +
                                        decoded.split("=")[0] +
                                        ":");
                                    print("result number is :" +
                                        decoded.split("=")[1] +
                                        ":");

                                    if (decoded.contains("=")) {
                                      if (decoded.split("=").length == 2) {
                                        var recName = decoded.split("=")[0];
                                        var recNumber = decoded.split("=")[1];
                                        if (!recNumber.contains(loginProvider
                                            .appUser.value.phoneNo
                                            .split("+92")[1])) {
                                          var isExist = false;
                                          for (var i in trustedList) {
                                            isExist =
                                                '${i}'.contains(recNumber);
                                            if (isExist) {
                                              break;
                                            }
                                          }
                                          if (!isExist) {
                                            showAlertDialog(context);
                                            var res = await walletProvider
                                                .addtrustedContract(
                                                    loginProvider
                                                        .appUser.value.phoneNo
                                                        .split("+92")[1],
                                                    recNumber);

                                            Navigator.pop(context);
                                            setState(() {});
                                            if (res) {
                                              Fluttertoast.showToast(
                                                  msg: "Contact Added",
                                                  backgroundColor: Colors.black
                                                      .withOpacity(0.6),
                                                  textColor: Colors.white,
                                                  toastLength:
                                                      Toast.LENGTH_LONG);
                                            } else {
                                              Fluttertoast.showToast(
                                                  msg:
                                                      "Unable to add Contact in List",
                                                  backgroundColor: Colors.black
                                                      .withOpacity(0.6),
                                                  textColor: Colors.white,
                                                  toastLength:
                                                      Toast.LENGTH_LONG);
                                            }
                                          } else {
                                            Fluttertoast.showToast(
                                                msg: "Contact Already Exists",
                                                backgroundColor: Colors.black
                                                    .withOpacity(0.6),
                                                textColor: Colors.white,
                                                toastLength: Toast.LENGTH_LONG);
                                          }
                                        } else {
                                          Fluttertoast.showToast(
                                              msg: "Cannot Add own ID",
                                              backgroundColor:
                                                  Colors.black.withOpacity(0.6),
                                              textColor: Colors.white,
                                              toastLength: Toast.LENGTH_LONG);
                                        }
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
                                          backgroundColor:
                                              Colors.black.withOpacity(0.6),
                                          textColor: Colors.white,
                                          toastLength: Toast.LENGTH_LONG);
                                    }
                                  },
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: MaterialButton(
                                  color: AppColor.primary,
                                  child: Padding(
                                      padding: const EdgeInsets.all(17.0),
                                      child:
                                          // codeSent
                                          // ?
                                          Text(
                                        "Remove \nContact",
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                            fontSize: 15),
                                      )),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    side: BorderSide(color: AppColor.primary),
                                  ),
                                  onPressed: () async {
                                    if (selectionList.length != 0) {
                                      print("Not Null");
                                      if (selectionList.contains(true)) {
                                        print("Containes");
                                        for (int i = 0;
                                            i < selectionList.length;
                                            i++) {
                                          print(selectionList[i]);
                                          if (selectionList[i]) {
                                            showAlertDialog(context);
                                            setState(() {});
                                            try {
                                              var b = await walletProvider
                                                  .removeTrustedContract(
                                                      loginProvider
                                                          .appUser.value.phoneNo
                                                          .split("+92")[1],
                                                      '${trustedList[i]}');

                                              if (b) {
                                                Fluttertoast.showToast(
                                                    msg: "Contact Removed",
                                                    backgroundColor: Colors
                                                        .black
                                                        .withOpacity(0.6),
                                                    textColor: Colors.white,
                                                    toastLength:
                                                        Toast.LENGTH_LONG);
                                              } else {
                                                Fluttertoast.showToast(
                                                    msg: "Removal Failed",
                                                    backgroundColor: Colors
                                                        .black
                                                        .withOpacity(0.6),
                                                    textColor: Colors.white,
                                                    toastLength:
                                                        Toast.LENGTH_LONG);
                                              }
                                            } catch (e) {
                                              print(e);
                                            }
                                            Navigator.pop(context);
                                            setState(() {});
                                            selectionList.clear();
                                          }
                                        }
                                      } else {
                                        Fluttertoast.showToast(
                                            msg: "No Contact Selected",
                                            backgroundColor:
                                                Colors.black.withOpacity(0.6),
                                            textColor: Colors.white,
                                            toastLength: Toast.LENGTH_LONG);
                                      }
                                    } else {}
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                  SizedBox(
                    height: size.height * 0.025,
                  ),

                  Center(
                      child: Text(
                    "Trusted Members",
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: AppColor.primary.withOpacity(0.8)),
                  )),
                  Expanded(
                    child: FutureBuilder(
                        future: getTrustedList(),
                        builder: (context, AsyncSnapshot snapshot) {
                          if (!snapshot.hasData) {
                            return Center(child: CircularProgressIndicator());
                          } else {
                            if (trustedList.length == 0) {
                              return Center(
                                  child: Text(
                                "NO CONTACT YET",
                                style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold,
                                    color: AppColor.primary.withOpacity(0.5)),
                              ));
                            }
                            print(snapshot.data);
                            return Container(
                                child: ListView.builder(
                                    itemCount: trustedList.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return listRow(
                                          trustedList[index].toString(), index);
                                    }));
                          }
                        }),
                  ),
                  // Expanded(
                  //   child: ListView.builder(
                  //     itemCount: 2,
                  //     itemBuilder: (BuildContext context, int index) {
                  //       return listRow();
                  //     },
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<bool> selectionList = [];
  // List<String> numberList = [];
  getTrustedList() async {
    var res = await walletProvider
        .getTrusteeList(loginProvider.appUser.value.phoneNo.split("+92")[1]);
    trustedList = res[0];
    print("Trusteeee");
    print(trustedList);
    // numberList = [];
    for (int i = 0; i < trustedList.length; i++) {
      selectionList.add(false);
      // numberList.add(trustedList[i]);
    }
    return trustedList;
  }

  getUserName(String number) async {
    print("USER NAMEEEEEE");
    var res = await walletProvider.getUserName(
        number); //loginProvider.appUser.value.phoneNo.split("+92")[1]
    print(res);

    return res;
  }

  var pinController = TextEditingController();

  Widget listRow(var id, var index) {
    var size = MediaQuery.of(context).size;
    return Stack(
      children: [
        GestureDetector(
          onLongPress: () {
            setState(() {
              selectionList[index] = !selectionList[index];
            });
          },
          onTap: () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Center(child: Text("SET LIMIT")),
                    content: TextField(
                      controller: pinController,
                      style: TextStyle(fontSize: 15),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(
                        hintStyle:
                            TextStyle(color: Colors.black.withOpacity(0.5)),
                        labelText: "LIMIT",
                        // border: InputBorder.none,
                        // enabledBorder: InputBorder.none,
                        // errorBorder: InputBorder.none,
                        // disabledBorder: InputBorder.none,
                      ),
                    ),
                    actions: <Widget>[
                      MaterialButton(
                          child: Text('Ok'),
                          onPressed: () {
                            Navigator.pop(context);
                          })
                    ],
                  );
                });
          },
          child: Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Container(
                // height: MediaQuery.of(context).size.height * 0.12,
                width: MediaQuery.of(context).size.width * 0.8,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  elevation: 5,
                  child: Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Name:",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.black.withOpacity(0.7),
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  FutureBuilder(
                                      future: getUserName(
                                          trustedList[index].toString()),
                                      builder:
                                          (context, AsyncSnapshot snapshot) {
                                        if (!snapshot.hasData) {
                                          return Text(
                                            "Name",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.red,
                                                fontSize: 15),
                                          );
                                        } else {
                                          return Text(
                                            snapshot.data[0]
                                                .toString()
                                                .capitalizeFirst,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.black
                                                    .withOpacity(0.7),
                                                fontSize: 19),
                                          );
                                        }
                                      }),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Send Limit:",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.red.withOpacity(0.7),
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'Rs. ${0}',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.red.withOpacity(0.7),
                                        fontSize: 19,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              //  Row(
                              //   mainAxisAlignment:
                              //       MainAxisAlignment.spaceBetween,
                              //   children: [
                              //     Text(
                              //       "Receive Limit:",
                              //       textAlign: TextAlign.center,
                              //       style: TextStyle(
                              //           color: Colors.green.withOpacity(0.7),
                              //           fontSize: 17,
                              //           fontWeight: FontWeight.bold),
                              //     ),
                              //     FutureBuilder(
                              //       future: walletProvider.gettrustedContLimit(
                              //           loginProvider.appUser.value.phoneNo
                              //               .split("+92")[1],
                              //           id),
                              //       builder: (context, AsyncSnapshot snapshot) {
                              //         if (!snapshot.hasData) {
                              //           print("DAta1");
                              //           return Text(
                              //             'Rs. ${0}',
                              //             textAlign: TextAlign.center,
                              //             style: TextStyle(
                              //                 color:
                              //                     Colors.green.withOpacity(0.7),
                              //                 fontSize: 19,
                              //                 fontWeight: FontWeight.bold),
                              //           );
                              //         } else {
                              //           print("DAta");
                              //           print(snapshot.data[0]);
                              //           return Text(
                              //             'Rs. ${snapshot.data[0]}',
                              //             textAlign: TextAlign.center,
                              //             style: TextStyle(
                              //                 color:
                              //                     Colors.green.withOpacity(0.7),
                              //                 fontSize: 19,
                              //                 fontWeight: FontWeight.bold),
                              //           );
                              //         }
                              //       },
                              //     ),
                              //   ],
                              // ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                )),
          ),
        ),
        selectionList[index]
            ? GestureDetector(
                onLongPress: () {
                  setState(() {
                    selectionList[index] = !selectionList[index];
                  });
                },
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 3, right: 3, top: 2, bottom: 0),
                  child: Container(
                      // height: MediaQuery.of(context).size.height * 0.12,
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Expanded(
                        child: Align(
                          alignment: Alignment.center,
                          child: Container(
                            decoration: BoxDecoration(
                              color: AppColor.primary.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            height: MediaQuery.of(context).size.height * 0.113,
                            width: MediaQuery.of(context).size.width * 0.8,
                          ),
                        ),
                      )),
                ),
              )
            : Container()
      ],
    );
  }

  Widget detailInfoCard(String heading, String content, Color hColor) {
    return Flexible(
      flex: 3,
      child: Align(
        alignment: Alignment.center,
        child: Container(
          width: double.maxFinite,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                heading,
                textAlign: TextAlign.center,
                style: TextStyle(color: hColor, fontSize: 17),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    content,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.black.withOpacity(0.6),
                        fontSize: 19,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
