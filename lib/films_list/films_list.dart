import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class FilmsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Films"),
      ),
      body: Container(
        child: FilmsSection(),
      ),
    );
  }
}

class FilmsSection extends StatefulWidget {
  @override
  _FilmsSectionState createState() => _FilmsSectionState();
}

class _FilmsSectionState extends State<FilmsSection> {
  var _films = <FilmShorInfo>[];
  var progress = true;

  @override
  void initState() {
    super.initState();

    loadFilms();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
          child: Text("Top"),
        ),
        progress
            ? _showProgress()
            : Container(
                height: 300.0,
                child: ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.all(16.0),
                  scrollDirection: Axis.horizontal,
                  itemCount: _films.length,
                  itemExtent: 150.0,
                  itemBuilder: (context, index) {
                    return Card(
                      color: Colors.blue,
                      child: Column(
                        children: <Widget>[
                          Expanded(
                            flex: 0,
                            child: Image.network(_films[index].url),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
                            child: Text(
                              _films[index].title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
              )
      ],
    );
  }

  Widget _showProgress() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  void loadFilms() async {
    setState(() {
      progress = true;
    });

    String apiKey = 'api_key=0e1167c76e061f65cb570b74c42baf0f';
    String dataUrl = "https://api.themoviedb.org/3/movie/popular?$apiKey";

    http.Response response = await http.get(dataUrl);
    debugPrint(response.body);
    Map decode = jsonDecode(response.body);
    var films = <FilmShorInfo>[];
    for (var film in decode['results']) {
      films.add(FilmShorInfo.fromJson(film));
    }

    setState(() {
      progress = false;
      _films = films;
    });
  }
}

class FilmShorInfo {
  final String title;
  final String posterPath;
  String get url {
    String baseUrl = "https://image.tmdb.org/t/p/w500$posterPath";
    return baseUrl;
  }

  FilmShorInfo(this.title, this.posterPath);

  factory FilmShorInfo.fromJson(Map<String, dynamic> json) {
    return FilmShorInfo(json['title'], json['poster_path']);
  }
}
