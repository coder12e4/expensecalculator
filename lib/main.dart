import 'package:expensetracker/Providers/authproviders.dart';
import 'package:expensetracker/core/CommonWidgets/CommonWidgets.dart';
import 'package:expensetracker/core/theme/ExpenceTrackerThemes.dart';
import 'package:expensetracker/models/authmodels/RegisterModel.dart';
import 'package:expensetracker/models/authmodels/loginmodel.dart';
import 'package:expensetracker/pages/home/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/UserPersistanse/loginData.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // status bar color
  ));
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyDu2DiTrKjpy9tKZ2ZCIb1IztJGHyUthSM",
        appId: "1:917353520219:android:2c16a88657f6712feaf37e",
        messagingSenderId: "917353520219",
        projectId: "expensetracker-bc659"),
  );

  runApp(const ProviderScope(child: ExpeenceTracker()));
}

class ExpeenceTracker extends StatelessWidget {
  const ExpeenceTracker({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Expense Tracker',
      themeMode: ThemeMode.system,
      darkTheme: ExpenceTrackerthemes.darkTheme,
      theme: ExpenceTrackerthemes.lightTheme,
      home: const MyHomePage(title: "dd"),
    );
  }
}

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends ConsumerState {
  final userEntry = TextEditingController();
  final password = TextEditingController();
  final confirmPassWord = TextEditingController();
  final profession = TextEditingController();
  final salary = TextEditingController();
  final billingAddress = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _obscured = true;
  void _togglePasswordVisibility() {
    setState(() {
      _obscured = !_obscured;
    });
  }

  @override
  Widget build(BuildContext context) {
    final regOrLogin = ref.watch(regOrLoginProvider.notifier).state;

    final phoneNumber = ref.watch(phoneNumberProvider.notifier).state;
    final otpCode = ref.watch(otpCodeProvider.notifier).state;
    final verificationId = ref.watch(verificationIdProvider.notifier).state;
    final phoneAuth = ref.watch(phoneAuthProvider(phoneNumber));
    final signInWithOTP = ref.watch(signInWithOTPProvider(otpCode));

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Expanded(child: SizedBox()),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.monetization_on_outlined,
                    color: Colors.red,
                    size: 34,
                  ),
                  EpTxtExtralarge(text: "Expense Tracker"),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  EpTxtLarge(text: regOrLogin ? 'Register' : 'Login'),
                ],
              ),
              const SizedBox(
                height: 12,
              ),
              TextFormField(
                controller: userEntry,
                onChanged: (value) {
                  final checkroot = ref.watch(StringChecker(value));
                  if (checkroot == "Email") {
                    print("Email");
                  } else if (checkroot == "Phone Number") {
                    ref.read(phoneNumberProvider.notifier).state =
                        "+91" + value;
                  } else {}
                },
                validator: (value) {
                  // Regular expression for validating an email
                  const emailPattern = r'^[^@]+@[^@]+\.[^@]+';
                  final emailRegExp = RegExp(emailPattern);

                  // Regular expression for validating a phone number (simple example)
                  const phonePattern = r'^\+?1?\d{9,15}$';
                  final phoneRegExp = RegExp(phonePattern);

                  if (value == null || value.isEmpty) {
                    return 'Please enter an email or phone number';
                  } else if (emailRegExp.hasMatch(value)) {
                  } else if (phoneRegExp.hasMatch(value)) {
                  } else if (!emailRegExp.hasMatch(value) &&
                      !phoneRegExp.hasMatch(value)) {
                    return 'Enter a valid email or phone number';
                  }
                  return null;
                },
                maxLines: 1,
                decoration: const InputDecoration(
                  label: Text("Enter Your Email id/Phone number"),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              TextFormField(
                  obscureText: _obscured,
                  controller: password,
                  maxLines: 1,
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length < 7) {
                      return 'Please enter password with 8 letters';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      labelText: "Enter your password",
                      suffixIcon: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 4, 0),
                        child: GestureDetector(
                          onTap: _togglePasswordVisibility,
                          child: Icon(
                            _obscured
                                ? Icons.visibility_rounded
                                : Icons.visibility_off_rounded,
                            size: 24,
                          ),
                        ),
                      ))),
              const SizedBox(
                height: 12,
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 1),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },
                child: regOrLogin
                    ? Column(
                        key: ValueKey<bool>(regOrLogin),
                        children: [
                          TextFormField(
                            controller: confirmPassWord,
                            obscureText: _obscured,
                            validator: (val) {
                              if (val!.isEmpty) return 'Empty';
                              if (val != password.text) return 'Not Match';
                              return null;
                            },
                            decoration: const InputDecoration(
                                labelText: 'Confirm password'),
                          ),
                          SizedBox(height: 10),
                          TextFormField(
                              controller: profession,
                              decoration: InputDecoration(labelText: 'Job'),
                              validator: (val) {
                                if (val!.isEmpty) return 'Empty';
                                return null;
                              }),
                          SizedBox(height: 10),
                          TextFormField(
                              controller: salary,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(labelText: 'Salary'),
                              validator: (val) {
                                if (val!.isEmpty) return 'Empty';
                                return null;
                              }),
                          SizedBox(height: 10),
                          TextFormField(
                            controller: billingAddress,
                            validator: (val) {
                              if (val!.isEmpty) return 'Empty';
                              return null;
                            },
                            decoration:
                                InputDecoration(labelText: 'Billing Address'),
                          ),
                        ],
                      )
                    : Container(
                        key: ValueKey<bool>(regOrLogin),
                      ),
              ),
              const SizedBox(
                height: 12,
              ),
              Row(
                children: [
                  Expanded(
                      child: ElevatedButton(
                    onPressed: () async {
                      //ref.read(phoneAuthProvider(userEntry.text));

                      if (_formKey.currentState!.validate()) {
                        try {
                          if (regOrLogin) {
                            final registration = ref.watch(signUpFutureProvider(
                                Registermodel(
                                    userEntry.text,
                                    password.text,
                                    profession.text,
                                    salary.text,
                                    billingAddress.text,
                                    "")));

                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text(
                                        "Registration Success,please login")));
                            ref.refresh(regOrLoginProvider.notifier).state =
                                !regOrLogin;
                          } else {
                            final loginWithEmailName = ref.watch(
                                loginWithEmailFutureProvider(LoginModel(
                                        userEntry.text, password.text))
                                    .future);

                            if (loginWithEmailName != "userNotFound") {
                              print('jhdsbc');

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const HomeScreen()),
                              );

                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("login Success")));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("user not fount")));
                            }
                          }
                        } catch (e) {
                          print(e);
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content:
                                      Text("Action faild, please try again.")));
                        }
                      }

                      print(regOrLogin);
                    },
                    child: Text(regOrLogin ? 'Register' : 'Login'),
                  ))
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                      onTap: () {
                        ref.refresh(regOrLoginProvider.notifier).state =
                            !regOrLogin;
                        _formKey.currentState?.reset();
                      },
                      child: EpTxtSmall(
                          text: regOrLogin
                              ? "Already registered?, login here"
                              : "Dont You have an account? Register here")),
                ],
              ),
              const Expanded(child: SizedBox())
            ],
          ),
        ),
      ),
    );
  }
}
