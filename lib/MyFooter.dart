import 'package:flutter/material.dart';

class MyFooter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.calculate),
          label: 'Calculer un prêt',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.add),
          label: 'Ajouter un appartement',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.list),
          label: 'Liste des appartements',
        ),
      ],
      onTap: (int index) {
        switch (index) {
          case 0:
            Navigator.pushNamed(context, '/calculate_loan');
            break;
          case 1:
            Navigator.pushNamed(context, '/add_apartment');
            break;
          case 2:
            Navigator.pushNamed(context, '/list_apartments');
            break;
        }
      },
    );
  }
}
