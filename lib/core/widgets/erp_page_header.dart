import 'package:flutter/material.dart';

/// Standardized, responsive ERP Page Header for Arham Autos Suite.
/// Provides a unified icon badge, bold title, single-line subtitle with ellipsis,
/// and responsive trailing action slots that prevent clipping on 1280x720 / 1366x768 screens.
class ErpPageHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final List<Widget>? actions;
  final Color? iconColor;
  final Color? iconBgColor;
  final EdgeInsetsGeometry? padding;

  const ErpPageHeader({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.actions,
    this.iconColor = Colors.white,
    this.iconBgColor = const Color(0xFF0F172A),
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Color(0xFFE2E8F0), width: 1),
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 780;

          final leadingAndTitle = Row(
            mainAxisSize: isNarrow ? MainAxisSize.max : MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: (iconBgColor ?? const Color(0xFF0F172A)).withValues(alpha: 0.15),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              const SizedBox(width: 14),
              Expanded(
                flex: isNarrow ? 1 : 0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                        letterSpacing: -0.3,
                        fontFamily: 'Inter',
                      ),
                    ),
                    if (subtitle != null && subtitle!.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF64748B),
                          fontFamily: 'Inter',
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          );

          Widget? rightContent;
          if (trailing != null) {
            rightContent = trailing;
          } else if (actions != null && actions!.isNotEmpty) {
            rightContent = Wrap(
              spacing: 10,
              runSpacing: 8,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: actions!,
            );
          }

          if (isNarrow) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                leadingAndTitle,
                if (rightContent != null) ...[
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: rightContent,
                  ),
                ],
              ],
            );
          }

          return Row(
            children: [
              Expanded(child: leadingAndTitle),
              if (rightContent != null) ...[
                const SizedBox(width: 16),
                Flexible(
                  flex: 0,
                  child: rightContent,
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}
