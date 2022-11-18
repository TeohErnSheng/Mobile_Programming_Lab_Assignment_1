import 'dart:convert';
import 'package:ndialog/ndialog.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

import 'movie.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movie App',
      theme: ThemeData(
        fontFamily: 'Akaya',
        primarySwatch: Colors.green,
      ),
      home: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Movie Info'),
        ),
        body: const HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController movieName = TextEditingController();
  var poster = " ";
  var title = "";
  var year = "";
  var rated = "";
  var released = "";
  var runtime = "";
  var genre = "";
  var director = "";
  var writers = "";
  var actors = "";
  var plot = "";
  var language = "";
  var country = "";
  var awards = "";
  var ratingSource1 = "";
  var ratingImdb = "";
  var ratingSource2 = "";
  var ratingRotten = "";
  var ratingSource3 = "";
  var ratingMeta = "";

  Movie currentMovie = Movie(" ", " ", " ", " ", " ", " ", " ", " ", " ", " ",
      " ", " ", " ", " ", " ", " ", " ", " ", " ", " ");

  void _confirmDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          title: const Text(
            "Search Movie",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          content: Text(
            "Are you sure you want to search for ${movieName.text} ?",
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("Yes",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              onPressed: () {
                _loadMovie(movieName.text);
              },
            ),
            TextButton(
              child: const Text("No",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _loadMovie(String search) async {
    ProgressDialog progressDialog = ProgressDialog(context,
        message: const Text("Searching in Progress"),
        title: const Text("Searching..."));
    progressDialog.show();
    var url = Uri.parse('http://www.omdbapi.com/?t=$search&apikey=b272db94');
    var response = await http.get(url);
    var rescode = response.statusCode;
    if (rescode == 200) {
      setState(() {
        var jsonData = response.body;
        var parsedJson = json.decode(jsonData);
        poster = parsedJson['Poster'];
        title = parsedJson['Title'];
        year = parsedJson['Year'];
        rated = parsedJson['Rated'];
        released = parsedJson['Released'];
        runtime = parsedJson['Runtime'];
        genre = parsedJson['Genre'];
        director = parsedJson['Director'];
        writers = parsedJson['Writer'];
        actors = parsedJson['Actors'];
        plot = parsedJson['Plot'];
        language = parsedJson['Language'];
        country = parsedJson['Country'];
        awards = parsedJson['Awards'];
        ratingSource1 = parsedJson['Ratings'][0]['Source'];
        ratingImdb = parsedJson['Ratings'][0]['Value'];
        ratingSource2 = parsedJson['Ratings'][1]['Source'];
        ratingRotten = parsedJson['Ratings'][1]['Value'];
        ratingSource3 = parsedJson['Ratings'][2]['Source'];
        ratingMeta = parsedJson['Ratings'][2]['Value'];
        currentMovie = Movie(
            poster,
            title,
            year,
            rated,
            released,
            runtime,
            genre,
            director,
            writers,
            actors,
            plot,
            language,
            country,
            awards,
            ratingSource1,
            ratingImdb,
            ratingSource2,
            ratingRotten,
            ratingSource3,
            ratingMeta);
        progressDialog.dismiss();
        Fluttertoast.showToast(
            msg: "Movie Found",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            fontSize: 20.0);
      });
      Navigator.of(context).pop();
    } else {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Text("Enter Movie Name: ", style: TextStyle(fontSize: 18)),
          const SizedBox(height: 10),
          TextField(
            controller: movieName,
            style: const TextStyle(fontSize: 18),
            decoration: const InputDecoration(border: OutlineInputBorder()),
          ),
          const SizedBox(height: 10),
          MaterialButton(
              color: Colors.green,
              onPressed: () {
                _confirmDialog();
              },
              child: const Text(
                "Load Movie Info",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              )),
          const SizedBox(height: 20),
          Expanded(
            child: MovieGrid(
              currentMovie: currentMovie,
            ),
          ),
        ])));
  }
}

class MovieGrid extends StatefulWidget {
  final Movie currentMovie;
  const MovieGrid({Key? key, required this.currentMovie}) : super(key: key);

  @override
  State<MovieGrid> createState() => _MovieGridState();
}

class _MovieGridState extends State<MovieGrid> {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      primary: false,
      padding: const EdgeInsets.all(5),
      childAspectRatio: 100 / 130,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      crossAxisCount: 2,
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: <Color>[Colors.yellow, Colors.green],
          )),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.image_outlined,
                    size: 32,
                  ),
                  Text(
                    "Movie Poster",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Image.network(
                widget.currentMovie.poster,
                height: 150,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                      height: 150,
                      width: 150,
                      fit: BoxFit.cover,
                      'assets/images/test.jpeg');
                },
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: <Color>[Colors.yellow, Colors.green],
          )),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.info_outline,
                    size: 32,
                  ),
                  Text(
                    "Movie Info",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Text(
                "Title: ${widget.currentMovie.title}",
                style: const TextStyle(fontSize: 17),
              ),
              Text(
                "Rated: ${widget.currentMovie.rated}",
                style: const TextStyle(fontSize: 17),
              ),
              Text(
                "Year: ${widget.currentMovie.year}",
                style: const TextStyle(fontSize: 17),
              ),
              Text(
                "Released: ${widget.currentMovie.released}",
                style: const TextStyle(fontSize: 17),
              ),
              Text(
                "Runtime: ${widget.currentMovie.runtime}",
                style: const TextStyle(fontSize: 17),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: <Color>[Colors.yellow, Colors.green],
          )),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.details_outlined,
                    size: 32,
                  ),
                  Text("Movie Details",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 5),
              Text(
                "Genre: ${widget.currentMovie.genre}",
                style: const TextStyle(fontSize: 17),
              ),
              Text(
                "Language: ${widget.currentMovie.language}",
                style: const TextStyle(fontSize: 17),
              ),
              Text(
                "Country: ${widget.currentMovie.country}",
                style: const TextStyle(fontSize: 17),
              ),
              Text(
                "Awards: ${widget.currentMovie.awards}",
                style: const TextStyle(fontSize: 17),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: <Color>[Colors.yellow, Colors.green],
          )),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.person_outline,
                    size: 32,
                  ),
                  Text("Credits",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 5),
              Text(
                "Director: ${widget.currentMovie.director}",
                style: const TextStyle(fontSize: 17),
              ),
              Text("Writers: ${widget.currentMovie.writers}",
                  style: const TextStyle(fontSize: 17)),
              Text("Actors: ${widget.currentMovie.actors}",
                  style: const TextStyle(fontSize: 17))
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: <Color>[Colors.yellow, Colors.green],
          )),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.notes_outlined,
                    size: 32,
                  ),
                  Text("Plot",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 5),
              Text(widget.currentMovie.plot,
                  style: const TextStyle(fontSize: 17))
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: const BoxDecoration(
              gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: <Color>[Colors.yellow, Colors.green],
          )),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.rate_review_outlined,
                    size: 32,
                  ),
                  Text("Ratings",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ],
              ),
              const SizedBox(height: 5),
              Text(widget.currentMovie.ratingSource1,
                  style: const TextStyle(fontSize: 17)),
              Text(widget.currentMovie.ratingImdb,
                  style: const TextStyle(fontSize: 17)),
              const SizedBox(height: 5),
              Text(widget.currentMovie.ratingSource2,
                  style: const TextStyle(fontSize: 17)),
              Text(widget.currentMovie.ratingRotten,
                  style: const TextStyle(fontSize: 17)),
              const SizedBox(height: 5),
              Text(widget.currentMovie.ratingSource3,
                  style: const TextStyle(fontSize: 17)),
              Text(widget.currentMovie.ratingMeta,
                  style: const TextStyle(fontSize: 17)),
            ],
          ),
        ),
      ],
    );
  }
}
