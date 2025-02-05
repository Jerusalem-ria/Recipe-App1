import 'package:flutter/material.dart';
import 'recipe_detail.dart';
import 'home.dart';
import 'favorites_page.dart';
//import 'recipe_list.dart'; // Ensure to import your RecipeList
import 'popular_recipes_page.dart';
import 'editors_choice_page.dart';
//import 'account_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  SearchPageState createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> {
  int _selectedIndex = 1; // Set default index to Search
  final Set<String> favoriteRecipes = {}; // State for favorite recipes
  String selectedCategory = 'Breakfast'; // State for selected category

  // Sample Recipes
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
    // Add more recipes as needed
  ];

  final List<Map<String, String>> editorsChoiceRecipes = [
    {
      'imageUrl': 'assets/images/editor1.jpg',
      'title': 'Easy Homemade Beef Burger',
      'author': 'James Spader',
      'duration': '20 Min',
    },
    {
      'imageUrl': 'assets/images/editor2.jpg',
      'title': 'Blueberry with Egg for Breakfast',
      'author': 'Alice Fala',
      'duration': '12 Min',
    },
    {
      'imageUrl': 'assets/images/editor3.jpg',
      'title': 'Healthy Smoothie Bowl',
      'author': 'Chris Evans',
      'duration': '15 Min',
    },
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Home()),
      );
    } else if (index == 1) {
      // Stay on the current page
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
            toggleFavorite: toggleFavorite,
          ),
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
  }

  void toggleFavorite(String title) {
    setState(() {
      if (favoriteRecipes.contains(title)) {
        favoriteRecipes.remove(title);
      } else {
        favoriteRecipes.add(title);
      }
    });
  }

  void updateCategory(String category) {
    setState(() {
      selectedCategory = category;
    });
  }

  Widget _buildPopularRecipes(BuildContext context) {
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
              description: 'A delicious recipe for $title',
              favoriteRecipes: favoriteRecipes,
              toggleFavorite: toggleFavorite,
              relatedRecipes: [], // Add related recipes if available
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

  Widget _buildEditorsChoice(BuildContext context) {
    final List<Map<String, String>> editorsChoice = [
      {
        'imageUrl': 'assets/images/editor1.jpg',
        'title': 'Easy Homemade Beef Burger',
        'author': 'James Spader',
        'duration': '20 Min',
      },
      {
        'imageUrl': 'assets/images/editor2.jpg',
        'title': 'Blueberry with Egg for Breakfast',
        'author': 'Alice Fala',
        'duration': '12 Min',
      },
      {
        'imageUrl': 'assets/images/editor3.jpg',
        'title': 'Healthy Smoothie Bowl',
        'author': 'Chris Evans',
        'duration': '15 Min',
      },
    ];

    return Column(
      children: editorsChoice.map((recipe) {
        return Stack(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RecipeDetail(
                      title: recipe['title']!,
                      imageUrl: recipe['imageUrl']!,
                      author: recipe['author']!,
                      duration: recipe['duration']!,
                      description: 'A delicious recipe for ${recipe['title']!}',
                      favoriteRecipes: favoriteRecipes,
                      toggleFavorite: toggleFavorite,
                      relatedRecipes: [],
                    ),
                  ),
                );
              },
              child: Container(
                width: MediaQuery.of(context).size.width * 0.85,
                margin: EdgeInsets.only(bottom: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child:
                          Image.asset(recipe['imageUrl']!, fit: BoxFit.cover),
                    ),
                    SizedBox(height: 2),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              recipe['title']!,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'by ${recipe['author']}',
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                            Text(
                              recipe['duration']!,
                              style: TextStyle(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(
                              icon: Icon(
                                favoriteRecipes.contains(recipe['title']!)
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color:
                                    favoriteRecipes.contains(recipe['title']!)
                                        ? Colors.red
                                        : Colors.grey,
                              ),
                              onPressed: () {
                                toggleFavorite(recipe['title']!);
                              },
                            ),
                            Icon(Icons.arrow_forward),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                decoration: InputDecoration(
                  hintText: 'Search',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CategoryButton(
                    label: 'Breakfast',
                    isSelected: selectedCategory == 'Breakfast',
                    onTap: () => updateCategory('Breakfast'),
                  ),
                  CategoryButton(
                    label: 'Lunch',
                    isSelected: selectedCategory == 'Lunch',
                    onTap: () => updateCategory('Lunch'),
                  ),
                  CategoryButton(
                    label: 'Dinner',
                    isSelected: selectedCategory == 'Dinner',
                    onTap: () => updateCategory('Dinner'),
                  ),
                ],
              ),
              SizedBox(height: 16),
              SectionHeader(
                title: 'Popular Recipes',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PopularRecipesPage(
                        favoriteRecipes: favoriteRecipes,
                        toggleFavorite: toggleFavorite,
                        popularRecipes:
                            popularRecipes, // Pass your list of popular recipes
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 8),
              _buildPopularRecipes(context),
              SizedBox(height: 16),
              SectionHeader(
                title: 'Editor\'s Choice',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditorsChoicePage(
                        favoriteRecipes: favoriteRecipes,
                        toggleFavorite: toggleFavorite,
                        recipes:
                            editorsChoiceRecipes, // Pass your list of editor's choice recipes
                      ),
                    ),
                  );
                },
              ),
              SizedBox(height: 8),
              _buildEditorsChoice(context),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite), label: 'Favorites'),
          /* BottomNavigationBarItem(
              icon: Icon(Icons.notifications), label: 'Notifications'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'), */
        ],
        selectedItemColor: const Color.fromARGB(255, 5, 38, 7),
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}

class CategoryButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  CategoryButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.teal : Colors.grey[200],
        foregroundColor: isSelected ? Colors.white : Colors.black,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      child: Text(label),
    );
  }
}

class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  SectionHeader({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        GestureDetector(
          onTap: onTap,
          child: Text(
            'View All',
            style: TextStyle(color: Colors.teal),
          ),
        ),
      ],
    );
  }
}

class RecipeCard extends StatelessWidget {
  final String title;
  final String imageUrl;

  RecipeCard({required this.title, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
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
            'by Author',
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
          Text(
            'Duration',
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

class RecipeListItem extends StatelessWidget {
  final String title;
  final String author;
  final String imageUrl;
  final double cardWidth;
  final Set<String> favoriteRecipes;
  final void Function(String) toggleFavorite;

  RecipeListItem({
    required this.title,
    required this.author,
    required this.imageUrl,
    required this.cardWidth,
    required this.favoriteRecipes,
    required this.toggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: cardWidth,
      margin: EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Image.asset(imageUrl, fit: BoxFit.cover),
        title: Text(title),
        subtitle: Text('by $author'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                favoriteRecipes.contains(title)
                    ? Icons.favorite
                    : Icons.favorite_border,
                color:
                    favoriteRecipes.contains(title) ? Colors.red : Colors.grey,
              ),
              onPressed: () {
                toggleFavorite(title);
              },
            ),
            Icon(Icons.arrow_forward),
          ],
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RecipeDetail(
                title: title,
                imageUrl: imageUrl,
                author: author,
                duration: 'Duration',
                description: 'A delicious recipe for $title',
                favoriteRecipes: favoriteRecipes,
                toggleFavorite: toggleFavorite,
                relatedRecipes: [],
              ),
            ),
          );
        },
      ),
    );
  }
}
