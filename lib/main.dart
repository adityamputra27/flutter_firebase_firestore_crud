import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_crud_firebase/create_screen.dart';
import 'package:flutter_crud_firebase/firebase_options.dart';
import 'package:flutter_crud_firebase/update_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    _searchController.addListener(_onSearchChanged);
    super.initState();
  }

  void _onSearchChanged() {
    searchCountries();
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    getCountriesStream();
    super.didChangeDependencies();
  }

  List _allCountries = [];
  List _resultCountries = [];
  final TextEditingController _searchController = TextEditingController();

  searchCountries() {
    var showResults = [];
    if (_searchController.text != '') {
      for (var country in _allCountries) {
        var name = country['name'].toString().toLowerCase();
        if (name.contains(_searchController.text.toLowerCase())) {
          showResults.add(country);
        }
      }
    } else {
      showResults = List.from(_allCountries);
    }
    setState(() {
      _resultCountries = showResults;
    });
  }

  Future<void> getCountriesStream() async {
    var data = await FirebaseFirestore.instance
        .collection('countries')
        .orderBy('name')
        .get();
    setState(() {
      _allCountries = data.docs;
    });
    searchCountries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF4C59A5),
        title: CupertinoSearchTextField(
          backgroundColor: Colors.white,
          controller: _searchController,
        ),
      ),
      body: Container(
        margin: const EdgeInsets.all(20),
        child: ListView.builder(
          itemCount: _resultCountries.length,
          itemBuilder: (context, index) {
            return Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UpdateScreen(
                          countryId: _resultCountries[index].id,
                        ),
                      ),
                    ).then((value) {
                      if (value != null) {
                        setState(() {
                          getCountriesStream();
                        });
                      }
                    });
                  },
                  child: ListTile(
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(width: 2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    tileColor: const Color(0xFF4C59A5),
                    title: Text(
                      '${_resultCountries[index]['name']} - ${_resultCountries[index]['code']}',
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    subtitle: Text(
                      'Phone Code : ${_resultCountries[index]['phone']}',
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    trailing: IconButton(
                      onPressed: () {
                        var collection =
                            FirebaseFirestore.instance.collection('countries');
                        collection.doc(_resultCountries[index].id).delete();
                      },
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF4C59A5),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateScreen(),
            ),
          ).then((value) {
            if (value != null) {
              setState(() {
                getCountriesStream();
              });
            }
          });
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
