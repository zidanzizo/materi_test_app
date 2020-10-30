import 'package:flutter/material.dart';

class User with ChangeNotifier {
  final int id;
  final String name;
  final String email;
  final String alamat;
  final String mobile;
  final String jabatan;
  final String jenisKelamin;
  final String tempatLahir;
  final String tanggalLahir;

  User({
    this.id,
    this.name,
    this.email,
    this.alamat,
    this.mobile,
    this.jabatan,
    this.jenisKelamin,
    this.tempatLahir,
    this.tanggalLahir,
  });
}
