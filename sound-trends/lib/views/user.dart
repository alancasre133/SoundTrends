import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sound_trends/utils/const.dart' as cons;
import 'package:sound_trends/views/home.dart';
import 'package:sound_trends/views/stats.dart';
import 'package:flutter/material.dart';
import 'package:sound_trends/views/home.dart';
import 'package:sound_trends/views/user.dart';
import 'dart:io';
import 'package:spotify/spotify.dart' as spotify;
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:crypto/crypto.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_web_auth/flutter_web_auth.dart';
import 'package:url_launcher/url_launcher_string.dart';

class user extends StatefulWidget {
  
  final String tooken;
  const user({required this.tooken, super.key});
  
  @override
  State<user> createState() => _userState();
}

//Icono en la aplicacion que se vea bien

class _userState extends State<user> {
  void initState() {
    super.initState();
    fetchdata( super.widget.tooken); 

  }
  Map<String,dynamic>? userdata;
   Future<int> fetchdata(token) async {
                                userdata = await getUserProfile(token);
                                setState(() {
                                  userdata;
                                });
                                return userdata!.length;
}

Future<Map<String, dynamic>> getUserProfile(String accessToken) async {
  final response = await http.get(
    Uri.parse('https://api.spotify.com/v1/me'),
    headers: {
      'Authorization': 'Bearer $accessToken',
    },
  );

  if (response.statusCode == 200) {
    final Map<String, dynamic> userProfile = json.decode(response.body);
    log(userProfile.toString());
    log(userProfile['display_name']);
    
    return userProfile;
  } else {
    throw Exception('Error al obtener datos del perfil');
  }
}

   @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return MaterialApp(
     debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: cons.black,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
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
                          'Profile',
                          style: TextStyle(color: cons.white, fontSize: 20),
                        ),
                        IconButton(
                          icon: Icon(Icons.person, color: cons.white),
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => user( tooken: super.widget.tooken, )));
                          },
                        ),

                      ],
                    ),
SizedBox(width: size.width*1,
height: size.height*0.04),
            CircleAvatar(
              radius: size.width*0.15,
              backgroundImage: (userdata!['images'].length==0) ?  AssetImage('assets/profile_image.jpg') as ImageProvider : NetworkImage(userdata!['images'][0]['url']) as ImageProvider, // Reemplaza con tu imagen de perfil
            ),
             SizedBox(height: size.height * 0.02),
                      SizedBox(height: 20),

            // Nombre de usuario
            Text(
              userdata!['display_name'],
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 10),

            // Información del perfil
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                (userdata!['email']!=null) ? userdata!['email'] : 'No acces to email',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ),

            SizedBox(height: 20),

            // Botones de acciones
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.green),
                  onPressed: () {
                    // Acción al presionar el botón "Seguir"
                  },
                  child: Text('Change theme',style: TextStyle(color: cons.white),),
                  
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: Colors.green),
                  onPressed: () {
                    // Acción al presionar el botón "Mensaje"
                  },
                  child: Text('Friend List',style: TextStyle(color: cons.white)),
                ),
              ],
            ),

            SizedBox(height: 20),

            // Detalles adicionales o estadísticas
            ],

          ),
        ),


      ),
    );
  }
}