import 'package:flutter/material.dart';

import '../models/product_model.dart';
import '../models/cart_item.dart';
import '../data/product_data.dart';
import '../widgets/product_card.dart';
import '../widgets/category_button.dart';
import 'cart_page.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  int selectedIndex = 0;
  int currentNavIndex = 0;

  Set<Product> favorites = {};
  List<CartItem> cart = [];

  List<Product> get filteredProducts {
    if (selectedIndex == 1) {
      return products.where((p) => p.category == "Jackets").toList();
    }

    if (selectedIndex == 2) {
      return products.where((p) => p.category == "Sneakers").toList();
    }

    return products;
  }

  void addToCart(Product product) {
    setState(() {
      int index = cart.indexWhere((item) => item.product.name == product.name);
      if (index != -1) {
        cart[index].quantity++;
      } else {
        cart.add(CartItem(product: product));
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} added to cart!'),
        duration: const Duration(seconds: 1),
        backgroundColor: Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    int cartCount = cart.fold<int>(0, (sum, item) => sum + item.quantity);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "E-Commerce Shop",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.shopping_cart),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CartPage(
                          cart: cart,
                          onUpdateCart: () {
                            setState(() {});
                          },
                        ),
                      ),
                    );
                  },
                ),
                if (cartCount > 0)
                  Positioned(
                    right: 4,
                    top: 4,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        '$cartCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
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
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Row(
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
          ),
        ), // Row

        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            itemCount: filteredProducts.length,
            gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.72,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
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
                onAddToCart: () {
                  addToCart(product);
                },
              ); // ProductCard
            },
          ), // GridView.builder
        ), // Expanded
      ],
    ); // Column
  }

  Widget buildFavorites() {
    if (favorites.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite_border, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              "No favorites added yet",
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: favorites.length,
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.72,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
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
          onAddToCart: () {
            addToCart(product);
          },
        ); // ProductCard
      },
    ); // GridView.builder
  }
}
