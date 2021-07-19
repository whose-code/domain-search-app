import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:dio/dio.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(DomainSearchApp());
}

class DomainSearchApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Domain Search App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SearchPage(title: 'Domain Search'),
    );
  }
}

class SearchPage extends StatefulWidget {
  SearchPage({Key? key, required this.title}) : super(key: key);

  final String title;

  final dio = Dio(BaseOptions(
      baseUrl: 'https://api.godaddy.com/v1/domains/available',
      headers: {
        'Authorization': dotenv.env['GODADDY_API_KEY'],
        'Accept': 'application/json',
      }));

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _formKey = GlobalKey<FormState>();

  var _autoValidate = false;
  var _search;

  void searchDomains(String query) async {
    final response = await widget.dio.get('', queryParameters: {
      'domain': query,
    });

    // return response.data['available'];
    Text(
                    'searchDomains1()',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 22,
                      fontWeight:FontWeight.bold,
                    ),
                    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.red,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Form(
              key: _formKey,
              // ignore: deprecated_member_use
              autovalidate: _autoValidate,
              child: Column(
                children: [
                  TextFormField(
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.search),
                        hintText: 'Enter Domain Name',
                        border: OutlineInputBorder(),
                        filled: true,
                        errorStyle: TextStyle(fontSize: 15),
                      ),
                      onChanged: (value) {
                        _search = value;
                      },
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Please enter a search term';
                        }
                        return null;
                      }),
                  SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: RawMaterialButton(
                      onPressed: () {
                        final isValid = _formKey.currentState!.validate();
                        if (isValid) {
                          searchDomains(_search);
                        } else {
                          // ignore: todo
                          //TODO Set autovalidate = true
                          setState(() {
                            _autoValidate = true;
                          });
                        }
                      },
                      fillColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Text(
                          'Search',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Text(
                    'searchDomains()',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 22,
                      fontWeight:FontWeight.bold,
                    ),
                  )
                ],
              ),
            ),
            // ignore: unnecessary_null_comparison
          ],
        ),
      ),
    );
  }
}
