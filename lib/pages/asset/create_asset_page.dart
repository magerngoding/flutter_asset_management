// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'dart:typed_data';

import 'package:d_info/d_info.dart';
import 'package:d_method/d_method.dart';
import 'package:flutter/material.dart';
import 'package:d_input/d_input.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import '../../config/app_constant.dart';

class CreateAssetPage extends StatefulWidget {
  const CreateAssetPage({super.key});

  @override
  State<CreateAssetPage> createState() => _CreateAssetPageState();
}

class _CreateAssetPageState extends State<CreateAssetPage> {
  final formKey = GlobalKey<FormState>();
  final edtName = TextEditingController();
  List<String> types = [
    'Clothes',
    'Property',
    'Electronic',
    'Place',
    'Tool kit',
    'Machine',
    'Automotive',
    'other',
  ];

  String type = 'Automotive';

  String? imageName;
  Uint8List? imageByte;

  pickImage(ImageSource source) async {
    final picked = await ImagePicker().pickImage(source: source);
    if (picked != null) {
      // if there data
      imageName = picked.name;
      imageByte = await picked.readAsBytes();
      setState(() {}); // agar setelah gambar diambil langsung terauto refresh
    }
    DMethod.printBasic('imageName: $imageName');
  }

  save() async {
    bool isValidateInput = formKey.currentState!.validate();

    // jika input tidak valid -> stop/return
    if (!isValidateInput) return;

    // jika tidak ada gambar -> stop/return
    if (imageByte == null) {
      DInfo.toastError("Image don't empty");
      return;
    }

    // jika valid -> run/go on
    // DMethod.printBasic('Execute request to api');
    Uri url = Uri.parse(
      '${AppConstant.baseUrl}/asset/create.php',
    );

    try {
      final response = await http.post(url, body: {
        // body adalah isi body yang ada dipostman
        'name': edtName.text,
        'type': type,
        'image': imageName,
        'base64code': base64Encode(imageByte as List<int>),
      });
      DMethod.printResponse(response);

      Map resBody = jsonDecode(response.body);
      bool success = resBody['success'] ?? false;
      if (success) {
        DInfo.toastSuccess('Success Create New Asset');

        Navigator.pop(
            context); // kembali ke halaman sebelummnya setelah add gambar
      } else {
        DInfo.toastError('Failed Create New Asset');
      }
    } catch (e) {
      DMethod.printTitle('catch', e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        centerTitle: true,
        title: Text(
          'Create New Asset',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            DInput(
              controller: edtName,
              title: 'Name',
              hint: 'Vas Bunga',
              radius: BorderRadius.circular(12),
              fillColor: Colors.white,
              validator: (input) => input == '' ? "Don't empty!" : null,
            ),
            const SizedBox(
              height: 16.0,
            ),
            Text(
              "Type",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 8.0,
            ),
            DropdownButtonFormField(
              value: type,
              icon: const Icon(
                Icons.keyboard_arrow_down_rounded,
                size: 24.0,
              ),
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true, // untuk bagian belakang nya mengikuti jadi putih
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 16,
                ),
              ),
              items: types.map((e) {
                return DropdownMenuItem(
                  value: e,
                  child: Text(e),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  type = value;
                }
              },
            ),
            const SizedBox(
              height: 16.0,
            ),
            Text(
              "Image",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            AspectRatio(
              aspectRatio:
                  16 / 9, // ukuran lebar container ini secara keseluruhan
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(
                    Radius.circular(
                      12.0,
                    ),
                  ),
                ),
                alignment: Alignment.center,
                child: imageByte == null
                    ? Text('Empty')
                    : Image.memory(
                        imageByte!,
                      ), // Hasil gambar dari buttonbar masuk ke container ini
              ),
            ),
            ButtonBar(
              children: [
                // Camera
                OutlinedButton.icon(
                  icon: Icon(
                    Icons.camera_alt,
                    color: Colors.purple,
                  ),
                  onPressed: () {
                    pickImage(ImageSource.camera);
                  },
                  label: Text(
                    'Camera',
                    style: TextStyle(
                      color: Colors.purple,
                    ),
                  ),
                ),
                // Gallery
                OutlinedButton.icon(
                  icon: Icon(
                    Icons.image,
                    color: Colors.purple,
                  ),
                  onPressed: () {
                    pickImage(ImageSource.gallery);
                  },
                  label: Text(
                    'Gallery',
                    style: TextStyle(
                      color: Colors.purple,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () => save(),
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
