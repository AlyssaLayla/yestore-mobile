import 'package:flutter/material.dart';
// TODO: Impor drawer yang sudah dibuat sebelumnya


class ProductEntryFormPage extends StatefulWidget {
  const ProductEntryFormPage({super.key});

  @override
  State<ProductEntryFormPage> createState() => _ProductEntryFormPageState();
}

class _ProductEntryFormPageState extends State<ProductEntryFormPage> {
  final _formKey = GlobalKey<FormState>();
  String _name = "";
	String _description = "";
	int _amount = 0;
  String _category = "";
  int _price = 0;

  @override
  Widget build(BuildContext context) {
        return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Form Tambah Product di YESTORE',
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      // TODO: Tambahkan drawer yang sudah dibuat di sini. KATANYA GAUSAH
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: "Name",
                  labelText: "Masukkan Nama Produk",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                onChanged: (String? value) {
                  setState(() {
                    _name = value!;
                  });
                },
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Nama Produk tidak boleh kosong!";
                  }
                  if (RegExp(r'^-?\d+$').hasMatch(value)){
                    return "Nama Produk tidak boleh hanya angka!";
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: "Description",
                  labelText: "Masukkan Deskripsi Produk",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                onChanged: (String? value) {
                  setState(() {
                    _description = value!;
                  });
                },
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Description tidak boleh kosong!";
                  }
                  if (RegExp(r'^-?\d+$').hasMatch(value)){
                    return "Deksripsi tidak boleh hanya angka!";
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: "Amount",
                  labelText: "Masukkan Jumlah Produk",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                onChanged: (String? value) {
                  setState(() {
                    _amount = int.tryParse(value!) ?? 0;
                  });
                },
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Amount tidak boleh kosong!";
                  }
                  final parsedValue = int.tryParse(value);
                  if (parsedValue == null) {
                    return "Amount harus berupa angka!";
                  }
                  if (parsedValue <= 0) {
                    return "Amount harus berupa angka positif!";
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: "Category",
                  labelText: "Masukkan Kategori Produk",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                onChanged: (String? value) {
                  setState(() {
                    _category = value!;
                  });
                },
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Category tidak boleh kosong!";
                  }
                  if (RegExp(r'^-?\d+$').hasMatch(value)){
                    return "Category tidak boleh hanya angka!";
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: "Price (Rp)",
                  labelText: "Masukkan Harga Produk (Rp)",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                onChanged: (String? value) {
                  setState(() {
                    _price = int.tryParse(value!) ?? 0;
                  });
                },
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return "Price (Rp) tidak boleh kosong!";
                  }
                  final parsedValue = int.tryParse(value);
                  if (parsedValue == null) {
                    return "Price (Rp) harus berupa angka!";
                  }
                  if (parsedValue <= 0) {
                    return "Price (Rp) harus berupa angka positif!";
                  }
                  return null;
                },
              ),
            ),
            Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(
                      Theme.of(context).colorScheme.primary),
                ),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Mood berhasil tersimpan'),
                          content: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Name: $_name'),
                                Text('Description: $_description'),
                                Text('Amount: $_amount'),
                                Text('Category: $_category'),
                                Text('Price: $_price'),
                                // TODO: Munculkan value-value lainnya
                              ],
                            ),
                          ),
                        actions: [
                          TextButton(
                            child: const Text('OK'),
                            onPressed: () {
                              Navigator.pop(context);
                              _formKey.currentState!.reset();
                            },
                          ),
                        ],
                      );
                    },
                  );
                  }
                },
                child: const Text(
                  "Save",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
          ],
          )
        ),
      ),
    );
  }
}