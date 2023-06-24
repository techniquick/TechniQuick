import 'package:flutter/material.dart';

class JobSelectionWidget extends StatefulWidget {
  const JobSelectionWidget({super.key});

  @override
  _JobSelectionWidgetState createState() => _JobSelectionWidgetState();
}

class _JobSelectionWidgetState extends State<JobSelectionWidget> {
  String? selectedJob;
  List<String> selectedProfessions = [];

  final List<String> jobList = [
    "plumbing",
    "carpentry",
    "painting",
    "electrical",
    "metalwork",
    "drywall",
    "plastering",
    "nursing",
    "ceramics",
    "shower",
    "air_conditioning"
  ];

  final Map<String, List<String>> professionList = {
    "plumbing": ["pipefitter", "plumber", "draincleaner"],
    "carpentry": ["cabinetmaker", "trimcarpenter", "furnituremaker"],
    "painting": ["housepainter", "commercialpainter", "industrialpainter"],
    "electrical": ["electrician", "electricalengineer", "powerlineman"],
    "metalwork": ["blacksmith", "metalfabricator", "sheetmetalworker"],
    "drywall": ["drywaller", "taper", "plasterer"],
    "plastering": ["plasterer", "stuccomason", "ornamentalplasterer"],
    "nursing": [
      "registerednurse",
      "licensedpracticalnurse",
      "nursepractitioner"
    ],
    "ceramics": ["ceramicartist", "tilesetter", "glazespecialist"],
    "shower": ["showerinstaller", "showerrepairspecialist", "showerdesigner"],
    "air_conditioning": [
      "HVACtechnician",
      "refrigerationmechanic",
      "ductworkinstaller"
    ],
  };

  void _onJobSelected(String value) {
    setState(() {
      selectedJob = value;
      selectedProfessions.clear();
    });
  }

  void _onProfessionSelected(bool value, String profession) {
    setState(() {
      if (value) {
        selectedProfessions.add(profession);
      } else {
        selectedProfessions.remove(profession);
      }
    });
  }

  void _onSubmit() {
    List<String> professions = professionList[selectedJob]!;
    List<String> selectedProfessionNames = [];
    for (String profession in selectedProfessions) {
      if (professions.contains(profession)) {
        selectedProfessionNames.add(profession);
      }
    }
    if (selectedJob != null) {
      Job selectedJobObject = Job(selectedJob!, selectedProfessionNames);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Job Selection"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField(
              isExpanded: true,
              value: selectedJob,
              onChanged: (v) => _onJobSelected(v!),
              items: jobList.map((job) {
                return DropdownMenuItem(
                  value: job,
                  child: Text(job),
                );
              }).toList(),
              decoration: const InputDecoration(
                labelText: "Select a job",
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 16.0),
            const Text("Select professions:", style: TextStyle(fontSize: 16)),
            const SizedBox(height: 16.0),
            selectedJob != null
                ? Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      children: professionList[selectedJob]!.map((profession) {
                        return GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.4,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Text(profession,
                                            style: const TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.bold)),
                                      ),
                                      Expanded(
                                        child: SingleChildScrollView(
                                          child: Column(
                                            children: professionList[
                                                    selectedJob]!
                                                .map((subProfession) =>
                                                    CheckboxListTile(
                                                      value: selectedProfessions
                                                          .contains(
                                                              subProfession),
                                                      onChanged: (bool? value) {
                                                        _onProfessionSelected(
                                                            value!,
                                                            subProfession);
                                                      },
                                                      title:
                                                          Text(subProfession),
                                                    ))
                                                .toList(),
                                          ),
                                        ),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text("Done"),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                          child: Center(
                            child: Text(
                              profession,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}

class Job {
  String name;
  List<String> professions;

  Job(this.name, this.professions);
}
