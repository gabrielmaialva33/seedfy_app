import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/locale_provider.dart';
import 'responsive_builder.dart';

class OfflineIndicator extends StatelessWidget {
  final bool isOnline;
  final int? pendingSyncCount;
  final VoidCallback? onSyncPressed;
  final VoidCallback? onStatusPressed;

  const OfflineIndicator({
    super.key,
    required this.isOnline,
    this.pendingSyncCount,
    this.onSyncPressed,
    this.onStatusPressed,
  });

  @override
  Widget build(BuildContext context) {
    final localeProvider = context.watch<LocaleProvider>();
    final isPortuguese = localeProvider.locale.languageCode == 'pt';

    return ResponsiveBuilder(
      builder: (context, screenSize) {
        return MobileOptimizedCard(
          color: isOnline 
              ? Theme.of(context).colorScheme.surface 
              : Theme.of(context).colorScheme.errorContainer.withValues(alpha: 0.1),
          child: InkWell(
            onTap: onStatusPressed,
            child: Row(
              children: [
                // Connection status icon
                Container(
                  padding: EdgeInsets.all(
                    context.responsiveValue(mobile: 8, tablet: 6, desktop: 4),
                  ),
                  decoration: BoxDecoration(
                    color: isOnline 
                        ? Colors.green.withValues(alpha: 0.2)
                        : Colors.orange.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isOnline ? Icons.wifi : Icons.wifi_off,
                    color: isOnline ? Colors.green : Colors.orange,
                    size: context.responsiveValue(mobile: 20, tablet: 18, desktop: 16),
                  ),
                ),
                
                SizedBox(width: context.responsiveValue(mobile: 12, tablet: 10, desktop: 8)),

                // Status text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isOnline 
                            ? (isPortuguese ? 'Online' : 'Online')
                            : (isPortuguese ? 'Offline' : 'Offline'),
                        style: TextStyle(
                          fontSize: context.responsiveValue(mobile: 14, tablet: 13, desktop: 12),
                          fontWeight: FontWeight.w600,
                          color: isOnline ? Colors.green : Colors.orange,
                        ),
                      ),
                      if (pendingSyncCount != null && pendingSyncCount! > 0)
                        Text(
                          isPortuguese 
                              ? '$pendingSyncCount alterações pendentes'
                              : '$pendingSyncCount changes pending',
                          style: TextStyle(
                            fontSize: context.responsiveValue(mobile: 12, tablet: 11, desktop: 10),
                            color: Theme.of(context).textTheme.bodySmall?.color,
                          ),
                        ),
                      if (isOnline && (pendingSyncCount == null || pendingSyncCount == 0))
                        Text(
                          isPortuguese ? 'Sincronizado' : 'Synced',
                          style: TextStyle(
                            fontSize: context.responsiveValue(mobile: 12, tablet: 11, desktop: 10),
                            color: Theme.of(context).textTheme.bodySmall?.color,
                          ),
                        ),
                      if (!isOnline)
                        Text(
                          isPortuguese 
                              ? 'Dados salvos localmente'
                              : 'Data saved locally',
                          style: TextStyle(
                            fontSize: context.responsiveValue(mobile: 12, tablet: 11, desktop: 10),
                            color: Theme.of(context).textTheme.bodySmall?.color,
                          ),
                        ),
                    ],
                  ),
                ),

                // Sync button
                if (isOnline && pendingSyncCount != null && pendingSyncCount! > 0)
                  TouchOptimizedButton(
                    onPressed: onSyncPressed,
                    isSecondary: true,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.sync,
                          size: context.responsiveValue(mobile: 16, tablet: 14, desktop: 12),
                        ),
                        if (screenSize != ScreenSize.mobile) ...[
                          SizedBox(width: 4),
                          Text(
                            isPortuguese ? 'Sincronizar' : 'Sync',
                            style: TextStyle(
                              fontSize: context.responsiveValue(mobile: 12, tablet: 11, desktop: 10),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class OfflineStatusBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isOnline;
  final int? pendingSyncCount;
  final VoidCallback? onSyncPressed;

  const OfflineStatusBar({
    super.key,
    required this.isOnline,
    this.pendingSyncCount,
    this.onSyncPressed,
  });

  @override
  Widget build(BuildContext context) {
    final localeProvider = context.watch<LocaleProvider>();
    final isPortuguese = localeProvider.locale.languageCode == 'pt';

    if (isOnline && (pendingSyncCount == null || pendingSyncCount == 0)) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: isOnline 
          ? Theme.of(context).primaryColor.withValues(alpha: 0.1)
          : Colors.orange.withValues(alpha: 0.1),
      child: ResponsiveBuilder(
        builder: (context, screenSize) {
          return Row(
            children: [
              Icon(
                isOnline ? Icons.sync : Icons.wifi_off,
                size: 16,
                color: isOnline ? Theme.of(context).primaryColor : Colors.orange,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  isOnline
                      ? (isPortuguese 
                          ? '$pendingSyncCount alterações serão sincronizadas'
                          : '$pendingSyncCount changes will be synced')
                      : (isPortuguese 
                          ? 'Modo offline - dados salvos localmente'
                          : 'Offline mode - data saved locally'),
                  style: TextStyle(
                    fontSize: 12,
                    color: isOnline ? Theme.of(context).primaryColor : Colors.orange,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (isOnline && onSyncPressed != null)
                TextButton.icon(
                  onPressed: onSyncPressed,
                  icon: const Icon(Icons.sync, size: 16),
                  label: Text(
                    isPortuguese ? 'Sincronizar' : 'Sync',
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(40);
}

class OfflineBadge extends StatelessWidget {
  final bool isOnline;
  final bool showWhenOnline;

  const OfflineBadge({
    super.key,
    required this.isOnline,
    this.showWhenOnline = false,
  });

  @override
  Widget build(BuildContext context) {
    final localeProvider = context.watch<LocaleProvider>();
    final isPortuguese = localeProvider.locale.languageCode == 'pt';

    if (isOnline && !showWhenOnline) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isOnline ? Colors.green : Colors.orange,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isOnline ? Icons.wifi : Icons.wifi_off,
            color: Colors.white,
            size: 12,
          ),
          const SizedBox(width: 4),
          Text(
            isOnline
                ? (isPortuguese ? 'Online' : 'Online')
                : (isPortuguese ? 'Offline' : 'Offline'),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class SyncProgressIndicator extends StatefulWidget {
  final bool issyncing;
  final String? message;

  const SyncProgressIndicator({
    super.key,
    required this.issyncing,
    this.message,
  });

  @override
  State<SyncProgressIndicator> createState() => _SyncProgressIndicatorState();
}

class _SyncProgressIndicatorState extends State<SyncProgressIndicator>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _scaleController;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
  }

  @override
  void didUpdateWidget(SyncProgressIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.issyncing != oldWidget.issyncing) {
      if (widget.issyncing) {
        _rotationController.repeat();
        _scaleController.forward();
      } else {
        _rotationController.stop();
        _scaleController.reverse();
      }
    }
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localeProvider = context.watch<LocaleProvider>();
    final isPortuguese = localeProvider.locale.languageCode == 'pt';

    if (!widget.issyncing) {
      return const SizedBox.shrink();
    }

    return ScaleTransition(
      scale: CurvedAnimation(
        parent: _scaleController,
        curve: Curves.easeInOut,
      ),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              RotationTransition(
                turns: _rotationController,
                child: Icon(
                  Icons.sync,
                  color: Theme.of(context).primaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isPortuguese ? 'Sincronizando...' : 'Syncing...',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                    ),
                  ),
                  if (widget.message != null)
                    Text(
                      widget.message!,
                      style: TextStyle(
                        fontSize: 10,
                        color: Theme.of(context).textTheme.bodySmall?.color,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}