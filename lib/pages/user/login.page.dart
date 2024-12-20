// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:d_info/d_info.dart';
import 'package:d_method/d_method.dart';
import 'package:flutter/material.dart';
import 'package:flutter_asset_management/config/app_constant.dart';
import 'package:flutter_asset_management/pages/asset/home_page.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final edtUsername = TextEditingController();
  final edtPassword = TextEditingController();
  final formKey = GlobalKey<FormState>();

  void login(BuildContext context) {
    bool isValid = (formKey.currentState!.validate());
    if (isValid) {
      // Tervalidasi
      Uri url = Uri.parse(
        '${AppConstant.baseUrl}/user/login.php',
      );
      http.post(url, body: {
        'username': edtUsername.text,
        'password': edtPassword.text,
      }).then(
        (response) {
          // package dmethod auto kelar coy
          DMethod.printResponse(response);

          // balik ke bentuk array | klo encode ke bentuk enkripsi
          Map resBody = jsonDecode(response.body);

          bool success = resBody['success'] ?? false;
          if (success) {
            DInfo.toastSuccess('Login success');

            // Hapus login page dan buka home page
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(),
              ),
            );
          } else {
            DInfo.toastError('Login error!');
          }
        },
      ).catchError((onError) {
        DInfo.toastError('Something Wrong');
        DMethod.printTitle('catchError', onError.toString());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: -60,
            left: -60,
            child: CircleAvatar(
              radius: 120,
              backgroundColor: Colors.purple[300],
            ),
          ),
          Positioned(
            bottom: -90,
            right: -60,
            child: CircleAvatar(
              radius: 120,
              backgroundColor: Colors.purple[300],
            ),
          ),
          Positioned(
            bottom: 40,
            left: 20,
            child: Icon(
              Icons.scatter_plot,
              size: 90.0,
              color: Colors.purple[400],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(30.0),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppConstant.appName,
                    style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                          color: Colors.purple[700],
                        ),
                  ),
                  const SizedBox(
                    height: 30.0,
                  ),
                  // Textformfield ada validasinya, kalo textfield gak ada validasinya
                  TextFormField(
                    controller: edtUsername,
                    validator: (value) => value == '' ? "Don't empty" : null,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true, // agar warna putih ^ keluar
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      isDense: true, // agar size form mengecil
                      hintText: 'Username',
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  TextFormField(
                    controller: edtPassword,
                    validator: (value) => value == '' ? "Don't empty" : null,
                    obscureText: true,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true, // agar warna putih ^ keluar
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10),
                      ),

                      isDense: true, // agar size form mengecil
                      hintText: 'Password',
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      login(context);
                    },
                    child: Text(
                      'Login',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
