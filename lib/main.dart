import 'package:feda/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:feda/feda.dart';
import 'package:untitled/paiementPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Accueil(),
    );
  }
}

class Accueil extends StatefulWidget {
  const Accueil({super.key});

  @override
  State<Accueil> createState() => _AccueilState();
}

class _AccueilState extends State<Accueil> {
  final _idController = TextEditingController(text: "192809");

  // Recupération de toute mes transactions
  getAllData() async {
    var data = await Feda.all_transactions();
    print(data);
  }

  // Recupération des données d'une transaction
  findTransaction() async {
    FedaTransaction data =
    await Feda.find_transaction(int.parse(_idController.text));
    print(data.toString());
  }

  createRedirectTransaction() async {
    try {
      // Récupération du lien de paiement pour la transaction
      var response = await Feda.create_transaction(
        FedaTransactionRequest(
            amount: 10,
            clienMail: "tbaissou@gmail.com",
            description: "Ma premiere trx feda",
            phone_number: {
              'number': "0168894947",
              'country': 'bj',
            }
        ),
      );

      print(response);

      // Extraction de l'URL de paiement de la réponse
      if (response != null && response['url'] != null) {
        String paymentUrl = response['url'];

        // Navigation vers la page WebView avec l'URL de paiement
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PaymentWebViewPage(paymentUrl: paymentUrl),
          ),
        );

        // Traitement du résultat après retour de la page de paiement
        if (result == true) {
          // Le paiement a réussi
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Paiement effectué avec succès')),
          );

        }
      } else {
        // Gérer le cas où l'URL est manquante
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Erreur: URL de paiement non disponible')),
        );
      }
    } catch (e) {
      print("Erreur lors de la création de la transaction: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: $e')),
      );
    }
  }

 /* createRedirectTransaction() async {
    // Récupération du lien de paiement pour lantransaction afin de faire une redirection
    var transaction_lien = await Feda.create_transaction(
      FedaTransactionRequest(
          amount: 500,
          clienMail: "tbaissou@gmail.com",
          description: "Ma premiere trx feda",
          phone_number: {
            'number': "0168894947",
            'country': 'bj',
          }),
    );
    print(transaction_lien);

    // --- ou ---

    // Feda.create_transaction(
    //   FedaTransactionRequest(
    //       amount: 500,
    //       clienMail: "tbaissou@gmail.com",
    //       description: "Ma premiere trx feda",
    //       phone_number: {
    //         'number': "65924088",
    //         'country': 'bj',
    //       }),
    // ).then((transaction_lien) {

    //    // code de redirection

    // });
  }
*/
  createTransaction() async {
    Feda.create_transaction(
      // Transaction sans redirection
      // Pour les réseaux, je ne connais que les valeurs ci apreès : 'mtn', 'moov', 'mtn_ci', 'moov_tg', 'mtn_open', 'airtel_ne', 'free_sn','togocel', 'mtn_ecw'
      // Vous allez devoir vous débrouillez pour le reste 😅😅
        FedaTransactionRequest(
            amount: 500,
            clienMail: "tbaissou@gmail.com",
            description: "Ma premiere trx feda",
            phone_number: {
              'number': "0168894947",
              'country': 'bj',
            }),
        redirect: true,
        reseau: 'moov');
  }

  @override
  Widget build(BuildContext context) {
    double longeur = MediaQuery.of(context).size.height;
    double largeur = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('FedaPay plugin'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: largeur / 15),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const Text("Tout récupérer"),
            ElevatedButton(
                key: const Key('get_all_btn'),
                onPressed: getAllData,
                child: const Text("Récupérer")),
            Padding(
              padding:
              EdgeInsets.only(top: longeur / 15, bottom: longeur / 50.0),
              child: const Text("Récupérer une transaction avec son id"),
            ),
            TextFormField(
              key: const Key('trx_id'),
              controller: _idController,
              decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'Password',
                  suffix: InkWell(
                      key: const Key('get_btn'),
                      onTap: findTransaction,
                      child: const Icon(
                        Icons.search,
                        color: Colors.blue,
                      ))),
            ),
            Padding(
              padding:
              EdgeInsets.only(top: longeur / 15, bottom: longeur / 50.0),
              child: const Text("Lancer une transaction redirigée vers Feda"),
            ),
            ElevatedButton(
                key: const Key('create_redirect_btn'),
                onPressed: createRedirectTransaction,
                child: const Text("Récupérer")),
            Padding(
              padding:
              EdgeInsets.only(top: longeur / 15.0, bottom: longeur / 50.0),
              child: const Text("Lancer une transaction sans redirection"),
            ),
            ElevatedButton(
                key: const Key('create_btn'),
                onPressed: createTransaction,
                child: const Text("Récupérer")),
          ]),
        ),
      ),
    );
  }
}