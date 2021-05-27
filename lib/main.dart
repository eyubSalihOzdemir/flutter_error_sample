import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyAppState();
  }
}

String selectedHour = '01';
String selectedMinute = '01';
String localTimeZoneManuel = 'Etc/GMT-3';

class _MyAppState extends State<MyApp> {
  bool notificationsAllowed = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AwesomeNotifications().initialize(
        // set the icon to null if you want to use the default app icon
        null,
        [
          NotificationChannel(
              channelKey: 'scheduled',
              channelName: 'Basic notifications',
              channelDescription: 'Notification channel for basic tests',
              defaultColor: Color(0xFF9D50DD),
              ledColor: Colors.blue,
              onlyAlertOnce: true,
              playSound: true)
        ]);

    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      setState(() {
        notificationsAllowed = isAllowed;
      });

      if (!isAllowed) {
        requestUserPermission(isAllowed);
      }
    });
  }

  void requestUserPermission(bool isAllowed) async {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Color(0xfffbfbfb),
        title: Text('Get Notified!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/animated-bell.gif',
              height: 200,
              fit: BoxFit.fitWidth,
            ),
            Text(
              'Allow Awesome Notifications to send you beautiful notifications!',
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            style: TextButton.styleFrom(backgroundColor: Colors.grey),
            onPressed: () async {
              Navigator.of(context).pop();
              notificationsAllowed =
                  await AwesomeNotifications().isNotificationAllowed();
              setState(() {
                notificationsAllowed = notificationsAllowed;
              });
            },
            child: Text('Later', style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            style: TextButton.styleFrom(backgroundColor: Colors.deepPurple),
            onPressed: () async {
              Navigator.of(context).pop();
              await AwesomeNotifications()
                  .requestPermissionToSendNotifications();
              notificationsAllowed =
                  await AwesomeNotifications().isNotificationAllowed();
              setState(() {
                notificationsAllowed = notificationsAllowed;
              });
            },
            child: Text('Allow', style: TextStyle(color: Colors.white)),
          )
        ],
      ),
    );
  }

  double fontSizeOutDropdown = 40;
  double fontSizeInDropdown = 30;

  @override
  Widget build(BuildContext context) {
    List<String> _dropdownListHour = [];
    List<String> _dropdownListMinute = [];
    String fooString;
    for (var i = 0; i <= 23; i++) {
      fooString = '0';
      if (i <= 9) {
        fooString += i.toString();
      } else {
        fooString = i.toString();
      }
      _dropdownListHour.add(fooString);
    }
    for (var i = 0; i <= 59; i++) {
      fooString = '0';
      if (i <= 9) {
        fooString += i.toString();
      } else {
        fooString = i.toString();
      }
      _dropdownListMinute.add(fooString);
    }

    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: Text('Marcus Aurelius'),
            backgroundColor: Colors.purple[400],
          ),
          backgroundColor: Colors.pink[50],
          body: Center(
            child: Container(
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        child: DropdownButton<String>(
                          items: _dropdownListHour.map((String value) {
                            return new DropdownMenuItem<String>(
                                value: value.toString(),
                                child: new Text(value.toString(),
                                    style: TextStyle(
                                        fontSize: fontSizeInDropdown)));
                          }).toList(),
                          onChanged: (_) {
                            setState(() {
                              selectedHour = _.toString();
                            });
                          },
                          hint: Text(selectedHour),
                          itemHeight: 60,
                          style: TextStyle(
                              fontSize: fontSizeOutDropdown,
                              color: Colors.grey[700]),
                          dropdownColor: Colors.grey[200],
                        ),
                      ),
                      Container(
                        child: Text(
                          ':',
                          style: TextStyle(
                            fontSize: fontSizeOutDropdown,
                          ),
                        ),
                        alignment: Alignment.center,
                        width: 25,
                        margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      ),
                      Container(
                        child: DropdownButton<String>(
                          items: _dropdownListMinute.map((String value) {
                            return new DropdownMenuItem<String>(
                                value: value.toString(),
                                child: new Text(value.toString(),
                                    style: TextStyle(
                                        fontSize: fontSizeInDropdown)));
                          }).toList(),
                          onChanged: (_) {
                            setState(() {
                              selectedMinute = _.toString();
                            });
                          },
                          hint: Text(selectedMinute),
                          itemHeight: 60,
                          style: TextStyle(
                              fontSize: fontSizeOutDropdown,
                              color: Colors.grey[700]),
                          dropdownColor: Colors.grey[200],
                          isExpanded: false,
                        ),
                      )
                    ],
                    //mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                  ),
                  ElevatedButton(
                    autofocus: true,
                    onPressed: () async {
                      String localTimeZone = await AwesomeNotifications()
                          .getLocalTimeZoneIdentifier();
                      await AwesomeNotifications().createNotification(
                          content: NotificationContent(
                            id: 1,
                            title: 'testing',
                            channelKey: 'scheduled',
                            body: 'local time zone: $localTimeZone',
                          ),
                          schedule: NotificationCalendar(
                              allowWhileIdle: true,
                              hour: int.parse(selectedHour),
                              minute: int.parse(selectedMinute),
                              second: 0,
                              millisecond: 0,
                              timeZone: localTimeZone,
                              repeats: true));
                      Fluttertoast.showToast(
                          msg:
                              "Timer has been set to $selectedHour:$selectedMinute",
                          toastLength: Toast.LENGTH_SHORT,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.purple[900],
                          textColor: Colors.white,
                          fontSize: 16.0);
                    },
                    child: Text(
                      "Bildirimi Planla",
                      style: TextStyle(fontSize: 18),
                    ),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.purple[400]),
                        padding: MaterialStateProperty.all(
                            EdgeInsets.fromLTRB(30, 20, 30, 20))),
                  ),
                  Container(
                      child: Text(
                        // version
                        "v31.52.69",
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                      alignment: AlignmentDirectional.center)
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              ),
            ),
          )),
    );
  }
}