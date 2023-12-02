import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Reminder {
  late DateTime dateTime;
  late String medicine;
  int? key;

  Reminder({required this.dateTime, required this.medicine, this.key});

  // Adicione um construtor nomeado para criar um Reminder com chave nula
  Reminder.withoutKey({required this.dateTime, required this.medicine});
}

class ReminderAdapter extends TypeAdapter<Reminder> {
  @override
  final int typeId = 0;

  @override
  Reminder read(BinaryReader reader) {
    return Reminder(
      dateTime: DateTime.parse(reader.read() as String),
      medicine: reader.read() as String,
    );
  }

  @override
  void write(BinaryWriter writer, Reminder obj) {
    writer.write(obj.dateTime.toIso8601String());
    writer.write(obj.medicine);
  }
}

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(ReminderAdapter());
  await Hive.openBox<Reminder>('reminders');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Care Time',
      theme: ThemeData(
        primaryColor: Color.fromARGB(255, 32, 32, 32), // Verde pastel
        accentColor: Color.fromARGB(255, 58, 58, 58), // Verde azulado pastel
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Montserrat', // Fonte moderna
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  late DateTime _selectedTime;
  final TextEditingController _medicineController = TextEditingController();
  bool _isRepeating = false;
  int _selectedRepeatInterval = 1;

  @override
  void initState() {
    super.initState();
    _selectedTime = DateTime.now();
    _initializeNotifications();
  }

  Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onSelectNotification: (payload) async {
        // Implemente a lógica que deseja ao selecionar uma notificação
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Care Time',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontFamily: 'Montserrat', // Aplicar a mesma fonte no título
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _medicineController,
              decoration: const InputDecoration(
                labelText: 'Nome do Remédio',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _selectTime(context);
              },
              style: ElevatedButton.styleFrom(
                primary: Theme.of(context).primaryColor,
              ),
              child: const Text('Selecionar Hora'),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Checkbox(
                  value: _isRepeating,
                  onChanged: (value) {
                    setState(() {
                      _isRepeating = value ?? false;
                    });
                  },
                ),
                const Text('Repetir a cada'),
                const SizedBox(width: 8),
                _isRepeating
                    ? DropdownButton<int>(
                        value: _selectedRepeatInterval,
                        onChanged: (value) {
                          setState(() {
                            _selectedRepeatInterval = value!;
                          });
                        },
                        items: List.generate(
                          24,
                          (index) => DropdownMenuItem<int>(
                            value: index + 1,
                            child: Text('${index + 1} horas'),
                          ),
                        ),
                      )
                    : Container(),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                _scheduleNotification();
              },
              style: ElevatedButton.styleFrom(
                primary: Theme.of(context).accentColor,
              ),
              icon: const Icon(Icons.alarm),
              label: const Text('Agendar Notificação'),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ValueListenableBuilder(
                valueListenable: Hive.box<Reminder>('reminders').listenable(),
                builder: (context, Box<Reminder> remindersBox, widget) {
                  return ListView.builder(
                    itemCount: remindersBox.length,
                    itemBuilder: (context, index) {
                      Reminder reminder = remindersBox.getAt(index)!;
                      return Card(
                        elevation: 3,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        color: Colors.white, // Cor de fundo do cartão
                        child: ListTile(
                          title: Text(
                            'Data: ${reminder.dateTime.toString()}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          subtitle: Text(
                            'Remédio: ${reminder.medicine}',
                            style: TextStyle(
                              color: Theme.of(context).accentColor,
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  _editReminder(reminder);
                                },
                                color: Theme.of(context).accentColor,
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  _deleteReminder(reminder);
                                },
                                color: Colors.red, // Cor do ícone de exclusão
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<DateTime?> _selectTime(BuildContext context) async {
    DatePicker.showTimePicker(
      context,
      showTitleActions: true,
      onChanged: (date) {
        print('change $date');
      },
      onConfirm: (date) {
        setState(() {
          _selectedTime = date;
        });
      },
      currentTime: _selectedTime,
    );
  }

  Future<void> _scheduleNotification() async {
    DateTime scheduledTime = _selectedTime;

    if (_isRepeating) {
      scheduledTime = scheduledTime.add(
        Duration(hours: _selectedRepeatInterval),
      );
    }

    Reminder newReminder = Reminder.withoutKey(
      dateTime: scheduledTime,
      medicine: _medicineController.text,
    );

    // Se a chave for nula, atribua manualmente um valor dentro do intervalo permitido
    if (newReminder.key == null) {
      newReminder.key = DateTime.now().millisecondsSinceEpoch % 0xFFFFFFFF;
    }

    print('Chave do lembrete adicionado: ${newReminder.key}');

    Hive.box<Reminder>('reminders').put(newReminder.key!, newReminder);

    await AndroidAlarmManager.periodic(
      Duration(minutes: _isRepeating ? 1 : 0),
      0,
      _showNotification,
      startAt: scheduledTime,
      exact: true,
      wakeup: true,
    );
  }

  Future<void> _editReminder(Reminder reminder) async {
    DateTime? editedTime = await _selectTime(context);

    final Completer<void> completer = Completer<void>();

    if (editedTime != null) {
      final editedReminder = Reminder(
        dateTime: editedTime,
        medicine: reminder.medicine,
      );

      try {
        final key = Hive.box<Reminder>('reminders').keyAt(reminder.key!);
        Hive.box<Reminder>('reminders').put(key, editedReminder);

        await AndroidAlarmManager.cancel(reminder.key!);
        await _scheduleNotification();
        completer.complete();
      } catch (error) {
        print('Erro ao editar lembrete: $error');
        completer.completeError(error);
      }
    } else {
      completer.complete();
    }

    return completer.future;
  }

  Future<void> _deleteReminder(Reminder reminder) async {
    try {
      final remindersBox = Hive.box<Reminder>('reminders');
      print(
          'Tentando excluir lembrete. Chave: ${reminder.key}, Comprimento da caixa: ${remindersBox.length}');

      if (reminder.key != null) {
        remindersBox.delete(reminder.key!);
        await AndroidAlarmManager.cancel(reminder.key!);
        print('Lembrete excluído com sucesso.');
      } else {
        print('Aviso: Chave do lembrete é nula.');
      }
    } catch (error) {
      print('Erro ao excluir lembrete: $error');
    }
  }

  static Future<void> _showNotification(String title, String body) async {
    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: 'item x',
    );
  }
}
