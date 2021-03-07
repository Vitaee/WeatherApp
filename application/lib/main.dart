import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'services/weatherFunc.dart';
import 'package:weather_app/models/WeatherData.dart';

void main() {
  runApp(MyApp());
}

// Ekranımızda bir değişiklik olmayacaksa StatelessWidget kullanılır.
// Daha çok uygulamanın iskeletini oluşturmak için kullanılan bir widget.
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // Uygulamamızın iskeletini oluşturuyoruz.
      title: 'Flutter',
      theme: ThemeData.dark(),
      // Home parametresi uygulamamız açılınca ilk açılacak olan sayfayı belirler.
      home: MyHomePage(
        title: 'Weather App',
        text: "Weather City",
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.text}) : super(key: key);

  final String title;
  final String text;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<WeatherData> weather;
  static const historyLen = 4;
  List<String> searchHis = [
    "Gaziantep",
    "Giresun",
    "Trabzon",
    "Adana",
    "Ankara",
  ];
  List<String> filteredSearchHis;
  String selectedTerm;

  List<String> filterSearchTerms({
    @required String filter,
  }) {
    if (filter != null && filter.isNotEmpty) {
      return searchHis.reversed
          .where((term) => term.startsWith(filter))
          .toList();
    } else {
      return searchHis.reversed.toList();
    }
  }

  void addSearchTerm(String term) {
    if (searchHis.contains(term)) {
      putSearchTermFirst(term);
      return;
    }
    searchHis.add(term);
    if (searchHis.length > historyLen) {
      searchHis.removeRange(0, searchHis.length - historyLen);
    }
    filteredSearchHis = filterSearchTerms(filter: null);
  }

  void deleteSearchTerm(String term) {
    searchHis.removeWhere((t) => t == term);
    filteredSearchHis = filterSearchTerms(filter: null);
  }

  void putSearchTermFirst(String term) {
    deleteSearchTerm(term);
    addSearchTerm(term);
  }

  FloatingSearchBarController controller;

  @override
  void initState() {
    super.initState();
    weather = fetchWeather("istanbul");
    controller = FloatingSearchBarController();
    filteredSearchHis = filterSearchTerms(filter: null);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        body: Stack(
      fit: StackFit.expand,
      children: [
        FutureBuilder<WeatherData>(
          future: weather,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Column(
                children: <Widget>[
                  Container(
                    height: size.height * 0.42,
                    width: size.width,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(
                                "https://i.ibb.co/y6pWR3Y/weatherman-wallpaper-480x320.jpg"),
                            fit: BoxFit.cover)),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            alignment: Alignment.centerLeft,
                            margin: EdgeInsets.only(top: 70),
                            child: Padding(
                                padding: EdgeInsets.only(bottom: 10.0),
                                child: Text(
                                  "Currently in " + snapshot.data.cityName,
                                  style: Theme.of(context).textTheme.headline6,
                                )),
                          ),
                          Container(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                snapshot.data.temp + "\u00B0",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 40.0,
                                    fontWeight: FontWeight.w600),
                              )),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                alignment: Alignment.bottomLeft,
                                child: Text(
                                  snapshot.data.state,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 19.0,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 30),
                                child: Container(
                                  width: 70,
                                  alignment: Alignment.bottomRight,
                                  child: FaIcon(
                                    FontAwesomeIcons.cloudMoon,
                                    size: 60,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(10.0),
                      child: ListView(
                        children: <Widget>[
                          ListTile(
                            leading: FaIcon(FontAwesomeIcons.thermometerHalf),
                            title: Text(
                              "Felt Temprature",
                              style: Theme.of(context).textTheme.headline6,
                            ),
                            trailing: (Text(snapshot.data.feel + "\u00B0",
                                style: Theme.of(context).textTheme.headline6)),
                          ),
                          Divider(
                            thickness: 5,
                          ),
                          ListTile(
                              leading: FaIcon(FontAwesomeIcons.cloud),
                              title: Text("Weather",
                                  style: Theme.of(context).textTheme.headline6),
                              trailing: Text(snapshot.data.state,
                                  style:
                                      Theme.of(context).textTheme.headline6)),
                          Divider(
                            thickness: 5,
                          ),
                          ListTile(
                              leading: FaIcon(FontAwesomeIcons.solidSun),
                              title: Text(
                                "Humidityture",
                                style: Theme.of(context).textTheme.headline6,
                              ),
                              trailing: Text(snapshot.data.humidity,
                                  style:
                                      Theme.of(context).textTheme.headline6)),
                        ],
                      ),
                    ),
                  )
                ],
              );
            } else {
              return Column(children: <Widget>[
                Container(
                    height: size.height * 0.42,
                    width: size.width,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(
                                "https://i.hizliresim.com/Wu29DX.jpg"),
                            fit: BoxFit.cover))),
              ]);
            }
          },
        ),
        buildFloatingSearchBar(),
      ],
    ));
  }

  Widget buildFloatingSearchBar() {
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return FloatingSearchBar(
      controller: controller,
      hint: 'Search...',
      scrollPadding: const EdgeInsets.only(top: 16, bottom: 56),
      transitionDuration: const Duration(milliseconds: 800),
      transitionCurve: Curves.easeInOut,
      transition: CircularFloatingSearchBarTransition(),
      physics: const BouncingScrollPhysics(),
      axisAlignment: isPortrait ? 0.0 : -1.0,
      title: Text(
        selectedTerm ?? '',
        style: Theme.of(context).textTheme.headline6,
      ),
      openAxisAlignment: 0.0,
      maxWidth: isPortrait ? 600 : 500,
      debounceDelay: const Duration(milliseconds: 500),
      actions: [
        FloatingSearchBarAction(
          showIfOpened: false,
          child: CircularButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ),
        FloatingSearchBarAction.searchToClear(
          showIfClosed: false,
        ),
      ],
      onQueryChanged: (query) {
        setState(() {
          filteredSearchHis = filterSearchTerms(filter: query);
        });
      },
      onSubmitted: (query) {
        setState(() {
          addSearchTerm(query);
          selectedTerm = query;
          weather = fetchWeather(query);
        });
        controller.close();
      },
      builder: (context, transition) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Material(
            color: Colors.white,
            elevation: 4,
            child: Builder(
              builder: (context) {
                if (filteredSearchHis.isEmpty && controller.query.isEmpty) {
                  return Container(
                    height: 56,
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: Text(
                      "Start search..",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.caption,
                    ),
                  );
                } else if (filteredSearchHis.isEmpty) {
                  return ListTile(
                      tileColor: Colors.black87,
                      title: Text(controller.query),
                      leading: const Icon(Icons.search),
                      onTap: () {
                        setState(() {
                          addSearchTerm(controller.query);
                          selectedTerm = controller.query;
                          weather = fetchWeather(controller.query);
                        });
                        controller.close();
                      });
                } else {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: filteredSearchHis
                        .map((term) => ListTile(
                              tileColor: Colors.black87,
                              title: Text(
                                term,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              leading: const Icon(Icons.history),
                              trailing: IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  setState(() {
                                    deleteSearchTerm(term);
                                  });
                                },
                              ),
                              onTap: () {
                                setState(() {
                                  putSearchTermFirst(term);
                                  selectedTerm = term;
                                  weather = fetchWeather(term);
                                });
                                controller.close();
                              },
                            ))
                        .toList(),
                  );
                }
              },
            ),
          ),
        );
      },
    );
  }
}
