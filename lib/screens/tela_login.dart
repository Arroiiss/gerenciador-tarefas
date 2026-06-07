import "package:flutter/material.dart";

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLogin = true;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  void _handleAuth() {
    final email = _emailController.text;
    if (!email.contains("@")) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("E-mail inválido"),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    if (isLogin) {
      Navigator.pushReplacementNamed(context, "/calendar");
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Conta criada com sucesso! Agora faça seu login."),
          backgroundColor: Colors.orange,
        ),
      );
      setState(() {
        isLogin = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: -50,
            right: -50,
            child: CircleAvatar(
              radius: 120,
              backgroundColor: Colors.deepOrange.withOpacity(0.2),
            ),
          ),
          Positioned(
            bottom: -80,
            left: -30,
            child: CircleAvatar(
              radius: 150,
              backgroundColor: Colors.orangeAccent.withOpacity(0.15),
            ),
          ),

          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Container(
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      isLogin ? "Seja bem-vindo!" : "Realize seu cadastro",
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.orangeAccent,
                          ),
                    ),
                    const SizedBox(height: 30),
                    _buildTextField(Icons.email, "E-mail", controller: _emailController),
                    const SizedBox(height: 16),
                    _buildTextField(Icons.lock, "Senha", controller: _passwordController, obscure: true),
                    if (!isLogin) ...[
                      const SizedBox(height: 16),
                      _buildTextField(Icons.person, "Nome Completo", controller: _nameController),
                    ],
                    const SizedBox(height: 40),
                    _buildGradientButton(
                      isLogin ? "ENTRAR" : "CADASTRAR",
                      _handleAuth,
                    ),
                    const SizedBox(height: 20),
                    TextButton(
                      onPressed: () => setState(() => isLogin = !isLogin),
                      child: Text(
                        (isLogin ? "Realize seu cadastro" : "Faça seu login"),
                        style: const TextStyle(color: Colors.orangeAccent),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(IconData icon, String hint, {required TextEditingController controller, bool obscure = false}) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.white60),
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white38),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildGradientButton(String label, VoidCallback onPressed) {
    return Container(
      width: double.infinity,
      height: 55,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Colors.orangeAccent, Colors.deepOrange],
        ),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.orangeAccent.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}

