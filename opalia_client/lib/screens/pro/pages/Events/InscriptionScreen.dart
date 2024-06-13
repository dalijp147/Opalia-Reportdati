import 'package:flutter/material.dart';

class InscriptionScreen extends StatefulWidget {
  const InscriptionScreen({super.key});

  @override
  State<InscriptionScreen> createState() => _InscriptionScreenState();
}

class _InscriptionScreenState extends State<InscriptionScreen> {
  late FocusNode nameFocus;
  late FocusNode statutionFocus;

  late FocusNode numerotelFocus;
  late FocusNode datenaissanceFocus;
  late FocusNode nationaliteFocus;
  late FocusNode EmailFocus;
  late FocusNode DomicileFocus;
  late TextEditingController EmailController;
  late TextEditingController nameController;
  late TextEditingController statutionController;
  late TextEditingController numerotelController;
  late TextEditingController nationaliteController;
  late TextEditingController datenaissanceController;
  late TextEditingController DomicileController;
  @override
  void initState() {
    super.initState();
    //_fetchCategories();

    nameFocus = FocusNode();
    statutionFocus = FocusNode();
    numerotelFocus = FocusNode();
    datenaissanceFocus = FocusNode();
    nationaliteFocus = FocusNode();
    EmailFocus = FocusNode();
    DomicileFocus = FocusNode();
    numerotelController = TextEditingController();
    EmailController = TextEditingController();
    nameController = TextEditingController();
    statutionController = TextEditingController();
    nationaliteController = TextEditingController();
    datenaissanceController = TextEditingController();
    DomicileController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
