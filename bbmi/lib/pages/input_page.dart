// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'result_page.dart';

class InputPage extends StatefulWidget {
  const InputPage({super.key});

  @override
  State<InputPage> createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();

  String? _selectedCategory;

  final List<String> _categories = [
    'Anak-anak',
    'Remaja',
    'Dewasa',
  ];

  String _selectedGender = 'Laki-laki';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kalkulator BMI"),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              // TextFormField untuk nama
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Mohon isi data ini'; // Pesan error jika kosong
                  }
                  return null; // Valid jika isi
                },
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nama Lengkap',
                  hintText: 'Masukkan nama...',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                textCapitalization: TextCapitalization.words,
              ),
              SizedBox(height: 30),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Mohon isi data ini'; // Pesan error jika kosong
                  }
                  return null; // Valid jika isi
                },
                controller: _weightController,
                decoration: InputDecoration(
                  labelText: 'Berat Badan',
                  hintText: 'Contoh: 65',
                  suffixText: 'kg',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
              SizedBox(height: 30),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Mohon isi data ini'; // Pesan error jika kosong
                  }
                  return null; // Valid jika isi
                },
                controller: _heightController,
                decoration: InputDecoration(
                  labelText: 'Tinggi Badan',
                  hintText: 'Contoh: 170',
                  suffixText: 'cm',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
              SizedBox(height: 30),
              DropdownButtonFormField<String>(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Mohon isi data ini'; // Pesan error jika kosong
                  }
                  return null; // Valid jika isi
                },
                value: _selectedCategory,
                decoration: InputDecoration(
                  labelText: 'Kategori Usia',
                  border: OutlineInputBorder(),
                ),
                hint: Text('Pilih kategori...'),
                items: _categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
              ),
              SizedBox(height: 30),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Jenis Kelamin',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  RadioListTile<String>(
                    title: Text('Laki-laki'),
                    value: 'Laki-laki',
                    groupValue: _selectedGender,
                    onChanged: (value) {
                      setState(() {
                        _selectedGender = value!;
                      });
                    },
                  ),
                  RadioListTile<String>(
                    title: Text('Perempuan'),
                    value: 'Perempuan',
                    groupValue: _selectedGender,
                    onChanged: (value) {
                      setState(() {
                        _selectedGender = value!;
                      });
                    },
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  if (_formKey.currentState!.validate()) {
                    final nama = _nameController.text;
                    final berat = double.parse(_weightController.text);
                    final tinggi = double.parse(_heightController.text) / 100;
                    final bmi = berat / (tinggi * tinggi);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ResultPage(
                          nama: nama,
                          bmi: bmi,
                          gender: _selectedGender,
                          kategori: _selectedCategory!,
                        ),
                      ),
                    );
                  }
                },
                child: Container(
                  margin: EdgeInsets.only(top: 50),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.blue,
                  ),
                  width: double.infinity,
                  height: 50,
                  child: Center(
                    child: Text(
                      "Hitung",
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
      ),
    );
  }
}
