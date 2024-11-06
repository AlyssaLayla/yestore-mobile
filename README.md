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


##  Apa fungsi dari setState()? Jelaskan variabel apa saja yang dapat terdampak dengan fungsi tersebut.

##  Jelaskan perbedaan antara const dengan final.
Sebenarnya, keduanya memiliki kesamaan dimana bertujuan untuk membuat nilai yang tidak bisa diubah(immutable). Namun ada hal yang membedakan keduanya:
- `const` adalah variabel yang diatur saat compile dan tidak bisa diubah. `const` bersifat compile-time constant, sehingga lebih efisien dalam penggunaan memori. Contohnya adalah penggunaan yang statis seperti warna dan text
- `final` adalah variabel yang hanya dapat diinsialisasi satu kali. Saat variabel diinsialisasi pertama kali, nilainya tidak dapat diubah. `final` digunakan untuk variabel yang nilainya tidak diketahui hingga runtime, bisa berupa hasil perhitungan yang bersifat dinamis.
##  Jelaskan bagaimana cara kamu mengimplementasikan checklist-checklist di atas.
- Membuat sebuah program Flutter baru dengan tema E-commerce yang sesuai dengan tugas-tugas sebelumnya
- Membuat tiga tombol sederhana dengan ikon dan teks untuk:
    - Melihat daftar produk(`Lihat Daftar Produk`)
    - Menambah produk (`Tambah Produk`)
    - Logout (`Logout`)
- Mengimplementasikan warna-warna yang berbeda untuk setiap tombol (`Lihat Daftar`, `Produk`, `Tambah Produk`, dan `Logout`)
- Memunculkan `Snackbar` dengan tulisan:
    - "Kamu telah menekan tombol Lihat Daftar Produk" ketika tombol `Lihat Daftar Produk` ditekan.
    - "Kamu telah menekan tombol Tambah Produk" ketika tombol `Tambah Produk` ditekan.
    - Kamu telah menekan tombol Logout" ketika tombol `Logout` ditekan.

    1. Saya menambahkan impor di `views.py`
    ```python
    from django.views.decorators.csrf import csrf_exempt
    from django.views.decorators.http import require_POST
    ```
    2. Masih di `views.py`, saya menambahkan fungsi dengan nama `add_product_entry_ajax` seperti kode berikut: 
    ```python
    @csrf_exempt
    @require_POST
    def add_product_entry_ajax(request):
    name = strip_tags(request.POST.get("name"))
    price = request.POST.get("price")
    quantity = request.POST.get("quantity")
    description = strip_tags(request.POST.get("description"))
    category = strip_tags(request.POST.get("category"))
    user = request.user

    new_product= Product(
        user=user, 
        name=name, 
        price=price,
        quantity=quantity, 
        description=description,
        category=category,
    )
    new_product.save()

    return HttpResponse(b"CREATED", status=201)
    ```

- Menambahkan Routing untuk fungsi `add_product_entry_ajax` di `urls.py` dan menambahkan pathnya juga.
    ```python
    from django.urls import path
    from main.views import show_main, create_product_entry, show_xml, show_json, show_xml_by_id, show_json_by_id, register, login_user, logout_user, edit_product, delete_product, add_product_entry_ajax

    app_name = 'main'

    urlpatterns = [
        path('', show_main, name='show_main'),
        path('create-product-entry', create_product_entry, name='create_product_entry'),
        path('xml/', show_xml, name='show_xml'),
        path('json/', show_json, name='show_json'),
        path('xml/<str:id>/', show_xml_by_id, name='show_xml_by_id'),
        path('json/<str:id>/', show_json_by_id, name='show_json_by_id'),
        path('register/', register, name='register'),
        path('login/', login_user, name='login'),
        path('logout/', logout_user, name='logout'),
        path('edit-product/<uuid:id>', edit_product, name='edit_product'),
        path('delete/<uuid:id>', delete_product, name='delete_product'),
        path('add_product_entry_ajax', add_product_entry_ajax, name='add_product_entry_ajax'),
    ]
    ```
- Menampilkan Data Product dengan `fetch()` API
    1. Menghapus 2 baris yang tidak diperlukan
    ```python
    products = Product.objects.filter(user=request.user)
    ```
    dan baris ini
    ```python
    'products': products,
    ```
    2. Mengubah baris pertama di `views.py`
    ```python
    def show_xml(request):
    data = data = Product.objects.filter(user=request.user)
    return HttpResponse(serializers.serialize("xml", data), content_type="application/xml")

    def show_json(request):
        data = data = Product.objects.filter(user=request.user)
        return HttpResponse(serializers.serialize("json", data), content_type="application/json")
    ```
    3. Saya menambahkan blok ini untuk menandakan tampilan dari `product_card`
    ```html
      <div id="product_card"></div>
    ```
    4. Saya menambahkan script untuk menampilkan. Saya membuat `getProducts()` dan `refreshProducts()`
    ```JavaScript
        async function getProducts(){
        return fetch("{% url 'main:show_json' %}").then((res) => res.json())
    }

    async function refreshProducts() {
        document.getElementById("product_card").innerHTML = "";
        document.getElementById("product_card").className = "";
        const product = await getProducts();
        let htmlString = "";
        let classNameString = "";

        if (product.length === 0) {
            classNameString = "flex flex-col items-center justify-center min-h-[24rem] p-6";
            htmlString = `
                <div class="flex flex-col items-center justify-center min-h-[24rem] p-6">
                    <img src="{% static 'image/noneproduct.png' %}" alt="Sad face" class="w-32 h-32 mb-4"/>
                    <p class="text-center text-gray-600 mt-4">Belum ada data product.</p>
                </div>
            `;
        }
        else {
        classNameString = "columns-1 sm:columns-2 lg:columns-3 gap-6 space-y-6 w-full";
        product.forEach((item) => {
            const name = DOMPurify.sanitize(item.fields.name);
            const description = DOMPurify.sanitize(item.fields.description);
            const category = DOMPurify.sanitize(item.fields.category);
            htmlString += `
            <div class="relative break-inside-avoid mb-6">
            <div class="relative bg-white shadow-lg rounded-lg overflow-hidden transform hover:scale-105 transition-transform duration-300">
                <div class="p-4 border-t-4 border-red-500">
                <h3 class="text-xl font-bold text-gray-800 mb-2">${item.fields.name}</h3>
                <p class="text-sm font-semibold text-yellow-500 mb-2">${item.fields.category}</p>
                <p class="text-gray-600 mb-4">
                    ${item.fields.description}
                </p>
                <div class="flex items-center justify-between mb-2">
                    <span class="text-lg font-semibold text-red-600">
                    Rp${item.fields.price}
                    </span>
                    <span class="text-sm text-gray-700">
                    Stock: ${item.fields.quantity}
                    </span>
                </div>
                </div>

                <div class="flex justify-end space-x-4 p-4 border-t border-gray-200">
                <a href="/edit-product/${item.pk}" 
                    class="bg-yellow-500 hover:bg-yellow-600 text-white font-semibold py-2 px-4 rounded-lg transition duration-300">
                    Edit
                </a>
                <a href="/delete/${item.pk}" 
                    class="bg-red-500 hover:bg-red-600 text-white font-semibold py-2 px-4 rounded-lg transition duration-300">
                    Delete
                </a>
                </div>
            </div>
            </div>
            `;
        });
    }
        document.getElementById("product_card").className = classNameString;
        document.getElementById("product_card").innerHTML = htmlString;
    }
    ```
- Membuat Modal sebagai form untuk menambah produk dengan ajax
1. Implementasi Modal
    ````html
        <div id="crudModal" tabindex="-1" aria-hidden="true" class="hidden fixed inset-0 z-50 w-full flex items-center justify-center bg-gray-800 bg-opacity-50 overflow-x-hidden overflow-y-auto transition-opacity duration-300 ease-out">
            <div id="crudModalContent" class="relative bg-white rounded-lg shadow-lg w-5/6 sm:w-3/4 md:w-1/2 lg:w-1/3 mx-4 sm:mx-0 transform scale-95 opacity-0 transition-transform transition-opacity duration-300 ease-out">
            <!-- Modal header -->
            <div class="flex items-center justify-between p-4 border-b rounded-t">
                <h3 class="text-xl font-semibold text-gray-900">
                Add New Product Entry
                </h3>
                <button type="button" class="text-gray-400 bg-transparent hover:bg-gray-200 hover:text-gray-900 rounded-lg text-sm p-1.5 ml-auto inline-flex items-center" id="closeModalBtn">
                <svg aria-hidden="true" class="w-5 h-5" fill="currentColor" viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg">
                    <path fill-rule="evenodd" d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" clip-rule="evenodd"></path>
                </svg>
                <span class="sr-only">Close modal</span>
                </button>
            </div>
            <!-- Modal body -->
            <div class="px-6 py-4 space-y-6 form-style">
                <form id="productForm">
                <div class="mb-4">
                    <label for="name" class="block text-sm font-medium text-gray-700">Product Name</label>
                    <input type="text" id="name" name="name" class="mt-1 block w-full border border-gray-300 rounded-md p-2 hover:border-indigo-700" placeholder="Enter product name" required>
                </div>
                <div class="mb-4">
                    <label for="price" class="block text-sm font-medium text-gray-700">Price</label>
                    <input type="number" id="price" name="price" min="0" class="mt-1 block w-full border border-gray-300 rounded-md p-2 hover:border-indigo-700" placeholder="Enter price" required>
                </div>
                <div class="mb-4">
                    <label for="quantity" class="block text-sm font-medium text-gray-700">Quantity</label>
                    <input type="number" id="quantity" name="quantity" min="0" class="mt-1 block w-full border border-gray-300 rounded-md p-2 hover:border-indigo-700" placeholder="Enter quantity" required>
                </div>
                <div class="mb-4">
                    <label for="description" class="block text-sm font-medium text-gray-700">Description</label>
                    <textarea id="description" name="description" rows="3" class="mt-1 block w-full resize-none border border-gray-300 rounded-md p-2 hover:border-indigo-700" placeholder="Enter product description" required></textarea>
                </div>
                <div class="mb-4">
                    <label for="category" class="block text-sm font-medium text-gray-700">Category</label>
                    <input type="text" id="category" name="category" class="mt-1 block w-full border border-gray-300 rounded-md p-2 hover:border-indigo-700" placeholder="Enter category" required>
                </div>
                </form>
            </div>
            <!-- Modal footer -->
            <div class="flex flex-col space-y-2 md:flex-row md:space-y-0 md:space-x-2 p-6 border-t border-gray-200 rounded-b justify-center md:justify-end">
                <button type="button" class="bg-gray-500 hover:bg-gray-600 text-white font-bold py-2 px-4 rounded-lg" id="cancelButton">Cancel</button>
                <button type="submit" id="submitProductEntry" form="productForm" class="bg-indigo-700 hover:bg-indigo-600 text-white font-bold py-2 px-4 rounded-lg">Save</button>
            </div>
            </div>
        </div>
    ```
2. Menambahkan fungsi `showModal()` dan `hideModal()`
    ```JavaScript
    const modal = document.getElementById('crudModal');
    const modalContent = document.getElementById('crudModalContent');

    function showModal() {
        const modal = document.getElementById('crudModal');
        const modalContent = document.getElementById('crudModalContent');

        modal.classList.remove('hidden'); 
        setTimeout(() => {
            modalContent.classList.remove('opacity-0', 'scale-95');
            modalContent.classList.add('opacity-100', 'scale-100');
        }, 50); 
    }

    function hideModal() {
        const modal = document.getElementById('crudModal');
        const modalContent = document.getElementById('crudModalContent');

        modalContent.classList.remove('opacity-100', 'scale-100');
        modalContent.classList.add('opacity-0', 'scale-95');

        setTimeout(() => {
            modal.classList.add('hidden');
        }, 150); 
    }
      document.getElementById("cancelButton").addEventListener("click", hideModal);
      document.getElementById("closeModalBtn").addEventListener("click", hideModal);
    ```
3. Menambahkan Button
    ```html
        <button data-modal-target="crudModal" data-modal-toggle="crudModal" class="btn bg-indigo-700 hover:bg-indigo-600 text-white font-bold py-2 px-4 rounded-lg transition duration-300 ease-in-out transform hover:-translate-y-1 hover:scale-105" onclick="showModal();">
        Add New Product by AJAX
        </button>
    ```

- Menambahkan data Product dengan AJAX
1. Membuat fungsi `aaddProductEntry()` pada `script` dan menambahkan event listener untuk menjalankan fungsinya
    ```html
    <script>
        function addProductEntry() {
        fetch("{% url 'main:add_product_entry_ajax' %}", {
        method: "POST",
        body: new FormData(document.querySelector('#productForm')),
        })
        .then(response => refreshProducts())

        document.getElementById("productForm").reset(); 
        document.querySelector("[data-modal-toggle='crudModal']").click();

        return false;
    }
    ...

        document.getElementById("productForm").addEventListener("submit", (e) => {
        e.preventDefault();
        addProductEntry();
    })
    </script>
    ```

</details>
