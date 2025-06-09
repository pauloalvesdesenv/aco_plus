import 'package:aco_plus/app/core/components/h.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      showSemanticsDebugger: false,
      debugShowMaterialGrid: false,
      home: Scaffold(
        backgroundColor: Color(0xFFF8FCFC),
        body: Center(
          child: SizedBox(
            width: 300,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const H(20),
                Image.asset('assets/images/logo.png', width: 60),
                const H(20),
                Text(
                  'AÇO+',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const H(20),
                Text(
                  'Carregando, por favor aguarde...',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
                const H(4),
                SizedBox(
                  width: 250,
                  height: 4,
                  child: LinearProgressIndicator(
                    color: Colors.red,
                    backgroundColor: Colors.red.withOpacity(0.1),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
