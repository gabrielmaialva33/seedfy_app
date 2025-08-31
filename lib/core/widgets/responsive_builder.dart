import 'package:flutter/material.dart';

enum ScreenSize { mobile, tablet, desktop }

class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext, ScreenSize) builder;
  final double mobileMaxWidth;
  final double tabletMaxWidth;

  const ResponsiveBuilder({
    super.key,
    required this.builder,
    this.mobileMaxWidth = 600,
    this.tabletMaxWidth = 1200,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenSize = _getScreenSize(constraints.maxWidth);
        return builder(context, screenSize);
      },
    );
  }

  ScreenSize _getScreenSize(double width) {
    if (width < mobileMaxWidth) {
      return ScreenSize.mobile;
    } else if (width < tabletMaxWidth) {
      return ScreenSize.tablet;
    } else {
      return ScreenSize.desktop;
    }
  }
}

class ResponsiveWidget extends StatelessWidget {
  final Widget? mobile;
  final Widget? tablet;
  final Widget? desktop;
  final Widget? fallback;

  const ResponsiveWidget({
    super.key,
    this.mobile,
    this.tablet,
    this.desktop,
    this.fallback,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, screenSize) {
        switch (screenSize) {
          case ScreenSize.mobile:
            return mobile ?? fallback ?? const SizedBox.shrink();
          case ScreenSize.tablet:
            return tablet ?? mobile ?? fallback ?? const SizedBox.shrink();
          case ScreenSize.desktop:
            return desktop ??
                tablet ??
                mobile ??
                fallback ??
                const SizedBox.shrink();
        }
      },
    );
  }
}

class ResponsiveValue<T> {
  final T mobile;
  final T? tablet;
  final T? desktop;

  const ResponsiveValue({
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  T getValue(ScreenSize screenSize) {
    switch (screenSize) {
      case ScreenSize.mobile:
        return mobile;
      case ScreenSize.tablet:
        return tablet ?? mobile;
      case ScreenSize.desktop:
        return desktop ?? tablet ?? mobile;
    }
  }
}

extension ResponsiveExtension on BuildContext {
  ScreenSize get screenSize {
    final width = MediaQuery.of(this).size.width;
    if (width < 600) {
      return ScreenSize.mobile;
    } else if (width < 1200) {
      return ScreenSize.tablet;
    } else {
      return ScreenSize.desktop;
    }
  }

  bool get isMobile => screenSize == ScreenSize.mobile;

  bool get isTablet => screenSize == ScreenSize.tablet;

  bool get isDesktop => screenSize == ScreenSize.desktop;

  double responsiveValue({
    required double mobile,
    double? tablet,
    double? desktop,
  }) {
    switch (screenSize) {
      case ScreenSize.mobile:
        return mobile;
      case ScreenSize.tablet:
        return tablet ?? mobile;
      case ScreenSize.desktop:
        return desktop ?? tablet ?? mobile;
    }
  }

  EdgeInsets get responsivePadding {
    switch (screenSize) {
      case ScreenSize.mobile:
        return const EdgeInsets.all(16);
      case ScreenSize.tablet:
        return const EdgeInsets.all(24);
      case ScreenSize.desktop:
        return const EdgeInsets.all(32);
    }
  }

  double get responsiveMaxWidth {
    switch (screenSize) {
      case ScreenSize.mobile:
        return double.infinity;
      case ScreenSize.tablet:
        return 800;
      case ScreenSize.desktop:
        return 1200;
    }
  }
}

class AdaptiveScaffold extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget? body;
  final Widget? drawer;
  final Widget? endDrawer;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final FloatingActionButtonLocation? floatingActionButtonLocation;
  final bool extendBodyBehindAppBar;
  final Color? backgroundColor;

  const AdaptiveScaffold({
    super.key,
    this.appBar,
    this.body,
    this.drawer,
    this.endDrawer,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.extendBodyBehindAppBar = false,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, screenSize) {
        // For mobile, use standard Scaffold
        if (screenSize == ScreenSize.mobile) {
          return Scaffold(
            appBar: appBar,
            body: body,
            drawer: drawer,
            endDrawer: endDrawer,
            bottomNavigationBar: bottomNavigationBar,
            floatingActionButton: floatingActionButton,
            floatingActionButtonLocation: floatingActionButtonLocation,
            extendBodyBehindAppBar: extendBodyBehindAppBar,
            backgroundColor: backgroundColor,
          );
        }

        // For tablet/desktop, adapt layout
        return Scaffold(
          backgroundColor: backgroundColor,
          body: Row(
            children: [
              // Permanent sidebar for larger screens
              if (drawer != null && screenSize != ScreenSize.mobile)
                SizedBox(
                  width: 280,
                  child: drawer!,
                ),

              // Main content area
              Expanded(
                child: Column(
                  children: [
                    if (appBar != null) appBar!,
                    Expanded(
                      child: body ?? const SizedBox.shrink(),
                    ),
                  ],
                ),
              ),

              // End drawer for larger screens
              if (endDrawer != null && screenSize != ScreenSize.mobile)
                SizedBox(
                  width: 280,
                  child: endDrawer!,
                ),
            ],
          ),
          floatingActionButton: floatingActionButton,
          floatingActionButtonLocation: floatingActionButtonLocation,
        );
      },
    );
  }
}

class MobileOptimizedCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final double? elevation;
  final BorderRadius? borderRadius;

  const MobileOptimizedCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.color,
    this.elevation,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, screenSize) {
        final defaultPadding = EdgeInsets.all(
          context.responsiveValue(mobile: 12, tablet: 16, desktop: 20),
        );

        final defaultMargin = EdgeInsets.all(
          context.responsiveValue(mobile: 8, tablet: 12, desktop: 16),
        );

        return Card(
          margin: margin ?? defaultMargin,
          color: color,
          elevation: elevation ?? (screenSize == ScreenSize.mobile ? 2 : 4),
          shape: RoundedRectangleBorder(
            borderRadius: borderRadius ??
                BorderRadius.circular(
                  context.responsiveValue(mobile: 12, tablet: 16, desktop: 20),
                ),
          ),
          child: Padding(
            padding: padding ?? defaultPadding,
            child: child,
          ),
        );
      },
    );
  }
}

class AdaptiveGrid extends StatelessWidget {
  final List<Widget> children;
  final double? crossAxisSpacing;
  final double? mainAxisSpacing;
  final double? childAspectRatio;
  final ScrollPhysics? physics;
  final bool shrinkWrap;

  const AdaptiveGrid({
    super.key,
    required this.children,
    this.crossAxisSpacing,
    this.mainAxisSpacing,
    this.childAspectRatio,
    this.physics,
    this.shrinkWrap = false,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, screenSize) {
        final crossAxisCount = context
            .responsiveValue(
              mobile: 1,
              tablet: 2,
              desktop: 3,
            )
            .round();

        return GridView.count(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: crossAxisSpacing ?? 16,
          mainAxisSpacing: mainAxisSpacing ?? 16,
          childAspectRatio: childAspectRatio ?? 1.0,
          physics: physics,
          shrinkWrap: shrinkWrap,
          children: children,
        );
      },
    );
  }
}

class TouchOptimizedButton extends StatelessWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final bool isSecondary;
  final bool isDestructive;
  final double? width;
  final EdgeInsetsGeometry? padding;

  const TouchOptimizedButton({
    super.key,
    required this.child,
    this.onPressed,
    this.isSecondary = false,
    this.isDestructive = false,
    this.width,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    const minTouchTarget = 48.0;

    return ResponsiveBuilder(
      builder: (context, screenSize) {
        final buttonHeight = context.responsiveValue(
          mobile: minTouchTarget,
          tablet: 44,
          desktop: 40,
        );

        final buttonPadding = padding ??
            EdgeInsets.symmetric(
              horizontal:
                  context.responsiveValue(mobile: 24, tablet: 20, desktop: 16),
              vertical:
                  context.responsiveValue(mobile: 12, tablet: 10, desktop: 8),
            );

        if (isDestructive) {
          return SizedBox(
            width: width,
            height: buttonHeight,
            child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: buttonPadding,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: child,
            ),
          );
        }

        if (isSecondary) {
          return SizedBox(
            width: width,
            height: buttonHeight,
            child: OutlinedButton(
              onPressed: onPressed,
              style: OutlinedButton.styleFrom(
                padding: buttonPadding,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: child,
            ),
          );
        }

        return SizedBox(
          width: width,
          height: buttonHeight,
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              padding: buttonPadding,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: child,
          ),
        );
      },
    );
  }
}
