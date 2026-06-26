import 'package:flutter/material.dart';

import '../models/product_model.dart';
import '../data/product_data.dart';
import '../widgets/product_card.dart';
import '../widgets/category_button.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  int selectedIndex = 0;
  int currentNavIndex = 0;

  Set<Product> favorites = {};

  List<Product> get filteredProducts {
    if (selectedIndex == 1) {
      return products.where((p) => p.category == "Jackets").toList();
    }

    if (selectedIndex == 2) {
      return products.where((p) => p.category == "Sneakers").toList();
    }

    return products;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("E-Commerce Shop"),
      ),

      body: currentNavIndex == 0
        ? buildHome()
        : buildFavorites(),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentNavIndex,
        onTap: (index) {
          setState(() {
            currentNavIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: "Favorites",
          ),
        ],
      ),
    );
  }

  Widget buildHome() {
    return Column(
      children: [
        Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceAround,
          children: [
            CategoryButton(
              title: "All",
              isSelected: selectedIndex == 0,
              onTap: () {
                setState(() {
                  selectedIndex = 0;
                });
              },
            ), // CategoryButton
            CategoryButton(
              title: "Jackets",
              isSelected: selectedIndex == 1,
              onTap: () {
                setState(() {
                  selectedIndex = 1;
                });
              },
            ), // CategoryButton
            CategoryButton(
              title: "Sneakers",
              isSelected: selectedIndex == 2,
              onTap: () {
                setState(() {
                  selectedIndex = 2;
                });
              },
            ), // CategoryButton
          ],
        ), // Row

        Expanded(
          child: GridView.builder(
            itemCount: filteredProducts.length,
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ), // SliverGridDelegateWithFixedCrossAxisCount
            itemBuilder: (context, index) {
              Product product =
                  filteredProducts[index];

              return ProductCard(
                product: product,
                isFavorite:
                    favorites.contains(product),
                onFavorite: () {
                  setState(() {
                    if (favorites.contains(product)) {
                      favorites.remove(product);
                    } else {
                      favorites.add(product);
                    }
                  });
                },
              ); // ProductCard
            },
          ), // GridView.builder
        ), // Expanded
      ],
    ); // Column
  }

  Widget buildFavorites() {
    return GridView.builder(
      itemCount: favorites.length,
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ), // SliverGridDelegateWithFixedCrossAxisCount
      itemBuilder: (context, index) {
        Product product =
            favorites.elementAt(index);

        return ProductCard(
          product: product,
          isFavorite: true,
          onFavorite: () {
            setState(() {
              favorites.remove(product);
            });
          },
        ); // ProductCard
      },
    ); // GridView.builder
  }
}
