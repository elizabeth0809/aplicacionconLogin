import 'package:flutter/material.dart';

class loginFormProvider extends ChangeNotifier {
  //este key hace referencia al widget de form
  GlobalKey<FormState> formkey = new GlobalKey<FormState>();
  String email = '';
  String password = '';
  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  bool isValidForm() {
    return formkey.currentState?.validate() ?? false;
  }
}
