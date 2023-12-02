import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Konum Uygulaması',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String konumBilgisi = 'Konum bilgisi bekleniyor...';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Konum Uygulaması'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              konumBilgisi,
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _konumBilgisiniGetir,
              child: Text('Konumu Göster'),
            ),
          ],
        ),
      ),
    );
  }

  void _konumBilgisiniGetir() async {
    bool konumIzni = await _izinleriKontrolEt();
    if (konumIzni) {
      Position konum = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        konumBilgisi =
        'Latitude: ${konum.latitude}, Longitude: ${konum.longitude}';
      });
    } else {
      // Kullanıcı izni reddetti
      // Gerekirse bir geri bildirim veya açıklama gösterebilirsiniz.
      setState(() {
        konumBilgisi = 'Konum izni reddedildi.';
      });
    }
  }

  Future<bool> _izinleriKontrolEt() async {
    LocationPermission konumIzni = await Geolocator.checkPermission();
    if (konumIzni == LocationPermission.denied) {
      konumIzni = await Geolocator.requestPermission();
      if (konumIzni == LocationPermission.denied) {
        return false;
      }
    }

    if (konumIzni == LocationPermission.deniedForever) {
      // Kullanıcı kalıcı olarak izni reddetti
      // Gerekirse bir geri bildirim veya açıklama gösterebilirsiniz.
      return false;
    }

    return true;
  }
}
