import 'package:flutter/material.dart';

class EpTxtSmall extends StatelessWidget {
  final String text;
  const EpTxtSmall({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodySmall,
    );
  }
}

class EpTxtMedium extends StatelessWidget {
  final String text;
  const EpTxtMedium({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }
}

class EpTxtLarge extends StatelessWidget {
  final String text;
  const EpTxtLarge({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.titleLarge,
    );
  }
}

class EpTxtExtralarge extends StatelessWidget {
  final String text;
  const EpTxtExtralarge({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.headlineLarge,
    );
  }
}

class ExpTextField extends StatelessWidget {
  final String labal;
  final TextEditingController textEditingController;
  final bool ObsecuredText;
  final Icon icon;
  const ExpTextField(
      {super.key,
      required this.labal,
      required this.textEditingController,
      required this.ObsecuredText,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textEditingController,
      obscureText: ObsecuredText,
      decoration: InputDecoration(suffixIcon: icon, label: Text(labal)),
    );
  }
}
