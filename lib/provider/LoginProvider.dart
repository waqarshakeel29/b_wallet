import 'dart:async';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:b_wallet/model/app_driver.dart';
import 'package:b_wallet/shared/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:path/path.dart' as path;

import 'network_provider.dart';

enum LoginResult {
  inProgress,
  notLoggedIn,
  loginSuccess,
  noUserFound,
  incorrectPassword,
  noInternet,
  emailInUse,
  passwordTooWeak,
  unknowError,
  loginWithoutPhoneSuccess,
}
enum RegistrationState {
  registeredWithEmail,
  notRegisteredWithEmail,
  registertedWithAuthProviders,
}

class LoginProvider {
  bool get isUserLoggedIn {
    return _user != null;
  }

  bool _isLoggedIn = false;

  Future<void> signOut() async {
    await auth.signOut();
    _setUser(null);
  }

  final networkProvider = GetIt.I<NetworkProvider>();
  ValueNotifier<User> userStream;
  ValueNotifier<LoginResult> loginNotifier =
      ValueNotifier(LoginResult.notLoggedIn);

  ValueNotifier<AppUser> appUser = ValueNotifier(null);
  User _user;
  // AppUser appUser;

  LoginProvider({User user, String name, String paymentId}) {
    this._user = user;
    userStream = ValueNotifier(user);

    userStream.addListener(() {
      if (_user != null)
        appUser.value = AppUser(
          name: name,
          // email: _user.email,
          // photoUrl: _user.photoURL,
          phoneNo: paymentId,
          uid: _user.uid,
        );
    });
    // initalize appUser
    if (_user != null)
      appUser.value = AppUser(
        uid: _user.uid,
        // email: _user.email,
        name: name,
        phoneNo: paymentId,
        // photoUrl: _user.photoURL
      );
  }

  isUserPresent(String userId) async {
    return await networkProvider.isUserPresent(COMPANY_ID, userId);
  }

  isPinCorrect(String userId, String pin) async {
    return await networkProvider.isPinCorrect(COMPANY_ID, userId, pin);
  }

  FirebaseAuth auth = FirebaseAuth.instance;
  RegistrationState cachedRegistrationStatus;
  formatAuthProviderName(String fullName) => fullName.replaceFirst(".com", "");

  Future<RegistrationState> checkMailRegistered(String email,
      {bool emitMessages}) async {
    print("checkMailRegisted accessed");
    if (cachedRegistrationStatus != null) return cachedRegistrationStatus;
    RegistrationState result;
    final users =
        (await FirebaseAuth.instance.fetchSignInMethodsForEmail(email));
    if (users.length == 0) {
      result = RegistrationState.notRegisteredWithEmail;
    } else if (users[0] == "password") {
      result = RegistrationState.registeredWithEmail;
    } else {
      emitMessages = emitMessages ?? true;
      if (emitMessages)
        Fluttertoast.showToast(
            msg: "You are already signed in with " +
                formatAuthProviderName(users[0]),
            backgroundColor: Colors.white,
            textColor: Colors.black,
            toastLength: Toast.LENGTH_LONG);

      result = RegistrationState.registertedWithAuthProviders;
    }
    return result;
  }

  // Future<void> signInWithGoogle() async {
  //   loginNotifier.value = LoginResult.inProgress;
  //   // Trigger the authenticaion flow
  //   final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

  //   // Obtain the auth details from the request
  //   GoogleSignInAuthentication googleAuth;
  //   try {
  //     googleAuth = await googleUser.authentication;
  //   } on PlatformException catch (e) {
  //     Fluttertoast.showToast(
  //         msg: e.message,
  //         backgroundColor: Colors.white,
  //         textColor: Colors.black,
  //         toastLength: Toast.LENGTH_LONG);
  //     loginNotifier.value = LoginResult.unknowError;
  //     return;
  //   }

  //   // Create a new credential
  //   final credential = GoogleAuthProvider.credential(
  //     accessToken: googleAuth.accessToken,
  //     idToken: googleAuth.idToken,
  //   );

  //   // Once signed in, return the UserCredential
  //   UserCredential authResult;
  //   try {
  //     authResult =
  //         (await FirebaseAuth.instance.signInWithCredential(credential));
  //   } on PlatformException catch (e) {
  //     Fluttertoast.showToast(
  //         msg: e.message,
  //         backgroundColor: Colors.white,
  //         textColor: Colors.black,
  //         toastLength: Toast.LENGTH_LONG);
  //     loginNotifier.value = LoginResult.unknowError;
  //     return;
  //   }
  //   _setUser(authResult.user);
  //   await storeUserInFirestore();

  //   // check if phone number is stored already
  //   if (await hasPhoneNoOfUser()) {
  //     loginNotifier.value = LoginResult.loginSuccess;
  //   } else {
  //     loginNotifier.value = LoginResult.loginWithoutPhoneSuccess;
  //   }
  // }

  // Future<bool> hasPhoneNoOfUser() async {
  //   final userDocs = await FirebaseFirestore.instance
  //       .collection("user")
  //       .where("email", isEqualTo: _user.email)
  //       .get();
  //   if (userDocs.docs.length == 0) {
  //     return false;
  //   }
  //   return userDocs.docs[0].data()['phoneNo'] != null;
  // }

  // Future<void> signInWithFacebook() async {
  //   UserCredential authResult;
  //   try {
  //     loginNotifier.value = LoginResult.inProgress;
  //     // Trigger the sign-in flow
  //     final result = await FacebookAuth.instance.login(
  //       permissions: ["email", "public_profile", "user_friends"],
  //     );

  //     // Create a credential from the access token
  //     final AuthCredential facebookAuthCredential =
  //         FacebookAuthProvider.credential(result.accessToken.token);

  //     // Once signed in, return the UserCredential
  //     authResult = (await FirebaseAuth.instance
  //         .signInWithCredential(facebookAuthCredential));
  //   } on PlatformException catch (e) {
  //     Fluttertoast.showToast(
  //         msg: e.message,
  //         backgroundColor: Colors.white,
  //         textColor: Colors.black,
  //         toastLength: Toast.LENGTH_LONG);
  //     loginNotifier.value = LoginResult.unknowError;
  //     return;
  //   }
  //   _setUser(authResult.user);
  //   await storeUserInFirestore();
  //   // check if phone number is stored already
  //   if (await hasPhoneNoOfUser()) {
  //     loginNotifier.value = LoginResult.loginSuccess;
  //   } else {
  //     loginNotifier.value = LoginResult.loginWithoutPhoneSuccess;
  //   }
  // }

  Future<void> loginWithEmail(String email, String password,
      {String phoneNo}) async {
    loginNotifier.value = LoginResult.inProgress;
    try {
      UserCredential result = await auth.signInWithEmailAndPassword(
          email: email, password: password);
      if (result.user != null) {
        _setUser(result.user);
        Fluttertoast.showToast(
            msg: "Sign in success",
            backgroundColor: Colors.white,
            textColor: Colors.black,
            toastLength: Toast.LENGTH_LONG);
        loginNotifier.value = LoginResult.loginSuccess;
      }
    } on PlatformException catch (exception) {
      if (exception.code == "ERROR_USER_NOT_FOUND") {
        loginNotifier.value = LoginResult.noUserFound;
        Fluttertoast.showToast(
            msg: "No user found against provided email",
            backgroundColor: Colors.white,
            textColor: Colors.black,
            toastLength: Toast.LENGTH_LONG);
      } else if (exception.code == "ERROR_WRONG_PASSWORD") {
        Fluttertoast.showToast(
            msg: "Incorrect password",
            gravity: ToastGravity.CENTER,
            backgroundColor: Colors.white,
            textColor: Colors.black,
            toastLength: Toast.LENGTH_LONG);
        loginNotifier.value = LoginResult.incorrectPassword;
      }
    }
  }

  Future<void> registerWithEmail(
      String name, String email, String password, ui.Image image,
      {String phoneNo}) async {
    loginNotifier.value = LoginResult.inProgress;
    // isLoginInProcess = true;
    // notifyListeners();
    Fluttertoast.showToast(
        msg: "Registering. Please wait...",
        backgroundColor: Colors.white,
        textColor: Colors.black,
        toastLength: Toast.LENGTH_LONG);
    UserCredential authResult;
    try {
      authResult = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on PlatformException catch (exception) {
      if (exception.code == "ERROR_EMAIL_ALREADY_IN_USE") {
        Fluttertoast.showToast(
            msg: "Email already in use",
            backgroundColor: Colors.white,
            textColor: Colors.black,
            toastLength: Toast.LENGTH_LONG);
        loginNotifier.value = LoginResult.emailInUse;
        return;
      } else if (exception.code == "ERROR_WEAK_PASSWORD") {
        Fluttertoast.showToast(
            msg: "Password too weak. Use a combination of letters and numbers",
            backgroundColor: Colors.white,
            textColor: Colors.black,
            toastLength: Toast.LENGTH_LONG);
        loginNotifier.value = LoginResult.passwordTooWeak;
        return;
      }
    }
    _setUser(authResult.user);

    // set data of {user}

    // String imageUrl;
    // if (image != null) {
    //   imageUrl = await uploadUserImage(image);
    // }

    // await updateUserName(name, imageUrl);

    await storeUserInFirestore(phoneNo: phoneNo);
    if (!_user.emailVerified) {
      _user.sendEmailVerification();
    }

    Fluttertoast.showToast(msg: "Registration success");
    loginNotifier.value = LoginResult.loginSuccess;
  }

  Future<bool> registerUserWithNumber(
      User user, String name, String phoneForRegister, String pin) async {
    _setUser(user);
    storeUserInFirestore(phoneNo: user.phoneNumber, name: name);

    bool resp = await networkProvider.addUserInCompany(
        COMPANY_ID, name, "0", phoneForRegister, pin);

    if (resp != null) {
      return true;
    }
    return false;
  }

  Future<void> _setUser(User user) async {
    this._user = user;
    userStream.value = user;
    // remove all cached state
    cachedRegistrationStatus = null;
  }

  // Future<String> uploadUserImage(ui.Image toUpload) async {
  //   var byteData = await toUpload.toByteData(format: ui.ImageByteFormat.png);
  //   var buffer = byteData.buffer.asUint8List();

  //   Directory tempDir = await getTemporaryDirectory();
  //   String tempPath = tempDir.path;
  //   String tempFilePath = path.join(tempPath, "temp.png");
  //   final fileToUpload = File(tempFilePath)..writeAsBytesSync(buffer);

  //   final storage = FirebaseStorage.instance;
  //   // final StorageMetadata metaData = StorageMetadata()
  //   final snapshot = await storage
  //       .ref()
  //       .child("user/profile_picture/${_user.uid}.png")
  //       .putFile(fileToUpload)
  //       .onComplete;
  //   return await snapshot.ref.getDownloadURL();
  // }

  Future<void> updateUserName(String name, String imageUrl,
      {String password}) async {
    // if (name == null && imageUrl == null && password == null) return null;
    // UserUpdateInfo userUpdateInfo = new UserUpdateInfo();
    // if (name != null) userUpdateInfo.displayName = name;
    // if (imageUrl != null) userUpdateInfo.photoUrl = imageUrl;
    if (name != null) await _user.updateProfile(displayName: name);
    if (imageUrl != null) await _user.updateProfile(photoURL: imageUrl);

    await _user.reload();
    _setUser(auth.currentUser);
  }

  Future<AppUser> getUserFromUid(String uid) async {
    final userDocs = await FirebaseFirestore.instance
        .collection("user")
        .where("uid", isEqualTo: _user.uid)
        .get();

    var user = AppUser.fromMap(userDocs.docs[0].data());
    return user;
  }

  Future<AppUser> getUserFromNummber(String number) async {
    final userDocs = await FirebaseFirestore.instance
        .collection("user")
        .where("phoneNo", isEqualTo: number)
        .get();

    print("result");
    print(userDocs.docs);
    var user = AppUser.fromMap(userDocs.docs[0].data());
    final Map<String, dynamic> dataToUpload = {
      "uid": user.uid,
      "name": user.name,
      // "email": _user.email,
      "phoneNo": user.phoneNo,
      // "games": userGames.map((e) => e.id).toList(),
    };
    appUser.value = AppUser.fromMap(dataToUpload);
    appUser.notifyListeners();

    return user;
  }

  Future<void> storeUserInFirestore(
      {bool isUpdate = false, String phoneNo, String name}) async {
    if (!isUpdate) {
      final userDocs = await FirebaseFirestore.instance
          .collection("user")
          .where("uid", isEqualTo: _user.uid)
          .get();
      //already saved user
      if (userDocs.docs.length > 0) return;
    }
    final Map<String, dynamic> dataToUpload = {
      "uid": _user.uid,
      "name": _user.displayName == null ? name : _user.displayName,
      // "email": _user.email,
      "phoneNo": phoneNo,
      // "games": userGames.map((e) => e.id).toList(),
    };

    // if (_user.photoURL != null) {
    //   dataToUpload.putIfAbsent("photoUrl", () => _user.photoURL);
    //   // final photoBytes = (await get(_user.photoUrl)).bodyBytes;
    //   // var blurHash = await BlurHash.encode(photoBytes, 4, 3);
    //   // dataToUpload.putIfAbsent("photoBlurHash", () => blurHash);
    // }
    await FirebaseFirestore.instance
        .collection("user")
        .doc(
          _user.uid,
        )
        .set(dataToUpload)
        .then((value) {
      appUser.value = AppUser.fromMap(dataToUpload);
      appUser.notifyListeners();
    });
  }

  // Future<File> pickImageForRegistration() async {
  //   final picker = ImagePicker();
  //   final pickedFile = await picker.getImage(
  //       source: ImageSource.gallery,
  //       imageQuality: 70,
  //       maxHeight: 1000,
  //       maxWidth: 1000);
  //   if (pickedFile != null) return File(pickedFile.path);
  //   return null;
  // }

  Future<AppUser> getFirestoreUserFromEmail(String email) async {
    final docs = (await (FirebaseFirestore.instance
            .collection("user")
            .where("email", isEqualTo: email)
            .get()))
        .docs;
    if (docs[0] != null) return AppUser.fromMap(docs[0].data());
    return null;
  }

  Future<void> updatePassword(String password) async {
    if (password != null) {
      try {
        await _user.updatePassword(password);
        _setUser(null);
        Fluttertoast.showToast(
            msg: "Password updated. Please sign in again",
            backgroundColor: Colors.white,
            textColor: Colors.black,
            toastLength: Toast.LENGTH_LONG);
      } catch (e) {
        Fluttertoast.showToast(
            msg: e.message,
            backgroundColor: Colors.white,
            textColor: Colors.black,
            toastLength: Toast.LENGTH_LONG);
      }
    }
  }

  Future<void> updateUserProfile({String name, ui.Image image}) async {
    String imageUrl;
    // if (image != null) {
    //   imageUrl = await uploadUserImage(image);
    // }

    await updateUserName(
      name,
      imageUrl,
    );
    await storeUserInFirestore(isUpdate: true);
    Fluttertoast.showToast(
        msg: "Profile updated",
        backgroundColor: Colors.white,
        textColor: Colors.black,
        toastLength: Toast.LENGTH_LONG);
  }

  Future<void> sendResetPasswordEmail(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email);
    } on PlatformException catch (e) {
      Fluttertoast.showToast(
          msg: e.message,
          backgroundColor: Colors.white,
          textColor: Colors.black,
          toastLength: Toast.LENGTH_LONG);
    }
  }
}
