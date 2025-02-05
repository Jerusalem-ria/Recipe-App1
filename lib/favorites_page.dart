import 'package:flutter/material.dart';
import 'recipe_detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FavoritesPage extends StatefulWidget {
  final Set<String> favoriteRecipes;
  final List<Map<String, String>> allRecipes;
  final Function toggleFavorite;

  const FavoritesPage({
    required this.favoriteRecipes,
    required this.allRecipes,
    required this.toggleFavorite,
    super.key,
  });

  @override
  FavoritesPageState createState() => FavoritesPageState();
}

class FavoritesPageState extends State<FavoritesPage> {
  @override
  Widget build(BuildContext context) {
    final favoriteRecipeDetails = widget.allRecipes
        .where((recipe) => widget.favoriteRecipes.contains(recipe['title']))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: favoriteRecipeDetails.map((recipe) {
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
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(
                          widget.favoriteRecipes.contains(recipe['title']!)
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color:
                              widget.favoriteRecipes.contains(recipe['title']!)
                                  ? Colors.red
                                  : Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            widget.toggleFavorite(recipe['title']!);
                          });
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.remove_circle_outline,
                            color: Colors.red), // Changed icon
                        onPressed: () async {
                          await _deleteFavoriteRecipe(recipe['title']!);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Future<void> _deleteFavoriteRecipe(String title) async {
    // Remove from Firestore
    await FirebaseFirestore.instance
        .collection('favorites')
        .doc(title)
        .delete();

    // Update local state
    setState(() {
      widget.favoriteRecipes.remove(title);
    });
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
              relatedRecipes: widget.allRecipes,
            ),
          ),
        );
      },
      child: Container(
        width: 200,
        margin: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.asset(
                imageUrl,
                height: 150,
                width: 200,
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
