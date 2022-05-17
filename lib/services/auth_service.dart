import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class AuthService extends ChangeNotifier {
  final String _baseUrl = 'identitytoolkit.googleapis.com';
  final String _firebaseToken = 'AIzaSyBvLDtBsh2lY82pCOLE1kCDn-MZB3J9uxU';
  final storage = new FlutterSecureStorage();
  //si retornamos algo, es un error, si no todo esta bien
  Future<String?> createUser(String email, String password) async {
    //se crea la informacion
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };
    //se crea el url
    final url =
        Uri.https(_baseUrl, '/v1/accounts:signUp', {'key': _firebaseToken});
    final resp = await http.post(url, body: json.encode(authData));
    //aqui se decodifica la respuesta
    final Map<String, dynamic> decodedResp = json.decode(resp.body);
    if (decodedResp.containsKey('idToken')) {
      //return decodedResp['idToken'];
      await storage.write(key: 'token', value: decodedResp['idToken']);
      return null;
    } else {
      return decodedResp['error']['message'];
    }
  }

  Future<String?> login(String email, String password) async {
    //se crea la informacion
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };
    //se crea el url
    final url = Uri.https(
        _baseUrl, 'v1/accounts:signInWithPassword', {'key': _firebaseToken});
    final resp = await http.post(url, body: json.encode(authData));
    //aqui se decodifica la respuesta
    final Map<String, dynamic> decodedResp = json.decode(resp.body);

    if (decodedResp.containsKey('idToken')) {
      //return decodedResp['idToken'];
      await storage.write(key: 'token', value: decodedResp['idToken']);

      return null;
    } else {
      return decodedResp['error']['message'];
    }
  }

  Future logout() async {
    await storage.delete(key: 'token');
    return;
  }

  Future<String> readToken() async {
    return await storage.read(key: 'token') ?? '';
  }
}
