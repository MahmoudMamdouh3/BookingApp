import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobile_app_travistax/appBar.dart';
import 'hotels.dart';
import 'weather.dart';

class Hotel {
  late final String place;
  late final String destination;

  Hotel({required this.place, required this.destination});
}

class SearchResultsPage extends StatelessWidget {
  final String location;
  final String dateRange;
  final num budget;

  const SearchResultsPage(
      {Key? key,
      required this.budget,
      required this.location,
      required this.dateRange})
      : super(key: key);

  get place => null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16.0),
              Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    size: 24.0,
                  ),
                  const SizedBox(width: 8.0),
                  Text(
                    location,
                    style: const TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today,
                    size: 24.0,
                  ),
                  const SizedBox(width: 8.0),
                  const Text(
                    'Selected Dates:',
                    style: TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  Text(
                    ' $dateRange',
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              FutureBuilder<double>(
                future: getLocationTemperature(location),
                builder:
                    (BuildContext context, AsyncSnapshot<double> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  final tempC = snapshot.data;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8.0),
                      const Text(
                        'Current temperature:',
                        style: TextStyle(
                            fontSize: 18.0, fontFamily: 'ProximaNova'),
                      ),
                      const SizedBox(height: 3.0),
                      Row(
                        children: [
                          const Icon(
                            Icons.thermostat_rounded,
                            size: 24.0,
                          ),
                          const SizedBox(width: 8.0),
                          Text(
                            '${tempC!.toStringAsFixed(1)}°C',
                            style: const TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 24.0),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('packages')
                    .where('destination', isEqualTo: location)
                    .where('total', isLessThanOrEqualTo: budget)
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text(
                          'No packages found for $location within budget.'),
                    );
                  }
                  List<Map<String, dynamic>> hotelList = snapshot.data!.docs
                      .map((DocumentSnapshot document) =>
                          document.data()! as Map<String, dynamic>)
                      .toList();
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: hotelList
                          .map((singleHotel) => HotelScreen(hotel: singleHotel))
                          .toList(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
