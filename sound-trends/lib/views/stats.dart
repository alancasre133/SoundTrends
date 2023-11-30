import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:sound_trends/utils/const.dart' as cons;
import 'package:sound_trends/views/home.dart';
import 'package:sound_trends/views/top.dart';
import 'package:sound_trends/views/user.dart';
import 'package:sound_trends/views/stats.dart';
import 'dart:developer';
import 'dart:convert';
import 'dart:io';
import 'package:spotify/spotify.dart' as spotify;
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:crypto/crypto.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:url_launcher/url_launcher_string.dart';
class stats extends StatefulWidget {
  final String token;
  const stats({required this.token,super.key});

  @override
  State<stats> createState() => _statsState();
}

class _statsState extends State<stats> {
  @override
  void initState() {
    super.initState();
    fetchdata('');

  }
Future<void> fetchdata(token) async {
    final recentracks = await getRecentTracks(widget.token);
    await getGenresFromRecentTracks(widget.token, recentracks);
}
Future<List<Map<String, dynamic>>> getRecentTracks(String accessToken) async {
  final response = await http.get(
    Uri.parse('https://api.spotify.com/v1/me/player/recently-played?limit=100'),
    headers: {'Authorization': 'Bearer $accessToken'},
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> data = json.decode(response.body);
    return List<Map<String, dynamic>>.from(data['items']);
  } else {
    throw Exception('Error al obtener las últimas canciones escuchadas');
  }
}

Future<List<String>> getGenresFromRecentTracks(String accessToken, List<Map<String, dynamic>> tracks) async {
  final List<String> genres = [];

  for (final track in tracks) {
    final genre = track['track'];
    print(genre);
    
  }

  return genres.toSet().toList(); // Eliminar duplicados
}

Future<Map<String, dynamic>> getArtistDetails(String accessToken, String artistId) async {
  final response = await http.get(
    Uri.parse('https://api.spotify.com/v1/artists/$artistId'),
    headers: {'Authorization': 'Bearer $accessToken'},
  );

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Error al obtener detalles del artista');
  }
}

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    int _selectedIndex = 1;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: cons.black,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
             children: <Widget>[
              Container(
                width: size.width * 0.95,
                height: size.height * 0.08,
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
                        Container(
                          alignment: Alignment.center,
                width: size.height * 0.3,
                height: size.height * 0.08,
               child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                       children:<Widget>[ AutoSizeText(
                          'Stats',
              maxLines: 1, // Número máximo de líneas antes de truncar
              overflow: TextOverflow.ellipsis,
                          style: TextStyle(color: cons.white, fontSize: 20),
                        ),
                    AutoSizeText(
                      'Past 4 Weeks',
              maxLines: 1, // Número máximo de líneas antes de truncar
              overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: cons.gray,fontSize: 12),
                    ),
                        ]
                ),
                        ),

                        IconButton(
                          icon: Icon(Icons.person, color: cons.white),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => user( tooken: super.widget.token,)));
                          },
                        ),
                      ],
                    ),

                  ],
                ),
              ),
              Container(
                width: size.width * 0.95,
                height: size.height * 0.12,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      width: size.width * 0.45,
                      decoration: BoxDecoration(
                        color: cons.lightblack,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center, 
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0), 
                            child: Text(
                              '1,915',
                              style: TextStyle(color: cons.green, fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(height: size.height*0.00,),
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0), 
                            child: AutoSizeText(
                              minFontSize: 6,
                              maxFontSize: 1000,
                              'Total tracks streamed',
                              style: TextStyle(color: cons.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: size.width * 0.45,
                      decoration: BoxDecoration(
                        color: cons.lightblack,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center, 
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0), 
                            child: Text(
                              '112',
                              style: TextStyle(color: cons.green, fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0), 
                            child: AutoSizeText(
                              minFontSize: 6,
                              maxFontSize: 1000,
                              'Total hours streamed',
                              style: TextStyle(color: cons.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: size.height * 0.01),
              Container(
                width: size.width * 0.95,
                height: size.height * 0.35,
                decoration: BoxDecoration(
                  color: cons.lightblack,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0, top: 10.0), 
                      child: Text(
                        'Genres',
                        style: TextStyle(color: cons.white, fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: 2), 
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0), 
                      child: Text(
                        'Your top genre is pop, appearing in 69 of your artists',
                        style: TextStyle(color: cons.gray, fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
//Poner codigo de la grafica-----------------------------------------------------------------
                  ],
                ),
              ),
              SizedBox(height: size.height * 0.01),
              Container(
                width: size.width * 0.95,
                height: size.height * 0.20,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      width: size.width * 0.40,
                      decoration: BoxDecoration(
                        color: cons.lightblack,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center, 
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0), 
                            child: Text(
                              '73%',
                              style: TextStyle(color: cons.green, fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(height: 10,),
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0), 
                            child: AutoSizeText(
                            minFontSize: 20,
                            maxFontSize: 40,
              maxLines: 2, // Número máximo de líneas antes de truncar
              overflow: TextOverflow.ellipsis,
                              'Of your tracks are energic',
                              style: TextStyle(color: cons.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: size.width * 0.40,
                      decoration: BoxDecoration(
                        color: cons.lightblack,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center, 
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0), 
                            child: Text(
                              '64%',
                              style: TextStyle(color: cons.green, fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(height: 10,),
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0), 
                            child: AutoSizeText(
                              'Of your tracks are danceable',
                            minFontSize: 20,
                            maxFontSize: 40,
              maxLines: 2, // Número máximo de líneas antes de truncar
              overflow: TextOverflow.ellipsis,
                              style: TextStyle(color: cons.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                    /*
                    Container(
                      width: size.width * 0.40,
                      decoration: BoxDecoration(
                        color: cons.lightblack,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center, 
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0), 
                            child: Text(
                              '17%',
                              style: TextStyle(color: cons.green, fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(height: 10,),
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0), 
                            child: Text(
                              'Of your tracks are lively',
                              style: TextStyle(color: cons.white, fontSize: 25, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),*/
                  ],
                ),
              ),
              SizedBox(height: size.height * 0.01),
              Container(
                width: size.width * 0.95,
                height: size.height * 0.10,
                alignment: Alignment.center,
                child: 
                SingleChildScrollView(scrollDirection: Axis.horizontal,
                child:                 Column(
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
              ),
              SizedBox(height: size.height * 0.01),
            ],
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
              Navigator.push(context, MaterialPageRoute(builder: (context) =>  home(token: super.widget.token,)));
            }
            if(_selectedIndex==1){
              
            }
            if(_selectedIndex==2){
              Navigator.push(context, MaterialPageRoute(builder: (context) => top(token: super.widget.token)));
            }
          });
        },
      ),

      ),
    );
  }
}