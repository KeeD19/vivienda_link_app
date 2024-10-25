import 'package:flutter/material.dart';
import '../chat/Chat.dart';
import '../home/Dashboard.dart';
import '../payments/Payments.dart';
// import 'package:provider/provider.dart';
// import '../../providers/Auth_provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Esta variable mantiene el índice de la pestaña seleccionada
  int _selectedIndex = 0;

  // Lista de las pantallas que se mostrarán al seleccionar cada opción
  static List<Widget> _pages = <Widget>[
    DashboardPage(),
    ChatPage(),
    PaymentsPage()
  ];

  // Método para actualizar el índice cuando se selecciona una nueva opción
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vivienda Link'),
        // Image.asset('assets/images/logoVivienda.jpeg'),
      ),
      body: _pages[_selectedIndex], // Muestra la pantalla seleccionada
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.payment),
            label: 'Pagos',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor:
            Colors.green, // Cambia el color del icono seleccionado
        unselectedItemColor:
            Colors.grey, // Color de los iconos no seleccionados
        backgroundColor: Colors.white, // Fondo de la barra de navegación
        onTap: _onItemTapped,
      ),
    );
  }
}
