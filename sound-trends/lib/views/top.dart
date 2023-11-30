import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:sound_trends/utils/const.dart' as cons;
import 'package:sound_trends/views/home.dart';
import 'package:sound_trends/views/stats.dart';
import 'package:sound_trends/views/user.dart';
import 'package:http/http.dart' as http;
 
class top extends StatefulWidget {
  final String token;
  const top({required this.token,super.key});
 
  @override
  State<top> createState() => _topState();
}
 
//Icono en la aplicacion que se vea bien
 
class _topState extends State<top> {
 
  List<String> topSongs = [];
  List<String> topSongImages = [];
  List<String> recommendedSongs = [];
  List<String> recommendedSongImages = [];
  bool isLoading = true;
 
  @override
  void initState() {
    super.initState();
    fetchTopSongs(widget.token);
  }
 
  Future<void> fetchTopSongs(String token) async {
    await getTopSongs(token);
    await getRecommendations(token);
  }
 
  Future<void> getTopSongs(String token) async {
    try {
      final response = await http.get(
        Uri.parse('https://api.spotify.com/v1/me/top/tracks?limit=10'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
 
      if (response.statusCode == 200) {
        final List<dynamic>? tracks = json.decode(response.body)['items'];
 
        if (tracks != null) {
          topSongs = tracks.map<String>((track) => track['name']).toList();
          topSongImages =
              tracks.map<String>((track) => track['album']['images'][0]['url']).toList();
 
          setState(() {
            topSongs;
            isLoading = false;
          });
 
          // Imprimir los valores
          print('Top Songs: $topSongs');
          print('Top Song Images: $topSongImages');
        } else {
          // Manejar el caso donde tracks es null, si es necesario
        }
      } else {
        throw Exception('Error al obtener las canciones principales');
      }
    } catch (e) {
      log('Error fetching recommendations: $e'); // Agrega más detalles al mensaje de registro
      setState(() {
        isLoading = false;
      });
    }
  }
 
  Future<void> getRecommendations(String token) async {
    try {
      final response = await http.get(
        Uri.parse('https://api.spotify.com/v1/recommendations?limit=10&seed_tracks=${topSongs.join(",")}'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );
      print('URL de la solicitud: ${Uri.parse('https://api.spotify.com/v1/recommendations?limit=10&seed_tracks=${topSongs.join(",")}')}');
 
      if (response.statusCode == 200) {
        final List<dynamic>? tracks = json.decode(response.body)['tracks'];
 
        if (tracks != null) {
          recommendedSongs = tracks.map<String>((track) => track['name']).toList();
          recommendedSongImages =
              tracks.map<String>((track) => track['album']['images'][0]['url']).toList();
 
          setState(() {
            isLoading = false;
          });
 
          // Imprimir los valores
          print('Recommended Songs: $recommendedSongs');
          print('Recommended Song Images: $recommendedSongImages');
        } else {
          // Manejar el caso donde tracks es null, si es necesario
        }
      } else {
        throw Exception('Error al obtener las recomendaciones');
      }
    } catch (e) {
      log('Error fetching recommendations: $e'); // Agrega más detalles al mensaje de registro
      setState(() {
        isLoading = false;
      });
    }
  }
 
  @override
  Widget build(BuildContext context) {
    int _selectedIndex = 2;
    final size = MediaQuery.of(context).size;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: cons.black,
        body: SingleChildScrollView( // Agrega SingleChildScrollView aquí
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: size.width * 0.95,
                  height: size.height * 0.10,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(Icons.search, color: cons.white),
                            onPressed: () {
                              // Acción al hacer clic
                            },
                          ),
                          Text(
                            'Stats',
                            style: TextStyle(color: cons.white, fontSize: 20),
                          ),
                          IconButton(
                            icon: Icon(Icons.person, color: cons.white),
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => user(tooken: super.widget.token,)));
                            },
                          ),
                        ],
                      ),
                      Text(
                        'Past 4 Weeks',
                        style: TextStyle(color: cons.gray),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: size.width*1,
                height: size.height*0.04),
                Container(
                  width: size.width * 0.95,
                  height: size.height * 0.10,
                  child: Row(crossAxisAlignment: CrossAxisAlignment.center
                  ,mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: size.width * 0.4,
                      height: size.height * 0.10,
                      alignment: Alignment.center,
                      child: Column(
                        children:[
                          Text(
                            'Tracks',
                            style: TextStyle(color: cons.green, fontSize: 20),
                          ),
                          SizedBox(width: 8), // Ajusta el espacio entre el texto y la línea
                          Container(
                            width: size.width * 0.2,
                            height: 1, // Ajusta el grosor de la línea
                            color: cons.green,
                          ),
                        ]
                      ),
                    ),              
                    Container(
                      width: size.width * 0.4,
                      height: size.height * 0.10,
                      alignment: Alignment.center,
                      child: Column(
                        children:[
                          Text(
                            'Artists',
                            style: TextStyle(color: cons.white, fontSize: 20),
                          ),
                          SizedBox(width: 8), // Ajusta el espacio entre el texto y la línea
                          Container(
                            width: size.width * 0.0,
                            height: 1, // Ajusta el grosor de la línea
                            color: cons.white,
                          ),
                        ]
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: size.height * 0.02),
              Container(
              width: size.width * 0.95,
              height: size.height * 0.53,
              child: isLoading
                ? Center(child: CircularProgressIndicator()) // Indicador de carga
                : ListView.builder(
                    itemCount: recommendedSongs!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        width: size.width * 0.80,
                        height: size.height * 0.15,
                        decoration: BoxDecoration(
                          border: Border.all(color: cons.green),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: size.width * 0.3,
                              height: size.height * 0.13,
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(recommendedSongImages ! [index]),
                                radius: 50,
                              ),
                            ),
                            Container(
                              width: size.width * 0.3,
                              height: size.height * 0.13,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(recommendedSongs ! [index], style: TextStyle(color: cons.white, fontSize: 20)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  width: size.width * 0.95,
                  height: size.height * 0.10,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              // Acción al hacer clic
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.transparent,
                              elevation: 0,
                            ),
                            child: Text(
                              '4 Weeks',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              // Acción al hacer clic
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.transparent,
                              elevation: 0,
                            ),
                            child: Text(
                              '6 Months',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              // Acción al hacer clic
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.transparent,
                              elevation: 0,
                            ),
                            child: Text(
                              'Lifetime',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
                             
                              // Acción al hacer clic
                            },
                            style: ElevatedButton.styleFrom(
                              primary: Colors.transparent,
                              elevation: 0,
                            ),
                            icon: Icon(Icons.calendar_today, color: Colors.white),
                            label: Text(''),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: size.height * 0.01),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: const Color.fromARGB(232, 0, 0, 0),
          selectedItemColor: Color.fromARGB(255, 30, 241, 139),
          unselectedItemColor: Color.fromARGB(165, 241, 239, 239),
         
          items:  <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.equalizer),
              label: 'Stats',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.trending_up),
              label: 'Top',
            ),
            /*BottomNavigationBarItem(
              backgroundColor: Colors.transparent,
              icon: Icon(Icons.music_note_sharp),
              label: 'Identity',
            ),*/
            /*BottomNavigationBarItem(
              backgroundColor: Colors.transparent,
              icon: Icon(Icons.person),
              label: 'Profile',
            ),*/
          ],
          currentIndex: _selectedIndex,
          onTap: (int index) {
            setState(() {
              _selectedIndex = index;
              if(_selectedIndex==0){
                Navigator.push(context, MaterialPageRoute(builder: (context) => home(token: super.widget.token,)));
              }
              if(_selectedIndex==1){
                Navigator.push(context, MaterialPageRoute(builder: (context) => stats(token: super.widget.token)));
              }
              if(_selectedIndex==2){                
              }
            });
          },
        ),
      ),
    );
  }
}
