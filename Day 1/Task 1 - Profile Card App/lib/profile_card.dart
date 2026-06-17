import 'package:flutter/material.dart';

class ProfileCard extends StatelessWidget {
  const ProfileCard({
    required this.status,
    required this.onStatusPressed,
    super.key,
  });

  final String status;
  final VoidCallback onStatusPressed;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 92,
                  height: 92,
                  decoration: BoxDecoration(
                    color: colors.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.person_outline,
                    size: 52,
                    color: colors.onPrimaryContainer,
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Maya Chen',
                        style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Junior Flutter Developer',
                        style: textTheme.titleMedium?.copyWith(color: colors.primary),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        status,
                        key: const Key('profileStatus'),
                        style: textTheme.bodyMedium?.copyWith(color: colors.secondary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              'Curious mobile developer focused on accessible, polished interfaces and practical cross-platform apps.',
              style: textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            const ContactRow(icon: Icons.email_outlined, label: 'maya.chen@example.com'),
            const SizedBox(height: 12),
            const ContactRow(icon: Icons.phone_outlined, label: '+36 30 555 0184'),
            const SizedBox(height: 12),
            const ContactRow(icon: Icons.location_on_outlined, label: 'Budapest, Hungary'),
            const SizedBox(height: 28),
            FilledButton.icon(
              onPressed: onStatusPressed,
              icon: const Icon(Icons.refresh),
              label: const Text('Update status'),
            ),
          ],
        ),
      ),
    );
  }
}

class ContactRow extends StatelessWidget {
  const ContactRow({
    required this.icon,
    required this.label,
    super.key,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Icon(icon, size: 22, color: Theme.of(context).colorScheme.primary),
        const SizedBox(width: 12),
        Expanded(child: Text(label)),
      ],
    );
  }
}
