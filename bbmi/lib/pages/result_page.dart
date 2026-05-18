// ignore_for_file: prefer_const_constructors, unnecessary_string_interpolations

import 'package:flutter/material.dart';

class ResultPage extends StatelessWidget {
  final String nama, gender, kategori;
  final double bmi;

  const ResultPage(
      {required this.nama,
      required this.bmi,
      required this.gender,
      required this.kategori,
      super.key});

  String _getKategori() {
    if (bmi < 18.5) return 'Kurus';
    if (bmi < 25.0) return 'Normal';
    if (bmi < 30.0) return 'Normal';
    return "Obesitas";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hasil BMI"),
        leading: BackButton(),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 120),
            Text(
              "$nama",
              style: TextStyle(fontSize: 30),
            ),
            SizedBox(height: 30),
            Text(
              "${bmi.toStringAsFixed(1)}",
              style: TextStyle(
                fontSize: 50,
              ),
            ),
            SizedBox(height: 30),
            Text(
              _getKategori(),
              style: TextStyle(
                fontSize: 30,
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pop(
                  context,
                );
              },
              child: Container(
                margin: EdgeInsets.only(top: 50, left: 24, right: 24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.blue,
                ),
                width: double.infinity,
                height: 50,
                child: Center(
                  child: Text(
                    "Hitung Ulang",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
