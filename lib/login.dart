import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Importar paquete para cambiar el color de la barra de estado
import 'home.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _passwordVisible = false;

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
              TextField(
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 16),
              // Password Input
              TextField(
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
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                  );
                },
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
    );
  }
}
