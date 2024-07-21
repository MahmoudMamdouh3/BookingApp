import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart';

class Airport {
  final String name;
  final String iata;

  Airport({required this.name, required this.iata});
}

final List<Airport> airports = [
  Airport(name: 'Cairo International Airport', iata: 'CAI'),
  Airport(name: 'John F. Kennedy International Airport', iata: 'JFK'),
  Airport(name: 'Los Angeles International Airport', iata: 'LAX'),
  Airport(name: 'Beijing Capital International Airport', iata: 'PEK'),
  Airport(name: 'Tokyo Haneda International Airport', iata: 'HND'),
  Airport(name: 'Dubai International Airport', iata: 'DXB'),
  Airport(name: 'Istanbul Airport', iata: 'IST'),
  Airport(name: 'Singapore Changi Airport', iata: 'SIN'),
  Airport(name: 'Seoul Incheon International Airport', iata: 'ICN'),
  Airport(name: 'Hong Kong International Airport', iata: 'HKG'),
  Airport(name: 'Bangkok Suvarnabhumi Airport', iata: 'BKK'),
  Airport(name: 'Sydney Kingsford-Smith Airport', iata: 'SYD'),
  Airport(name: 'Toronto Pearson International Airport', iata: 'YYZ'),
  Airport(name: 'Rome Fiumicino Airport', iata: 'FCO'),
  Airport(name: 'Munich Airport', iata: 'MUC'),
  Airport(name: 'Madrid Barajas Airport', iata: 'MAD'),
  Airport(name: 'Copenhagen Airport', iata: 'CPH'),
  Airport(name: 'Zurich Airport', iata: 'ZRH'),
  Airport(name: 'Vienna International Airport', iata: 'VIE'),
  Airport(name: 'Dublin Airport', iata: 'DUB'),
  Airport(name: 'Oslo Gardermoen Airport', iata: 'OSL'),
  Airport(name: 'Stockholm Arlanda Airport', iata: 'ARN'),
  Airport(name: 'Helsinki Airport', iata: 'HEL'),
  Airport(name: 'Brussels Airport', iata: 'BRU'),
  Airport(name: 'Athens International Airport', iata: 'ATH'),
  Airport(name: 'Lisbon Portela Airport', iata: 'LIS'),
  Airport(name: 'Warsaw Chopin Airport', iata: 'WAW'),
  Airport(name: 'Budapest Ferenc Liszt International Airport', iata: 'BUD'),
  Airport(name: 'Moscow Sheremetyevo International Airport', iata: 'SVO'),
  Airport(name: 'Kiev Boryspil International Airport', iata: 'KBP'),
  Airport(name: 'Bucharest Henri Coanda International Airport', iata: 'OTP'),
  Airport(name: 'Prague Václav Havel Airport', iata: 'PRG'),
  Airport(name: 'Amsterdam Airport Schiphol', iata: 'AMS'),
];

class InputBox extends StatefulWidget {
  const InputBox({Key? key}) : super(key: key);

  @override
  InputBoxState createState() => InputBoxState();
}

class InputBoxState extends State<InputBox> {
  final TextEditingController controller = TextEditingController();
  stt.SpeechToText? speech;
  bool isListening = false;
  String transcription = '';
  Airport? selectedAirport;
  List<Airport> filteredAirports = [];
  String error = '';

  @override
  void initState() {
    super.initState();
    speech = stt.SpeechToText();
  }

  void startListening() async {
    if (!isListening) {
      final PermissionStatus status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        throw Exception('Microphone permission not granted');
      }
      bool available = await speech?.initialize() ?? false;
      if (available) {
        setState(() => isListening = true);
        speech?.listen(
          onResult: (result) {
            setState(() {
              transcription = result.recognizedWords;
              controller.text = transcription;
            });
          },
          listenMode: ListenMode.confirmation,
        );
      } else {
        setState(() {
          isListening = false;
          error = "Speech recognition unavailable";
        });
      }
    }
  }

  void stopListening() {
    if (isListening) {
      speech?.stop();
      setState(() => isListening = false);
    }
  }

  Future<List<Airport>> _fetchAirports(String pattern) async {
    await Future.delayed(const Duration(milliseconds: 300));
    List<Airport> matchedAirports = [];
    for (var airport in airports) {
      if (airport.name.toLowerCase().contains(pattern.toLowerCase()) ||
          airport.iata.toLowerCase().contains(pattern.toLowerCase())) {
        matchedAirports.add(airport);
      }
    }
    return matchedAirports;
  }

  void _onChanged(String value) {
    setState(() {
      selectedAirport = null;
      if (value.isNotEmpty) {
        filteredAirports = airports
            .where((airport) =>
                airport.name.toLowerCase().contains(value.toLowerCase()) ||
                airport.iata.toLowerCase().contains(value.toLowerCase()))
            .toList();
      } else {
        filteredAirports.clear();
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    speech!.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool showList = false;
    return Column(
      children: [
        TypeAheadField<Airport>(
          textFieldConfiguration: TextFieldConfiguration(
            controller: controller,
            onChanged: (value) => _onChanged(value),
            decoration: InputDecoration(
              hintText: 'Enter text',
              suffixIcon: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: startListening,
                    icon: const Icon(Icons.mic),
                    color: isListening ? Colors.red : Colors.grey,
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        controller.clear();
                        selectedAirport = null;
                        showList = false;
                      });
                    },
                    icon: const Icon(Icons.clear),
                  ),
                ],
              ),
            ),
          ),
          suggestionsCallback: (pattern) async {
            return await _fetchAirports(pattern);
          },
          itemBuilder: (context, Airport suggestion) {
            return ListTile(
              title: Text(suggestion.name),
              subtitle: Text(suggestion.iata),
            );
          },
          onSuggestionSelected: (Airport suggestion) {
            setState(() {
              controller.text = suggestion.iata;
              selectedAirport = suggestion;
            });
          },
        ),
        const SizedBox(height: 16.0),
        Visibility(
          visible: selectedAirport != null,
          child: Text(
              'Your Departure airport: ${selectedAirport?.name} (${selectedAirport?.iata})'),
        ),
        Visibility(
          visible: selectedAirport == null,
          child: const Text('No airport selected'),
        ),
        const SizedBox(height: 16.0),
        showList
            ? SizedBox(
                height: 200.0,
                child: ListView.builder(
                  itemCount: filteredAirports.length,
                  itemBuilder: (BuildContext context, int index) {
                    final Airport airport = filteredAirports[index];
                    return ListTile(
                      title: Text(airport.name),
                      subtitle: Text(airport.iata),
                      onTap: () {
                        setState(() {
                          controller.text = airport.iata;
                          selectedAirport = airport;
                          showList = false;
                        });
                      },
                    );
                  },
                ),
              )
            : Container(),
      ],
    );
  }
}
