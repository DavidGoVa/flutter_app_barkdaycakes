import 'package:barkdaycakes_app/filter1_page.dart';
import 'package:barkdaycakes_app/filter2_page.dart';
import 'package:barkdaycakes_app/filter3_page.dart';
import 'package:barkdaycakes_app/producto_detalle_page.dart';
import 'package:barkdaycakes_app/providers/productos_provider.dart';
import 'package:flutter/material.dart';
import 'dart:async';
/*import 'package:google_sign_in/google_sign_in.dart';*/
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'tracker_page.dart';
import 'menu_page.dart';
import 'information/profile_page.dart';
import 'information/aboutus_page.dart';
import 'information/privacy_page.dart';
import 'models/cart.dart';

void main() {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      try {
        // Inicializa Stripe
        Stripe.publishableKey =
            'pk_test_51ROlKhDI84DN79IOIbeviXw4hoth5bmmgiBoc9QHASdFQ7gSaKjf4bFLOUdjywYWzPvM7PUML9RWp69AdUa4Mw8D00Jj424JzW';
        await Stripe.instance.applySettings();

        runApp(
          MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (context) => Cart()),
              ChangeNotifierProvider(create: (context) => ProductosProvider()),
            ],
            child: MyApp(),
          ),
        );
      } catch (e, stackTrace) {
        print("ERROR AL INICIAR LA APP: $e");
        print("STACKTRACE: $stackTrace");
      }
    },
    (error, stackTrace) {
      print("EXCEPCIÓN NO DETECTADA DURANTE LA EJECUCIÓN: $error");
      print("STACKTRACE: $stackTrace");
    },
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/home': (context) => HomeScreen(),
        '/menu': (context) => MenuPage(),
        '/tracker': (context) => TrackerPage(),
        '/profile': (context) => ProfilePage(),
        '/aboutus': (context) => AboutUsPage(),
        '/privacy': (context) => PrivacyPage(),
        '/producto_detalle': (context) {
          final args =
              ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>;
          final idProducto = args['idProducto'];
          return ProductoDetallePage(idProducto: idProducto);
        },
        '/filter1': (context) {
          final args =
              ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>;
          final nombreCategoria = args['nombreCategoria'];
          return Filter1Page(nombreCategoria: nombreCategoria);
        },
        '/filter2': (context) {
          final args =
              ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>;
          final nombreCategoria = args['nombreCategoria'];
          final filter1 = args['filter1'];
          return Filter2Page(
            nombreCategoria: nombreCategoria,
            filter1: filter1,
          );
        },
        '/filter3': (context) {
          final args =
              ModalRoute.of(context)!.settings.arguments
                  as Map<String, dynamic>;
          final nombreCategoria = args['nombreCategoria'];
          final filter1 = args['filter1'];
          final filter2 = args['filter2'];
          return Filter3Page(
            nombreCategoria: nombreCategoria,
            filter1: filter1,
            filter2: filter2,
          );
        },
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
      lowerBound: 0.9,
      upperBound: 1.1,
    )..repeat(reverse: true);

    _cargarProductos(); // Cargar los productos

    Future.delayed(Duration(seconds: 3), () {
      _controller.stop();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    });
  }

  // Método para cargar los productos en el provider
  Future<void> _cargarProductos() async {
    try {
      await Provider.of<ProductosProvider>(
        context,
        listen: false,
      ).cargarProductos();
    } catch (e) {
      print("Error al cargar productos: $e");
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF6AAAE),
      body: Center(
        child: ScaleTransition(
          scale: _controller,
          child: Image.asset('public/img/barkdaycakeslogo.png', width: 200),
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFF6AAAE),
        centerTitle: true, // Esto es clave
        title: Image.asset('public/img/barkdaycakeslogo.png', width: 100),
      ),
      drawer: Drawer(
        child: Container(
          color: Color.fromARGB(255, 247, 204, 206),
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(color: Color(0xFFF6AAAE)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.person_outline, size: 48, color: Colors.white),
                    SizedBox(height: 10),
                    Text(
                      'Hola, usuario',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Bienvenid@ a Barkday Cakes',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ),
              _buildDrawerItem(context, 'ORDENAR', routeName: "/menu"),
              _buildDrawerItem(context, 'TRACKER', routeName: "/tracker"),
              _buildDrawerItem(context, 'BARK PROFILE', routeName: "/profile"),
              Divider(color: Colors.white24),

              _buildDrawerItem(
                context,
                'Servicio al cliente',
                routeName: "/cs",
                isBold: false,
              ),
              _buildDrawerItem(
                context,
                'Nosotros',
                routeName: "/aboutus",
                isBold: false,
              ),
              _buildDrawerItem(
                context,
                'Privacidad',
                routeName: "/privacy",
                isBold: false,
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Color.fromRGBO(255, 255, 255, 1),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('public/img/homescreenimage.png', fit: BoxFit.cover),
          Column(
            children: [
              Expanded(child: Container()), // Espacio arriba (2/3)
              Container(
                margin: EdgeInsets.only(left: 10, right: 10, bottom: 50),
                padding: EdgeInsets.all(16),
                height: MediaQuery.of(context).size.height / 6,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(255, 255, 255, 0.6),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(height: 10),
                    ButtonBar(
                      alignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(150, 60),
                            padding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(0),
                              ),
                            ),
                            textStyle: TextStyle(fontSize: 20),
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, "/menu");
                          },
                          child: Text('Menú'),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(150, 60),
                            padding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 16,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(0),
                              ),
                            ),
                            textStyle: TextStyle(fontSize: 20),
                          ),
                          onPressed: () {
                            Navigator.pushNamed(context, "/tracker");
                          },
                          child: Text('Track Order'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context,
    String title, {
    required String routeName,
    bool isBold = true,
  }) {
    return ListTile(
      title: Text(
        title.toUpperCase(),
        style: TextStyle(
          color: Colors.white,
          fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
          fontSize: 16,
        ),
      ),
      onTap: () async {
        if (routeName == '/cs') {
          const whatsappUrl = 'https://wa.me/5540559333';
          if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
            await launchUrl(Uri.parse(whatsappUrl));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('No se pudo abrir WhatsApp')),
            );
          }
        } else {
          Navigator.pushNamed(context, routeName);
        }
      },
    );
  }
}
