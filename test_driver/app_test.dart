import 'dart:async';
import 'dart:convert';
import 'dart:io';

// Imports the Flutter Driver API.
import 'package:flutter_driver/flutter_driver.dart';
import 'package:test/test.dart';

void main() {
  group('IrmaMobile', () {
    FlutterDriver driver;
    StreamSubscription streamSubscription;
    Process irmaServer;
    setUpAll(() async {
      // Connect to a running Flutter application instance.
      driver = await FlutterDriver.connect();
      streamSubscription = driver.serviceClient.onIsolateRunnable.asBroadcastStream().listen((isolateRef) {
        // This is a workaround for https://github.com/flutter/flutter/issues/24703.
        isolateRef.resume();
      });

      print('Starting IRMA server...');
      irmaServer = await Process.start('irma', ['server'], mode: ProcessStartMode.inheritStdio, runInShell: true);

      // Forward neccessary ports
      await Process.run('adb', ['reverse', 'tcp:8080', 'tcp:8080']);
      await Process.run('adb', ['reverse', 'tcp:8088', 'tcp:8088']);
    });

    tearDownAll(() async {
      if (driver != null) await driver.close();
      streamSubscription?.cancel();
      irmaServer?.kill();
    });

    Future<void> _startIrmaSession(String request) async {
      final requestH = await HttpClient().postUrl(Uri.parse('http://localhost:8088/session'));
      requestH.headers.set('Content-Type', 'application/json');
      requestH.write(request);
      final response = await requestH.close();
      final sessionData = await response.transform(utf8.decoder).first;
      final data = jsonDecode(sessionData) as Map<String, dynamic>;
      await driver.requestData(jsonEncode(data["sessionPtr"]));
    }

    test('main', () async {
      // Wait for initialization
      await driver.waitFor(find.byValueKey('next_enrollment_p1'));

      // Enable developer mode
      await driver.requestData("");

      // Tap through enrollment info screens
      await driver.tap(find.byValueKey('next_enrollment_p1'));
      await driver.tap(find.byValueKey('next_enrollment_p2'));
      await driver.tap(find.byValueKey('next_enrollment_p3'));

      // Enter pin
      await driver.waitFor(find.byValueKey('enrollment_choose_pin'));
      await driver.enterText('12345');

      // Confirm pin
      await driver.waitFor(find.byValueKey('enrollment_confirm_pin'));
      await driver.enterText('12345');

      // Skip email providing
      await driver.tap(find.byValueKey('enrollment_skip_email'));
      await driver.tap(find.byValueKey('skip_confirm'));

      // Wait until wallet displayed
      await driver.waitFor(find.byValueKey('wallet_present'));

      // Start session
      await _startIrmaSession("""{
        "@context": "https://irma.app/ld/request/issuance/v2",
        "credentials": [
          {
            "credential": "irma-demo.gemeente.personalData",
            "attributes": {
              "initials": "W.L.",
              "firstnames": "Willeke Liselotte",
              "prefix": "de",
              "familyname": "Bruijn",
              "fullname": "W.L. de Bruijn",
              "gender": "V",
              "nationality": "Ja",
              "surname": "de Bruijn",
              "dateofbirth": "10-04-1965",
              "cityofbirth": "Amsterdam",
              "countryofbirth": "Nederland",
              "over12": "Yes",
              "over16": "Yes",
              "over18": "Yes",
              "over21": "Yes",
              "over65": "No",
              "bsn": "999999990",
              "digidlevel": "Substantieel"
            }
          },
          {
            "credential": "irma-demo.gemeente.address",
            "attributes": {
              "street":"","houseNumber":"","zipcode":"1234AB","municipality":"","city":""
            }
          }
        ]
      }""");

      // Accept issued credential
      await driver.tap(find.byValueKey('issuance_accept_yes'));

      // Wait until done
      await driver.waitFor(find.byValueKey('wallet_present'));
    }, timeout: const Timeout(Duration(minutes: 5)));
  });
}