import 'package:arilatiahflutter1/Tugasflutter8.dart';
import 'package:arilatiahflutter1/latihanflutter7.dart';
import 'package:flutter/material.dart';

class navigation extends StatefulWidget {
  const navigation({super.key});

  @override
  State<navigation> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<navigation> {
  // INDEX BOTTOM NAVIGATION
  int _selectedIndex = 0;

  // DAFTAR HALAMAN
  static const List<Widget> _widgetOptions = <Widget>[
    InputInteraktif(),
    tugas8(),
  ];

  // FUNGSI PINDAH HALAMAN
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: _widgetOptions.elementAt(_selectedIndex)),
      // / BOTTOM NAVIGATION
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Rumah'),

          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Business',
          ),
        ],

        currentIndex: _selectedIndex,

        selectedItemColor: const Color.fromARGB(255, 7, 23, 255),

        onTap: _onItemTapped,
      ),
    );
  }
}
