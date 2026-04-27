// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get appTitle => 'Story App';

  @override
  String get login => 'Masuk';

  @override
  String get register => 'Daftar';

  @override
  String get logout => 'Keluar';

  @override
  String get email => 'Email';

  @override
  String get password => 'Kata Sandi';

  @override
  String get name => 'Nama';

  @override
  String get loginTitle => 'Selamat Datang';

  @override
  String get loginSubtitle => 'Masuk untuk berbagi ceritamu';

  @override
  String get registerTitle => 'Buat Akun';

  @override
  String get registerSubtitle => 'Bergabung dan bagikan perjalanan belajarmu';

  @override
  String get noAccount => 'Belum punya akun? ';

  @override
  String get haveAccount => 'Sudah punya akun? ';

  @override
  String get signIn => 'Masuk';

  @override
  String get signUp => 'Daftar';

  @override
  String get storyList => 'Cerita';

  @override
  String get storyDetail => 'Detail Cerita';

  @override
  String get addStory => 'Cerita Baru';

  @override
  String get description => 'Deskripsi';

  @override
  String get descriptionHint => 'Ceritakan tentang momen ini...';

  @override
  String get camera => 'Kamera';

  @override
  String get gallery => 'Galeri';

  @override
  String get upload => 'Unggah';

  @override
  String get uploading => 'Mengunggah...';

  @override
  String get loading => 'Memuat...';

  @override
  String get errorOccurred => 'Terjadi kesalahan';

  @override
  String get retry => 'Coba Lagi';

  @override
  String get emptyStories => 'Belum ada cerita. Jadilah yang pertama!';

  @override
  String get logoutConfirm => 'Apakah Anda yakin ingin keluar?';

  @override
  String get cancel => 'Batal';

  @override
  String get confirm => 'Konfirmasi';

  @override
  String get registerSuccess => 'Pendaftaran berhasil! Silakan masuk.';

  @override
  String get uploadSuccess => 'Cerita berhasil diunggah!';

  @override
  String get emailRequired => 'Email wajib diisi';

  @override
  String get passwordRequired => 'Kata sandi wajib diisi';

  @override
  String get nameRequired => 'Nama wajib diisi';

  @override
  String get descriptionRequired => 'Deskripsi wajib diisi';

  @override
  String get passwordMinLength => 'Kata sandi minimal 8 karakter';

  @override
  String get selectImage => 'Silakan pilih gambar';

  @override
  String get changeLanguage => 'Ganti Bahasa';

  @override
  String postedBy(String name) {
    return 'Dikirim oleh $name';
  }
}
