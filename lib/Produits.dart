import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

import 'menu.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: ProductListPage(),
    );
  }
}

class Product {
  final String name;
  final String image;
  final double price;

  Product({required this.name, required this.image, required this.price});
}

class ProductListPage extends StatefulWidget {
  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  final List<Product> products = [
    // List of products
    Product(
      name: 'Tomates',
      image: 'assets/images/tomatoes.jpg',
      price: 2000.0,
    ),
    Product(
      name: 'Salades',
      image: 'assets/images/—Pngtree—lettuce_5628523.png',
      price: 1200.0,
    ),
    Product(
      name: 'Carottes',
      image: 'assets/images/carottes.png',
      price: 1200.0,
    ),
    Product(
      name: 'Poivres',
      image: 'assets/images/poire-fraiche-humide.jpg',
      price: 1200.0,
    ),

    Product(
      name: 'Pommes',
      image: 'assets/images/pomme.jpg',
      price: 1500.0,
    ),
    Product(
      name: 'P-Verte',
      image: 'assets/images/pomme-verte.jpg',
      price: 1000.0,
    ),
    Product(
      name: 'Carottes',
      image: 'assets/images/delicious-carrot-raw.jpg',
      price: 1200.0,
    ),
    Product(
      name: 'Piments',
      image: 'assets/images/red-chili-peppers.jpg',
      price: 1200.0,
    ),
    Product(
      name: 'Salades',
      image: 'assets/images/fresh-beetroot-isolated-white.jpg',
      price: 1200.0,
    ),
    Product(
      name: 'Oignons',
      image: 'assets/images/raw-onions-white-surface.jpg',
      price: 1200.0,
    ),
    Product(
      name: 'Salades',
      image: 'assets/images/poire-fraiche-humide.jpg',
      price: 1200.0,
    ),
    Product(
      name: 'Salades',
      image: 'assets/images/raw-onions-white-surface.jpg',
      price: 1200.0,
    ),
    Product(
      name: 'Riz',
      image: 'assets/images/pierre-bamin--LdilhDx3sk-unsplash.jpg',
      price: 1200.0,
    ),
    Product(
      name: 'Salades',
      image: 'assets/images/poire-fraiche-humide.jpg',
      price: 1200.0,
    ),
  ];

  List<Product> filteredProducts = [];

  @override
  void initState() {
    filteredProducts = products;
    super.initState();
  }

  void filterProducts(String query) {
    setState(() {
      filteredProducts = products
          .where((product) =>
              product.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          "Produits disponibles",
          style: GoogleFonts.aboreto(
            color: Colors.black,
            fontWeight: FontWeight.w900,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
            size: 30,
          ),
          onPressed: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              PageRouteBuilder(
                transitionDuration: Duration(milliseconds: 500),
                pageBuilder: (_, __, ___) => MenuCards(),
              ),
            );
          },
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(26.0),
            child: TextField(
              onChanged: (value) => filterProducts(value),
              decoration: InputDecoration(
                labelText: 'Rechercher un produit',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(35.0),
                ),
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return ListView.builder(
                  itemCount: filteredProducts.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ProductListItem(
                      product: filteredProducts[index],
                      onProductSelected: (Product selectedProduct) {
                        Navigator.push(
                          context,
                          PageRouteBuilder(
                            transitionDuration: Duration(milliseconds: 500),
                            pageBuilder: (_, __, ___) => OrderFormPage(
                              product: selectedProduct,
                            ),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ProductListItem extends StatelessWidget {
  final Product product;
  final Function(Product) onProductSelected;

  ProductListItem({required this.product, required this.onProductSelected});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onProductSelected(product),
      child: Card(
        elevation: 2.0,
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: Hero(
                  tag: product.image,
                  child: Image.asset(
                    product.image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  product.name,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  '${product.price.toStringAsFixed(2)} FCFA',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                    color: Colors.blue,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => OrderFormPage(product: product),
                      ),
                    );
                  },
                  child: Text('Commander'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OrderFormPage extends StatelessWidget {
  final Product product;

  OrderFormPage({required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Commander ${product.name}',
          style: GoogleFonts.aboreto(
            color: Colors.black,
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Center(
                //   child: Text(
                //     'Formulaire de Commande',
                //     style: TextStyle(
                //       fontSize: 30,
                //       fontWeight: FontWeight.bold,
                //     ),
                //   ),
                // ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Hero(
                      tag: product.image,
                      child: Image.asset(
                        product.image,
                        width: 250,
                        height: 300,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      product.name,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                // Add necessary form fields for the order here
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Lieu de livraison',
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  decoration: InputDecoration(
                    labelText: 'Quantité',
                  ),
                  keyboardType: TextInputType.number,
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    Radio(
                      value: true,
                      groupValue: false,
                      onChanged: (value) {},
                    ),
                    Text('Payé'),
                    SizedBox(width: 20),
                    Radio(
                      value: false,
                      groupValue: false,
                      onChanged: (value) {},
                    ),
                    Text('Non payé'),
                  ],
                ),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text('Succès'),
                            content: Text(
                                'Votre commande a été envoyée avec succès !'),
                            actions: [
                              ElevatedButton(
                                child: Text('OK'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Center(
                      child: Text(
                        'Valider la commande',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
