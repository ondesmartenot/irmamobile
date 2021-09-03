import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:irmamobile/main.dart';
import 'package:irmamobile/src/data/irma_test_repository.dart';
import 'package:irmamobile/src/widgets/irma_button.dart';

import 'util.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  WidgetController.hitTestWarningShouldBeFatal = true;

  group('irma-enroll', () {
    // Initialize the app's repository for integration tests (enable developer mode, etc.)
    IrmaTestRepository testRepo;
    setUpAll(() async => testRepo = await IrmaTestRepository.ensureInitialized());
    setUp(() => testRepo.init());
    tearDown(() => testRepo.clean());

    testWidgets('tc1', (tester) async {
      // Scenario 1 of enrollment process
      // Initialize the app for integration tests
      await tester.pumpWidgetAndSettle(IrmaApp());

      // Tap through enrollment info screens
      await tester.tapAndSettle(
          find.descendant(of: find.byKey(const Key('enrollment_p1')), matching: find.byKey(const Key('next'))));
      await tester.tapAndSettle(
          find.descendant(of: find.byKey(const Key('enrollment_p2')), matching: find.byKey(const Key('next'))));
      await tester.tapAndSettle(
          find.descendant(of: find.byKey(const Key('enrollment_p3')), matching: find.byKey(const Key('next'))));

      // Enter Pin
      await tester.enterTextAtFocusedAndSettle('12345');
      // Enter wrong pin
      await tester.enterTextAtFocusedAndSettle('67890');

      await tester.waitFor(find.byKey(const Key('irma_dialog')));

      // Check "Wrong PIN" dialog title text
      String string = tester.getText(find.byKey(const Key('irma_dialog_title')));
      expect(string, 'PIN incorrect');
      // Check dialog text
      string = tester.getText(find.byKey(const Key('irma_dialog_content')));
      expect(string, 'PINs do not match. Choose a new PIN.');

      await tester
          .tapAndSettle(find.descendant(of: find.byKey(const Key('irma_dialog')), matching: find.byType(IrmaButton)));

      // Enter pin
      await tester.enterTextAtFocusedAndSettle('12345');
      // Confirm pin
      await tester.enterTextAtFocusedAndSettle('12345');

      // Check error message is not displayed
      expect(
        tester.any(find.descendant(
            of: find.byKey(const Key('enrollment_provide_email_textfield')),
            matching: find.text('This is not a valid email address'))),
        false,
      );

      await tester.enterTextAtFocusedAndSettle('Wrong_syntax');
      await tester.tapAndSettle(find.byKey(const Key('enrollment_email_next')));

      // Check error message
      expect(
        tester.any(find.descendant(
            of: find.byKey(const Key('enrollment_provide_email_textfield')),
            matching: find.text('This is not a valid email address'))),
        true,
      );

      // Check textfield is still present
      expect(
        tester.any(
            find.descendant(of: find.byKey(const Key('enrollment_provide_email')), matching: find.byType(TextField))),
        true,
      );

      await tester.enterTextAtFocusedAndSettle('testing_irma_app@example.com');
      await tester.tapAndSettle(find.byKey(const Key('enrollment_email_next')));

      // Wait for Email confirmation screen
      await tester.waitFor(find.byKey(const Key('email_sent_screen')));
      print('check screen title');
      // Check screen title
      string = tester.getText(find.byKey(const Key('irma_app_bar')), firstMatchOnly: true);
      expect(string, 'Secure your IRMA app');

      // Check text
      string = tester.getText(
        find.descendant(of: find.byKey(const Key('email_sent_screen')), matching: find.byType(Text)),
        firstMatchOnly: true,
      );
      expect(string, 'Confirm your email address');

      // Click continue
      await tester.tapAndSettle(find.descendant(
          of: find.byKey(const Key('email_sent_screen_continue')), matching: find.byKey(const Key('primary'))));

      // Wait until wallet displayed
      await tester.waitFor(find.byKey(const Key('wallet_present')));
      // No cards should be available in the wallet
      expect(tester.any(find.byKey(const Key('wallet_card_0'))), false);
    }, timeout: const Timeout(Duration(minutes: 4)));

    testWidgets('tc2', (tester) async {
      // Scenario 2 of enrollment process
      // Initialize the app for integration tests
      await tester.pumpWidgetAndSettle(IrmaApp());

      // Tap through enrollment info screens
      await tester.tapAndSettle(
          find.descendant(of: find.byKey(const Key('enrollment_p1')), matching: find.byKey(const Key('next'))));
      await tester.tapAndSettle(
          find.descendant(of: find.byKey(const Key('enrollment_p2')), matching: find.byKey(const Key('next'))));
      await tester.tapAndSettle(
          find.descendant(of: find.byKey(const Key('enrollment_p3')), matching: find.byKey(const Key('next'))));

      // Check screen title
      String string = tester.getText(find.byKey(const Key('irma_app_bar')), firstMatchOnly: true);
      expect(string, 'Secure your IRMA app');

      // Check text
      string = tester.getText(
        find.descendant(of: find.byKey(const Key('enrollment_choose_pin')), matching: find.byType(Text)),
        firstMatchOnly: true,
      );
      expect(string, 'Choose a 5-digit PIN');

      // Enter Pin
      print('Enter pin');
      await tester.enterTextAtFocusedAndSettle('12345');

      // Check screen title
      print('check screen title Secure your irma app');
      string = tester.getText(find.byKey(const Key('irma_app_bar')), firstMatchOnly: true);
      expect(string, 'Secure your IRMA app');

      // Check text
      print('check text Enter your pin');
      string = tester.getText(find.byKey(const Key('enrollment_confirm_pin')), firstMatchOnly: true);
      expect(string, 'Enter your PIN again');

      // Confirm pin
      await tester.enterTextAtFocusedAndSettle('12345');

      // Check screen title
      print('check screen title Secure your irma app');
      string = tester.getText(find.byKey(const Key('irma_app_bar')), firstMatchOnly: true);
      expect(string, 'Secure your IRMA app');

      // Check text
      print('check text email enrollment');
      string = tester.getText(find.byKey(const Key('enrollment_provide_email')), firstMatchOnly: true);
      expect(string, 'An email address allows you to disable your IRMA app when your mobile has been lost or stolen.');

      // Check textfield
      print('check textfield email');
      expect(
        tester.any(
            find.descendant(of: find.byKey(const Key('enrollment_provide_email')), matching: find.byType(TextField))),
        true,
      );

      // Check buttons Skip & Next
      print('check buttons Skip & Next');
      expect(tester.any(find.byKey(const Key('enrollment_skip_email'))), true);
      expect(tester.any(find.byKey(const Key('enrollment_email_next'))), true);

      // Click Skip
      print('Skip Email');
      await tester.tapAndSettle(find.byKey(const Key('enrollment_skip_email')));
      print('check irma dialog is displayed');
      await tester.waitFor(find.byKey(const Key('irma_dialog')));
      // Check dialog title text
      string = tester.getText(find.byKey(const Key('irma_dialog_title')));
      expect(string, 'Are you sure?');
      // Check dialog text
      string = tester.getText(find.byKey(const Key('irma_dialog_content')));
      expect(string,
          'Protect your data. When you enter an email address, you can block your IRMA app when your mobile has been lost or stolen.');

      // Confirm Skip
      await tester.tap(find.byKey(const Key('enrollment_skip_confirm')));

      // Wait until wallet displayed
      await tester.waitFor(find.byKey(const Key('wallet_present')));
      // No cards should be available in the wallet
      expect(tester.any(find.byKey(const Key('wallet_card_0'))), false);
    }, timeout: const Timeout(Duration(minutes: 4)));
  });
}
