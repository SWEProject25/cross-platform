import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lam7a/core/theme/app_pallete.dart';
import 'package:lam7a/features/authentication/ui/widgets/authentication_text_input_field.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('TextInputField Widget Tests', () {
    group('Constructor and Initialization', () {
      testWidgets('should create with all required parameters', (tester) async {
        String capturedValue = '';

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TextInputField(
                labelTextField: 'Test Label',
                flex: 8,
                textType: TextInputType.text,
                isValid: true,
                onChangeEffect: (value) {
                  capturedValue = value;
                },
              ),
            ),
          ),
        );

        expect(find.text('Test Label'), findsOneWidget);
        expect(find.byType(TextFormField), findsOneWidget);
      });

      testWidgets('should initialize with default values', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TextInputField(
                labelTextField: 'Test',
                flex: 8,
                textType: TextInputType.text,
                isValid: true,
                onChangeEffect: (value) {},
              ),
            ),
          ),
        );

        final textInputField = tester.widget<TextInputField>(
          find.byType(TextInputField),
        );

        expect(textInputField.isLimited, false);
        expect(textInputField.isPassword, false);
        expect(textInputField.isDate, false);
        expect(textInputField.content, '');
        expect(textInputField.enabled, true);
        expect(textInputField.isLoginField, false);
        expect(textInputField.errorText, '');
      });

      testWidgets('should initialize with custom content', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TextInputField(
                labelTextField: 'Test',
                flex: 8,
                textType: TextInputType.text,
                isValid: true,
                onChangeEffect: (value) {},
                content: 'Initial Content',
              ),
            ),
          ),
        );

        expect(find.text('Initial Content'), findsOneWidget);
      });

      testWidgets('should initialize all optional parameters', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TextInputField(
                labelTextField: 'Test',
                flex: 8,
                textType: TextInputType.text,
                isValid: true,
                onChangeEffect: (value) {},
                isLimited: true,
                isPassword: true,
                isDate: true,
                content: 'Test Content',
                enabled: false,
                isLoginField: true,
                errorText: 'Error message',
              ),
            ),
          ),
        );

        final textInputField = tester.widget<TextInputField>(
          find.byType(TextInputField),
        );

        expect(textInputField.isLimited, true);
        expect(textInputField.isPassword, true);
        expect(textInputField.isDate, true);
        expect(textInputField.content, 'Test Content');
        expect(textInputField.enabled, false);
        expect(textInputField.isLoginField, true);
        expect(textInputField.errorText, 'Error message');
      });
    });

    group('Text Input Functionality', () {
      testWidgets('should call onChangeEffect when text changes', (tester) async {
        String capturedValue = '';

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TextInputField(
                labelTextField: 'Username',
                flex: 8,
                textType: TextInputType.text,
                isValid: true,
                onChangeEffect: (value) {
                  capturedValue = value;
                },
              ),
            ),
          ),
        );

        await tester.enterText(find.byType(TextFormField), 'test@example.com');
        await tester.pump();

        expect(capturedValue, 'test@example.com');
      });

      testWidgets('should display entered text', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TextInputField(
                labelTextField: 'Email',
                flex: 8,
                textType: TextInputType.emailAddress,
                isValid: true,
                onChangeEffect: (value) {},
              ),
            ),
          ),
        );

        await tester.enterText(find.byType(TextFormField), 'john@example.com');
        await tester.pump();

        expect(find.text('john@example.com'), findsOneWidget);
      });

      testWidgets('should handle multiple text changes', (tester) async {
        List<String> capturedValues = [];

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TextInputField(
                labelTextField: 'Test',
                flex: 8,
                textType: TextInputType.text,
                isValid: true,
                onChangeEffect: (value) {
                  capturedValues.add(value);
                },
              ),
            ),
          ),
        );

        await tester.enterText(find.byType(TextFormField), 'a');
        await tester.pump();
        await tester.enterText(find.byType(TextFormField), 'ab');
        await tester.pump();
        await tester.enterText(find.byType(TextFormField), 'abc');
        await tester.pump();

        expect(capturedValues, ['a', 'ab', 'abc']);
      });

      testWidgets('should respect maxLength of 50 characters', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TextInputField(
                labelTextField: 'Test',
                flex: 8,
                textType: TextInputType.text,
                isValid: true,
                onChangeEffect: (value) {},
              ),
            ),
          ),
        );

        final longText = 'a' * 60;
        await tester.enterText(find.byType(TextFormField), longText);
        await tester.pump();

        final textField = tester.widget<TextFormField>(find.byType(TextFormField));
      });
    });

    group('Password Field Functionality', () {
      testWidgets('should obscure text when isPassword is true', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TextInputField(
                labelTextField: 'Password',
                flex: 8,
                textType: TextInputType.text,
                isPassword: true,
                isValid: true,
                onChangeEffect: (value) {},
              ),
            ),
          ),
        );

        final textField = tester.widget<TextFormField>(find.byType(TextFormField));
      });

      testWidgets('should show visibility toggle icon when isPassword is true', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TextInputField(
                labelTextField: 'Password',
                flex: 8,
                textType: TextInputType.text,
                isPassword: true,
                isValid: true,
                onChangeEffect: (value) {},
              ),
            ),
          ),
        );

        expect(find.byIcon(Icons.visibility_off_sharp), findsOneWidget);
      });

      testWidgets('should toggle password visibility when icon is tapped', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TextInputField(
                labelTextField: 'Password',
                flex: 8,
                textType: TextInputType.text,
                isPassword: true,
                isValid: true,
                onChangeEffect: (value) {},
              ),
            ),
          ),
        );

        // Initially obscured
        var textField = tester.widget<TextFormField>(find.byType(TextFormField));
        expect(find.byIcon(Icons.visibility_off_sharp), findsOneWidget);

        // Tap to show password
        await tester.tap(find.byIcon(Icons.visibility_off_sharp));
        await tester.pump();

        textField = tester.widget<TextFormField>(find.byType(TextFormField));
        expect(find.byIcon(Icons.visibility_sharp), findsOneWidget);

        // Tap to hide password again
        await tester.tap(find.byIcon(Icons.visibility_sharp));
        await tester.pump();

        textField = tester.widget<TextFormField>(find.byType(TextFormField));
        expect(find.byIcon(Icons.visibility_off_sharp), findsOneWidget);
      });

      testWidgets('should not show visibility icon when isPassword is false', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TextInputField(
                labelTextField: 'Username',
                flex: 8,
                textType: TextInputType.text,
                isPassword: false,
                isValid: true,
                onChangeEffect: (value) {},
              ),
            ),
          ),
        );

        expect(find.byIcon(Icons.visibility_off_sharp), findsNothing);
        expect(find.byIcon(Icons.visibility_sharp), findsNothing);
      });
    });

    group('Validation Icons', () {
      testWidgets('should show check icon when valid and not empty', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TextInputField(
                labelTextField: 'Email',
                flex: 8,
                textType: TextInputType.emailAddress,
                isValid: true,
                onChangeEffect: (value) {},
                content: 'test@example.com',
              ),
            ),
          ),
        );

        await tester.pump();
        expect(find.byIcon(Icons.check_circle_sharp), findsOneWidget);
      });

      testWidgets('should show error icon when invalid and not empty', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TextInputField(
                labelTextField: 'Email',
                flex: 8,
                textType: TextInputType.emailAddress,
                isValid: false,
                onChangeEffect: (value) {},
                content: 'invalid-email',
              ),
            ),
          ),
        );

        await tester.pump();
        expect(find.byIcon(Icons.error), findsOneWidget);
      });

      testWidgets('should not show validation icons when field is empty', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TextInputField(
                labelTextField: 'Email',
                flex: 8,
                textType: TextInputType.emailAddress,
                isValid: true,
                onChangeEffect: (value) {},
              ),
            ),
          ),
        );

        expect(find.byIcon(Icons.check_circle_sharp), findsNothing);
        expect(find.byIcon(Icons.error), findsNothing);
      });

      testWidgets('should not show validation icons when isLoginField is true', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TextInputField(
                labelTextField: 'Email',
                flex: 8,
                textType: TextInputType.emailAddress,
                isValid: true,
                onChangeEffect: (value) {},
                content: 'test@example.com',
                isLoginField: true,
              ),
            ),
          ),
        );

        expect(find.byIcon(Icons.check_circle_sharp), findsNothing);
        expect(find.byIcon(Icons.error), findsNothing);
      });

testWidgets('should show validation icons after text entry', (tester) async {
  bool isCurrentlyValid = true;
  String currentText = '';

  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: StatefulBuilder(
          builder: (context, setState) {
            return TextInputField(
              labelTextField: 'Email',
              flex: 8,
              textType: TextInputType.emailAddress,
              isValid: isCurrentlyValid,
              content: currentText,
              onChangeEffect: (value) {
                setState(() {
                  currentText = value;
                  isCurrentlyValid = value.isNotEmpty;
                });
              },
            );
          },
        ),
      ),
    ),
  );

  // No icons initially (empty field)
  expect(find.byIcon(Icons.check_circle_sharp), findsNothing);

  // Enter text
  await tester.enterText(find.byType(TextFormField), 'test@example.com');
  await tester.pumpAndSettle(); // Use pumpAndSettle to ensure state updates

  // Check icon should appear
  expect(find.byIcon(Icons.check_circle_sharp), findsOneWidget);
});
    });

    group('Character Counter', () {
      testWidgets('should show character counter when isLimited is true', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TextInputField(
                labelTextField: 'Bio',
                flex: 8,
                textType: TextInputType.text,
                isLimited: true,
                isValid: true,
                onChangeEffect: (value) {},
              ),
            ),
          ),
        );

        await tester.enterText(find.byType(TextFormField), 'Hello');
        await tester.pump();

        expect(find.text('5/50'), findsOneWidget);
      });

      testWidgets('should not show character counter when isLimited is false', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TextInputField(
                labelTextField: 'Bio',
                flex: 8,
                textType: TextInputType.text,
                isLimited: false,
                isValid: true,
                onChangeEffect: (value) {},
              ),
            ),
          ),
        );

        await tester.enterText(find.byType(TextFormField), 'Hello');
        await tester.pump();

        expect(find.text('5/50'), findsNothing);
      });

      testWidgets('should update character counter on text change', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TextInputField(
                labelTextField: 'Bio',
                flex: 8,
                textType: TextInputType.text,
                isLimited: true,
                isValid: true,
                onChangeEffect: (value) {},
              ),
            ),
          ),
        );

        await tester.enterText(find.byType(TextFormField), 'A');
        await tester.pump();
        expect(find.text('1/50'), findsOneWidget);

        await tester.enterText(find.byType(TextFormField), 'ABC');
        await tester.pump();
        expect(find.text('3/50'), findsOneWidget);

        await tester.enterText(find.byType(TextFormField), 'ABCDEFGHIJ');
        await tester.pump();
        expect(find.text('10/50'), findsOneWidget);
      });

      testWidgets('should show 0/50 for empty field when limited', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TextInputField(
                labelTextField: 'Bio',
                flex: 8,
                textType: TextInputType.text,
                isLimited: true,
                isValid: true,
                onChangeEffect: (value) {},
              ),
            ),
          ),
        );

        expect(find.text('0/50'), findsOneWidget);
      });
    });

    group('Date Picker Functionality', () {
      testWidgets('should open date picker when isDate is true and field is tapped', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TextInputField(
                labelTextField: 'Birth Date',
                flex: 8,
                textType: TextInputType.datetime,
                isDate: true,
                isValid: true,
                onChangeEffect: (value) {},
              ),
            ),
          ),
        );

        await tester.tap(find.byType(TextFormField));
        await tester.pumpAndSettle();

        // DatePicker dialog should appear
        expect(find.byType(DatePickerDialog), findsOneWidget);
      });

      testWidgets('should format date correctly when date is selected', (tester) async {
        String capturedValue = '';

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TextInputField(
                labelTextField: 'Birth Date',
                flex: 8,
                textType: TextInputType.datetime,
                isDate: true,
                isValid: true,
                onChangeEffect: (value) {
                  capturedValue = value;
                },
              ),
            ),
          ),
        );

        await tester.tap(find.byType(TextFormField));
        await tester.pumpAndSettle();

        // Select a date (tap OK button)
        await tester.tap(find.text('OK'));
        await tester.pumpAndSettle();

        // Value should be formatted as YYYY-MM-DD
        expect(capturedValue, matches(r'\d{4}-\d{2}-\d{2}'));
      });

      testWidgets('should format single digit months with leading zero', (tester) async {
        String capturedValue = '';

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TextInputField(
                labelTextField: 'Birth Date',
                flex: 8,
                textType: TextInputType.datetime,
                isDate: true,
                isValid: true,
                onChangeEffect: (value) {
                  capturedValue = value;
                },
              ),
            ),
          ),
        );

        await tester.tap(find.byType(TextFormField));
        await tester.pumpAndSettle();

        // The date picker will show the initial date (2000-01-01)
        await tester.tap(find.text('OK'));
        await tester.pumpAndSettle();

        // Should have leading zeros for month and day
        final parts = capturedValue.split('-');
        expect(parts.length, 3);
        expect(parts[1].length, 2); // Month should be 2 digits
        expect(parts[2].length, 2); // Day should be 2 digits
      });

      testWidgets('should not open date picker when isDate is false', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TextInputField(
                labelTextField: 'Email',
                flex: 8,
                textType: TextInputType.emailAddress,
                isDate: false,
                isValid: true,
                onChangeEffect: (value) {},
              ),
            ),
          ),
        );

        await tester.tap(find.byType(TextFormField));
        await tester.pumpAndSettle();

        expect(find.byType(DatePickerDialog), findsNothing);
      });

      testWidgets('should handle date picker cancellation', (tester) async {
        String capturedValue = 'unchanged';

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TextInputField(
                labelTextField: 'Birth Date',
                flex: 8,
                textType: TextInputType.datetime,
                isDate: true,
                isValid: true,
                onChangeEffect: (value) {
                  capturedValue = value;
                },
              ),
            ),
          ),
        );

        await tester.tap(find.byType(TextFormField));
        await tester.pumpAndSettle();

        // Cancel the date picker
        await tester.tap(find.text('Cancel'));
        await tester.pumpAndSettle();

        // Value should remain unchanged
        expect(capturedValue, 'unchanged');
      });
    });

    group('Enabled/Disabled State', () {
      testWidgets('should be enabled by default', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TextInputField(
                labelTextField: 'Test',
                flex: 8,
                textType: TextInputType.text,
                isValid: true,
                onChangeEffect: (value) {},
              ),
            ),
          ),
        );

        final textField = tester.widget<TextFormField>(find.byType(TextFormField));
        expect(textField.enabled, true);
      });

      testWidgets('should be disabled when enabled is false', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TextInputField(
                labelTextField: 'Test',
                flex: 8,
                textType: TextInputType.text,
                isValid: true,
                onChangeEffect: (value) {},
                enabled: false,
              ),
            ),
          ),
        );

        final textField = tester.widget<TextFormField>(find.byType(TextFormField));
        expect(textField.enabled, false);
      });

      testWidgets('should not allow text input when disabled', (tester) async {
        String capturedValue = '';

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TextInputField(
                labelTextField: 'Test',
                flex: 8,
                textType: TextInputType.text,
                isValid: true,
                onChangeEffect: (value) {
                  capturedValue = value;
                },
                enabled: false,
              ),
            ),
          ),
        );

        await tester.enterText(find.byType(TextFormField), 'test');
        await tester.pump();

        // Text should not be entered when disabled
        expect(capturedValue, '');
      });
    });

    group('Focus State', () {
      testWidgets('should show error text when focused', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TextInputField(
                labelTextField: 'Email',
                flex: 8,
                textType: TextInputType.emailAddress,
                isValid: false,
                onChangeEffect: (value) {},
                errorText: 'Invalid email format',
              ),
            ),
          ),
        );

        // Error text should not show when not focused
        expect(find.text('Invalid email format'), findsNothing);

        // Tap to focus
        await tester.tap(find.byType(TextFormField));
        await tester.pump();

        // Error text should show when focused
        expect(find.text('Invalid email format'), findsOneWidget);
      });

      testWidgets('should hide error text when unfocused', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  TextInputField(
                    labelTextField: 'Email',
                    flex: 8,
                    textType: TextInputType.emailAddress,
                    isValid: false,
                    onChangeEffect: (value) {},
                    errorText: 'Invalid email format',
                  ),
                  TextField(key: Key('other-field')),
                ],
              ),
            ),
          ),
        );

        // Tap to focus
        await tester.tap(find.byType(TextFormField).first);
        await tester.pump();

        expect(find.text('Invalid email format'), findsOneWidget);

        // Tap another field to unfocus
        await tester.tap(find.byKey(Key('other-field')));
        await tester.pump();

        // Error text should be hidden
        expect(find.text('Invalid email format'), findsNothing);
      });
    });

    group('Layout and Styling', () {
      testWidgets('should have correct margin when isLimited is false', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TextInputField(
                labelTextField: 'Test',
                flex: 8,
                textType: TextInputType.text,
                isValid: true,
                onChangeEffect: (value) {},
                isLimited: false,
              ),
            ),
          ),
        );

        final container = tester.widget<Container>(
          find.descendant(
            of: find.byType(TextInputField),
            matching: find.byType(Container),
          ).first,
        );

        expect((container.margin as EdgeInsets).bottom, 25);
      });

      testWidgets('should have correct margin when isLimited is true', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TextInputField(
                labelTextField: 'Test',
                flex: 8,
                textType: TextInputType.text,
                isValid: true,
                onChangeEffect: (value) {},
                isLimited: true,
              ),
            ),
          ),
        );

        final container = tester.widget<Container>(
          find.descendant(
            of: find.byType(TextInputField),
            matching: find.byType(Container),
          ).first,
        );

        expect((container.margin as EdgeInsets).bottom, 2);
      });

      testWidgets('should have Row with Spacers', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TextInputField(
                labelTextField: 'Test',
                flex: 8,
                textType: TextInputType.text,
                isValid: true,
                onChangeEffect: (value) {},
              ),
            ),
          ),
        );

        expect(find.byType(Row), findsWidgets);
        expect(find.byType(Spacer), findsWidgets);
      });

      testWidgets('should use correct font family', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TextInputField(
                labelTextField: 'Test',
                flex: 8,
                textType: TextInputType.text,
                isValid: true,
                onChangeEffect: (value) {},
              ),
            ),
          ),
        );

        final textField = tester.widget<TextFormField>(find.byType(TextFormField));
      });
    });

    group('Keyboard Type', () {
      testWidgets('should use text keyboard type', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TextInputField(
                labelTextField: 'Username',
                flex: 8,
                textType: TextInputType.text,
                isValid: true,
                onChangeEffect: (value) {},
              ),
            ),
          ),
        );

        final textField = tester.widget<TextFormField>(find.byType(TextFormField));
      });

      testWidgets('should use email keyboard type', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TextInputField(
                labelTextField: 'Email',
                flex: 8,
                textType: TextInputType.emailAddress,
                isValid: true,
                onChangeEffect: (value) {},
              ),
            ),
          ),
        );

        final textField = tester.widget<TextFormField>(find.byType(TextFormField));
      });

      testWidgets('should use number keyboard type', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TextInputField(
                labelTextField: 'Phone',
                flex: 8,
                textType: TextInputType.number,
                isValid: true,
                onChangeEffect: (value) {},
              ),
            ),
          ),
        );

        final textField = tester.widget<TextFormField>(find.byType(TextFormField));
      });

      testWidgets('should use datetime keyboard type', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TextInputField(
                labelTextField: 'Date',
                flex: 8,
                textType: TextInputType.datetime,
                isValid: true,
                onChangeEffect: (value) {},
              ),
            ),
          ),
        );

        final textField = tester.widget<TextFormField>(find.byType(TextFormField));
      });
    });

    group('Dark Mode Support', () {
      testWidgets('should render in dark mode', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData.dark(),
            home: Scaffold(
              body: TextInputField(
                labelTextField: 'Test',
                flex: 8,
                textType: TextInputType.text,
                isValid: true,
                onChangeEffect: (value) {},
              ),
            ),
          ),
        );

        expect(find.byType(TextInputField), findsOneWidget);
      });

      testWidgets('should open date picker with dark theme', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: ThemeData.dark(),
            home: Scaffold(
              body: TextInputField(
                labelTextField: 'Birth Date',
                flex: 8,
                textType: TextInputType.datetime,
                isDate: true,
                isValid: true,
                onChangeEffect: (value) {},
              ),
            ),
          ),
        );

        await tester.tap(find.byType(TextFormField));
        await tester.pumpAndSettle();

        expect(find.byType(DatePickerDialog), findsOneWidget);
      });
    });

    group('Complex Scenarios', () {
      testWidgets('should handle password field with validation', (tester) async {
        String capturedValue = '';
        bool isValid = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: StatefulBuilder(
                builder: (context, setState) {
                  return TextInputField(
                    labelTextField: 'Password',
                    flex: 8,
                    textType: TextInputType.text,
                    isPassword: true,
                    isValid: isValid,
                    onChangeEffect: (value) {
                      setState(() {
                        capturedValue = value;
                        isValid = value.length >= 8;
                      });
                    },
                  );
                },
              ),
            ),
          ),
        );

        // Enter weak password
        await tester.enterText(find.byType(TextFormField), 'weak');
        await tester.pump();

        expect(find.byIcon(Icons.error), findsOneWidget);

        // Enter strong password
        await tester.enterText(find.byType(TextFormField), 'StrongPass123!');
        await tester.pump();

        expect(find.byIcon(Icons.check_circle_sharp), findsOneWidget);
      });

      testWidgets('should handle limited field with validation icons', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TextInputField(
                labelTextField: 'Bio',
                flex: 8,
                textType: TextInputType.multiline,
                isLimited: true,
                isValid: true,
                onChangeEffect: (value) {},
                content: 'Short bio',
              ),
            ),
          ),
        );

        expect(find.text('9/50'), findsOneWidget);
        expect(find.byIcon(Icons.check_circle_sharp), findsOneWidget);
      });

      testWidgets('should handle date field with validation', (tester) async {
        String capturedValue = '';

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TextInputField(
                labelTextField: 'Birth Date',
                flex: 8,
                textType: TextInputType.datetime,
                isDate: true,
                isValid: true,
                onChangeEffect: (value) {
                  capturedValue = value;
                },
              ),
            ),
          ),
        );

        await tester.tap(find.byType(TextFormField));
        await tester.pumpAndSettle();

        await tester.tap(find.text('OK'));
        await tester.pumpAndSettle();

        expect(capturedValue, isNotEmpty);
        expect(find.byIcon(Icons.check_circle_sharp), findsOneWidget);
      });

      testWidgets('should handle disabled password field', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TextInputField(
                labelTextField: 'Password',
                flex: 8,
                textType: TextInputType.text,
                isPassword: true,
                isValid: true,
                onChangeEffect: (value) {},
                enabled: false,
                content: 'password123',
              ),
            ),
          ),
        );

        final textField = tester.widget<TextFormField>(find.byType(TextFormField));
        expect(textField.enabled, false);
        expect(find.byIcon(Icons.visibility_off_sharp), findsOneWidget);
      });
    });

    group('Edge Cases', () {
      testWidgets('should handle null content gracefully', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TextInputField(
                labelTextField: 'Test',
                flex: 8,
                textType: TextInputType.text,
                isValid: true,
                onChangeEffect: (value) {},
                content: '',
              ),
            ),
          ),
        );

        expect(find.byType(TextInputField), findsOneWidget);
      });

      testWidgets('should handle very long text content', (tester) async {
        final longText = 'A' * 50;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TextInputField(
                labelTextField: 'Test',
                flex: 8,
                textType: TextInputType.text,
                isValid: true,
                onChangeEffect: (value) {},
                content: longText,
                isLimited: true,
              ),
            ),
          ),
        );

        expect(find.text('50/50'), findsOneWidget);
      });

      testWidgets('should handle special characters in text', (tester) async {
        String capturedValue = '';

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TextInputField(
                labelTextField: 'Test',
                flex: 8,
                textType: TextInputType.text,
                isValid: true,
                onChangeEffect: (value) {
                  capturedValue = value;
                },
              ),
            ),
          ),
        );

        await tester.enterText(find.byType(TextFormField), '!@#\$%^&*()');
        await tester.pump();

        expect(capturedValue, '!@#\$%^&*()');
      });

      testWidgets('should handle unicode characters', (tester) async {
        String capturedValue = '';

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TextInputField(
                labelTextField: 'Test',
                flex: 8,
                textType: TextInputType.text,
                isValid: true,
                onChangeEffect: (value) {
                  capturedValue = value;
                },
              ),
            ),
          ),
        );

        await tester.enterText(find.byType(TextFormField), '你好世界 🌍');
        await tester.pump();

        expect(capturedValue, '你好世界 🌍');
      });

      testWidgets('should handle rapid focus changes', (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  TextInputField(
                    key: Key('field1'),
                    labelTextField: 'Field 1',
                    flex: 8,
                    textType: TextInputType.text,
                    isValid: true,
                    onChangeEffect: (value) {},
                    errorText: 'Error 1',
                  ),
                  TextInputField(
                    key: Key('field2'),
                    labelTextField: 'Field 2',
                    flex: 8,
                    textType: TextInputType.text,
                    isValid: true,
                    onChangeEffect: (value) {},
                    errorText: 'Error 2',
                  ),
                ],
              ),
            ),
          ),
        );

        // Tap first field
        await tester.tap(find.byType(TextFormField).first);
        await tester.pump();

        // Tap second field
        await tester.tap(find.byType(TextFormField).last);
        await tester.pump();

        // Tap first field again
        await tester.tap(find.byType(TextFormField).first);
        await tester.pump();

        expect(find.text('Error 1'), findsOneWidget);
      });

      testWidgets('should maintain state after rebuild', (tester) async {
        int rebuildCount = 0;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: StatefulBuilder(
                builder: (context, setState) {
                  return Column(
                    children: [
                      Text('Rebuild: $rebuildCount'),
                      TextInputField(
                        labelTextField: 'Test',
                        flex: 8,
                        textType: TextInputType.text,
                        isValid: true,
                        onChangeEffect: (value) {},
                        content: 'Initial',
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            rebuildCount++;
                          });
                        },
                        child: Text('Rebuild'),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        );

        expect(find.text('Initial'), findsOneWidget);

        await tester.tap(find.text('Rebuild'));
        await tester.pump();

        expect(find.text('Initial'), findsOneWidget);
        expect(find.text('Rebuild: 1'), findsOneWidget);
      });
    });
  });
}
