import 'package:flutter/material.dart';

class Item {
  final String name;
  final double price;

  Item(this.name, this.price);
}

enum PageType {
  start,
  vegetables,
  fruits,
  bill,
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.orange,
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: ShoppingCart(),
    );
  }
}

class ShoppingCart extends StatefulWidget {
  @override
  _ShoppingCartState createState() => _ShoppingCartState();
}

class _ShoppingCartState extends State<ShoppingCart> {
  // Initialize pages
  PageType currentPage = PageType.start;

  // Items for each page
  List<Item> vegetables = [
    Item("Carrot", 50.0),
    Item("Cauliflower", 45.0),
    Item("Tomatoes", 40.0),
    Item("Potatoes", 20.0),
    Item("Brinjal", 20.0),
    Item("Onion", 60.0),
    Item("Ladies Finger", 35.0),
    Item("Beans", 80.0),
    Item("Bottlegourd", 20.0),
  ];

  List<Item> fruits = [
    Item("Apple", 220.0),
    Item("Orange", 70.0),
    Item("Banana", 60.0),
    Item("Pineapple", 90.0),
    Item("Grapes", 80.0),
    Item("Papaya", 60.0),
  ];

  List<Item> selectedItems = [];

  // Function to navigate to the next page
  void nextPage() {
    setState(() {
      if (currentPage == PageType.start) {
        currentPage = PageType.vegetables;
      } else if (currentPage == PageType.vegetables) {
        currentPage = PageType.fruits;
      } else if (currentPage == PageType.fruits) {
        currentPage = PageType.bill;
      } else if (currentPage == PageType.bill) {
        // Reset the selected items and navigate back to the start
        selectedItems.clear();
        currentPage = PageType.start;
      }
    });
  }

  // Function to navigate to the previous page
  void previousPage() {
    setState(() {
      if (currentPage == PageType.vegetables) {
        currentPage = PageType.start;
      } else if (currentPage == PageType.fruits) {
        currentPage = PageType.vegetables;
      } else if (currentPage == PageType.bill) {
        // Reset the selected items and navigate back to the fruits page
        selectedItems.clear();
        currentPage = PageType.fruits;
      }
    });
  }

  // Function to add selected items to the cart
  void addToCart(Item item) {
    setState(() {
      selectedItems.add(item);
    });
  }

  // Function to calculate the total price
  double calculateTotalPrice() {
    double total = 0.0;
    for (var item in selectedItems) {
      total += item.price;
    }
    return total;
  }

  // Function to place the order and show a success message
  void placeOrder() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Order Placed Successfully'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                nextPage(); // Navigate to the start page after placing the order
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            currentPage == PageType.start ? 'Grocery Cart' : 'Shopping Cart'),
        leading: currentPage == PageType.start
            ? null
            : IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: previousPage,
              ),
      ),
      body: getPageWidget(),
    );
  }

  // Function to get the appropriate widget for the current page
  Widget getPageWidget() {
    switch (currentPage) {
      case PageType.start:
        return buildStartPage();
      case PageType.vegetables:
        return buildVegetablesPage();
      case PageType.fruits:
        return buildFruitsPage();
      case PageType.bill:
        return buildBill();
      default:
        return Container(); // Handle unexpected case
    }
  }

  // Function to build the start page
  Widget buildStartPage() {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
              'https://img.freepik.com/free-vector/hand-drawn-doodle-icons-set_1308-86227.jpg?w=740&t=st=1703493414~exp=1703494014~hmac=3719eea056879a227ce43bbfd0ad6ec7711f057cbed9626c91f61c7bfeb2f4bf'),
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
        child: ElevatedButton(
          onPressed: () {
            setState(() {
              currentPage = PageType.vegetables;
            });
          },
          style: ElevatedButton.styleFrom(
            primary: Theme.of(context).colorScheme.primary, // Orange color
          ),
          child: Text('Start Shopping'),
        ),
      ),
    );
  }

  // Function to build the vegetables page with a table
  Widget buildVegetablesPage() {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vegetables'),
      ),
      body: Column(
        children: [
          Expanded(
            child: DataTable(
              columns: [
                DataColumn(label: Text('Select')),
                DataColumn(label: Text('Name')),
                DataColumn(label: Text('Price (Rs.)')),
              ],
              rows: vegetables.map((item) {
                return DataRow(
                  cells: [
                    DataCell(
                      Checkbox(
                        value: selectedItems.contains(item),
                        onChanged: (bool? value) {
                          if (value != null) {
                            setState(() {
                              value
                                  ? addToCart(item)
                                  : selectedItems.remove(item);
                            });
                          }
                        },
                      ),
                    ),
                    DataCell(Text(item.name)),
                    DataCell(Text('Rs. ${item.price.toStringAsFixed(2)}')),
                  ],
                );
              }).toList(),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    currentPage = PageType.start;
                  });
                },
                style: ElevatedButton.styleFrom(
                  primary:
                      Theme.of(context).colorScheme.primary, // Orange color
                ),
                child: Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: nextPage,
                style: ElevatedButton.styleFrom(
                  primary:
                      Theme.of(context).colorScheme.primary, // Orange color
                ),
                child: Text('Next'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Function to build the fruits page with a table
  Widget buildFruitsPage() {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fruits'),
      ),
      body: Column(
        children: [
          Expanded(
            child: DataTable(
              columns: [
                DataColumn(label: Text('Select')),
                DataColumn(label: Text('Name')),
                DataColumn(label: Text('Price (Rs.)')),
              ],
              rows: fruits.map((item) {
                return DataRow(
                  cells: [
                    DataCell(
                      Checkbox(
                        value: selectedItems.contains(item),
                        onChanged: (bool? value) {
                          if (value != null) {
                            setState(() {
                              value
                                  ? addToCart(item)
                                  : selectedItems.remove(item);
                            });
                          }
                        },
                      ),
                    ),
                    DataCell(Text(item.name)),
                    DataCell(Text('Rs. ${item.price.toStringAsFixed(2)}')),
                  ],
                );
              }).toList(),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    currentPage = PageType.start;
                  });
                },
                style: ElevatedButton.styleFrom(
                  primary:
                      Theme.of(context).colorScheme.primary, // Orange color
                ),
                child: Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: nextPage,
                style: ElevatedButton.styleFrom(
                  primary:
                      Theme.of(context).colorScheme.primary, // Orange color
                ),
                child: Text('Next'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Function to build the consolidated bill page
  Widget buildBill() {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bill'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Bill',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Container(
              width: double.infinity,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: selectedItems.length,
                itemBuilder: (context, index) {
                  var item = selectedItems[index];
                  return ListTile(
                    title: Text(item.name),
                    subtitle: Text('Rs. ${item.price.toStringAsFixed(2)}'),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Total: Rs. ${calculateTotalPrice().toStringAsFixed(2)}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: placeOrder,
              style: ElevatedButton.styleFrom(
                primary: Theme.of(context).colorScheme.primary, // Orange color
              ),
              child: Text('Place Order'),
            ),
          ],
        ),
      ),
    );
  }
}
