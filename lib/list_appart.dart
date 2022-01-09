import 'package:appartement/db.dart';
import 'package:appartement/main.dart';
import 'package:appartement/model.dart/Model_apparte.dart';
import 'package:flutter/material.dart';

// ignore: camel_case_types
class List_Appart extends StatefulWidget {
  const List_Appart({Key? key}) : super(key: key);

  @override
  State<List_Appart> createState() => _List_AppartState();
}

// ignore: camel_case_types
class _List_AppartState extends State<List_Appart> {
  @override
  Widget build(BuildContext context) {
    hauteurApp = MediaQuery.of(context).size.height;
    largueurApp = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/', (Route<dynamic> route) => false);
              }),
        ),
        body: FutureBuilder<List<Appartement_Model>>(
          future: Baselocal().apparte(),
          builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, i) {
                    Appartement_Model appart = snapshot.data![i];
                    return Card(
                      elevation: 8,
                      child: GestureDetector(
                          onTap: () {}, child: Text(appart.nom)),
                    );
                  });
            } else {
              return const Center(
                child: SizedBox(
                  child: CircularProgressIndicator(),
                  width: 60,
                  height: 60,
                ),
              );
            }
          },
        ));
  }
}
