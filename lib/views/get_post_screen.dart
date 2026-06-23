import 'package:arilatiahflutter1/model/product_models.dart';
import 'package:arilatiahflutter1/services/api_services.dart';
import 'package:flutter/material.dart';

class PostListScreenDay33 extends StatefulWidget {
  const PostListScreenDay33({super.key});

  @override
  State<PostListScreenDay33> createState() => _PostListScreenDay33State();
}

class _PostListScreenDay33State extends StatefulWidget {
  const _PostListScreenDay33State({super.key});

  @override
  State<PostListScreenDay33> createState() => _PostListScreenDay33State();
}

class _PostListScreenDay33State extends State<PostListScreenDay33> {
  late final ApiService _apiService;
  late Future<List<PosModel>> _postsFuture;

  @override
  void initState() {
    super.initState();
    final dio = createDioClient();
    _apiService = ApiService(dio);
    _postsFuture = _apiService.getAllProducts();
  }

  void _refreshPosts() {
    setState(() {
      _postsFuture = _apiService.getAllProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Fake Store API',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColor.primaryColor,
      ),
      body: FutureBuilder<List<PosModel>>(
        future: _postsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.wifi_off, size: 64, color: Colors.grey),
                    const SizedBox(height: 16),
                    Text(
                      'Gagal memuat data:\n${snapshot.error}',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _refreshPosts,
                      child: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              ),
            );
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Tidak ada data produk'));
          }

          final products = snapshot.data!;

          return RefreshIndicator(
            onRefresh: () async => _refreshPosts(),
            child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Image.network(
                          product.image,
                          width: 80,
                          height: 80,
                          fit: BoxFit.contain,
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 8),

                              Text(
                                '\$${product.price}',
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),

                              const SizedBox(height: 4),

                              Text('⭐ ${product.rating.rate}'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}


          // class _PostListScreenDay33State extends State<PostListScreenDay33> {
          //   late final ApiService _apiService;
          //   late Future<List<product_models>> _postsFuture;

          //   @override
          //   void initState() {
          //     super.initState();
          //     final dio = createDioClient();
          //     _apiService = ApiService(dio);
          //     _postsFuture = _apiService.getAllPosts();
          //   }

          //   void _refreshPosts() {
          //     setState(() {
          //       _postsFuture = _apiService.getAllPosts();
          //     });
          //   }

          //   @override
          //   Widget build(BuildContext context) {
          //     return Scaffold(
          //       appBar: AppBar(
          //         title: const Text('API', style: TextStyle(color: Colors.white)),
          //         backgroundColor: AppColor.primaryColor,
          //         // iconTheme: const IconThemeData(color: Colors.white),
          //       ), // AppBar
          //       body: FutureBuilder<List<PostModels>>(
          //         future: _postsFuture,
          //         builder: (context, snapshot) {
          //           if (snapshot.connectionState == ConnectionState.waiting) {
          //             return const Center(child: CircularProgressIndicator());
          //           }

          //           if (snapshot.hasError) {
          //             return Center(
          //               child: Padding(
          //                 padding: const EdgeInsets.all(24),
          //                 child: Column(
          //                   mainAxisSize: MainAxisSize.min,
          //                   children: [
          //                     const Icon(Icons.wifi_off, size: 64, color: Colors.grey),
          //                     const SizedBox(height: 16),
          //                     Text(
          //                       'Gagal memuat data:\n${snapshot.error}',
          //                       textAlign: TextAlign.center,
          //                       style: const TextStyle(color: Colors.grey),
          //                     ), // Text
          //                     const SizedBox(height: 16),
          //                     ElevatedButton(
          //                       onPressed: _refreshPosts,
          //                       child: const Text('Coba Lagi'),
          //                     ), // ElevatedButton
          //                   ],
          //                 ), // Column
          //               ), // Padding
          //             ); // Center
          //           }

//           if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return const Center(child: Text('Tidak ada data post.'));
//           }

//           final posts = snapshot.data!;

//           return RefreshIndicator(
//             onRefresh: () async => _refreshPosts(),
//             child: ListView.builder(
//               itemCount: posts.length,
//               itemBuilder: (context, index) {
//                 final post = posts[index];
//                 return Card(
//                   margin: const EdgeInsets.symmetric(
//                     horizontal: 12,
//                     vertical: 6,
//                   ), // EdgeInsets.symmetric
//                   child: ListTile(
//                     leading: CircleAvatar(
//                       backgroundColor: AppColor.primaryColor,
//                       child: Text(
//                         '${post.id}',
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 12,
//                         ), // TextStyle
//                       ), // Text
//                     ), // CircleAvatar
//                     title: Text(
//                       post.title ?? "",
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                       style: const TextStyle(fontWeight: FontWeight.w600),
//                     ), // Text
//                     subtitle: Text(
//                       post.body ?? "",
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                     ), // Text
//                     trailing: const Icon(Icons.arrow_forward_ios, size: 16),
//                   ), // ListTile
//                 ); // Card
//               },
//             ), // ListView.builder
//           ); // RefreshIndicator
//         },
//       ), // FutureBuilder
//     ); // Scaffold
//   }
// }
