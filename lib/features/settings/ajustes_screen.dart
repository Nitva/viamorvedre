import 'package:flutter/material.dart';

class AjustesScreen extends StatefulWidget {
  const AjustesScreen({super.key});

  @override
  State<AjustesScreen> createState() => _AjustesScreenState();
}

class _AjustesScreenState extends State<AjustesScreen> {
  bool _notificacionesEnabled = true;
  String _formatoHora = '24h';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajustes'),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Preferencias',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    child: Column(
                      children: [
                        SwitchListTile(
                          title: const Text('Notificaciones'),
                          subtitle: const Text('Recibir alertas de autobuses'),
                          value: _notificacionesEnabled,
                          onChanged: (value) {
                            setState(() {
                              _notificacionesEnabled = value;
                            });
                          },
                        ),
                        const Divider(height: 1),
                        ListTile(
                          title: const Text('Formato de hora'),
                          subtitle: Text(_formatoHora),
                          trailing: PopupMenuButton(
                            onSelected: (value) {
                              setState(() {
                                _formatoHora = value;
                              });
                            },
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: '24h',
                                child: Text('24 horas'),
                              ),
                              const PopupMenuItem(
                                value: '12h',
                                child: Text('12 horas (AM/PM)'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Información',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Card(
                    child: Column(
                      children: [
                        const ListTile(
                          title: Text('Versión'),
                          subtitle: Text('1.0.0'),
                        ),
                        const Divider(height: 1),
                        const ListTile(
                          title: Text('Acerca de'),
                          subtitle: Text('Transporte público en tiempo real'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
