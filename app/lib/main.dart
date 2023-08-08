import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:app/screens/tabs.dart';

const colorOrange=Color.fromARGB(255, 255, 165, 0);
const colorWhite=Colors.white;

final theme=ThemeData(
  useMaterial3: true,
  appBarTheme: const AppBarTheme(
    backgroundColor:  colorOrange,
    foregroundColor: colorWhite
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: colorOrange,
    selectedItemColor: colorWhite,
  ),
  );

void main(){
  runApp(const ProviderScope(child: App()));
}

class App extends StatelessWidget{
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme,
      home: const TabsScreen(),
    );
  }
}