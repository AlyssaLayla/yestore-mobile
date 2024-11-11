# YESTORE MOBILE

Nama    : Alyssa Layla Sasti

Kelas   : PBP D

NPM     : 2306152052

<details>
<summary> <b> Tugas 8: Flutter Navigation, Layouts, Forms, and Input Elements</b> </summary>

# Pertanyaan

## Apa kegunaan const di Flutter? Jelaskan apa keuntungan ketika menggunakan const pada kode Flutter. Kapan sebaiknya kita menggunakan const, dan kapan sebaiknya tidak digunakan?
`const` di Flutter memiliki kegunaan sebagai pananda nilai konstan atau nilai yang tidak berubah, sehingga diinisiasikannya saat compile-time saja. 

Keuntungan menggunakan `const` diantaranya adalah:
1. Optimasi Performa: kode yang menggunakan `const` tidak perlu dibuat ulang setiap kali widget di-rebuild. Ini dikarenakan objekk tersebut telah disimpan dalam memori hanya satu kali. Sehingga dapat mengurangi penggunaan memori dan meningkatkan performa
2. Menjaga Immutabilitas: kode yang menggunakan `const` membuat objeknya bersifat immutable atau tidak dapat diubah. 
3. Kompilasi Lebih Efisien: Dikarenakan objek yang menggunakan `const` hanya diinisiasikan sekali saat compile-time saja, ini meningkatkan efisiensi kompilasi dan mengurangi runtime.
4. Hot Reload Lebih Efektif: Dikarenakan flutter tidak perlu merender ulang widget `const`, hot reload menjadi lebih cepat dan efektif.

Kapan sebaiknya kita menggunakan `const`?
- Ketika menggunakan widget stateless. Ini akan membuat widget tidak berubah setelah dibuat, seperti teks statis, ikon, dekorasi
- Untuk penggunaan layout. Ini akan berguna untuk membuat layout agar tidak berubah, seperti nilai padding, margin, dan alignment.

Kapan sebaiknya tidak menggunakan `const`?
- Ketika menggunakan stateful widget atau data yang dinamis. 

## Jelaskan dan bandingkan penggunaan Column dan Row pada Flutter. Berikan contoh implementasi dari masing-masing layout widget ini!
- `column` digunakan untuk mengatur widget secara vertikal. Ini berarti widget disusun dengan tata letak bertumpuk ke bawah. Contohnya seperti yang saya gunakan pada projek saya di bawah ini
    ```left_drawer.dart
    child: const Column(
        children: [
            Text(
                'YESTORE',
                textAlign: TextAlign.center,
                style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                ),
            ),
            Padding(padding: EdgeInsets.all(8)),
            Text(
                "YES, saya akan membeli apa saja yang dijual!",
                style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.normal,
                color: Colors.white,
                ),
                textAlign: TextAlign.center,
                ),
            ],
        ),
    ```

- `row` digunakan untuk mengatur widget secara Horizontal. Ini berarti widget disusun dengan tata letaj ke samping. Contohnya seperti yang saya gunakan pada projek saya di bawah ini
    ```menu.dart
    Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
            InfoCard(title: 'NPM', content: npm),
            InfoCard(title: 'Name', content: name),
            InfoCard(title: 'Class', content: className),
            ],
        ),
    ```


## Sebutkan apa saja elemen input yang kamu gunakan pada halaman form yang kamu buat pada tugas kali ini. Apakah terdapat elemen input Flutter lain yang tidak kamu gunakan pada tugas ini? Jelaskan!
Pada halaman form, elemen input yang saya gunakan hanyalah `TextFormField`. Masih banyak elemen input pada flutter yang tidak saya gunakan pada tugas kali ini. Diantaranya adalah:
1. `DropdownButtonFormField`: Berguna untuk memilih nilai dari daftar opsi dalam bentuk dropdown. Seperti memilih jenis produk atau memilih kategori.
2. `Checkbox`: Checkbox berguna untuk input boolean yang berupa input persetujuan dari pengguna, misalnya keterangan sudah membaca syarat dan ketentuan.
3. `RadioListTile`: Widget untuk menampilkan opsi radio dengan teks (label) di sebelahnya dalam bentuk daftar. Elemen ini digunakan ketika pengguna perlu memilih satu opsi dari beberapa opsi yang ada
4. `Switch`: Swicth adalah widgget untuk pengguna memilih antara dua status, aktif atau non-aktif, iya atu tidak. Sering diapakai untuk pengaturan fitur yang hanya memiliki dua opsi.
5. `Slider`: Widget yang digunakan untuk pengguna memilih nilai dari rentang nilai tertentu dengan cara menggeser. Dapat digunakan untik memilih nilai numerik dalam interval tertentu.
6. `DatePicker`: Widget yang memungkinkan pengguna untuk memilih tanggal dari tampilan kalender.
7. `TimePicker`: Widget yang memungkinkan pengguna untuk memilih waktu (jam dan menit) dari tampilan jam analog atau digital


## Bagaimana cara kamu mengatur tema (theme) dalam aplikasi Flutter agar aplikasi yang dibuat konsisten? Apakah kamu mengimplementasikan tema pada aplikasi yang kamu buat?
Untuk mengatur tema aplikasi flutter agar konsisten, bisa didefinisikan di MaterialApp menggunakan `theme`. Pada tugas kali ini, saya mengimplementasikan  `theme`  untuk set color theme nya di `MaterialApp` yang ada di `main.dart`.
```main.dart
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

## Bagaimana cara kamu menangani navigasi dalam aplikasi dengan banyak halaman pada Flutter?
Cara menagani navigasi dalam flutter dapat dengan metode `push`, `pushReplacement` dan `pop`. 
- `Navigator.push()`: Menambahkan route ke dalam stack route yang dimanage oleh navigaror. Ini membuat pengguna dapat kembali ke page sebelumnya dengan tombol back karena page sebelumnya tidak direplace (tidak di `pop ()`), hanya berapa tepat di bawah new page pada stack route

- `Navigator.pushReplacement()`: Menghapus route yang sedang tidampilkan kepada pengguna dan menggantinya dengan suatu route. Hal ini membuat pengguna tidak dapat kembali ke page sebelumnya dengan tombol back karena page sebelumnya telah dihapus (di `pop()`), sehingga tidak ada di bawah new page pada stack route

- `Navigator.pop()`: Untuk menghapus route yang sedang ditampilkan kepada pengguna. Sehingga page yang berada paling atas di stack route terhapus. Sehingga pengguna akan pindah ke page yang routenya berada di bawah page teratas yang terpop tersebut.

</details>


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

