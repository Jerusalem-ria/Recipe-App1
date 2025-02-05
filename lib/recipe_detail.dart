import 'package:flutter/material.dart';
import 'related_recipes_page.dart';
//import 'recipe_list.dart';

class Recipe {
  final String title;
  final String imageUrl;
  final String author;
  final String duration;
  final String description;
  final List<String> mealTimes;
  final Set<String> favoriteRecipes;
  final Function toggleFavorite;
  final List<Map<String, String>> relatedRecipes;

  const Recipe({
    required this.title,
    required this.imageUrl,
    required this.author,
    required this.duration,
    required this.description,
    required this.mealTimes,
    required this.favoriteRecipes,
    required this.toggleFavorite,
    required this.relatedRecipes,
  });
}

class RecipeDetail extends StatefulWidget {
  final String title;
  final String imageUrl;
  final String author;
  final String duration;
  final String description;
  final Set<String> favoriteRecipes;
  final Function toggleFavorite;
  final List<Map<String, String>> relatedRecipes;

  const RecipeDetail(
      {required this.title,
      required this.imageUrl,
      required this.author,
      required this.duration,
      required this.description,
      required this.favoriteRecipes,
      required this.toggleFavorite,
      required this.relatedRecipes,
      super.key});

  @override
  RecipeDetailState createState() => RecipeDetailState();
}

class RecipeDetailState extends State<RecipeDetail> {
  bool showIngredients = false;
  bool showInstructions = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: Icon(
              widget.favoriteRecipes.contains(widget.title)
                  ? Icons.favorite
                  : Icons.favorite_border,
              color: widget.favoriteRecipes.contains(widget.title)
                  ? Colors.red
                  : Colors.grey,
            ),
            onPressed: () {
              setState(() {
                widget.toggleFavorite(widget.title);
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(
                widget.imageUrl,
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 20),
              Text(
                widget.title,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'by ${widget.author}',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 10),
              Text(
                widget.duration,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 20),
              Text(
                widget.description,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),

              SizedBox(height: 10),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildNutritionInfo(
                          Icons.local_fire_department, 'Calories', '120 Kcal'),
                      _buildNutritionInfo(Icons.restaurant, 'Carbs', '65g'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildNutritionInfo(
                          Icons.accessibility, 'Proteins', '27g'),
                      _buildNutritionInfo(Icons.fastfood, 'Fats', '91g'),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20), // Ingredients and Instructions buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          showIngredients = true;
                          showInstructions = false;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: showIngredients
                            ? const Color.fromARGB(255, 5, 38, 7)
                            : const Color.fromARGB(
                                44, 99, 99, 99), // Active color
                        padding: EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Ingredients',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          showInstructions = true;
                          showIngredients = false;
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: showInstructions
                            ? const Color.fromARGB(255, 5, 38, 7)
                            : const Color.fromARGB(
                                44, 99, 99, 99), // Active color
                        padding: EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        'Instructions',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              if (showIngredients) ...[
                SizedBox(height: 20),
                _buildIngredients(),
              ],
              if (showInstructions) ...[
                SizedBox(height: 20),
                _buildInstructions(),
              ],
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Related Recipes',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RelatedRecipesPage(
                            favoriteRecipes: widget.favoriteRecipes,
                            toggleFavorite: widget.toggleFavorite,
                            relatedRecipes: widget.relatedRecipes,
                          ),
                        ),
                      );
                    },
                    child: Text(
                      'See All',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.amber,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: widget.relatedRecipes.map((recipe) {
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
                              color: widget.favoriteRecipes
                                      .contains(recipe['title']!)
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNutritionInfo(IconData icon, String label, String value) {
    return Column(
      children: [
        Icon(icon, color: const Color.fromARGB(255, 5, 38, 7)),
        SizedBox(height: 5),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _buildIngredients() {
    // (mock data)
    final List<Map<String, String>> ingredients = [
      {'ingredient': 'Flour', 'amount': '2 cups'},
      {'ingredient': 'Milk', 'amount': '1 cup'},
      {'ingredient': 'Eggs', 'amount': '2'},
      {'ingredient': 'Salt', 'amount': '1 tsp'},
      {'ingredient': 'Sugar', 'amount': '1 tbsp'},
      {'ingredient': 'Butter', 'amount': '1/2 cup'},
      {'ingredient': 'Vanilla extract', 'amount': '1 tsp'},
      {'ingredient': 'Blueberries', 'amount': '1/2 cup (optional)'},
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: ingredients
          .map((item) => Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade500,
                      blurRadius: 5,
                      spreadRadius: 1,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                padding: EdgeInsets.all(10),
                margin: EdgeInsets.symmetric(vertical: 5),
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item['ingredient']!,
                      style: TextStyle(fontSize: 16),
                    ),
                    Text(
                      item['amount']!,
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              ))
          .toList(),
    );
  }

  Widget _buildInstructions() {
    // (mock data)
    final List<String> instructions = [
      'Mix all the ingredients in a large bowl.',
      'Preheat a pan over medium heat.',
      'Pour a small amount of batter into the pan.',
      'Cook until bubbles form on the surface, then flip and cook until golden brown.',
      'Serve hot with maple syrup or toppings of your choice.',
      'Enjoy your delicious meal!',
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: instructions.asMap().entries.map((entry) {
        int idx = entry.key;
        String instruction = entry.value;
        return Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade500,
                blurRadius: 5,
                spreadRadius: 1,
                offset: Offset(2, 2),
              ),
            ],
          ),
          padding: EdgeInsets.all(10),
          margin: EdgeInsets.symmetric(vertical: 5),
          width: double.infinity,
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: const Color.fromARGB(86, 0, 0, 0),
                child: Text(
                  '${idx + 1}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  instruction,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        );
      }).toList(),
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
              relatedRecipes: widget.relatedRecipes,
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
