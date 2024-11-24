import 'package:flutter/material.dart';
import 'package:resepmakanan_5a/models/recipe_model.dart';
import 'package:resepmakanan_5a/services/recipe_service.dart';
import 'package:resepmakanan_5a/ui/detail_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  RecipeService _recipeService = RecipeService();
  late Future<List<RecipeModel>> futureRecipes;

  @override
  void initState() {
    super.initState();
    futureRecipes = _recipeService.getAllRecipe();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
      ),
      body: FutureBuilder<List<RecipeModel>>(
          future: futureRecipes,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text("Gagal load data : ${snapshot.error}"),
              );
            } else if (!snapshot.hasData) {
              return Center(
                child: Text("Tidak ada data"),
              );
            } else {
              return GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final recipe = snapshot.data![index];
                  return CustomCard(
                      id: recipe.id,
                      img: recipe.photoUrl,
                      title: recipe.title,
                      likes_count: recipe.likesCount,
                      comments_count: recipe.commentsCount);
                },
              );
            }
          }),
    );
  }
}

class CustomCard extends StatelessWidget {
  final String img;
  final String title;
  final int likes_count;
  final int comments_count;
  final int id;
  const CustomCard({
    required this.id,
    required this.img,
    required this.title,
    required this.likes_count,
    required this.comments_count,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailScreen(
              id: id,
            ),
          ),
        );
      },
      child: Card(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Column(
          children: [
            Image.network(
              "$img",
              fit: BoxFit.cover,
              width: double.infinity,
              height: 100,
            ),
            Text(
              "$title",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  children: [Icon(Icons.star), Text("$likes_count")],
                ),
                Row(
                  children: [Icon(Icons.comment), Text("$comments_count")],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
