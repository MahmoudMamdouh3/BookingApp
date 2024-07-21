import 'package:flutter/material.dart';
import 'appBar.dart';
import 'results.dart';

class QuestionsPage extends StatefulWidget {
  const QuestionsPage({Key? key}) : super(key: key);

  @override
  _QuestionPageState createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionsPage> {
  List<String> selectedOptions = ['', ''];

  final List<List<String>> options = [
    ['Hot Weather', 'Cold Weather', 'Tropical Weather'],
    ['Shopping', 'Sightseeing', 'Relaxation']
  ];
  final budgetInputController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

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
                const Text(
                  'What is your preferred weather?',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: options[0]
                      .asMap()
                      .entries
                      .map(
                        (entry) => RadioListTile(
                          title: Text(entry.value),
                          value: entry.value,
                          groupValue: selectedOptions[0],
                          onChanged: (value) {
                            setState(() {
                              selectedOptions[0] = value.toString();
                            });
                          },
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 16.0),
                const Text(
                  'What is your main target of this visit?',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: options[1]
                      .asMap()
                      .entries
                      .map(
                        (entry) => RadioListTile(
                          title: Text(entry.value),
                          value: entry.value,
                          groupValue: selectedOptions[1],
                          onChanged: (value) {
                            setState(() {
                              selectedOptions[1] = value.toString();
                            });
                          },
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 16.0),
                const Text(
                  'How much budget are you planning for?',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: budgetInputController,
                  decoration: const InputDecoration(
                    labelText: 'Enter in Dollars',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16.0),
                Center(
                  child: ElevatedButton(
                    onPressed: selectedOptions.contains('')
                        ? null
                        : () {
                            String location = '';
                            if (selectedOptions[0] == 'Hot Weather' &&
                                selectedOptions[1] == 'Shopping') {
                              location = 'Dubai';
                            } else if (selectedOptions[0] == 'Hot Weather' &&
                                selectedOptions[1] == 'Sightseeing') {
                              location = 'Cairo';
                            } else if (selectedOptions[0] == 'Hot Weather' &&
                                selectedOptions[1] == 'Relaxation') {
                              location = 'New York';
                            } else if (selectedOptions[0] == 'Cold Weather' &&
                                selectedOptions[1] == 'Shopping') {
                              location = 'Paris';
                            } else if (selectedOptions[0] == 'Cold Weather' &&
                                selectedOptions[1] == 'Sightseeing') {
                              location = 'London';
                            } else if (selectedOptions[0] == 'Cold Weather' &&
                                selectedOptions[1] == 'Relaxation') {
                              location = 'Copenhagen';
                            } else if (selectedOptions[0] ==
                                    'Tropical Weather' &&
                                selectedOptions[1] == 'Shopping') {
                              location = 'Bangok';
                            } else {
                              location = '';
                            }
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SearchResultsPage(
                                  location: location,
                                  budget: int.parse(budgetInputController.text),
                                  dateRange: '',
                                ),
                              ),
                            );
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(234, 1, 92, 86),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 16),
                      textStyle: const TextStyle(fontSize: 18),
                    ),
                    child: const Text('Submit'),
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
