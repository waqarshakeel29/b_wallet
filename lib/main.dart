import 'package:b_wallet/constants.dart';
import 'package:b_wallet/home_screen.dart';
import 'package:b_wallet/provider/LoginProvider.dart';
import 'package:b_wallet/provider/history_provider.dart';
import 'package:b_wallet/provider/home_provider.dart';
import 'package:b_wallet/provider/network_provider.dart';
import 'package:b_wallet/provider/wallet_provider.dart';
import 'package:b_wallet/shared/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';

import 'customWidget.dart';
import 'mainTest.dart';
import 'model/app_driver.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  GetIt.I.registerSingleton(NetworkProvider());
  final networkProvider = GetIt.I<NetworkProvider>();
  networkProvider.init();

  final user = FirebaseAuth.instance.currentUser;
  var name = "";
  var pid = "";
  if (user != null) {
    final userDocs = await FirebaseFirestore.instance
        .collection("user")
        .where("uid", isEqualTo: user.uid)
        .get();

    var myUser = AppUser.fromMap(userDocs.docs[0].data());
    name = myUser.name;
    pid = myUser.phoneNo;
    print("${myUser.name} logined");
  }
  GetIt.I
      .registerSingleton(LoginProvider(user: user, name: name, paymentId: pid));
  GetIt.I.registerSingleton(WalletProvider());
  GetIt.I.registerSingleton(HomeProvider());
  GetIt.I.registerSingleton(HistoryProvider());
  runApp(MyApp());
}

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: HomeScreen(),
//     );
//   }
// }

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final provider = GetIt.I<LoginProvider>();

  String phoneNo, smssent, verificationId;
  get verifiedSuccess => null;

  Future<void> verfiyPhone() async {
    final PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verId) {
      this.verificationId = verId;
    };
    final PhoneCodeSent smsCodeSent = (String verId, [int forceCodeResent]) {
      this.verificationId = verId;
      smsCodeDialoge(context).then((value) {
        print("Code Sent");
      });
    };
    final PhoneVerificationCompleted verifiedSuccess =
        (PhoneAuthCredential credential) async {};
    final PhoneVerificationFailed verifyFailed = (FirebaseAuthException e) {
      print('${e.message}');
    };
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: "+92" + numberController.text,
      timeout: const Duration(seconds: 30),
      verificationCompleted: verifiedSuccess,
      verificationFailed: verifyFailed,
      codeSent: smsCodeSent,
      codeAutoRetrievalTimeout: autoRetrieve,
    );
  }

  Future<bool> smsCodeDialoge(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: Text('Enter OTP'),
            content: TextField(
              onChanged: (value) {
                this.smssent = value;
              },
            ),
            contentPadding: EdgeInsets.all(10.0),
            actions: <Widget>[
              FlatButton(
                color: Colors.black,
                onPressed: () async {
                  if (FirebaseAuth.instance.currentUser != null) {
                    // Navigator.of(context).pop();
                    await provider.registerUserWithNumber(
                        FirebaseAuth.instance.currentUser,
                        nameController.text,
                        numberController.text,
                        pinController.text);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CustomWidgetExample(
                                menuScreenContext: context,
                              )),
                    );
                  } else {
                    Navigator.of(context).pop();
                    signIn(smssent);
                  }
                  // FirebaseAuth.instance.currentUser.then((user) {
                  //   if (user != null) {
                  //   } else {}
                  // });
                },
                child: Text(
                  'done',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          );
        });
  }

  Future<void> signIn(String smsCode) async {
    final AuthCredential credential = PhoneAuthProvider.getCredential(
      verificationId: verificationId,
      smsCode: smsCode,
    );

    await FirebaseAuth.instance
        .signInWithCredential(credential)
        .then((user) async {
      var b = await provider.registerUserWithNumber(user.user,
          nameController.text, numberController.text, pinController.text);
      if (b) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),

          // CustomWidgetExample(
          //     menuScreenContext: context,
          //   ),
        );
      } else {
        Fluttertoast.showToast(
            msg: "Not Authrized",
            backgroundColor: Colors.white,
            textColor: Colors.black,
            toastLength: Toast.LENGTH_LONG);
      }
    }).catchError((e) {
      print(e);
    });
  }

  var numberController = TextEditingController();
  var nameController = TextEditingController();
  var pinController = TextEditingController();

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);

    super.dispose();
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
      body: Padding(
        padding: EdgeInsets.only(
            left: size.width * 0.08,
            right: size.width * 0.08,
            top: size.width * 0.08),
        child: ListView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            Column(
              children: [
                SizedBox(
                  height: size.height * 0.07,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Image(
                    image: AssetImage("assets/images/crop_wallet.png"),
                    height: 150,
                  ),
                ),
                SizedBox(
                  height: size.height * 0.03,
                ),
                Text(
                  "B-Wallet",
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: AppColor.primary),
                ),
                SizedBox(
                  height: size.height * 0.05,
                ),
              ],
            ),
            Column(
              children: [
                Row(
                  children: [
                    Expanded(
                        child: Container(
                      margin: EdgeInsets.zero,
                      padding: EdgeInsets.zero,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5, right: 5),
                        child: TextField(
                          controller: nameController,
                          style: TextStyle(fontSize: 15),
                          decoration: InputDecoration(
                            hintStyle:
                                TextStyle(color: Colors.black.withOpacity(0.5)),
                            labelText: "FULL NAME",
                            // border: InputBorder.none,
                            // enabledBorder: InputBorder.none,
                            // errorBorder: InputBorder.none,
                            // disabledBorder: InputBorder.none,
                          ),
                          keyboardType: TextInputType.name,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp('[a-zA-Z ]')),
                          ],
                        ),
                      ),
                    ))
                  ],
                ),
                SizedBox(
                  height: size.height * 0.025,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.zero,
                        padding: EdgeInsets.zero,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5, right: 5),
                          child: TextField(
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            controller: numberController,
                            onChanged: (value) {
                              print(value);
                            },
                            style: TextStyle(fontSize: 15),
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              prefix: Padding(
                                padding: const EdgeInsets.only(right: 5),
                                child: Text(
                                  "+92",
                                ),
                              ),
                              hintStyle: TextStyle(
                                  color: Colors.black.withOpacity(0.5)),
                              labelText: "PHONE NUMBER",

                              // border: InputBorder.none,
                              // enabledBorder: InputBorder.none,
                              // errorBorder: InputBorder.none,
                              // disabledBorder: InputBorder.none,
                            ),
                            // onChanged: (value) {
                            // print("Chnage");
                            // setState(() {});
                            // final formatter = new NumberFormat("#,###");
                            // new Text(formatter.format(1234));
                            // print(value.substring(1, 3));
                            // numberController.text = value.substring(1, 3) +
                            //     " " +
                            //     value.substring(4, value.length);
                            // print(value.substring(4, value.length));
                            // setState(() {});
                            // if (value.length > 3) {
                            //   print(value.substring(1, 3));
                            //   numberController.text = value.substring(1, 3) +
                            //       " " +
                            //       value.substring(4, value.length);
                            //   print(value.substring(4, value.length));
                            // }
                            // },
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: size.height * 0.025,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.zero,
                        padding: EdgeInsets.zero,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5, right: 5),
                          child: TextField(
                            controller: pinController,
                            style: TextStyle(fontSize: 15),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            decoration: InputDecoration(
                              hintStyle: TextStyle(
                                  color: Colors.black.withOpacity(0.5)),
                              labelText: "PIN",
                              // border: InputBorder.none,
                              // enabledBorder: InputBorder.none,
                              // errorBorder: InputBorder.none,
                              // disabledBorder: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: size.height * 0.07,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(13.5),
              child: MaterialButton(
                color: AppColor.primary,
                child: Padding(
                    padding: const EdgeInsets.all(17.0),
                    child:
                        // codeSent
                        // ?
                        Text(
                      "Sign Up",
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
                  if (nameController.text.trim() != "") {
                    if (numberController.text.trim() != "") {
                      if (numberController.text.trim().length == 10) {
                        if (pinController.text.trim() != "") {
                          showAlertDialog(context);
                          var response = await provider
                              .isUserPresent(numberController.text);
                          Navigator.pop(context);
                          if (response != null) {
                            if (!response[0]) {
                              await verfiyPhone();
                            } else {
                              Fluttertoast.showToast(
                                  msg: "User already Exists",
                                  backgroundColor:
                                      Colors.black.withOpacity(0.6),
                                  textColor: Colors.white,
                                  toastLength: Toast.LENGTH_LONG);
                              print("User already Exists");
                            }
                          } else {
                            Fluttertoast.showToast(
                                msg: "Check network Connection",
                                backgroundColor: Colors.black.withOpacity(0.6),
                                textColor: Colors.white,
                                toastLength: Toast.LENGTH_LONG);
                            print("Check network Connection");
                          }
                        } else {
                          Fluttertoast.showToast(
                              msg: "PIN is Empty",
                              backgroundColor: Colors.black.withOpacity(0.6),
                              textColor: Colors.white,
                              toastLength: Toast.LENGTH_LONG);
                          print("PIN is Empty");
                        }
                      } else {
                        Fluttertoast.showToast(
                            msg: "Number is incorrect",
                            backgroundColor: Colors.black.withOpacity(0.6),
                            textColor: Colors.white,
                            toastLength: Toast.LENGTH_LONG);
                        print("Number is incorrect");
                      }
                    } else {
                      Fluttertoast.showToast(
                          msg: "Number is Empty",
                          backgroundColor: Colors.black.withOpacity(0.6),
                          textColor: Colors.white,
                          toastLength: Toast.LENGTH_LONG);
                      print("Number is Empty");
                    }
                  } else {
                    Fluttertoast.showToast(
                        msg: "Name is Empty",
                        backgroundColor: Colors.black.withOpacity(0.6),
                        textColor: Colors.white,
                        toastLength: Toast.LENGTH_LONG);
                    print("Name is Empty");
                  }
                },
                // onPressed: () {
                //   provider.isUserPresent(numberController.text);
                // }
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyLoginPage extends StatefulWidget {
  MyLoginPage({Key key}) : super(key: key);
  @override
  _MyLoginPageState createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {
  final provider = GetIt.I<LoginProvider>();

  var numberController = TextEditingController();
  var pinController = TextEditingController();

  bool hideText = true;

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
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
  void dispose() {
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(widget.title),
      //   backgroundColor: AppColor.primaryYellow,
      // ),
      body: Padding(
        padding: EdgeInsets.only(
            left: size.width * 0.08,
            right: size.width * 0.08,
            top: size.width * 0.08),
        child: ListView(
          physics: NeverScrollableScrollPhysics(),
          children: [
            Column(
              children: [
                SizedBox(
                  height: size.height * 0.07,
                ),
                Align(
                  alignment: Alignment.center,
                  child: Image(
                    image: AssetImage("assets/images/crop_wallet.png"),
                    height: 150,
                  ),
                ),
                SizedBox(
                  height: size.height * 0.03,
                ),
                Text(
                  "B-Wallet",
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: AppColor.primary),
                ),
                SizedBox(
                  height: size.height * 0.05,
                ),
              ],
            ),
            Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.zero,
                        padding: EdgeInsets.zero,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5, right: 5),
                          child: TextField(
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            controller: numberController,
                            style: TextStyle(fontSize: 15),
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              prefix: Padding(
                                padding: const EdgeInsets.only(right: 5),
                                child: Text("+92"),
                              ),
                              hintStyle: TextStyle(
                                  color: Colors.black.withOpacity(0.5)),
                              labelText: "PHONE NUMBER",
                              // border: InputBorder.none,
                              // enabledBorder: InputBorder.none,
                              // errorBorder: InputBorder.none,
                              // disabledBorder: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: size.height * 0.025,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.zero,
                        padding: EdgeInsets.zero,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 5, right: 5),
                          child: TextField(
                            controller: pinController,
                            style: TextStyle(fontSize: 15),
                            keyboardType: TextInputType.number,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            enableSuggestions: false,
                            autocorrect: false,
                            obscureText: hideText,
                            decoration: InputDecoration(
                              hintStyle: TextStyle(
                                  color: Colors.black.withOpacity(0.5)),
                              labelText: "PIN",
                              // border: InputBorder.none,
                              // enabledBorder: InputBorder.none,
                              // errorBorder: InputBorder.none,
                              // disabledBorder: InputBorder.none,
                              suffixIcon: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      hideText = !hideText;
                                    });
                                  },
                                  child: hideText
                                      ? Icon(Icons.visibility)
                                      : Icon(Icons.visibility_off)),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: size.height * 0.07,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(13.5),
              child: MaterialButton(
                  color: AppColor.primary,
                  child: Padding(
                      padding: const EdgeInsets.all(17.0),
                      child:
                          // codeSent
                          // ?
                          Text(
                        "SIGN IN",
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
                    var isNetConnected = await Utils.isInternetAvailable();
                    if (isNetConnected) {
                      if (numberController.text.trim() != "") {
                        if (numberController.text.trim().length != 10) {
                          Fluttertoast.showToast(
                              msg: "Wrong Number",
                              backgroundColor: Colors.black.withOpacity(0.6),
                              textColor: Colors.white,
                              toastLength: Toast.LENGTH_LONG);
                          print("Wrong Number");
                        } else {
                          if (pinController.text.trim() != "") {
                            showAlertDialog(context);
                            var response = await provider
                                .isUserPresent(numberController.text);
                            if (response != null) {
                              if (response[0]) {
                                var response = await provider.isPinCorrect(
                                    numberController.text, pinController.text);
                                print(response);
                                if (response[0]) {
                                  await provider.getUserFromNummber(
                                      "+92" + numberController.text);
                                  Navigator.pop(context);
                                  Get.offAll(() => HomeScreen());
                                } else {
                                  Navigator.pop(context);
                                  Fluttertoast.showToast(
                                      msg: "PIN Incorrect",
                                      backgroundColor:
                                          Colors.black.withOpacity(0.6),
                                      textColor: Colors.white,
                                      toastLength: Toast.LENGTH_LONG);
                                  print("PIN Incorrect");
                                }
                              } else {
                                Navigator.pop(context);
                                Fluttertoast.showToast(
                                    msg:
                                        "Number does not exist. PLEASE SIGN UP FIRST",
                                    backgroundColor:
                                        Colors.black.withOpacity(0.6),
                                    textColor: Colors.white,
                                    toastLength: Toast.LENGTH_LONG);
                                print(
                                    "Number does not exist. PLEASE SIGN UP FIRST");
                              }
                            } else {
                              Navigator.pop(context);
                            }
                            print(response);
                          } else {
                            Fluttertoast.showToast(
                                msg: "PIN Empty",
                                backgroundColor: Colors.black.withOpacity(0.6),
                                textColor: Colors.white,
                                toastLength: Toast.LENGTH_LONG);
                            print("PIN Empty");
                          }
                        }
                      } else {
                        Fluttertoast.showToast(
                            msg: "Number is Empty",
                            backgroundColor: Colors.black.withOpacity(0.6),
                            textColor: Colors.white,
                            toastLength: Toast.LENGTH_LONG);
                        print("Number is Empty");
                      }
                    } else {
                      Fluttertoast.showToast(
                          msg: "Internet is not Available",
                          backgroundColor: Colors.black.withOpacity(0.6),
                          textColor: Colors.white,
                          toastLength: Toast.LENGTH_LONG);
                      print("Internet is not Available");
                    }
                  }),
            ),
            SizedBox(
              height: size.height * 0.025,
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: const EdgeInsets.all(13.5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "FORGET PASSWORD?",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          fontSize: 15),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MyHomePage()));
                      },
                      child: Text(
                        "CREATE ACCOUNT",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColor.primary,
                            fontSize: 15),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
