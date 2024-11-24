import 'package:flutter/material.dart';
import 'package:resepmakanan_5a/models/recipe_model.dart';
import 'package:resepmakanan_5a/services/recipe_service.dart';

class DetailScreen extends StatelessWidget {
  final int id;

  const DetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final RecipeService recipeService = RecipeService();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Resep"),
      ),
      body: FutureBuilder<RecipeModel>(
        future: recipeService.getRecipeById(id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          } else if (snapshot.hasData) {
            final recipe = snapshot.data!;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(
                    recipe.photoUrl,
                    width: double.infinity,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          recipe.title,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.star, color: Colors.yellow),
                                Text(" ${recipe.likesCount} likes"),
                              ],
                            ),
                            const SizedBox(width: 16),
                            Row(
                              children: [
                                const Icon(Icons.comment, color: Colors.grey),
                                Text(" ${recipe.commentsCount} comments"),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Deskripsi
                        const Text(
                          "Description",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(recipe.description),
                        const SizedBox(height: 16),
                        const Text(
                          "Ingredients",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(recipe.ingredients),
                        const SizedBox(height: 16),
                        const Text(
                          "Steps",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(recipe.cookingMethod),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: Text("Tidak ada data"));
          }
        },
      ),
    );
  }
}
