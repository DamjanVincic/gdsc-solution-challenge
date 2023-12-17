import 'package:flutter/material.dart';
import '../models/quote.dart';
import '../services/quote_service.dart';
import 'quote_details_screen.dart';

class QuoteListScreen extends StatefulWidget {
  final QuoteService quoteService;
  final Color primaryColor;
  final Color accentColor;

  const QuoteListScreen({
    Key? key,
    required this.quoteService,
    required this.primaryColor,
    required this.accentColor,
  }) : super(key: key);

  @override
  _QuoteListScreenState createState() => _QuoteListScreenState();
}

class _QuoteListScreenState extends State<QuoteListScreen> {
  late List<Quote> notifications;
  String selectedCategory = 'All'; // Default category is 'All'

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    // Fetch notifications asynchronously
    notifications = await widget.quoteService.fetchQuotes();
    // Call setState to rebuild the widget with the new data
    setState(() {});
  }

  List<String> getUniqueCategories() {
    // Get unique categories from the list of notifications
    Set<String> uniqueCategories =
        notifications.map((item) => item.category).toSet();
    return ['All', ...uniqueCategories.toList()];
  }

  List<Quote> getFilteredNotifications() {
    // Filter notifications based on the selected category
    if (selectedCategory == 'All') {
      return notifications;
    } else {
      return notifications
          .where((item) => item.category == selectedCategory)
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = widget.primaryColor; // Store primary color locally
    final Color accentColor = widget.accentColor;
    
    return Scaffold(
        appBar: AppBar(
          title: const Text('Quote List'),
          backgroundColor: primaryColor,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            // DropdownButton for selecting categories
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: accentColor),
                // Use accent color for the border
                borderRadius:
                    BorderRadius.circular(8.0), // Adjust the radius as needed
              ),
              child: DropdownButton<String>(
                value: selectedCategory,
                onChanged: (String? newValue) {
                  setState(() {
                    selectedCategory = newValue ?? 'All';
                  });
                },
                items: getUniqueCategories()
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            )
          ],
        ),
        body: Container(
          color: accentColor,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: notifications.isNotEmpty
                  ? ListView.builder(
                      itemCount: getFilteredNotifications().length,
                      itemBuilder: (context, index) {
                        final notificationItem =
                            getFilteredNotifications()[index];
                        return GestureDetector(
                          onTap: () {
                            // Navigate to QuoteDetailsScreen when an item is clicked
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => QuoteDetailsScreen(
                                  notificationItem: notificationItem,
                                  primaryColor: primaryColor,
                                  accentColor: accentColor,
                                ),
                              ),
                            );
                          },
                          child: Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Title: ${notificationItem.title}',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: accentColor,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Category: ${notificationItem.category}',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: accentColor,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'Details: ${notificationItem.details}',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: accentColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  : const Center(
                      child:
                          CircularProgressIndicator(), // Show a loading indicator while fetching data
                    ),
            ),
          ),
        ));
  }
}
