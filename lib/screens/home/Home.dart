import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vivienda_link_app/utils/Colors_Utils.dart';
import '../../providers/Auth_provider.dart';
import '../../utils/SpinnerLoader.dart';
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
  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.getTypeUser();
  }

  int _selectedIndex = 0;

  static final List<Widget> _pages = <Widget>[const DashboardPage(), const ChatPage(), const PaymentsPage()];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final ordersProvider = Provider.of<AuthProvider>(context);
    debugPrint('tipo de usuario: ${ordersProvider.typeUser}');
    return Scaffold(
        appBar: const HeadUtil(),
        body: ordersProvider.isLoading
            ? const Center(child: Spinner())
            : SizedBox(
                width: screenWidth,
                height: screenHeight * 0.8,
                child: _pages[_selectedIndex],
              ),
        bottomNavigationBar: ordersProvider.typeUser == 3
            ? Container(
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(color: AppColors.backgroundColor), // Quita el borde superior
                  ),
                ),
                child: BottomNavigationBar(
                  elevation: 0,
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
                  selectedItemColor: AppColors.orangeColor,
                  unselectedItemColor: AppColors.grey,
                  backgroundColor: AppColors.backgroundColor,
                  onTap: _onItemTapped,
                ))
            : Container(
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(color: AppColors.backgroundColor), // Quita el borde superior
                  ),
                ),
                child: BottomNavigationBar(
                  elevation: 0,
                  items: const <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home),
                      label: 'Home',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.chat_bubble),
                      label: 'Chat',
                    ),
                  ],
                  currentIndex: _selectedIndex,
                  selectedItemColor: AppColors.orangeColor,
                  unselectedItemColor: AppColors.grey,
                  backgroundColor: AppColors.backgroundColor,
                  onTap: _onItemTapped,
                ),
              ));
  }
}
