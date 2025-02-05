import 'package:flutter/material.dart';
import 'recipe_detail.dart';

class RecipeList extends StatefulWidget {
  final Set<String> favoriteRecipes;
  final Function toggleFavorite;
  final String category;
  final List<Map<String, String>> recipes;

  const RecipeList(
      {required this.favoriteRecipes,
      required this.toggleFavorite,
      required this.category,
      required this.recipes,
      super.key});

  @override
  RecipeListState createState() => RecipeListState();
}

class RecipeListState extends State<RecipeList> {
  @override
  Widget build(BuildContext context) {
    // Filter recipes based on the selected category (meal time)
    List<Map<String, String>> filteredRecipes = widget.recipes.where((recipe) {
      if (recipe['mealTimes'] == null) return false;
      List<String> mealTimes = recipe['mealTimes']!
          .split(',')
          .map((e) => e.trim())
          .toList(); // Trim whitespace
      return mealTimes.contains(widget.category);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: filteredRecipes.map((recipe) {
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
                      widget.favoriteRecipes.contains(recipe['title']!)
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: widget.favoriteRecipes.contains(recipe['title']!)
                          ? Colors.red
                          : Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        widget.toggleFavorite(recipe['title']!);
                      });
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
              favoriteRecipes: widget.favoriteRecipes,
              toggleFavorite: widget.toggleFavorite,
              relatedRecipes: widget.recipes,
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
