import 'package:flutter/material.dart';
import 'home.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
      url: 'https://lufcdolvcnpgsbjhdooo.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imx1ZmNkb2x2Y25wZ3Niamhkb29vIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzY4MjY1NjIsImV4cCI6MjA1MjQwMjU2Mn0.FA4C97uZZfpuxfBDtmJUCxWs_O20NJLDtugmhNepMIY');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LoginPage(),
    );
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink.shade50, // Background warna pink muda
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset(
                "assets/images/logo.png", // Ganti dengan path gambar Anda
                width: 300,
                height: 300,
              ),
              const _InputField(),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     const Text("Don't have an account?"),
              //     TextButton(
              //       onPressed: () {
              //         Navigator.push(
              //           context,
              //           MaterialPageRoute(
              //               builder: (context) => const SignUpPage()),
              //         );
              //       },
              //       child: const Text("Register"),
              //     ),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InputField extends StatefulWidget {
  const _InputField({super.key});

  @override
  State<_InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<_InputField> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword =
      true; // Untuk menyembunyikan atau menampilkan password
  final SupabaseClient supabase = Supabase.instance.client;

  Future<void> _login() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Username dan password tidak boleh kosong!"),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    try {
      final response = await supabase
          .from('user')
          .select()
          .eq('username', username)
          .eq('password', password)
          .single();

      if (response != null) {
        // Login berhasil
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login berhasil!')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } else {
        // Data tidak ditemukan
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Username atau password salah!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: $e')),
      );
    }
  }

  // void _login(BuildContext context) {
  //   if (_usernameController.text.isEmpty) {
  //     // Menampilkan pesan error jika username kosong
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text("Username tidak boleh kosong!"),
  //         backgroundColor: Colors.redAccent,
  //       ),
  //     );
  //     return;
  //   }

  //   // Jika validasi berhasil, navigasi ke HomePage
  //   Navigator.push(
  //     context,
  //     MaterialPageRoute(
  //       builder: (context) => const HomePage(),
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildTextField(
          context,
          controller: _usernameController,
          hintText: "Username",
          icon: Icons.person, // Tambahkan ikon person untuk username
        ),
        const SizedBox(height: 10),
        _buildTextField(
          context,
          controller: _passwordController,
          hintText: "Password",
          icon: Icons.lock, // Tambahkan ikon lock untuk password
          isPassword: true,
        ),
        const SizedBox(height: 10),
        // Forgot Password text
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {
              // Forgot Password logic here
            },
            child: const Text(
              "Forgot Password?",
              style: TextStyle(color: Colors.black),
            ),
          ),
        ),
        ElevatedButton(
          onPressed:
              _login, // Jangan lupa tanda kurung jika ingin menjalankan fungsi
          style: ElevatedButton.styleFrom(
            maximumSize: const Size(200, 50),
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
          ),
          child: const Text(
            "Login",
            style: TextStyle(
              fontSize: 20,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(
    BuildContext context, {
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool isPassword = false,
  }) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.black), // Warna teks hitam
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        fillColor: Colors.white,
        filled: true,
        prefixIcon: Icon(
          icon, // Ikon yang sesuai (person atau lock)
          color: Colors.black,
        ),
        // Menambahkan ikon mata di sisi kanan untuk password
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  color: Colors.black,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              )
            : null,
      ),
      obscureText: isPassword
          ? _obscurePassword
          : false, // Menangani tampilkan/menghilangkan password
      style: const TextStyle(color: Colors.black), // Warna teks hitam
    );
  }
}

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword =
      true; // Untuk menyembunyikan atau menampilkan password

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink
          .shade50, // Background warna pink muda yang sama seperti halaman login
      appBar: AppBar(
        title: const Text("Register"),
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                "Create a new account",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              _buildTextField("Username", icon: Icons.person),
              const SizedBox(height: 10),
              _buildTextField("Password", icon: Icons.lock, isPassword: true),
              const SizedBox(height: 20),
              TextButton(
      
                onPressed: () {
                  // Sign Up logic here
                },
                style: TextButton.styleFrom(
                  fixedSize: Size(400, 100),
                  backgroundColor: Colors.white,
                  shape: const StadiumBorder(),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  "Register",
                  style: TextStyle(
                    fontSize: 30,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String hintText,
      {required IconData icon, bool isPassword = false}) {
    return TextField(
      controller: isPassword ? _passwordController : _usernameController,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.black), // Warna teks hitam
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(18),
          borderSide: BorderSide.none,
        ),
        fillColor: Colors.white,
        filled: true,
        prefixIcon: Icon(
          icon, // Ikon yang sesuai
          color: Colors.black,
        ),
        // Menambahkan ikon mata di sisi kanan untuk password
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  color: Colors.black,
                ),
                onPressed: () {
                  setState(() {
                    _obscurePassword = !_obscurePassword;
                  });
                },
              )
            : null,
      ),
      obscureText: isPassword
          ? _obscurePassword
          : false, // Menangani tampilkan/menghilangkan password
      style: const TextStyle(color: Colors.black), // Warna teks hitam
    );
  }
}
