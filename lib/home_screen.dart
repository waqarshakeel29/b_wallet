import 'package:b_wallet/constants.dart';
import 'package:b_wallet/model/transaction_history.dart';
import 'package:b_wallet/paint.dart';
import 'package:b_wallet/provider/LoginProvider.dart';
import 'package:b_wallet/provider/home_provider.dart';
import 'package:b_wallet/provider/wallet_provider.dart';
import 'package:b_wallet/qr_screen.dart';
import 'package:b_wallet/scan_qr.dart';
import 'package:b_wallet/send_screen.dart';
import 'package:b_wallet/shared/utils.dart';
import 'package:b_wallet/transaction_history.dart';
import 'package:b_wallet/trusted_contact.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:qr_flutter/qr_flutter.dart';

import 'borrow_screen.dart';
import 'main.dart';

class HomeScreen extends StatefulWidget {
  final BuildContext menuScreenContext;
  final Function onScreenHideButtonPressed;
  final bool hideStatus;
  HomeScreen(
      {Key key,
      this.menuScreenContext,
      this.onScreenHideButtonPressed,
      this.hideStatus = false})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return HomeScreenState();
  }
}

class HomeScreenState extends State<HomeScreen> {
  // List<TransactionHistory> historyList = [];

  final walletProvider = GetIt.I<WalletProvider>();
  final loginProvider = GetIt.I<LoginProvider>();
  final homeProvider = GetIt.I<HomeProvider>();

  @override
  void initState() {
    super.initState();
    loginProvider.appUser.addListener(() {
      setState(() {});
    });

    walletProvider.balance.addListener(() {
      setState(() {});
    });

    // getData();
  }

  getData() async {
    return await walletProvider
        .getBalance(loginProvider.appUser.value.phoneNo.split("+92")[1]);
  }

  void showDialog() {
    showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 700),
      context: context,
      pageBuilder: (_, __, ___) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.5,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  QrImage(
                    data: loginProvider.appUser.value.phoneNo.split("+92")[1],
                    version: QrVersions.auto,
                    size: MediaQuery.of(context).size.height * 0.35,
                    gapless: false,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      loginProvider.appUser.value.name.split(" ")[0] + "'s QR",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            margin: EdgeInsets.only(bottom: 50, left: 12, right: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        return SlideTransition(
          position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim),
          child: child,
        );
      },
    );
  }

  var scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      key: scaffoldKey,
      endDrawer: Drawer(
        child: Container(
          color: AppColor.primary,
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Container(
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      'Hello, \n' + loginProvider.appUser.value.name,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyle(color: Colors.white, fontSize: 40),
                    )),
              ),
              Divider(
                color: Colors.white,
              ),
              ListTile(
                title: Row(
                  children: <Widget>[
                    Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Icon(
                          Icons.home,
                          size: 35,
                          color: Colors.white,
                        )),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Home',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TransactionHistoryScreen()));
                },
                child: ListTile(
                  title: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Icon(
                          Icons.person_outline,
                          color: Colors.white,
                          size: 35,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'History',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BorrowScreen()));
                },
                child: ListTile(
                  title: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Icon(
                          Icons.person_outline,
                          color: Colors.white,
                          size: 35,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Borrow',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ),
              ListTile(
                title: Row(
                  children: <Widget>[
                    Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Icon(
                          Icons.help,
                          size: 35,
                          color: Colors.white,
                        )),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Help',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ],
                ),
              ),
              ListTile(
                title: Row(
                  children: <Widget>[
                    Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Icon(
                          Icons.info,
                          size: 35,
                          color: Colors.white,
                        )),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'About',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ],
                ),
              ),
              ListTile(
                title: Row(
                  children: <Widget>[
                    Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Icon(
                          Icons.settings,
                          size: 35,
                          color: Colors.white,
                        )),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Feedback',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ],
                ),
              ),
              ListTile(
                title: Row(
                  children: <Widget>[
                    Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Icon(
                          Icons.developer_mode,
                          size: 35,
                          color: Colors.white,
                        )),
                    SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.offAll(MyLoginPage());
                      },
                      child: Text(
                        'Logout',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
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
                        "Home",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                        ),
                      ),
                      Expanded(child: SizedBox()),
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
                                        "QR \nDetails",
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
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => QRScreen()));
                                    setState(() {});
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
                                        "Trusted \nContact",
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
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                TrustedContactScreen()));
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
                    "Recent Transactions",
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: AppColor.primary.withOpacity(0.8)),
                  )),
                  Expanded(
                    child: FutureBuilder(
                        future: homeProvider.getListTrnsactionHistory(),
                        builder: (context, AsyncSnapshot snapshot) {
                          if (!snapshot.hasData) {
                            return Center(child: CircularProgressIndicator());
                          } else {
                            return Container(
                                child: ListView.builder(
                                    itemCount: homeProvider.historyList.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return listRow(
                                          homeProvider.historyList[index]);
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
          Positioned(
            right: 35,
            top: (size.height * 0.09) - 10,
            child: IconButton(
              icon: Icon(
                Icons.menu,
                size: 30,
                color: Colors.white,
              ),
              onPressed: () => scaffoldKey.currentState.openEndDrawer(),
            ),
          ),
        ],
      ),
    );
  }

  Widget listRow(TransactionHistory transactionHistory) {
    var size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
          height: MediaQuery.of(context).size.height * 0.1,
          width: MediaQuery.of(context).size.width * 0.8,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              transactionHistory.day.toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: walletProvider
                                          .isReceived(transactionHistory)
                                      ? Colors.green
                                      : Colors.red,
                                  fontSize: 17),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  Utils.intToDay(transactionHistory.month),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.black.withOpacity(0.6),
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(
                    child: VerticalDivider(
                      thickness: 1,
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                walletProvider.isReceived(transactionHistory)
                                    ? "Reveived From"
                                    : "Sent To",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black.withOpacity(0.6),
                                    fontSize: 15),
                              ),
                              SizedBox(
                                height: size.height * 0.003,
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(
                                      // "Waqar Shakeel asdd asdas "
                                      (() {
                                        var namelist = transactionHistory.name
                                            .toString()
                                            .split(" ");
                                        if (namelist.length > 1) {
                                          return namelist[0].capitalizeFirst +
                                              " " +
                                              namelist[1].capitalizeFirst;
                                        } else {
                                          return namelist[0].capitalizeFirst;
                                        }
                                        // return
                                      }()),
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          color: walletProvider.isReceived(
                                                  transactionHistory)
                                              ? Colors.green
                                              : Colors.red,
                                          fontSize: 19,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  // FutureBuilder(
                                  //     future: homeProvider
                                  //         .getUserName(transactionHistory),
                                  //     builder:
                                  //         (context, AsyncSnapshot snapshot) {
                                  //       if (!snapshot.hasData) {
                                  //         return Text(
                                  //           "N/A",
                                  //           textAlign: TextAlign.center,
                                  //           style: TextStyle(
                                  //               color:
                                  //                   walletProvider.isReceived(
                                  //                           transactionHistory)
                                  //                       ? Colors.green
                                  //                       : Colors.red,
                                  //               fontSize: 15),
                                  //         );
                                  //       } else {
                                  //         return Flexible(
                                  //           child: Text(
                                  //             // "Waqar Shakeel asdd asdas "
                                  //             (() {
                                  //               var namelist = snapshot.data[0]
                                  //                   .toString()
                                  //                   .split(" ");
                                  //               if (namelist.length > 1) {
                                  //                 return namelist[0]
                                  //                         .capitalizeFirst +
                                  //                     " " +
                                  //                     namelist[1]
                                  //                         .capitalizeFirst;
                                  //               } else {
                                  //                 return namelist[0]
                                  //                     .capitalizeFirst;
                                  //               }
                                  //               // return
                                  //             }()),
                                  //             textAlign: TextAlign.center,
                                  //             overflow: TextOverflow.ellipsis,
                                  //             style: TextStyle(
                                  //                 color:
                                  //                     walletProvider.isReceived(
                                  //                             transactionHistory)
                                  //                         ? Colors.green
                                  //                         : Colors.red,
                                  //                 fontSize: 19,
                                  //                 fontWeight: FontWeight.bold),
                                  //           ),
                                  //         );
                                  //       }
                                  //     }),

                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    transactionHistory.amount.toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: walletProvider
                                                .isReceived(transactionHistory)
                                            ? Colors.green.withOpacity(0.7)
                                            : Colors.red.withOpacity(0.7),
                                        fontSize: 19,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )),
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
