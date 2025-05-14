import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meet_up/config/routes/app_routes.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Settings')),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Account Section
            SettingsSectionHeader(title: 'Account'),
            SettingsItem(
              title: 'Profile',
              description: 'Edit your profile information',
              onTap: () {
                // Navigate to Profile settings
                context.pushNamed(AppRoutes.profile);
              },
            ),
            SettingsItem(
              title: 'Privacy',
              description: 'Manage your privacy settings',
              onTap: () {
                // Navigate to Privacy settings
              },
            ),

            // ... other Account settings
            Divider(),

            // Chats Section
            SettingsSectionHeader(title: 'Chats'),
            SettingsItem(
              title: 'Theme',
              description: 'Change the app theme',
              onTap: () {
                // Open Theme selection dialog/screen
              },
            ),
            SettingsItem(
              title: 'Wallpaper',
              description: 'Change chat wallpaper',
              onTap: () {
                // Navigate to Wallpaper selection
              },
            ),

            // ... other Chats settings
            Divider(),

            // Notifications Section
            SettingsSectionHeader(title: 'Notifications'),
            SettingsItem(
              title: 'Notification Tone',
              description: 'Customize notification sounds',
              onTap: () {
                // Open Notification Tone selection
              },
            ),

            // ... other Notifications settings
            Divider(),

            // Storage and Data Section
            SettingsSectionHeader(title: 'Storage and Data'),
            SettingsItem(
              title: 'Manage Storage',
              description: 'See how much storage is used',
              onTap: () {
                // Navigate to Storage management
              },
            ),

            // ... other Storage and Data settings
            Divider(),

            // Help Section
            SettingsSectionHeader(title: 'Help'),
            SettingsItem(
              title: 'Help Center',
              description: 'Find answers to your questions',
              onTap: () {
                // Open Help Center (e.g., in a WebView or browser)
              },
            ),
            // ... other Help settings
          ],
        ),
      ),
    );
  }
}

class SettingsSectionHeader extends StatelessWidget {
  final String title;

  const SettingsSectionHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
      child: Text(title, style: Theme.of(context).textTheme.titleLarge),
    );
  }
}

class SettingsItem extends StatelessWidget {
  final String title;
  final String? description;
  final VoidCallback onTap;
  final Widget? trailing; // For optional trailing widgets like Switches

  const SettingsItem({
    super.key,
    required this.title,
    this.description,
    required this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          children: [
            // Optional: Add an Icon here if needed
            // Icon(Icons.person, size: 24.0),
            // SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleMedium),
                  if (description != null)
                    Text(
                      description!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                ],
              ),
            ),
            if (trailing != null) ...[SizedBox(width: 16.0), trailing!],
          ],
        ),
      ),
    );
  }
}

// Example of a Settings item with a Switch
class SettingsSwitchItem extends StatefulWidget {
  final String title;
  final String? description;
  final bool initialValue;
  final ValueChanged<bool> onChanged;

  const SettingsSwitchItem({
    super.key,
    required this.title,
    this.description,
    required this.initialValue,
    required this.onChanged,
  });

  @override
  State<SettingsSwitchItem> createState() => _SettingsSwitchItemState();
}

class _SettingsSwitchItemState extends State<SettingsSwitchItem> {
  late bool _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return SettingsItem(
      title: widget.title,
      description: widget.description,
      onTap: () {
        setState(() {
          _value = !_value;
        });
        widget.onChanged(_value);
      },
      trailing: Switch(
        value: _value,
        onChanged: (newValue) {
          setState(() {
            _value = newValue;
          });
          widget.onChanged(newValue);
        },
      ),
    );
  }
}
