class AuthController {
  bool isLoggedIn = false;
  String userType = ''; // Menyimpan tipe pengguna (user atau admin)

  Future<bool> login(String username, String password, String userType) async {
    // Simulasi pengecekan ke database atau server
    await Future.delayed(Duration(milliseconds: 200));

    // Contoh validasi sederhana
    if ((username == 'user' && password == 'user123' && userType == 'user') ||
        (username == 'admin' &&
            password == 'admin123' &&
            userType == 'admin')) {
      isLoggedIn = true;
      this.userType = userType; // Tetapkan tipe pengguna setelah login
      return true;
    } else {
      isLoggedIn = false;
      return false;
    }
  }

  void logout() {
    isLoggedIn = false;
    userType = ''; // Reset tipe pengguna saat logout
  }
}
