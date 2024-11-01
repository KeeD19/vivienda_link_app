import 'package:flutter/material.dart';
import 'package:vivienda_link_app/utils/Colors_Utils.dart';
import '../chat/Chat.dart';
import '../home/Dashboard.dart';
import '../payments/Payments.dart';
import '../../utils/HeadUtil.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  static final List<Widget> _pages = <Widget>[
    const DashboardPage(),
    const ChatPage(),
    const PaymentsPage()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: const HeadUtil(),
      body: SizedBox(
        width: screenWidth,
        height: screenHeight * 0.8,
        child: _pages[_selectedIndex],
      ),
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
        selectedItemColor: AppColors.bluePrimaryColor,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.white,
        onTap: _onItemTapped,
      ),
    );
  }
}
