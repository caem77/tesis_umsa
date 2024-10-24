import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:milike/src/screens/logout.dart';
import 'package:milike/src/screens/post_crud_screen.dart';
import 'package:milike/src/screens/post_screen.dart';
import 'package:milike/src/utils/local_storage.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();
  final box = GetStorage();
  int _selectedScreenIndex = 0;
  String nombre = '';

  List<Widget> screens = [];
  List<Widget> iconos = [];

  @override
  void initState() {
    super.initState();
    cargarMenus();
  }

  cargarMenus() {
    screens = [];
    iconos = [];
    print('rol es..... ${box.read('rol')}');

    if (box.read('rol') == 2) {
      screens.add(const PostCrudScreen());
      iconos.add(Icon(Icons.post_add, size: 30, color: Colors.blue[800]));
      iconos.add(Icon(
        Icons.thumb_up,
        size: 30,
        color: Colors.blue[800],
      ));
      screens.add(const PostScreen());
      iconos.add(Icon(Icons.logout, size: 30, color: Colors.red[800]));
      screens.add(const Logout());
    } else {
      iconos.add(Icon(
        Icons.thumb_up,
        size: 30,
        color: Colors.blue[800],
      ));
      screens.add(const PostScreen());
      iconos.add(Icon(Icons.logout, size: 30, color: Colors.red[800]));
      screens.add(const Logout());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color.fromARGB(255, 230, 231, 233),
        child: screens[_selectedScreenIndex],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: 0,
        height: 60.0,
        items: iconos,
        color: Colors.white,
        buttonBackgroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 230, 231, 233),
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 600),
        onTap: (index) {
          setState(() {
            _selectedScreenIndex = index;
          });
        },
        letIndexChange: (index) => true,
      ),
    );
  }
}
