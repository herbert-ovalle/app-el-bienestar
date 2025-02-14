
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ConfigScreen extends StatelessWidget {

  const ConfigScreen({super.key});

  @override
  Widget build(BuildContext context) {
     bool _isDark = false;
    return Scaffold(
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          child: ListView(
            children: [
              _SingleSection(
                  title: "General",
                  children: [
                    _CustomListTile(
                        title: "Modo oscuro",
                        icon: Icons.dark_mode_outlined,
                        trailing: Switch(
                            value: _isDark,
                            onChanged: (value) {
                                _isDark = value;
                            })),
                    const _CustomListTile(
                        title: "Notificaciones",
                        icon: Icons.notifications_none_rounded),
                    const _CustomListTile(
                        title: "Seguridad",
                        icon: CupertinoIcons.lock_shield)]),
                                      const Divider(),
              const _SingleSection(
                title: "Organización",
                children: [
                  _CustomListTile(
                      title: "Perfil", icon: Icons.person_outline_rounded),
                  _CustomListTile(title: "Mensajes", icon: Icons.message_outlined),
                  _CustomListTile(title: "LLamadas", icon: Icons.phone_outlined),
                  _CustomListTile(title: "Contactos", icon: Icons.contacts_outlined),
                  _CustomListTile(
                      title: "Calendario", icon: Icons.calendar_today_rounded)
                ],
              ),
              const Divider(),
              const _SingleSection(
                children: [
                  _CustomListTile(
                      title: "Ayuda y retroalimentación", icon: Icons.help_outline_rounded),
                  _CustomListTile(title: "Información", icon: Icons.info_outline_rounded),
                  _CustomListTile(
                      title: "Salir", icon: Icons.exit_to_app_rounded),
                ],
              ),
            ]
        ),
      ),
    ));
  }
}

class _CustomListTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget? trailing;
  const _CustomListTile(
      { required this.title, required this.icon, this.trailing});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      leading: Icon(icon),
      trailing: trailing,
      onTap: () {},
    );
  }
}

class _SingleSection extends StatelessWidget {
  final String? title;
  final List<Widget> children;
  const _SingleSection({
    this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title!,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        Column(
          children: children,
        ),
      ],
    );
  }
}
