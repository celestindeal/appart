import 'package:appartement/MyFooter.dart';
import 'package:appartement/model.dart/db.dart';
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
      body: FutureBuilder<List<Appartement_Model>>(
        future: baselocal.apparte(),
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
                        onTap: () {
                          profil_appart = appart;
                          Navigator.pushNamed(context, '/profil_appart');
                        },
                        child: SizedBox(height: 30, child: Text(appart.nom))),
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
      ),
      bottomNavigationBar: MyFooter(),
    );
  }
}
