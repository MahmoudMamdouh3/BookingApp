import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'appBar.dart';
import 'results.dart';
import 'package:url_launcher/url_launcher.dart';
import 'questionsPage.dart';
import 'package:flutter_image_slideshow/flutter_image_slideshow.dart';
import 'inputBox.dart';

final Uri _url = Uri.parse(
    'https://www.tripadvisor.co.uk/Tourism-g294201-Cairo_Cairo_Governorate-Vacations.html');
final Uri _parisUrl = Uri.parse(
    'https://www.tripadvisor.co.uk/Tourism-g187147-Paris_Ile_de_France-Vacations.htmll');
final Uri _londonUrl = Uri.parse(
    'https://www.tripadvisor.co.uk/Tourism-g186338-London_England-Vacations.html');

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  homePageState createState() => homePageState();
}

class homePageState extends State<HomePage> {
  late final TextEditingController locationController;
  late final TextEditingController dateRangeController;
  late final TextEditingController budgetController;

  @override
  void initState() {
    super.initState();
    locationController = TextEditingController();
    dateRangeController = TextEditingController();
    budgetController = TextEditingController();
  }

  @override
  void dispose() {
    locationController.dispose();
    dateRangeController.dispose();
    budgetController.dispose();
    super.dispose();
  }

  final List<Widget> imageList = [
    GestureDetector(
      onTap: () => launchUrl(_url),
      child: Stack(
        children: [
          Image.asset('images/cairo.png', fit: BoxFit.cover),
          Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(234, 1, 92, 86),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: const Positioned(
              bottom: 155,
              left: 40,
              child: Text(
                'Cairo, Egypt',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontFamily: 'ProximaNova',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )
        ],
      ),
    ),
    GestureDetector(
      onTap: () => launchUrl(_londonUrl),
      child: Stack(
        children: [
          Image.asset(
            'images/london.png',
            fit: BoxFit.cover,
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: const Positioned(
              bottom: 55,
              left: 140,
              child: Text(
                'London, UK',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontFamily: 'ProximaNova',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    ),
    GestureDetector(
      onTap: () => launchUrl(_parisUrl),
      child: Stack(
        children: [
          Image.asset(
            'images/paris.png',
            fit: BoxFit.cover,
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: const Positioned(
              bottom: 55,
              left: 140,
              child: Text(
                'Paris, France',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontFamily: 'ProximaNova',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(),
        body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const InputBox(),
                    const SizedBox(height: 16.0),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: locationController,
                            decoration: const InputDecoration(
                              labelText: 'Your Preferred Destination',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: dateRangeController,
                            decoration: const InputDecoration(
                              labelText: 'Date',
                              border: OutlineInputBorder(),
                            ),
                            onTap: () async {
                              final picked = await showDateRangePicker(
                                context: context,
                                firstDate: DateTime.now(),
                                lastDate: DateTime.now()
                                    .add(const Duration(days: 365)),
                              );
                              if (picked != null) {
                                final startDate =
                                    DateFormat.yMd().format(picked.start);
                                final endDate =
                                    DateFormat.yMd().format(picked.end);
                                final dateRange = '$startDate - $endDate';
                                setState(() {
                                  dateRangeController.text = dateRange;
                                });
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 10.0),
                        Expanded(
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            controller: budgetController,
                            decoration: const InputDecoration(
                              labelText: 'Budget',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    Center(
                      child: Column(
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SearchResultsPage(
                                    location: locationController.text,
                                    dateRange: dateRangeController.text,
                                    budget: int.parse(budgetController.text),
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(255, 245, 129, 43),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                )),
                            child: const Text(
                              'Search',
                              style: TextStyle(
                                  fontSize: 18, fontFamily: 'ProximaNova'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16.0),
                    Column(
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const QuestionsPage()),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color.fromARGB(234, 1, 92, 86),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 48, vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                )),
                            child: const Text(
                              'Press here if you want us to recommend you a place?',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 18, fontFamily: 'ProximaNova'),
                            )),
                      ],
                    ),
                    const SizedBox(height: 26.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.whatshot),
                        SizedBox(width: 8.0),
                        Text(
                          'Check Our Popular Destinations',
                          style: TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    ImageSlideshow(
                      width: double.infinity,
                      height: 270,
                      initialPage: 0,
                      indicatorColor: Colors.blue,
                      indicatorBackgroundColor: Colors.grey,
                      onPageChanged: (value) {
                        print('Page changed: $value');
                      },
                      autoPlayInterval: 6000,
                      isLoop: true,
                      children: imageList,
                    ),
                  ],
                ),
              ),
            )));
  }
}
