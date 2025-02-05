import 'package:flutter/material.dart';
import 'recipe_detail.dart';

class EditorsChoicePage extends StatelessWidget {
  final Set<String> favoriteRecipes;
  final Function toggleFavorite;
  final List<Map<String, String>> recipes;

  const EditorsChoicePage({
    required this.favoriteRecipes,
    required this.toggleFavorite,
    required this.recipes,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editor\'s Choice'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: recipes.map((recipe) {
            return Stack(
              children: [
                _buildRecipeCard(
                  context: context,
                  imageUrl: recipe['imageUrl']!,
                  title: recipe['title']!,
                  author: recipe['author']!,
                  duration: recipe['duration']!,
                ),
                Positioned(
                  right: 0,
                  child: IconButton(
                    icon: Icon(
                      favoriteRecipes.contains(recipe['title']!)
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: favoriteRecipes.contains(recipe['title']!)
                          ? Colors.red
                          : Colors.grey,
                    ),
                    onPressed: () {
                      toggleFavorite(recipe['title']!);
                    },
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildRecipeCard({
    required BuildContext context,
    required String imageUrl,
    required String title,
    required String author,
    required String duration,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RecipeDetail(
              title: title,
              imageUrl: imageUrl,
              author: author,
              duration: duration,
              description: 'A delicious recipe for $title',
              favoriteRecipes: favoriteRecipes,
              toggleFavorite: toggleFavorite,
              relatedRecipes: recipes,
            ),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.asset(
                imageUrl,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'by $author',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            Text(
              duration,
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
