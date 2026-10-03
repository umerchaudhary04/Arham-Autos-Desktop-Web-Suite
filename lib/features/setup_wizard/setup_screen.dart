import 'package:flutter/material.dart';

class SetupWizardScreen extends StatefulWidget {
  const SetupWizardScreen({super.key});

  @override
  State<SetupWizardScreen> createState() => _SetupWizardScreenState();
}

class _SetupWizardScreenState extends State<SetupWizardScreen> {
  int _currentStep = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Setup Wizard')),
      body: Stepper(
        currentStep: _currentStep,
        onStepContinue: () {
          if (_currentStep < 3) {
            setState(() => _currentStep += 1);
          } else {
            // Finish setup
          }
        },
        onStepCancel: () {
          if (_currentStep > 0) {
            setState(() => _currentStep -= 1);
          }
        },
        steps: const [
          Step(
            title: Text('Language Selection'),
            content: Text('Select English or Urdu'),
          ),
          Step(
            title: Text('Backup Location'),
            content: Text('Select directory for backups'),
          ),
          Step(
            title: Text('Master Key'),
            content: Text('Save or Print the Master Key'),
          ),
          Step(
            title: Text('Manager Account'),
            content: Text('Create the initial Manager account'),
          ),
        ],
      ),
    );
  }
}
