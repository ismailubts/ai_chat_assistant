import 'package:flutter/material.dart';

import 'responsive.dart';

/// A widget that builds different layouts based on screen size.
class ResponsiveBuilder extends StatelessWidget {
  /// Builder for mobile layout (required).
  final Widget Function(BuildContext context, BoxConstraints constraints)
  mobile;

  /// Builder for tablet layout (optional, defaults to mobile).
  final Widget Function(BuildContext context, BoxConstraints constraints)?
  tablet;

  /// Builder for desktop layout (optional, defaults to tablet or mobile).
  final Widget Function(BuildContext context, BoxConstraints constraints)?
  desktop;

  const ResponsiveBuilder({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (Responsive.isDesktop(context)) {
          return desktop?.call(context, constraints) ??
              tablet?.call(context, constraints) ??
              mobile(context, constraints);
        }

        if (Responsive.isTablet(context)) {
          return tablet?.call(context, constraints) ??
              mobile(context, constraints);
        }

        return mobile(context, constraints);
      },
    );
  }
}

/// A widget that shows different children based on screen size.
class ResponsiveWidget extends StatelessWidget {
  /// Widget for mobile layout (required).
  final Widget mobile;

  /// Widget for tablet layout (optional, defaults to mobile).
  final Widget? tablet;

  /// Widget for desktop layout (optional, defaults to tablet or mobile).
  final Widget? desktop;

  const ResponsiveWidget({
    super.key,
    required this.mobile,
    this.tablet,
    this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    if (Responsive.isDesktop(context)) {
      return desktop ?? tablet ?? mobile;
    }

    if (Responsive.isTablet(context)) {
      return tablet ?? mobile;
    }

    return mobile;
  }
}

/// A widget that provides responsive padding.
class ResponsivePadding extends StatelessWidget {
  final Widget child;
  final double? horizontal;
  final double? vertical;
  final double? all;

  const ResponsivePadding({
    super.key,
    required this.child,
    this.horizontal,
    this.vertical,
    this.all,
  });

  @override
  Widget build(BuildContext context) {
    final h = horizontal ?? all ?? Responsive.horizontalPadding(context);
    final v = vertical ?? all ?? 0;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: h, vertical: v),
      child: child,
    );
  }
}

/// A widget that constrains its child to a maximum width.
class ResponsiveConstrainedBox extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  final Alignment alignment;

  const ResponsiveConstrainedBox({
    super.key,
    required this.child,
    this.maxWidth = 1200,
    this.alignment = Alignment.topCenter,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}

/// A responsive grid widget that adapts columns based on screen size.
class ResponsiveGrid extends StatelessWidget {
  final List<Widget> children;
  final int? mobileColumns;
  final int? tabletColumns;
  final int? desktopColumns;
  final double spacing;
  final double runSpacing;

  const ResponsiveGrid({
    super.key,
    required this.children,
    this.mobileColumns,
    this.tabletColumns,
    this.desktopColumns,
    this.spacing = 16,
    this.runSpacing = 16,
  });

  @override
  Widget build(BuildContext context) {
    final columns = Responsive.value<int>(
      context,
      mobile: mobileColumns ?? 2,
      tablet: tabletColumns ?? 3,
      desktop: desktopColumns ?? 4,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth =
            (constraints.maxWidth - (spacing * (columns - 1))) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: runSpacing,
          children: children.map((child) {
            return SizedBox(width: itemWidth, child: child);
          }).toList(),
        );
      },
    );
  }
}
