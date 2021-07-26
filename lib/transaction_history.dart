import 'package:b_wallet/constants.dart';
import 'package:b_wallet/model/transaction_history.dart';
import 'package:b_wallet/paint.dart';
import 'package:b_wallet/provider/LoginProvider.dart';
import 'package:b_wallet/provider/history_provider.dart';
import 'package:b_wallet/provider/home_provider.dart';
import 'package:b_wallet/provider/wallet_provider.dart';
import 'package:b_wallet/qr_screen.dart';
import 'package:b_wallet/scan_qr.dart';
import 'package:b_wallet/send_screen.dart';
import 'package:b_wallet/shared/utils.dart';
import 'package:b_wallet/trusted_contact.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter_range_slider/flutter_range_slider.dart' as frs;

class TransactionHistoryScreen extends StatefulWidget {
  final BuildContext menuScreenContext;
  final Function onScreenHideButtonPressed;
  final bool hideStatus;
  TransactionHistoryScreen(
      {Key key,
      this.menuScreenContext,
      this.onScreenHideButtonPressed,
      this.hideStatus = false})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TransactionHistoryScreenState();
  }
}

class TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  // List<TransactionHistory> historyList = [];

  var selectedIndex = 0;
  int selected = 2;
  int tempSelected = 2;
  TextEditingController amountController = TextEditingController(text: "50");

  final walletProvider = GetIt.I<WalletProvider>();
  final loginProvider = GetIt.I<LoginProvider>();
  final homeProvider = GetIt.I<HistoryProvider>();

  // double _lowerValue = 20.0;
  // double _upperValue = 80.0;
  // double _lowerValueFormatter = 20.0;
  // double _upperValueFormatter = 20.0;

  @override
  void initState() {
    super.initState();

    var today = DateTime.now();
    today.year;
    today.month;
    today.day;
    var f = NumberFormat("00");
    startDate = f.format(today.day).toString() +
        "-" +
        f.format(today.month).toString() +
        "-" +
        f.format(today.year).toString();

    selectedDate1 = DateTime(
      today.year,
      today.month,
      today.day,
    );
    tempDate1 = selectedDate1;

    selectedDate2 = DateTime(
      today.year,
      today.month,
      1,
    );
    tempDate2 = selectedDate2;

    endDate = f.format(1).toString() +
        "-" +
        f.format(today.month).toString() +
        "-" +
        f.format(today.year).toString();
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
              padding: const EdgeInsets.all(8.0),
              child: Material(
                type: MaterialType.transparency,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Transactions",
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: AppColor.primary),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.1,
                      child: GridView.count(
                          crossAxisCount: 3,
                          childAspectRatio: 2.0,
                          padding: const EdgeInsets.all(4.0),
                          mainAxisSpacing: 4.0,
                          crossAxisSpacing: 4.0,
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                color: true ? AppColor.primary : Colors.white,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Center(
                                child: Text(
                                  "From",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      color: true
                                          ? Colors.white
                                          : AppColor.primary),
                                ),
                              ),
                              width: 10,
                              height: 10,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: true ? AppColor.primary : Colors.white,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Center(
                                child: Text(
                                  "To",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      color: true
                                          ? Colors.white
                                          : AppColor.primary),
                                ),
                              ),
                              width: 10,
                              height: 10,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: true ? AppColor.primary : Colors.white,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Center(
                                child: Text(
                                  "All",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      color: true
                                          ? Colors.white
                                          : AppColor.primary),
                                ),
                              ),
                              width: 10,
                              height: 10,
                            ),
                          ].toList()),
                    ),
                    Text(
                      "Transactions",
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: AppColor.primary),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.1,
                      child: GridView.count(
                          crossAxisCount: 3,
                          childAspectRatio: 2.0,
                          padding: const EdgeInsets.all(4.0),
                          mainAxisSpacing: 4.0,
                          crossAxisSpacing: 4.0,
                          children: <Widget>[
                            Container(
                              decoration: BoxDecoration(
                                color: true ? AppColor.primary : Colors.white,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Center(
                                child: Text(
                                  "From",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      color: true
                                          ? Colors.white
                                          : AppColor.primary),
                                ),
                              ),
                              width: 10,
                              height: 10,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: true ? AppColor.primary : Colors.white,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Center(
                                child: Text(
                                  "To",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      color: true
                                          ? Colors.white
                                          : AppColor.primary),
                                ),
                              ),
                              width: 10,
                              height: 10,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: true ? AppColor.primary : Colors.white,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Center(
                                child: Text(
                                  "All",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      color: true
                                          ? Colors.white
                                          : AppColor.primary),
                                ),
                              ),
                              width: 10,
                              height: 10,
                            ),
                          ].toList()),
                    ),

                    // frs.RangeSlider(
                    //   min: 0.0,
                    //   max: 100.0,
                    //   lowerValue: _lowerValue,
                    //   upperValue: _upperValue,
                    //   divisions: 5,
                    //   showValueIndicator: true,
                    //   valueIndicatorMaxDecimals: 1,
                    //   onChanged: (double newLowerValue, double newUpperValue) {
                    //     setState(() {
                    //       _lowerValue = newLowerValue;
                    //       _upperValue = newUpperValue;
                    //     });
                    //   },
                    //   onChangeStart:
                    //       (double startLowerValue, double startUpperValue) {
                    //     print(
                    //         'Started with values: $startLowerValue and $startUpperValue');
                    //   },
                    //   onChangeEnd:
                    //       (double newLowerValue, double newUpperValue) {
                    //     print(
                    //         'Ended with values: $newLowerValue and $newUpperValue');
                    //   },
                    // ),
                  ],
                ),
              ),
            ),
            // margin: EdgeInsets.only(bottom: 50, left: 12, right: 12),
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
      body: Stack(
        children: [
          // Container(
          //   width: MediaQuery.of(context).size.width,
          //   height: MediaQuery.of(context).size.height * 0.256,
          //   decoration: BoxDecoration(
          //     borderRadius: BorderRadius.circular(10.0),
          //     color: AppColor.primary,
          //   ),
          // ),

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
                        "Transaction History",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                        ),
                      ),
                      Expanded(child: SizedBox()),
                    ],
                  ),
                  SizedBox(
                    height: size.height * 0.04,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      width: size.width * 0.785,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              Text(
                                "From:",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              GestureDetector(
                                onTap: () {
                                  startDatePicker();
                                },
                                child: Container(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      startDate,
                                      style: TextStyle(
                                        color: AppColor.primary,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Expanded(
                            child: SizedBox(
                                // width: size.height * 0.02,
                                ),
                          ),
                          Row(
                            children: [
                              Text(
                                "To:",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              GestureDetector(
                                onTap: () {
                                  endDatePicker();
                                },
                                child: Container(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      endDate,
                                      style: TextStyle(
                                        color: AppColor.primary,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // Expanded(child: SizedBox()),
                          // GestureDetector(
                          //   onTap: () {
                          //     showDialog();
                          //   },
                          //   child: Icon(
                          //     Icons.filter_list,
                          //     size: 30,
                          //     color: Colors.white,
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(
                    height: size.height * 0.02,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.06,
                    child: GridView.count(
                        crossAxisCount: 3,
                        childAspectRatio: 2.6,
                        padding: const EdgeInsets.all(4.0),
                        mainAxisSpacing: 30.0,
                        crossAxisSpacing: 30.0,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                tempSelected = 0;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: tempSelected == 0
                                    ? AppColor.primary
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Center(
                                child: Text(
                                  "Received",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: tempSelected == 0
                                          ? Colors.white
                                          : AppColor.primary),
                                ),
                              ),
                              width: 10,
                              height: 10,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                tempSelected = 1;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: tempSelected == 1
                                    ? AppColor.primary
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Center(
                                child: Text(
                                  "Sent",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: tempSelected == 1
                                          ? Colors.white
                                          : AppColor.primary),
                                ),
                              ),
                              width: 10,
                              height: 10,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                tempSelected = 2;
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: tempSelected == 2
                                    ? AppColor.primary
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Center(
                                child: Text(
                                  "All",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: tempSelected == 2
                                          ? Colors.white
                                          : AppColor.primary),
                                ),
                              ),
                              width: 10,
                              height: 10,
                            ),
                          ),
                        ].toList()),
                  ),

                  Center(
                    child: MaterialButton(
                        color: AppColor.primary,
                        child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Text(
                              "APPLY",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 18),
                            )),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          side: BorderSide(color: AppColor.primary),
                        ),
                        // onPressed: () {},
                        onPressed: () async {
                          selectedDate1 = tempDate1;
                          selectedDate2 = tempDate2;
                          selected = tempSelected;
                          // List<TransactionHistory> data =
                          //     await homeProvider.getListTrnsactionHistory(
                          //         selectedDate1, selectedDate2, selected);
                          // for (int i = 0; i < data.length; i++) {
                          //   if (walletProvider.isReceived(data[i])) {
                          //     var d = await walletProvider
                          //         .getUserName('${data[i].sender}');
                          //     data[i].name = d[0];
                          //   } else {
                          //     var d = await walletProvider
                          //         .getUserName('${data[i].reciver}');
                          //     data[i].name = d[0];
                          //   }
                          // }
                          // print("DATA");
                          // print(data);
                          setState(() {});
                        }),
                  ),
                  SizedBox(
                    height: size.height * 0.012,
                  ),
                  Expanded(
                    child: FutureBuilder(
                        future: homeProvider.getListTrnsactionHistory(
                            selectedDate1, selectedDate2, selected),
                        // selectedDate1.day,
                        // selectedDate1.month,
                        // selectedDate1.year,
                        // selectedDate2.day,
                        // selectedDate2.month,
                        // selectedDate2.year),
                        builder: (context, AsyncSnapshot snapshot) {
                          if (!snapshot.hasData) {
                            return Center(child: CircularProgressIndicator());
                          } else {
                            if (snapshot.data.length == 0) {
                              return Center(
                                  child: Text(
                                "NO RESULT FOUND",
                                style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    color: AppColor.primary.withOpacity(0.8)),
                              ));
                            }
                            return Container(
                                child: ListView.builder(
                                    itemCount: snapshot.data.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return listRow(snapshot.data[index]);
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
                                    ? "Received From"
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
                                  FutureBuilder(
                                      future: homeProvider
                                          .getUserName(transactionHistory),
                                      builder:
                                          (context, AsyncSnapshot snapshot) {
                                        if (!snapshot.hasData) {
                                          return Text(
                                            "N/A",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color:
                                                    walletProvider.isReceived(
                                                            transactionHistory)
                                                        ? Colors.green
                                                        : Colors.red,
                                                fontSize: 15),
                                          );
                                        } else {
                                          return Flexible(
                                            child: Text(
                                              // "Waqar Shakeel asdd asdas "
                                              (() {
                                                var namelist = snapshot.data[0]
                                                    .toString()
                                                    .split(" ");
                                                if (namelist.length > 1) {
                                                  return namelist[0]
                                                          .capitalizeFirst +
                                                      " " +
                                                      namelist[1]
                                                          .capitalizeFirst;
                                                } else {
                                                  return namelist[0]
                                                      .capitalizeFirst;
                                                }
                                                // return
                                              }()),

                                              // snapshot.data[0]
                                              //     .toString()
                                              //     .capitalizeFirst,
                                              textAlign: TextAlign.center,
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color:
                                                      walletProvider.isReceived(
                                                              transactionHistory)
                                                          ? Colors.green
                                                          : Colors.red,
                                                  fontSize: 19),
                                            ),
                                          );
                                        }
                                      }),
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

  bool isDateVisible = false;
  DateTime selectedDate1 = null;
  DateTime selectedDate2 = null;
  DateTime tempDate1 = null;
  DateTime tempDate2 = null;
  String startDate = "S";
  String endDate = "E";

  void startDatePicker() {
    var f = NumberFormat("00");
    DateTime _selectedDateTime;
    showCupertinoModalPopup(
        context: context,
        builder: (_) => Container(
              height: 300,
              color: Color.fromARGB(255, 255, 255, 255),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: Container(
                      height: 200,
                      child: CupertinoDatePicker(
                          mode: CupertinoDatePickerMode.date,
                          initialDateTime: DateTime.now(),
                          maximumDate: DateTime.now(),
                          // minimumDate: DateTime.now(),
                          // initialDateTime: isDateVisible
                          //     ? selectedDate1.millisecondsSinceEpoch <
                          //             DateTime.now().millisecondsSinceEpoch
                          //         ? DateTime.now()
                          //         : selectedDate1
                          // : DateTime.now(),
                          // minimumDate: DateTime.now(),
                          onDateTimeChanged: (val) {
                            _selectedDateTime = val;
                          }),
                    ),
                  ),

                  // Close the modal
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CupertinoButton(
                        child: Text(
                          'OK',
                          style: TextStyle(color: AppColor.primary),
                        ),
                        onPressed: () {
                          if (_selectedDateTime == null) {
                            _selectedDateTime = DateTime.now();
                          }

                          var temp = DateTime(_selectedDateTime.year,
                              _selectedDateTime.month, _selectedDateTime.day);
                          if (temp.compareTo(selectedDate2) >= 0) {
                            setState(() {
                              isDateVisible = true;
                              // selectedDate = selectedDate;

                              startDate = f.format(temp.day).toString() +
                                  "-" +
                                  f.format(temp.month).toString() +
                                  "-" +
                                  f.format(temp.year).toString();
                            });
                            tempDate1 = temp;
                          } else {
                            Fluttertoast.showToast(
                                msg: "Start Date must be greater than End Date",
                                backgroundColor: Colors.black.withOpacity(0.6),
                                textColor: Colors.white,
                                toastLength: Toast.LENGTH_LONG);
                          }
                          Navigator.of(context).pop();
                        },
                      ),
                      Flexible(
                          flex: 1,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.08,
                          )),
                      CupertinoButton(
                        child: Text(
                          'CANCEL',
                          style: TextStyle(color: Colors.red),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  )
                ],
              ),
            ));
  }

  void endDatePicker() {
    var f = NumberFormat("00");
    DateTime _selectedDateTime;
    showCupertinoModalPopup(
        context: context,
        builder: (_) => Container(
              height: 300,
              color: Color.fromARGB(255, 255, 255, 255),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
                    child: Container(
                      height: 200,
                      child: CupertinoDatePicker(
                          mode: CupertinoDatePickerMode.date,
                          initialDateTime: DateTime.now(),
                          maximumDate: DateTime.now(),

                          //     ? selectedDate2.millisecondsSinceEpoch <
                          //             DateTime.now().millisecondsSinceEpoch
                          //         ? DateTime.now()
                          //         : selectedDate2
                          //     : DateTime.now(),
                          // minimumDate: DateTime.now(),
                          onDateTimeChanged: (val) {
                            _selectedDateTime = val;
                          }),
                    ),
                  ),

                  // Close the modal
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CupertinoButton(
                        child: Text(
                          'OK',
                          style: TextStyle(color: AppColor.primary),
                        ),
                        onPressed: () {
                          if (_selectedDateTime == null) {
                            _selectedDateTime = DateTime.now();
                          }

                          var temp = DateTime(_selectedDateTime.year,
                              _selectedDateTime.month, _selectedDateTime.day);

                          if (temp.compareTo(tempDate1) <= 0) {
                            setState(() {
                              isDateVisible = true;
                              // selectedDate = selectedDate;

                              endDate = f.format(temp.day).toString() +
                                  "-" +
                                  f.format(temp.month).toString() +
                                  "-" +
                                  f.format(temp.year).toString();
                            });
                            tempDate2 = temp;
                          } else {
                            Fluttertoast.showToast(
                                msg:
                                    "End Date must be smaller or equl to Start Date",
                                backgroundColor: Colors.black.withOpacity(0.6),
                                textColor: Colors.white,
                                toastLength: Toast.LENGTH_LONG);
                          }
                          Navigator.of(context).pop();
                        },
                      ),
                      Flexible(
                          flex: 1,
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.08,
                          )),
                      CupertinoButton(
                        child: Text(
                          'CANCEL',
                          style: TextStyle(color: Colors.red),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  )
                ],
              ),
            ));
  }
}
