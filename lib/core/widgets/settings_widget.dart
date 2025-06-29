import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:settings_ui/settings_ui.dart';

class KebabSettingsWidget extends StatelessWidget {
  const KebabSettingsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: SettingsList(
        sections: [
          SettingsSection(
            title: const Text('Účet'),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                leading: const Icon(Icons.person),
                title: Text(user?.email ?? 'Žádný E-mail'),
                value: const Text('Přihlášen'),
              ),
              SettingsTile.navigation(
                leading: const Icon(Icons.kebab_dining),
                title: const Text('Změnit uživatelské jméno'),
                value: Text("Sike"),
                onPressed: (context) {
                  // TODO: Implement change username
                },
              ),
              SettingsTile.navigation(
                leading: const Icon(Icons.lock),
                title: const Text('Změnit Heslo'),
                onPressed: (context) {
                  // TODO: Implement change password
                },
              ),
            ],
          ),
          SettingsSection(
            title: const Text('Obecné'),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                leading: const Icon(Icons.info),
                title: const Text('Info'),
                onPressed: (context) {
                  showAboutDialog(
                    context: context,
                    applicationName: 'Kebaby Brno',
                    applicationVersion: '1.0.0',
                  );
                },
              ),
              SettingsTile(
                leading: const Icon(Icons.logout),
                title: const Text('Odhlásit se'),
                onPressed: (context) async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushReplacementNamed(context, '/sign-in');
                },
              ),
              SettingsTile(
                leading: const Icon(Icons.delete_forever, color: Colors.red),
                title: const Text(
                  'Smazat Účet',
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: (context) async {
                  final user = FirebaseAuth.instance.currentUser;
                  final email = user?.email;
                  if (user == null || email == null) return;

                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Smazat Účet'),
                      content: const Text(
                        'Skutečně chcete smazat svůj účet? Tato operace nemůže být odprovedena.',
                      ),
                      actions: [
                        TextButton(
                          child: const Text('Zrušit'),
                          onPressed: () => Navigator.of(context).pop(false),
                        ),
                        TextButton(
                          child: const Text(
                            'Smazat',
                            style: TextStyle(color: Colors.red),
                          ),
                          onPressed: () => Navigator.of(context).pop(true),
                        ),
                      ],
                    ),
                  );

                  if (confirmed == true) {
                    final passwordController = TextEditingController();
                    final password = await showDialog<String>(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text('Potvrdit Mazbu'),
                          content: TextField(
                            controller: passwordController,
                            obscureText: true,
                            decoration: const InputDecoration(
                              labelText: 'Zadejte své heslo',
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(context).pop(null),
                              child: const Text('Zrušit'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(
                                  context,
                                ).pop(passwordController.text.trim());
                              },
                              child: const Text(
                                'Smazat',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                    if (password == null) return;
                    try {
                      final credential = EmailAuthProvider.credential(
                        email: email,
                        password: password,
                      );
                      await user.reauthenticateWithCredential(credential);

                      // After successful reauthentication, delete the user
                      await user.delete();

                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("Účet úspěšně smazán."),
                            content: const Text(
                              "Nyní budete přesměměrováni na přihlihlašovací obrazovku.",
                            ),
                          );
                        },
                      );

                      Navigator.pushReplacementNamed(context, '/sign-in');
                    } on FirebaseAuthException catch (e) {
                      if (e.code == 'invalid-credential') {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Špatné heslo. Prosím zkuste znovu.'),
                          ),
                        );
                      } else if (e.code == 'requires-recent-login') {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Prosím, znovu se přihlašte, aby jste mohli smazat svůj účet.',
                            ),
                          ),
                        );
                      } else if (e.code == 'missing-password') {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Prosím, zadejte heslo.')),
                        );
                      } else {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text('Error: $e.')));
                      }
                    }
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
