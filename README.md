# YESTORE MOBILE

Nama    : Alyssa Layla Sasti

Kelas   : PBP D

NPM     : 2306152052

<details>
<summary> <b> Tugas 7: Elemen Dasar Flutter</b> </summary>

# Pertanyaan

##  Jelaskan apa yang dimaksud dengan stateless widget dan stateful widget, dan jelaskan perbedaan dari keduanya.
- Stateless widgets adalah widget yang tidak dapat berubah ketika sudah dibuat. Ini berarti stateless widget tidak dapat berubah ketika runtime app. Beberapa contohnya adalah elemen UI yang statis (tidak perlu merespon perubahan status): Icon, IconButton, and Text 
- Stateful widgets adalah widget yang propertina dapat berubah selama runtime. Stateful widget bersifat dinamis, dimana dapat berubah tampilannya sebagai respon dari suatu event yang di trigger dari interaksi dengan user atau ketika menerima data
- Sebagai konklusi, stateless widget tidak memiliki keadaan yang berubah dan stateful widget memiliki keadaan yang dapat berubah. Metode utama yang digunakan stateless widget adalah `build()` saja. Namun, untuk stateful widget, metode yang digunakan juga adalah `createState()` dan `build()`.

## Sebutkan widget apa saja yang kamu gunakan pada proyek ini dan jelaskan fungsinya.
- MaterialApp: Widget utama untuk aplikasi Flutter. Title, theme, home diatur di MaterialApp. Pada projek saya, MyHomePage dijadikan home, sehingga tampilan tersebutlah yang akan muncul pertama.
- Scaffold: Widget yang menyediakan struktur dasar antarmuka halaman yang menjadi fondasi utama, seperti `AppBar` dan `Body`
- SnackBar: Untuk memberikan pesan notifikasi yang muncul di bawah layar untuk memberi tahu pengguna tentang suatu aksi event yang dilakukan
- Row: Untuk menyusun elemen secara horizontal
- Padding: Untuk memberi jarak antara konten dalam widget agar tidak saling menempel dan rapi
- Column: Untuk menyusun elemen secara vertikal. 
- Text: Widget untuk menampikan teks pada tampilan UI
- AppBar: Widget untuk menampikan bar pada bagian atas halaman. Biasanya berisi ikon, judul halaman, nama aplikasi.
- InkWell: Untuk menambahkan efek percikan. Untuk membuat `ItemCard` interaktif dan memberikan efek tersebut saat ditekan
- Icon: Untuk menampilan icon grafis sesuai keperluan
- Card: Widget yang membungkus konten dalam bentuk `card` sehingga tampilan desainnya rapi
- GridView.count: Untuk menampilkan widget dalam bentuk grid sesuai dengan jumlah kolomnya ingin berapa. Contoh dalam projek ini adalah 3 kolom.

##  Apa fungsi dari setState()? Jelaskan variabel apa saja yang dapat terdampak dengan fungsi tersebut.
- Fungsi `setState()` adalah untuk menginformasikan ada perubahan pada data yang harus direspon dengan flutter merender ulang widget untuk pembaruan UI. Fungsi ini digunakan pada Stateful Widget yang membutuhkan perubahan tampilan dinamis ketika datanya berubah
- Variabel yang terdampak dari fungsi `setState()` adalah variabel yang dideklarasikan dalam objek `state` dari stateful Widget tersebut. Contohnya variabel yang menunjukan loading indicator.
- Catatan: Pada projek ini tidak digunakan `setState()` karena tidak ada stateful widget

##  Jelaskan perbedaan antara const dengan final.
Sebenarnya, keduanya memiliki kesamaan dimana bertujuan untuk membuat nilai yang tidak bisa diubah(immutable). Namun ada hal yang membedakan keduanya:
- `const` adalah variabel yang diatur saat compile dan tidak bisa diubah. `const` bersifat compile-time constant, sehingga lebih efisien dalam penggunaan memori. Contohnya adalah penggunaan yang statis seperti warna dan text
- `final` adalah variabel yang hanya dapat diinsialisasi satu kali. Saat variabel diinsialisasi pertama kali, nilainya tidak dapat diubah. `final` digunakan untuk variabel yang nilainya tidak diketahui hingga runtime, bisa berupa hasil perhitungan yang bersifat dinamis.

##  Jelaskan bagaimana cara kamu mengimplementasikan checklist-checklist di atas.
- Membuat sebuah program Flutter baru dengan tema E-commerce yang sesuai dengan tugas-tugas sebelumnya
    Saya membuat direktori di lokal untuk menyimpan projek yestore-mobile ini. Saya meng-generate projek Flutter baru dengan nama `yestore_mobile`
    ```bash
    flutter create yestore_mobile
    ```
- Membuat tiga tombol sederhana dengan ikon dan teks untuk:
    - Melihat daftar produk(`Lihat Daftar Produk`)
    - Menambah produk (`Tambah Produk`)
    - Logout (`Logout`)
    1. Pertama saya membuat file `menu.dart` di dalam direktori lib untuk halaman utama aplikasi.
    2. file `main.dart` dibuat sebagai struktur dasar dengan salah satunya menggunakan widget `MaterialApp`. Judulnya saya beri nama sesuai nama E-commerce saya, yaitu YESTORE. Kemudian saya mengatur theme dengan set warnanya
    ```main.dart
        import 'package:flutter/material.dart';
        import 'package:yestore_mobile/menu.dart';

        void main() {
        runApp(const MyApp());
        }

        class MyApp extends StatelessWidget {
        const MyApp({super.key});

        @override
        Widget build(BuildContext context) {
            return MaterialApp(
            title: 'YESTORE',
            theme: ThemeData(
                colorScheme: ColorScheme.fromSwatch(
                primarySwatch: Colors.red,
                ).copyWith(secondary: const Color.fromARGB(255, 236, 125, 125)),
                useMaterial3: true,
            ),
            home: MyHomePage(),
            );
        }
        }
    ```

    3. Kemudian di `menu.dart` saya membuat class `MyHomePage` untuk dapat menampikan ketiga tombol tersebut
    ```menu.dart
        class MyHomePage extends StatelessWidget {
        final String npm = '2306152052'; 
        final String name = 'Alyssa Layla Sasti'; 
        final String className = 'PBP D'; 
        final List<ItemHomepage> items = [
            ItemHomepage("Lihat Daftar Produk", Icons.local_grocery_store_outlined, const Color.fromARGB(255, 236, 125, 125)),
            ItemHomepage("Tambah Produk", Icons.add_circle_outline, const Color.fromARGB(255, 236, 140, 79)),
            ItemHomepage("Logout", Icons.logout_rounded, const Color.fromARGB(255, 241, 204, 80)),
        ];

    MyHomePage({super.key});

    @override
    Widget build(BuildContext context) {
        return Scaffold(
        appBar: AppBar(
            title: const Text(
            'YESTORE',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
            ),
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
        ),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
                Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                    InfoCard(title: 'NPM', content: npm),
                    InfoCard(title: 'Name', content: name),
                    InfoCard(title: 'Class', content: className),
                ],
                ),
                const SizedBox(height: 16.0),
                Center(
                child: Column(
                    children: [
                    const Padding(
                        padding: EdgeInsets.only(top: 16.0),
                        child: Text(
                        'Welcome to YESTORE',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                        ),
                        ),
                    ),

                    // Grid untuk menampilkan ItemCard dalam bentuk grid 3 kolom.
                    GridView.count(
                        primary: true,
                        padding: const EdgeInsets.all(20),
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        crossAxisCount: 3,
                        // Agar grid menyesuaikan tinggi kontennya.
                        shrinkWrap: true,

                        // Menampilkan ItemCard untuk setiap item dalam list items.
                        children: items.map((ItemHomepage item) {
                        return ItemCard(item);
                        }).toList(),
                    ),
                    ],
                ),
                ),
            ],
            ),
        ),
        );
    }
    }
    ```

- Mengimplementasikan warna-warna yang berbeda untuk setiap tombol (`Lihat Daftar`, `Produk`, `Tambah Produk`, dan `Logout`)
    1. Karena saya ingin implementasikan warnayan berbeda - beda pada masing-masing tombol, saya membuat class `ItemHomePage` untuk menyimpan name, icon, dan color
    ```menu.dart
        class ItemHomepage {
            final String name;
            final IconData icon;
            final Color color;

            ItemHomepage(this.name, this.icon, this.color);
        }
    ```
    2. Kemudian pada `MyHomePage` saya masukkan masing - masing warna yang diinginkan
    ```menu.dart
            final List<ItemHomepage> items = [
            ItemHomepage("Lihat Daftar Produk", Icons.local_grocery_store_outlined, const Color.fromARGB(255, 236, 125, 125)),
            ItemHomepage("Tambah Produk", Icons.add_circle_outline, const Color.fromARGB(255, 236, 140, 79)),
            ItemHomepage("Logout", Icons.logout_rounded, const Color.fromARGB(255, 241, 204, 80)),
        ];
    ```
    3. Kemudian pada `ItemCard` saya membuat `color: item.color`, agar warnanya sesuai dengan yang sudah saya masukkan di Lost ItemsHomePage
    ```menu.dart
    class ItemCard extends StatelessWidget {
        final ItemHomepage item; 
        const ItemCard(this.item, {super.key}); 

        @override
        Widget build(BuildContext context) {
            return Material(
            color: item.color,
    ```
- Memunculkan `Snackbar` dengan tulisan:
    - "Kamu telah menekan tombol Lihat Daftar Produk" ketika tombol `Lihat Daftar Produk` ditekan.
    - "Kamu telah menekan tombol Tambah Produk" ketika tombol `Tambah Produk` ditekan.
    - Kamu telah menekan tombol Logout" ketika tombol `Logout` ditekan.
    1. Untuk memunculkan `Snackbar` ini, saya membuat fungsi widget `SnackBar` di `ItemCard`
    ```menu.dart
    class ItemCard extends StatelessWidget {
        final ItemHomepage item; 
        const ItemCard(this.item, {super.key}); 

        @override
        Widget build(BuildContext context) {
            return Material(
            color: item.color,
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
                onTap: () {
                ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                    SnackBar(content: Text("Kamu telah menekan tombol ${item.name}!"))
                    );
                },
                child: Container(
                padding: const EdgeInsets.all(8),
                child: Center(
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                        Icon(
                        item.icon,
                        color: Colors.white,
                        size: 30.0,
                        ),
                        const Padding(padding: EdgeInsets.all(3)),
                        Text(
                        item.name,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white),
                        ),
                    ],
                    ),
                ),
                ),
            ),
            );
        }
        }
    ```

</details>
