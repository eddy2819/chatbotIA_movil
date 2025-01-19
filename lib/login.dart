import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Importar paquete para cambiar el color de la barra de estado
import 'services/auth_service.dart'; // Importar AuthService
import 'home.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Importar SharedPreferences

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _passwordVisible = false;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;

    // Cambiar el color de la barra de estado y la barra de navegación
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.white, // Color de la barra de estado
        statusBarIconBrightness:
            Brightness.dark, // Color de los íconos de la barra de estado
        systemNavigationBarColor:
            Colors.white, // Color de la barra de navegación
        systemNavigationBarIconBrightness:
            Brightness.dark, // Color de los íconos de la barra de navegación
      ),
    );
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      try {
        final authService = AuthService();
        final response = await authService.login(
          _emailController.text,
          _passwordController.text,
        );

        // Guardar el token de acceso y el nombre
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('access_token', response['access_token'] ?? '');
        await prefs.setString('name', response['name'] ?? '');
        final token = prefs.getString('access_token');
        final userName = prefs.getString('name');
        print('Token almacenado: $token');
        print('Nombre almacenado: $userName');

        print('Usuario inició sesión exitosamente');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } catch (e) {
        print('Error en el inicio de sesión: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Email o contraseña equivocadas')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Añadir fondo blanco
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        elevation: 0,
        automaticallyImplyLeading: false, // Eliminar la flecha hacia atrás
        title: null, // Eliminar la palabra "Login"
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 24),
                // Logo
                Center(
                  child: Image.asset(
                    'assets/logo.png', // Asegúrate de que la ruta sea correcta
                    height: 100, // Ajusta el tamaño según sea necesario
                  ),
                ),
                SizedBox(height: 16),
                // Email Input
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    prefixIcon: Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese su email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                // Password Input
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                    ),
                  ),
                  obscureText: !_passwordVisible,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor ingrese su contraseña';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 8),
                // Remember Me and Forgot Password
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: false,
                          onChanged: (value) {
                            // Acción para "Remember Me"
                          },
                        ),
                        Text('Recuerdame'),
                      ],
                    ),
                    TextButton(
                      onPressed: () {
                        // Acción para "Forgot Password?"
                      },
                      child: Text(
                        'Restablecer contraseña?',
                        style: TextStyle(color: Colors.purple),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                // Login Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                  ),
                  onPressed: _login,
                  child: Text(
                    'Iniciar Sesion',
                    style: TextStyle(
                      fontSize: 16,
                      color: const Color.fromARGB(255, 37, 36, 36),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                // Sign Up
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("No tienes una cuenta? "),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          '/register',
                        ); // Navegar a la página de registro
                      },
                      child: Text(
                        'Registrate',
                        style: TextStyle(color: Colors.purple),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24),
                // Continue With
                Row(
                  children: [
                    Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text('O continua con'),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),
                SizedBox(height: 16),
                // Social Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(
                      onPressed: () {
                        // Acción para Google
                      },
                      icon: Icon(Icons.g_mobiledata),
                      iconSize: 32,
                    ),
                    IconButton(
                      onPressed: () {
                        // Acción para Facebook
                      },
                      icon: Icon(Icons.facebook),
                      color: Colors.blue,
                      iconSize: 32,
                    ),
                    IconButton(
                      onPressed: () {
                        // Acción para Apple
                      },
                      icon: Icon(Icons.apple),
                      iconSize: 32,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
