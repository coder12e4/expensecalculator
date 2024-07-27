import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expensetracker/models/authmodels/RegisterModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/UserPersistanse/loginData.dart';
import '../models/authmodels/loginmodel.dart';
import '../services/auth/auth.dart';

final auth = Provider<Auth>((ref) => Auth());
final signUpProvider = Provider<SignUp>((ref) {
  return SignUp();
});

final regOrLoginProvider = StateProvider<bool>(
    (ref) => false); // true for registration, false for login

final StringChecker = StateProvider.family<String, String>((ref, s) {
  final k = ref.watch(auth);
  return k.validateInput(s);
});

final signUpFutureProvider =
    FutureProvider.family<Person?, Registermodel>((ref, params) async {
  final signUp = ref.watch(signUpProvider);
  return signUp.createUser(params.userEntry, params.password, params.profession,
      params.salary, params.billingAddress, "");
});

final loginWithEmailFutureProvider =
    FutureProvider.family<String, LoginModel>((ref, params) async {
  final signUp = ref.watch(signUpProvider);
  try {
    String userId =
        await signUp.singnInWithEmailUser(params.userName, params.password);

    if (userId != "userNotFound") {
      ref.read(authProvider.notifier).login(userId);
      return userId;
    } else {
      return "userNotFound";
    }
  } catch (e) {
    return "userNotFound";
  }
});

class SignUp {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<Person> createUser(
      String userEntry,
      String password,
      String profession,
      String salary,
      String billingAddress,
      String userId) async {
    try {
      UserCredential k = await _auth.createUserWithEmailAndPassword(
          email: userEntry, password: password);
      User? user = k.user;
      Person? p = getFirebaseuser(user);
      await completeProfile(
          userEntry, password, profession, salary, billingAddress, p!.id);
      return p;
    } catch (e) {
      return null!;
    }
  }

  Future<void> completeProfile(
      String userEntry,
      String password,
      String profession,
      String salary,
      String billingAddress,
      String userId) async {
    final adduser = FirebaseFirestore.instance.collection("users");

    return adduser
        .add({
          "userEntry": userEntry,
          "password": password,
          'profession': profession,
          'salary': salary,
          'billingAddress': billingAddress,
          'userId': userId
        })
        .then((value) => print("User registration Successfull"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  Future<String> singnInWithEmailUser(
    String userEntry,
    String password,
  ) async {
    try {
      UserCredential k = await _auth.signInWithEmailAndPassword(
          email: userEntry, password: password);
      User? user = k.user;
      // Person? p = getFirebaseuser(user);

      return user!.uid.toString();
    } catch (e) {
      return "userNotFount";
    }
  }

  Person? getFirebaseuser(User? user) {
    return user == null ? null : Person(user.uid);
  }
}

class Person {
  String id;
  Person(this.id);
}

final firebaseAuthProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final phoneNumberProvider = StateProvider<String>((ref) => '');
final otpCodeProvider = StateProvider<String>((ref) => '');
final verificationIdProvider = StateProvider<String?>((ref) => null);

final phoneAuthProvider =
    FutureProvider.family<void, String>((ref, phoneNumber) async {
  final auth = ref.read(firebaseAuthProvider);
  await auth.verifyPhoneNumber(
    phoneNumber:
        '+91 ${phoneNumber.substring(0, 4)} ${phoneNumber.substring(4, 7)} ${phoneNumber.substring(7)}',
    verificationCompleted: (PhoneAuthCredential credential) async {
      await auth.signInWithCredential(credential);
    },
    verificationFailed: (FirebaseAuthException e) {
      if (e.code == 'invalid-phone-number') {
        print('The provided phone number is not valid.');
      }
    },
    codeSent: (String verificationId, int? resendToken) {
      // Save verification ID to be used later
      ref.read(verificationIdProvider.notifier).state = verificationId;
      // SMS sent to user's phone
      print('SMS sent to user\'s phone number');
    },
    codeAutoRetrievalTimeout: (String verificationId) {
      ref.read(verificationIdProvider.notifier).state = verificationId;
    },
  );
});

final signInWithOTPProvider =
    FutureProvider.family<void, String>((ref, otp) async {
  final verificationId = ref.read(verificationIdProvider.notifier).state;
  if (verificationId != null) {
    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: otp,
    );
    await ref.read(firebaseAuthProvider).signInWithCredential(credential);
  }
});
