# YESTORE MOBILE

Nama    : Alyssa Layla Sasti

Kelas   : PBP D

NPM     : 2306152052

<details>
<summary> <b> Tugas 9: Integrasi Layanan Web Django dengan Aplikasi Flutter</b> </summary>

# Pertanyaan

## Jelaskan mengapa kita perlu membuat model untuk melakukan pengambilan ataupun pengiriman data JSON? Apakah akan terjadi error jika kita tidak membuat model terlebih dahulu?
Model digunakan untuk mempermudah pengelolaan data JSON dengan memetakan struktur data ke objek yang terdefinisi. Hal ini meminimalkan kesalahan seperti kesalahan tipe data atau key yang salah. Tanpa model, pengelolaan data menjadi raw dan rentan terhadap error jika struktur JSON berubah atau jika field penting tidak tersedia.

## Jelaskan fungsi dari library http yang sudah kamu implementasikan pada tugas ini
Library http digunakan untuk mengirim dan menerima data melalui protokol HTTP, seperti GET untuk mengambil data dari server, POST untuk mengirim data, PUT untuk mengirim data pada skala atau bagian tertentu, dan DELETE untuk menghapus data. Library ini menjadi perantara antara aplikasi Flutter dan backend Django.

##  Jelaskan fungsi dari CookieRequest dan jelaskan mengapa instance CookieRequest perlu untuk dibagikan ke semua komponen di aplikasi Flutter.
CookieRequest adalah mekanisme untuk mengelola sesi berbasis cookie dalam Flutter. Ini memungkinkan status autentikasi pengguna (seperti login) dipertahankan di seluruh komponen aplikasi. Membagikan instance CookieRequest ke seluruh aplikasi memastikan sesi pengguna tetap konsisten dan tidak perlu autentikasi ulang pada setiap komponen sehingga mengingkatkan efisiensi

##  Jelaskan mekanisme pengiriman data mulai dari input hingga dapat ditampilkan pada Flutter.
- Input Data: Pengguna memasukkan data melalui UI di Flutter.
- Pengolahan Data: Data diubah menjadi format JSON dan dikirim melalui HTTP
- Kirim ke Backend: Data dikirim ke backend API Django menggunakan metode HTTP.
- Proses di Backend: Django memproses data, menyimpan ke database, atau mengembalikan respon berupa JSON.
- Tampilkan di Flutter: Flutter menerima respon JSON, mem-parsing-nya ke model, dan menampilkan data di UI.

## Jelaskan mekanisme autentikasi dari login, register, hingga logout. Mulai dari input data akun pada Flutter ke Django hingga selesainya proses autentikasi oleh Django dan tampilnya menu pada Flutter.
1. Login
- Input Data di Flutter: Pengguna memasukkan username dan password pada form login di aplikasi Flutter.
- Kirim ke Backend (Django): Flutter mengirim request POST ke endpoint Django yang menangani login
- Validasi di Django: Django memeriksa apakah username ada di database. Kemudian memverifikasi apakah password yang dikirim sesuai dengan yang tersimpan (biasanya dengan hashing). Jika valid, Django membuat sesi pengguna dengan cookie.
- Respon Django ke Flutter: 
    1. Jika sukses: Django mengembalikan data pengguna (seperti nama atau role) dan cookie sesi.
    2. Jika gagal: Django mengembalikan pesan error, seperti "Username atau password salah."
- Tampilan di Flutter: Jika login berhasil, Flutter menyimpan cookie melalui CookieRequest. Aplikasi menavigasi ke halaman utama atau menampilkan menu sesuai role pengguna.

2. Register
- Input Data di Flutter: Pengguna mengisi form pendaftaran dengan data seperti username, password, dan email.
- Kirim ke Backend (Django): Flutter mengirim request POST ke endpoint Django
- Validasi di Django: Django memeriksa apakah username sudah ada.
Django memeriksa apakah email valid. Password diperiksa sesuai kriteria keamanan (panjang minimal, kombinasi karakter, dll.).
- Simpan ke Database: Jika validasi berhasil, Django menyimpan data pengguna baru ke database dengan password yang di-hash
- Respon Django ke Flutter:
    1. Jika sukses: Django mengembalikan pesan sukses, seperti "Pendaftaran berhasil."
    2. Jika gagal: Django mengembalikan pesan error, seperti "Username sudah terpakai."
- Tampilan di Flutter: Flutter menampilkan pesan sukses atau error sesuai respon Django. Pengguna diarahkan ke halaman login untuk masuk.

3. Logout
- Proses Logout di Flutter: Ketika pengguna menekan tombol logout, Flutter mengirim request POST ke endpoint Django yang menangani logout.
- Hapus Sesi di Django: Django menghapus cookie sesi pengguna, mengakhiri autentikasi.
- Respon Django ke Flutter: Django mengembalikan status sukses ke Flutter.
- Tampilan di Flutter: Flutter menghapus data sesi lokal (di CookieRequest). Pengguna diarahkan ke halaman login atau halaman awal aplikasi.

## Jelaskan bagaimana cara kamu mengimplementasikan checklist di atas secara step-by-step! (bukan hanya sekadar mengikuti tutorial).
1.  Mengimplementasikan fitur registrasi akun pada proyek tugas Flutter.
    - Modifikasi modul authentication pada projek Django. Saya menambahkan fungsi berikut pada `authentication/views.py`
    ```python
    from django.contrib.auth import authenticate, login as auth_login
    from django.http import JsonResponse
    from django.views.decorators.csrf import csrf_exempt
    from django.contrib.auth.models import User
    import json
    from django.contrib.auth import logout as auth_logout

    @csrf_exempt
    def register(request):
    if request.method == 'POST':
        data = json.loads(request.body)
        username = data['username']
        password1 = data['password1']
        password2 = data['password2']

        # Check if the passwords match
        if password1 != password2:
            return JsonResponse({
                "status": False,
                "message": "Passwords do not match."
            }, status=400)
        
        # Check if the username is already taken
        if User.objects.filter(username=username).exists():
            return JsonResponse({
                "status": False,
                "message": "Username already exists."
            }, status=400)
        
        # Create the new user
        user = User.objects.create_user(username=username, password=password1)
        user.save()
        
        return JsonResponse({
            "username": user.username,
            "status": 'success',
            "message": "User created successfully!"
        }, status=200)
    
    else:
        return JsonResponse({
            "status": False,
            "message": "Invalid request method."
        }, status=400)
        
    ```
    - Tambahkan path ke `authentication/urls.py`
        ```python
            from authentication.views import login, register 

            path('register/', register, name='register'),
        ```
    - Saya membuat folder screens dengan nama `register.dart`
        ```dart
            import 'dart:convert';
            import 'package:flutter/material.dart';
            import 'package:yestore_mobile/screens/login.dart';
            import 'package:pbp_django_auth/pbp_django_auth.dart';
            import 'package:provider/provider.dart';

            class RegisterPage extends StatefulWidget {
            const RegisterPage({super.key});

            @override
            State<RegisterPage> createState() => _RegisterPageState();
            }

            class _RegisterPageState extends State<RegisterPage> {
            final _usernameController = TextEditingController();
            final _passwordController = TextEditingController();
            final _confirmPasswordController = TextEditingController();

            @override
            Widget build(BuildContext context) {
                final request = context.watch<CookieRequest>();
                return Scaffold(
                appBar: AppBar(
                    title: const Text('Register'),
                    leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                        Navigator.pop(context);
                    },
                    ),
                ),
                body: Center(
                    child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Card(
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                            const Text(
                                'Register',
                                style: TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                                ),
                            ),
                            const SizedBox(height: 30.0),
                            TextFormField(
                                controller: _usernameController,
                                decoration: const InputDecoration(
                                labelText: 'Username',
                                hintText: 'Enter your username',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(12.0)),
                                ),
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                                ),
                                validator: (value) {
                                if (value == null || value.isEmpty) {
                                    return 'Please enter your username';
                                }
                                return null;
                                },
                            ),
                            const SizedBox(height: 12.0),
                            TextFormField(
                                controller: _passwordController,
                                decoration: const InputDecoration(
                                labelText: 'Password',
                                hintText: 'Enter your password',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(12.0)),
                                ),
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                                ),
                                obscureText: true,
                                validator: (value) {
                                if (value == null || value.isEmpty) {
                                    return 'Please enter your password';
                                }
                                return null;
                                },
                            ),
                            const SizedBox(height: 12.0),
                            TextFormField(
                                controller: _confirmPasswordController,
                                decoration: const InputDecoration(
                                labelText: 'Confirm Password',
                                hintText: 'Confirm your password',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(12.0)),
                                ),
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                                ),
                                obscureText: true,
                                validator: (value) {
                                if (value == null || value.isEmpty) {
                                    return 'Please confirm your password';
                                }
                                return null;
                                },
                            ),
                            const SizedBox(height: 24.0),
                            ElevatedButton(
                                onPressed: () async {
                                String username = _usernameController.text;
                                String password1 = _passwordController.text;
                                String password2 = _confirmPasswordController.text;

                                final response = await request.postJson(
                                    "http://localhost:8000/auth/register/",
                                    jsonEncode({
                                        "username": username,
                                        "password1": password1,
                                        "password2": password2,
                                    }));
                                if (context.mounted) {
                                    if (response['status'] == 'success') {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                        content: Text('Successfully registered!'),
                                        ),
                                    );
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => const LoginPage()),
                                    );
                                    } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                        content: Text('Failed to register!'),
                                        ),
                                    );
                                    }
                                }
                                },
                                style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                minimumSize: Size(double.infinity, 50),
                                backgroundColor: Theme.of(context).colorScheme.primary,
                                padding: const EdgeInsets.symmetric(vertical: 16.0),
                                ),
                                child: const Text('Register'),
                            ),
                            ],
                        ),
                        ),
                    ),
                    ),
                ),
                );
            }
            }
        ```

2. Membuat halaman login pada proyek tugas Flutter.
    - Membuat fungsi login pada `authentication/views.py`
        ```python

        from django.contrib.auth import authenticate, login as auth_login
        from django.http import JsonResponse
        from django.views.decorators.csrf import csrf_exempt
        from django.contrib.auth.models import User
        import json
        from django.contrib.auth import logout as auth_logout

        @csrf_exempt
        def login(request):
            username = request.POST['username']
            password = request.POST['password']
            user = authenticate(username=username, password=password)
            if user is not None:
                if user.is_active:
                    auth_login(request, user)
                    # Status login sukses.
                    return JsonResponse({
                        "username": user.username,
                        "status": True,
                        "message": "Login sukses!"
                        # Tambahkan data lainnya jika ingin mengirim data ke Flutter.
                    }, status=200)
                else:
                    return JsonResponse({
                        "status": False,
                        "message": "Login gagal, akun dinonaktifkan."
                    }, status=401)

            else:
                return JsonResponse({
                    "status": False,
                    "message": "Login gagal, periksa kembali email atau kata sandi."
                }, status=401)
        
        ```
    -Membuat routing ke `authentication/urls.py`
        ```python
        from django.urls import path
        from authentication.views import login

        app_name = 'authentication'

        urlpatterns = [
            path('login/', login, name='login'),
        ]
        ```
    - Membuat file `login.dart` di projek Flutter
        ```dart
            import 'package:yestore_mobile/screens/menu.dart';
            import 'package:flutter/material.dart';
            import 'package:pbp_django_auth/pbp_django_auth.dart';
            import 'package:provider/provider.dart';
            import 'package:yestore_mobile/screens/register.dart';
            // TODO: Import halaman RegisterPage jika sudah dibuat

            void main() {
            runApp(const LoginApp());
            }

            class LoginApp extends StatelessWidget {
            const LoginApp({super.key});

            @override
            Widget build(BuildContext context) {
                return MaterialApp(
                title: 'Login',
                theme: ThemeData(
                    useMaterial3: true,
                    colorScheme: ColorScheme.fromSwatch(
                    primarySwatch: Colors.deepPurple,
                    ).copyWith(secondary: Colors.deepPurple[400]),
                ),
                home: const LoginPage(),
                );
            }
            }

            class LoginPage extends StatefulWidget {
            const LoginPage({super.key});

            @override
            State<LoginPage> createState() => _LoginPageState();
            }

            class _LoginPageState extends State<LoginPage> {
            final TextEditingController _usernameController = TextEditingController();
            final TextEditingController _passwordController = TextEditingController();

            @override
            Widget build(BuildContext context) {
                final request = context.watch<CookieRequest>();

                return Scaffold(
                appBar: AppBar(
                    title: const Text('Login'),
                ),
                body: Center(
                    child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Card(
                        elevation: 8,
                        shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                            const Text(
                                'Login',
                                style: TextStyle(
                                fontSize: 24.0,
                                fontWeight: FontWeight.bold,
                                ),
                            ),
                            const SizedBox(height: 30.0),
                            TextField(
                                controller: _usernameController,
                                decoration: const InputDecoration(
                                labelText: 'Username',
                                hintText: 'Enter your username',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(12.0)),
                                ),
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                                ),
                            ),
                            const SizedBox(height: 12.0),
                            TextField(
                                controller: _passwordController,
                                decoration: const InputDecoration(
                                labelText: 'Password',
                                hintText: 'Enter your password',
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(12.0)),
                                ),
                                contentPadding:
                                    EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
                                ),
                                obscureText: true,
                            ),
                            const SizedBox(height: 24.0),
                            ElevatedButton(
                                onPressed: () async {
                                String username = _usernameController.text;
                                String password = _passwordController.text;

                                // Cek kredensial
                                // TODO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
                                // Untuk menyambungkan Android emulator dengan Django pada localhost,
                                // gunakan URL http://10.0.2.2/
                                final response = await request
                                    .login("http://localhost:8000/auth/login/", {
                                    'username': username,
                                    'password': password,
                                });

                                if (request.loggedIn) {
                                    String message = response['message'];
                                    String uname = response['username'];
                                    if (context.mounted) {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => MyHomePage()),
                                    );
                                    ScaffoldMessenger.of(context)
                                        ..hideCurrentSnackBar()
                                        ..showSnackBar(
                                        SnackBar(
                                            content:
                                                Text("$message Selamat datang, $uname.")),
                                        );
                                    }
                                } else {
                                    if (context.mounted) {
                                    showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                        title: const Text('Login Gagal'),
                                        content: Text(response['message']),
                                        actions: [
                                            TextButton(
                                            child: const Text('OK'),
                                            onPressed: () {
                                                Navigator.pop(context);
                                            },
                                            ),
                                        ],
                                        ),
                                    );
                                    }
                                }
                                },
                                style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                minimumSize: Size(double.infinity, 50),
                                backgroundColor: Theme.of(context).colorScheme.primary,
                                padding: const EdgeInsets.symmetric(vertical: 16.0),
                                ),
                                child: const Text('Login'),
                            ),
                            const SizedBox(height: 36.0),
                            GestureDetector(
                                onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const RegisterPage()),
                                );
                                },
                                child: Text(
                                'Don\'t have an account? Register',
                                style: TextStyle(
                                    color: Theme.of(context).colorScheme.primary,
                                    fontSize: 16.0,
                                ),
                                ),
                            ),
                            ],
                        ),
                        ),
                    ),
                    ),
                ),
                );
            }
            }
        ```
3. Mengintegrasikan sistem autentikasi Django dengan proyek tugas Flutter.
    - Saya membuat django-app bernama `authentication` kemudian memasukkannya ke `INSTALLED_APPS` di main project `settings.py`
    - Menginstal `pip-install django-cors-headers` dan menambahkan `django-cors-headers` ke `requirements.txt`
    - Menambahkan `corsheaders` ke `INSTALLED_APPS` pada `settings.py` di main dan menambahkan `corsheaders.middleware.CorsMiddleware` ke MIDDLEWARE di `settings.py`
    - menambahkan variabel ini ke `settings.py` di main
    ```python
    ...
    CORS_ALLOW_ALL_ORIGINS = True
    CORS_ALLOW_CREDENTIALS = True
    CSRF_COOKIE_SECURE = True
    SESSION_COOKIE_SECURE = True
    CSRF_COOKIE_SAMESITE = 'None'
    SESSION_COOKIE_SAMESITE = 'None'
    ```
    - Menambah `ALLOWED_HOSTS` dengan "10.0.2.2"
    - Membuat fungsi login di `authentication/views.py` dan membuat file `urls.py` untuk url routing `login/` serta menambahkan `path('auth/', include('authentication.urls')),` pada `yestore_mobile/urls.py`
    - install package
    ```bash
    flutter pub add provider
    flutter pub add pbp_django_auth
    ```
    - Menyediakan `CookieRequest` ke `main.dart`
    - Membuat login dan register seperti yang sudah dijelaskan di poin sebelumnya

4. Membuat model kustom sesuai dengan proyek aplikasi Django.
    - Saya membuka endpoint JSON dengan mengisi terlebih dahulu produk pada projek Django (apabila masih kosong). Jika sudah ada data, buka dengan `/json` pada url localhostnya.
    - Ubah data JSON tersebut menjadi dart
    - Membuat folder baru `models/` di folder `lib`. Kemudian membuat file baru bernama `product_entry.dart`, kemudian masukkan kode json yang sudah menjadi dart

5. Membuat halaman yang berisi daftar semua item yang terdapat pada endpoint JSON di Django yang telah kamu deploy.
    - Saya membuat folder `lib/screens` dan membuat file bernama `list_productentry.dart`
    - Saya mengisi file tersebut dengan kode ini
        ```dart
        import 'package:flutter/material.dart';
        import 'package:yestore_mobile/models/product_entry.dart';
        import 'package:yestore_mobile/screens/detail_product.dart';
        import 'package:yestore_mobile/widgets/left_drawer.dart';
        import 'package:pbp_django_auth/pbp_django_auth.dart';
        import 'package:provider/provider.dart';

        class ProductEntryPage extends StatefulWidget {
        const ProductEntryPage({super.key});

        @override
        State<ProductEntryPage> createState() => _ProductEntryPageState();
        }

        class _ProductEntryPageState extends State<ProductEntryPage> {
        Future<List<Product>> fetchProduct(CookieRequest request) async {
            // TODO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
            final response = await request.get('http://localhost:8000/json/');
            
            // Melakukan decode response menjadi bentuk json
            var data = response;
            
            // Melakukan konversi data json menjadi object ProductEntry
            List<Product> listProduct = [];
            for (var d in data) {
            if (d != null) {
                listProduct.add(Product.fromJson(d));
            }
            }
            return listProduct;
        }

        @override
        Widget build(BuildContext context) {
            final request = context.watch<CookieRequest>();
            return Scaffold(
            appBar: AppBar(
                title: const Text('Product Entry List'),
            ),
            drawer: const LeftDrawer(),
            body: FutureBuilder(
                future: fetchProduct(request),
                builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.data == null) {
                    return const Center(child: CircularProgressIndicator());
                } else {
                    if (!snapshot.hasData) {
                    return const Column(
                        children: [
                        Text(
                            'Belum ada data product pada YESTORE.',
                            style: TextStyle(fontSize: 20, color: Color(0xff59A5D8)),
                        ),
                        SizedBox(height: 8),
                        ],
                    );
                    } else {
                        return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (_, index) {
                        final product = snapshot.data![index];
                        return GestureDetector(
                            onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                builder: (context) => ProductDetailPage(product: product),
                                ),
                            );
                            },
                            child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            padding: const EdgeInsets.all(20.0),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: const [
                                BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 4.0,
                                    offset: Offset(0, 4),
                                ),
                                ],
                            ),
                            child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                            Text(
                                "${snapshot.data![index].fields.name}",
                                style: const TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                ),
                            ),
                            const SizedBox(height: 10),
                            Text("${snapshot.data![index].fields.description}"),
                            const SizedBox(height: 10),
                            Text("${snapshot.data![index].fields.quantity}"),
                            const SizedBox(height: 10),
                            Text("${snapshot.data![index].fields.category}"),
                            const SizedBox(height: 10),
                            Text("${snapshot.data![index].fields.price}")
                                ],
                            ),
                            ),
                        );
                        },
                    );
                    }
                }
                },
            ),
            );
        }
        }
        ```
    - Tampilkan name, price, dan description dari masing-masing item pada halaman ini.
    ```dart
        children: [
            Text("${snapshot.data![index].fields.name}",
                style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                        ),
                            ),
                            const SizedBox(height: 10),
                            Text("${snapshot.data![index].fields.description}"),
                            const SizedBox(height: 10),
                            Text("${snapshot.data![index].fields.quantity}"),
                            const SizedBox(height: 10),
                            Text("${snapshot.data![index].fields.category}"),
                            const SizedBox(height: 10),
                            Text("${snapshot.data![index].fields.price}")
        ],
    ```

6. Membuat halaman detail untuk setiap item yang terdapat pada halaman daftar Item.
    - Halaman ini dapat diakses dengan menekan salah satu item pada halaman daftar Item.
    - Tampilkan seluruh atribut pada model item kamu pada halaman ini.
    - Tambahkan tombol untuk kembali ke halaman daftar item.

    - Untuk mengimplementasikan halaman detail, saya membuat file baru di dalam folder `screens` bernama `detail_product.dart`. Kemudian saya mengisi dengan kode berikut
    ```dart
    import 'package:flutter/material.dart';
    import 'package:yestore_mobile/models/product_entry.dart';

    class ProductDetailPage extends StatelessWidget {
    final Product product;

    const ProductDetailPage({super.key, required this.product});

    @override
    Widget build(BuildContext context) {
        return Scaffold(
        appBar: AppBar(
            title: Text(product.fields.name),
        ),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                Text(
                "Name: ${product.fields.name}",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text("Description: ${product.fields.description}"),
                const SizedBox(height: 10),
                Text("Quantity: ${product.fields.quantity}"),
                const SizedBox(height: 10),
                Text("Category: ${product.fields.category}"),
                const SizedBox(height: 10),
                Text("Price: Rp${product.fields.price}"),
                const SizedBox(height: 20),
                Center(
                child: ElevatedButton(
                    onPressed: () {
                    Navigator.pop(context);
                    },
                    child: const Text("Kembali ke List Produk"),
                ),
                ),
            ],
            ),
        ),
        );
    }
    }

    ```

    - Menambahkan agar page `detail_product.dart` dapat diakses dari halaman `list_productentry.dart`
        ```dart
            return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (_, index) {
                final product = snapshot.data![index];
                return GestureDetector(
                    onTap: () {
                        Navigator.push(
                        context,
                        MaterialPageRoute(
                        builder: (context) => ProductDetailPage(product: product),
                        ),
                    );
                },
            )
        }
        )
        ```

7. Melakukan filter pada halaman daftar item dengan hanya menampilkan item yang terasosiasi dengan pengguna yang login.
Untuk memfilter halaman daftar item dengan hanya menampilkan item yang sesuai dengan yang sudah di create oleh pengguna tertentu (yang sudah login), saya menambahkan fungsi `create_product_flutter(request)` di views.py main projek Django. Pada fungsi ini, telah di assign `user=request.user`, hal ini menandakan produk yang masuk telah terkait pada user tertentu yang telah login.
```python
@csrf_exempt
def create_product_flutter(request):
    if request.method == 'POST':

        data = json.loads(request.body)
        new_product = Product.objects.create(
            user=request.user,
            name=data["name"],
            price=int(data["price"]),
            quantity=int(data["quantity"]),
            description=data["description"],
            category=data["category"],
        )

        new_product.save()

        return JsonResponse({"status": "success"}, status=200)
    else:
        return JsonResponse({"status": "error"}, status=401)
```

Lalu pada projek flutter, menggunakan `pbp_django_auth` untuk menandakan session pengguna. Kemudian mengguanakan `CookieRequest` untuk pengiriman datanya

</details>


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

