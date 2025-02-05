import 'package:flutter/material.dart';
import 'recipe_list.dart' as recipeListLib;
import 'recipe_detail.dart';
import 'popular_recipes_page.dart';
import 'favorites_page.dart';
import 'search_page.dart';
//import 'account_page.dart';

const List<Map<String, String>> allRecipes = [
  {
    'title': 'Recipe 1',
    'imageUrl': 'assets/images/recipe1.jpg',
    'author': 'Author 1',
    'duration': '30 mins',
    'mealTimes': 'breakfast,lunch'
  },
  {
    'title': 'Recipe 2',
    'imageUrl': 'assets/images/recipe2.jpg',
    'author': 'Author 2',
    'duration': '25 mins',
    'mealTimes': 'dinner'
  },
];

class Home extends StatefulWidget {
  const Home({super.key});
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  final Set<String> favoriteRecipes = {};
  String selectedCategory = 'Popular'; // Define state for selected category

  void toggleFavorite(String title) {
    setState(() {
      if (favoriteRecipes.contains(title)) {
        favoriteRecipes.remove(title);
      } else {
        favoriteRecipes.add(title);
      }
      print(
          'Updated Favorite Recipes: $favoriteRecipes'); // Debugging print statement
    });
  }

  void navigateToCategory(BuildContext context, String category) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => recipeListLib.RecipeList(
            favoriteRecipes: favoriteRecipes,
            toggleFavorite: toggleFavorite,
            category: category,
            recipes: allRecipes),
      ),
    );
  }

  void updateCategory(String category) {
    setState(() {
      selectedCategory = category;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 0,
              ),
              // Greeting
              Row(
                children: [
                  Icon(Icons.wb_sunny, color: Colors.amber),
                  SizedBox(width: 5),
                  Text(
                    getGreeting(),
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                ],
              ),
              Text(
                'Alena Sabyan',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 0, 0, 0),
                ),
              ),
              SizedBox(height: 15),

              // Featured Recipes Section
              Text(
                'Featured',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: const Color.fromARGB(255, 0, 0, 0),
                ),
              ),
              SizedBox(height: 10),
              _buildFeaturedRecipes(context),
              SizedBox(height: 20),

              // Categories Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Categories',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              _buildCategories(context),
              SizedBox(height: 20),

              // Popular Recipes Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Popular Recipes',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PopularRecipesPage(
                            favoriteRecipes: favoriteRecipes,
                            toggleFavorite: toggleFavorite,
                            popularRecipes: [
                              {
                                'imageUrl': 'assets/images/popular1.jpg',
                                'title':
                                    'Healthy Taco Salad with Fresh Vegetables',
                                'author': 'John Doe',
                                'duration': '20 Min',
                              },
                              {
                                'imageUrl': 'assets/images/popular2.jpg',
                                'title': 'Japanese-style Pancakes Recipe',
                                'author': 'Jane Smith',
                                'duration': '12 Min',
                              },
                            ],
                          ),
                        ),
                      );
                    },
                    child: Text(
                      'See All',
                      style: TextStyle(color: Colors.amber),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              _buildPopularRecipes(context),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
          /*  BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),*/
        ],
        selectedItemColor: const Color.fromARGB(255, 5, 38, 7),
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SearchPage(),
              ),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FavoritesPage(
                  favoriteRecipes: favoriteRecipes,
                  allRecipes: [
                    {
                      'imageUrl': 'assets/images/popular1.jpg',
                      'title': 'Healthy Taco Salad with Fresh Vegetables',
                      'author': 'John Doe',
                      'duration': '20 Min',
                    },
                    {
                      'imageUrl': 'assets/images/popular2.jpg',
                      'title': 'Japanese-style Pancakes Recipe',
                      'author': 'Jane Smith',
                      'duration': '12 Min',
                    },
                  ],
                  toggleFavorite:
                      toggleFavorite, // Add the required argument here
                ),
              ),
            );
          }
        },
      ),
    );
  } /* else if (index == 3) {
            Navigator.pushNamed(context, '/notifications');
          } else if (index == 4) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AccountPage(
                  userName: 'John Doe', userEmail: 'john.doe@example.com',
                  userImage: 'assets/images/user.jpg',
                  userRecipes: [
                    {
                      'imageUrl': 'assets/images/popular1.jpg',
                      'title': 'Healthy Taco Salad with Fresh Vegetables',
                      'author': 'John Doe',
                      'duration': '20 Min',
                    },
                    {
                      'imageUrl': 'assets/images/popular2.jpg',
                      'title': 'Japanese-style Pancakes Recipe',
                      'author': 'John Doe',
                      'duration': '12 Min',
                    },
                  ], // List of user recipes
                ),
              ),
            );
          } */

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning,';
    } else if (hour < 17) {
      return 'Good Afternoon,';
    } else {
      return 'Good Evening,';
    }
  }

  Widget _buildCategories(BuildContext context) {
    final List<String> categories = ['Breakfast', 'Lunch', 'Dinner'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: categories.map((category) {
        return GestureDetector(
          onTap: () => navigateToCategory(context, category),
          child: _buildCategoryCard(title: category),
        );
      }).toList(),
    );
  }

  Widget _buildCategoryCard({required String title}) {
    return Container(
      width: 120,
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturedRecipes(BuildContext context) {
    final List<Map<String, String>> featuredRecipes = [
      {
        'imageUrl': 'assets/images/featured1.jpg',
        'title': 'Asian White Noodle with Extra Seafood',
        'author': 'James Spader',
        'duration': '20 Min',
      },
      {
        'imageUrl': 'assets/images/featured2.jpg',
        'title': 'Italian Pasta with Pesto Sauce',
        'author': 'Maria Rossi',
        'duration': '15 Min',
      },
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: featuredRecipes.map((recipe) {
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
                    setState(() {
                      toggleFavorite(recipe['title']!);
                    });
                  },
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildPopularRecipes(BuildContext context) {
    final List<Map<String, String>> popularRecipes = [
      {
        'imageUrl': 'assets/images/popular1.jpg',
        'title': 'Healthy Taco Salad with Fresh Vegetables',
        'author': 'John Doe',
        'duration': '20 Min',
      },
      {
        'imageUrl': 'assets/images/popular2.jpg',
        'title': 'Japanese-style Pancakes Recipe',
        'author': 'Jane Smith',
        'duration': '12 Min',
      },
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: popularRecipes.map((recipe) {
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
              description:
                  'A delicious recipe for $title', // Pass the description
              favoriteRecipes: favoriteRecipes,
              toggleFavorite: toggleFavorite,
              relatedRecipes: allRecipes,
            ),
          ),
        );
      },
      child: Container(
        width: 200,
        margin: EdgeInsets.only(right: 16.0),
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
