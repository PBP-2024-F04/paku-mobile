# PaKu: Palu Kuliner

## :busts_in_silhouette: Anggota Kelompok F04
1. 2306244936 &mdash; Rizqya Az Zahra Putri
2. 2306215816 &mdash; Arya Raditya Kusuma
3. 2306152411 &mdash; Muhammad Vito Secona
4. 2306224556 &mdash; Nafia Levana Aulia
5. 2306209933 &mdash; Naila Shakira Putrindari

## :spiral_notepad: Deskripsi Aplikasi

**PaKu (Palu Kuliner)** adalah layanan berbasis website dan aplikasi yang dirancang untuk memudahkan pendatang baru dalam menjelajahi ragam kuliner khas di sekitar kota Palu. Aplikasi ini menghadirkan fitur interaktif seperti **timeline** yang memungkinkan pengguna berbagi pengalaman kuliner mereka, menulis ulasan, serta menandai makanan favorit. Dengan sistem **review dan rating** yang dapat diakses oleh semua pengguna, PaKu membantu para pecinta kuliner menemukan rekomendasi makanan terbaik dari komunitas pengguna lainnya. Fitur **like dan favorit** memungkinkan pengguna menyimpan dan melacak makanan yang mereka sukai, menciptakan pengalaman kuliner yang lebih personal dan terorganisir.

Bagi merchant, PaKu memberikan peluang untuk **menambahkan produk makanan** baru serta **promosi menarik**, seperti diskon atau paket spesial, yang terhubung langsung dengan produk tertentu. Ini membantu merchant menjangkau lebih banyak pelanggan dan memperluas bisnis mereka. Dengan memberikan platform yang intuitif dan mudah diakses, PaKu mempertemukan foodie dan merchant dalam satu ekosistem kuliner, sekaligus mempromosikan cita rasa autentik lokal Palu. Aplikasi ini tidak hanya memudahkan pendatang untuk merasakan kuliner khas, tetapi juga mendorong pelaku usaha kuliner lokal untuk berkembang lebih luas di era digital.

## :open_file_folder: Daftar Modul yang akan Diimplementasikan

### Modul utama 

- **Review & Rating** _(dikerjakan oleh Nafia Levana Aulia)_:  
  Pengguna memiliki kemampuan untuk memberikan ulasan dan rating terhadap makanan yang telah mereka beli. Ulasan ini dapat diakses oleh pengguna lain, membantu menciptakan panduan yang dapat diandalkan untuk memilih makanan terbaik.

- **Timeline** _(dikerjakan oleh Muhammad Vito Secona)_:  
  Pengguna dapat membagikan pengalaman kuliner mereka dengan menambahkan makanan ke timeline, disertai ulasan singkat atau caption, seperti fitur media sosial. Ini memungkinkan pengguna untuk berbagi rekomendasi makanan secara langsung.

- **Like/Favorit** _(dikerjakan oleh Naila Shakira Putrindari)_:  
  Pengguna bisa menandai dan menyimpan makanan favorit mereka. Terdapat beberapa tag yang bisa diassign ketika memfavoritkan suatu makanan, yaitu 'Want to Try', 'Loving it', 'All Time Favorite'. Fitur ini dapat memberikan referensi cepat untuk makanan yang ingin dicoba lagi di masa depan.

- **Add Product** _(dikerjakan oleh Rizqya Az Zahra Putri)_:  
  Merchant dapat dengan mudah menambahkan produk makanan baru ke dalam aplikasi, lengkap dengan deskripsi dan harga. Ini memungkinkan mereka memperbarui daftar menu mereka secara berkala dan menjangkau lebih banyak foodie.

- **Add Promo** _(dikerjakan oleh Arya Raditya Kusuma)_:  
  Merchant bisa membuat promosi khusus seperti diskon atau paket bundling untuk menarik pelanggan. Promo ini terhubung langsung dengan produk tertentu, memberikan cara yang efektif untuk meningkatkan penjualan.

### Modul tambahan

- **Explore**:  
  Foodie dapat mencari makanan-makanan yang ada di database berdasarkan filter kategori, restoran, atau melalui search bar, memudahkan foodie untuk mencari makanan yang dia minati.

- **View other profile**:  
  Foodie dapat melihat profile dari foodie lain, dapat melihat post, favorite, dan review yang pernah foodie tersebut berikan. Dengan ini, foodie dapat dengan mudah berkoneksi dan berbagi rekomendasi dengan foodie lainnya.

## :bust_in_silhouette: _Role_ atau Peran Pengguna beserta Deskripsinya

1. **Guest**:  
   Pengguna yang belum melakukan log in.

2. **Foodie**:  
   Pengguna biasa yang dapat mencari, memberikan rating, ulasan, dan menyimpan makanan favorit. Mereka juga bisa berbagi pengalaman di timeline aplikasi.

3. **Merchant (Mitra)**:  
   Pengguna yang memiliki restoran atau warung dan dapat menambah produk serta mengelola promosi yang mereka tawarkan kepada foodie.

## :bust_in_silhouette: Alur Pengintegrasian dengan _web service_

1. Membuat Endpoint JSON di Proyek Django
   - Identifikasi kebutuhan data untuk setiap modul yang akan diakses oleh aplikasi Flutter.
   - Buat endpoint berbasis JSON untuk setiap modul pada proyek Django.
   - Implementasi mekanisme autentikasi (login dan logout) pada proyek Django untuk mengamankan akses ke endpoint.

2. Mengoptimalkan Endpoint.
   - Implementasikan pagination untuk menangani data dalam jumlah besar.
   - Validasi data untuk mencegah input yang tidak valid.
   - Mengintegrasikan Endpoint di Flutter

3. Menggunakan library `http` untuk mengakses endpoint.
   - Implementasi mekanisme autentikasi pada proyek Flutter.
   - Penanganan respons, termasuk kode status HTTP seperti 200, 400, atau 500.
   - Parsing data JSON menggunakan model berupa class di Dart.

## :rocket: Tautan APK
[Deployment PaKu](https://install.appcenter.ms/orgs/pbp-f04/apps/paku/distribution_groups/public/releases)

## :rocket: Tautan Video
[Video Promosi PaKu](https://youtu.be/m0JIzna7IsQ?si=tUCgHwhBvFlbrqEd)

## :rocket: Sheets Tracker Pengerjaan
[Sheets Tracker Pengerjaan PaKu](https://docs.google.com/spreadsheets/d/1xTAlUjnHdHML4rV8QLKRsMHG14CR71f_xnXhZ5GjmDs/edit?usp=sharing)
