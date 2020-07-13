import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Galeria"),
        ),
        body: GaleriaApp(),
      ),
    );
  }
}

class GaleriaApp extends StatefulWidget {
  @override
  _GaleriaAppState createState() => _GaleriaAppState();
}

class _GaleriaAppState extends State<GaleriaApp> {
  bool loading;
  List<String> photos = ["100","101","1015"];

  @override
  void initState() {
    loading = true;
    photos = [];
    _loadPhotos();
    super.initState();
  }

  _loadPhotos()async{
   final response =  await http.get("https://picsum.photos/v2/list");
   final json = jsonDecode(response.body);
   List<String> _photos = [];
   for(var JsonObject in json){
        _photos.add(JsonObject["id"]);
   }
   setState(() {
     loading = false;
     photos = _photos;
   });
  }

  @override
  Widget build(BuildContext context) {
    if(loading){
      return Center(child : CircularProgressIndicator());
    }
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
      ),
      itemBuilder: (context,index){
        return GestureDetector(
             onTap: (){
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context){
                    return PhotoPage(photos[index]);
                  },
               ),
              );
             },
            child : Image.network("https://picsum.photos/id/${photos[index]}/300/300"),
        );
      },
      itemCount: photos.length,
    );
  }
}

class PhotoPage extends StatelessWidget {
 final String id;
 PhotoPage(this.id);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(backgroundColor: Colors.black87,),
      backgroundColor: Colors.black87,
      body: Center(child: Image.network("https://picsum.photos/id/$id/600/600")),
     );
  }
}
