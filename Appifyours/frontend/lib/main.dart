import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Generated E-commerce App',
    theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        brightness: Brightness.light,
        appBarTheme: const AppBarTheme(
            elevation: 4, shadowColor: Colors.black38, color: Colors.blue, foregroundColor: Colors.white),
        cardTheme: CardThemeData(
            elevation: 3, shadowColor: Colors.black12,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                backgroundColor: Colors.blue)),
        inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            filled: true, fillColor: Colors.grey.shade50,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16))),
    home: const HomePage(),
    debugShowCheckedModeBanner: false,
  );
}

class Product {
  final String id;
  final String name;
  final String description;
  final double originalPrice;
  final double? discountPercentage;
  final String imageUrl;
  bool isInWishlist;
  int quantity;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.originalPrice,
    this.discountPercentage,
    required this.imageUrl,
    this.isInWishlist = false,
    this.quantity = 1,
  });

  double get discountedPrice {
    if (discountPercentage != null) {
      return originalPrice * (1 - discountPercentage! / 100);
    }
    return originalPrice;
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'],
      name: json['name'],
      description: json['description'],
      originalPrice: json['originalPrice'].toDouble(),
      discountPercentage: json['discountPercentage']?.toDouble(),
      imageUrl: json['imageUrl'],
      isInWishlist: json['isInWishlist'] ?? false,
      quantity: json['quantity'] ?? 1,
    );
  }
}

class ProductService {
  static Future<List<Product>> fetchProducts({String? search}) async {
    Uri url;
    if (search != null && search.isNotEmpty) {
      url = Uri.parse('http://localhost:5000/api/products?search=$search');
    } else {
      url = Uri.parse('http://localhost:5000/api/products');
    }
    
    final response = await http.get(url);
    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      List<Product> products = body.map((dynamic item) => Product.fromJson(item)).toList();
      return products;
    } else {
      throw Exception('Failed to load products');
    }
  }
}

class WishlistService {
  static Future<void> addToWishlist(String productId) async {
    // Implementation for adding to wishlist
  }

  static Future<void> removeFromWishlist(String productId) async {
    // Implementation for removing from wishlist
  }

  static Future<List<Product>> getWishlist() async {
    // Implementation for getting wishlist
    return [];
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _searchTerm = '';
  late Future<List<Product>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _productsFuture = ProductService.fetchProducts();
  }

  void _updateSearchTerm(String term) {
    setState(() {
      _searchTerm = term;
      _productsFuture = ProductService.fetchProducts(search: term);
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: FutureBuilder<List<Product>>(
      future: _productsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No products found'));
        } else {
          List<Product> products = snapshot.data!;
          
          return SingleChildScrollView(
            child: Column(
              children: [
          ProductSearchBarWidget(
            placeholder: 'Search products',
            onSearchChanged: (term) {
              // This will be handled by the HomePage
            },
          ),
                  ProductDetailCardWidget(
            category: 'All Products',
            columns: 2,
            products: [], // This will be filled by the HomePage
          ),
                  HeaderWidget(
            appName: 'My Store',
            backgroundColor: Colors.blue,
          ),
                  Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.grey[200],
            child: Text('Widget: BottomNavigationBarWidget'),
          ),
                  ProductGridWidget(
            products: [], // This will be filled by the HomePage
            columns: 2,
          ),
                      ],
            ),
          );
        }
      },
    ),
  );
}
// Header Widget
class HeaderWidget extends StatelessWidget {
  final String appName;
  final Color backgroundColor;

  const HeaderWidget({
    super.key,
    required this.appName,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      color: backgroundColor,
      child: Text(
        appName,
        style: const TextStyle(color: Colors.white, fontSize: 20),
      ),
    );
  }
}

// Product Search Bar Widget
class ProductSearchBarWidget extends StatelessWidget {
  final String placeholder;
  final Function(String) onSearchChanged;

  const ProductSearchBarWidget({
    super.key,
    required this.placeholder,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: placeholder,
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        onChanged: onSearchChanged,
      ),
    );
  }
}

// Hero Banner Widget
class HeroBannerWidget extends StatelessWidget {
  final String title;
  final Color backgroundColor;

  const HeroBannerWidget({
    super.key,
    required this.title,
    required this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

// Catalog View Card / Product Grid Widget
class ProductGridWidget extends StatelessWidget {
  final List<Product> products;
  final int columns;

  const ProductGridWidget({
    super.key,
    required this.products,
    required this.columns,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'All Products',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          if (products.isEmpty)
            const Center(child: Text('No products found'))
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.55,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 120,
                        child: Stack(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                              child: Image.network(
                                product.imageUrl,
                                width: double.infinity,
                                height: 120,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => Container(
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.image, size: 40),
                                ),
                              ),
                            ),
                            if (product.discountPercentage != null)
                              Positioned(
                                top: 6,
                                left: 6,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    '${product.discountPercentage}% OFF',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            Positioned(
                              top: 6,
                              right: 6,
                              child: GestureDetector(
                                onTap: () async {
                                  if (product.isInWishlist) {
                                    await WishlistService.removeFromWishlist(product.id);
                                  } else {
                                    await WishlistService.addToWishlist(product.id);
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(3),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.7),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    product.isInWishlist ? Icons.favorite : Icons.favorite_border,
                                    color: Colors.red,
                                    size: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 3),
                              Text(
                                product.description,
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey.shade600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  Text(
                                    '\$${product.discountedPrice.toStringAsFixed(2)}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: product.discountPercentage != null ? Colors.blue : Colors.black,
                                    ),
                                  ),
                                  if (product.originalPrice != product.discountedPrice)
                                    Padding(
                                      padding: const EdgeInsets.only(left: 6.0),
                                      child: Text(
                                        '\$${product.originalPrice.toStringAsFixed(2)}',
                                        style: TextStyle(
                                          fontSize: 10,
                                          decoration: TextDecoration.lineThrough,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}

// Store Info Widget
class StoreInfoWidget extends StatelessWidget {
  final String storeName;
  final String address;
  final String email;
  final String phone;

  const StoreInfoWidget({
    super.key,
    required this.storeName,
    required this.address,
    required this.email,
    required this.phone,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              storeName,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(address),
            const SizedBox(height: 8),
            Text(email),
            const SizedBox(height: 8),
            Text(phone),
          ],
        ),
      ),
    );
  }
}

// Profile Widget
class ProfileWidget extends StatelessWidget {
  final String profileTitle;
  final String buttonText;
  final Color buttonColor;

  const ProfileWidget({
    super.key,
    required this.profileTitle,
    required this.buttonText,
    required this.buttonColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            profileTitle,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          CircleAvatar(
            radius: 40,
            backgroundColor: Colors.grey[300],
            child: const Icon(Icons.person, size: 40),
          ),
          const SizedBox(height: 16),
          Text(
            'John Doe',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'john.doe@example.com',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    backgroundColor: buttonColor,
                  ),
                  child: Text(
                    buttonText,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Product Detail Card Widget
class ProductDetailCardWidget extends StatelessWidget {
  final String category;
  final int columns;
  final List<Product> products;

  const ProductDetailCardWidget({
    super.key,
    required this.category,
    required this.columns,
    required this.products,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            category,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          if (products.isEmpty)
            const Center(child: Text('No products available'))
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columns,
                childAspectRatio: 1.2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Card(
                  elevation: 3,
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          height: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: const BorderRadius.horizontal(left: Radius.circular(4)),
                          ),
                          child: product.imageUrl.isNotEmpty
                              ? Image.network(
                                  product.imageUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => 
                                      const Icon(Icons.image, size: 40, color: Colors.grey),
                                )
                              : const Icon(Icons.image, size: 40, color: Colors.grey),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                product.name,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (product.discountPercentage != null) ...[
                                Row(
                                  children: [
                                    Text(
                                      '\$${product.discountedPrice.toStringAsFixed(0)}',
                                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.green),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '\$${product.originalPrice.toStringAsFixed(0)}',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.grey,
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                    ),
                                  ],
                                ),
                              ] else
                                Text(
                                  '\$${product.originalPrice.toStringAsFixed(0)}',
                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey.shade300),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: IconButton(
                                            padding: EdgeInsets.zero,
                                            icon: const Icon(Icons.remove, size: 12),
                                            onPressed: () {},
                                          ),
                                        ),
                                        const Text('1', style: TextStyle(fontSize: 10)),
                                        SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: IconButton(
                                            padding: EdgeInsets.zero,
                                            icon: const Icon(Icons.add, size: 12),
                                            onPressed: () {},
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    icon: const Icon(Icons.favorite_border, size: 16),
                                    onPressed: () {},
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              SizedBox(
                                height: 24,
                                child: ElevatedButton(
                                  onPressed: () {},
                                  style: ElevatedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    minimumSize: const Size(double.infinity, 24),
                                  ),
                                  child: const Text('Add to Cart', style: TextStyle(fontSize: 9)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }
}
