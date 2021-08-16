import 'package:authentification/Start.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User user;
  bool isloggedin = false;
  List todos = [];
  List c = [];
  List d = [];
  List a = [];
  String name = '';
  String cat = '';
  String dir = '';
  String act = '';

  checkAuthentification() async {
    _auth.authStateChanges().listen((user) {
      if (user == null) {
        Navigator.of(context).pushReplacementNamed("start");
      }
    });
  }

  getUser() async {
    User firebaseUser = _auth.currentUser;
    await firebaseUser?.reload();
    firebaseUser = _auth.currentUser;

    if (firebaseUser != null) {
      setState(() {
        this.user = firebaseUser;
        this.isloggedin = true;
      });
    }
  }

  signOut() async {
    _auth.signOut();

    final googleSignIn = GoogleSignIn();
    await googleSignIn.signOut();
  }

  @override
  void initState() {
    super.initState();
    this.checkAuthentification();
    this.getUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          child: Icon(
            Icons.logout_outlined,
            color: Colors.white,
          ),
          onTap: signOut,
        ),
        title: Center(
          child: Text(
            "Movie List",
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        backgroundColor: Colors.deepPurple[200],
      ),
      floatingActionButton: Stack(
        children: [
          Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      title: Text("Add Movie"),
                      content: Container(
                        margin: EdgeInsets.all(10),
                        height: 292,
                        child: Column(
                          children: [
                            TextField(
                              decoration: InputDecoration(
                                  border: UnderlineInputBorder(),
                                  hintText: 'Enter the Movie'),
                              onChanged: (String value) {
                                name = value;
                              },
                            ),
                            //SizedBox(height: 20),
                            TextField(
                              decoration: InputDecoration(
                                  border: UnderlineInputBorder(),
                                  hintText: 'Genre'),
                              onChanged: (String value) {
                                cat = value;
                              },
                            ),
                            //SizedBox(height: 20),
                            TextField(
                              decoration: InputDecoration(
                                  border: UnderlineInputBorder(),
                                  hintText: 'Director'),
                              onChanged: (String value) {
                                dir = value;
                              },
                            ),
                            //SizedBox(height: 20),
                            TextField(
                              decoration: InputDecoration(
                                  border: UnderlineInputBorder(),
                                  hintText: 'Actors'),
                              onChanged: (String value) {
                                act = value;
                              },
                            ),
                            SizedBox(height: 10),
                            Container(
                              height: 70,
                              child: Image(
                                image: AssetImage("images/images3.png"),
                                fit: BoxFit.contain,
                              ),
                            ),
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            setState(
                              () {
                                todos.add(name);
                                c.add(cat);
                                d.add(dir);
                                a.add(act);
                              },
                            );
                            Navigator.of(context).pop();
                          },
                          style: TextButton.styleFrom(
                            primary: Colors.white,
                            backgroundColor: Colors.deepPurple[200],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                          ),
                          child: Text('Add'),
                        ),
                      ],
                    );
                  },
                );
              },
              backgroundColor: Colors.deepPurple[200],
              child: Icon(
                Icons.add,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 200,
              child: Image(
                image: AssetImage("images/images4.jpg"),
                fit: BoxFit.contain,
              ),
            ),
            Container(
              margin: EdgeInsets.all(4),
              child: Text(
                "Hello ${user.displayName} you are Logged in as ${user.email}",
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              height: 400,
              child: ListView.builder(
                  itemCount: todos.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Dismissible(
                      key: Key(todos[index]),
                      child: Card(
                        elevation: 4.0,
                        margin: EdgeInsets.all(8),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        child: ListTile(
                          title: Text(todos[index]),
                          subtitle: Text(
                              'Genre: ${c[index]} | Director: ${d[index]} | Actors: ${a[index]}'),
                          trailing: IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Colors.deepPurple[200],
                            ),
                            onPressed: () {
                              setState(
                                () {
                                  todos.removeAt(index);
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
