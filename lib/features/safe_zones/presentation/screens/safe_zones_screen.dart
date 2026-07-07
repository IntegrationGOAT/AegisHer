import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/design_tokens.dart';
import '../../../../theme/app_theme.dart';
import '../../../../core/widgets/glass_card.dart';
import '../../../../widgets/custom_app_bar.dart';
import '../../data/repositories/safe_zone_repository.dart';
import '../../domain/entities/safe_zone.dart';

class SafeZonesController extends StateNotifier<AsyncValue<List<SafeZone>>> {
  final Ref _ref;
  SafeZonesController(this._ref) : super(const AsyncValue.loading()) {
    _load();
  }

  Future<void> _load() async {
    state = const AsyncValue.loading();
    try {
      final zones = await _ref.read(safeZoneRepositoryProvider).list();
      if (!mounted) return;
      state = AsyncValue.data(zones);
    } catch (e, st) {
      if (!mounted) return;
      state = AsyncValue.error(e, st);
    }
  }
}

final safeZonesControllerProvider =
    StateNotifierProvider<SafeZonesController, AsyncValue<List<SafeZone>>>(
        (ref) => SafeZonesController(ref));

class SafeZonesScreen extends ConsumerStatefulWidget {
  const SafeZonesScreen({super.key});
  @override
  ConsumerState<SafeZonesScreen> createState() => _SZS();
}

class _SZS extends ConsumerState<SafeZonesScreen> {
  SafeZoneCategory? _filter;

  IconData _iconFor(SafeZoneCategory c) {
    switch (c) {
      case SafeZoneCategory.police:
        return Icons.local_police;
      case SafeZoneCategory.hospital:
        return Icons.local_hospital;
      case SafeZoneCategory.pharmacy:
        return Icons.local_pharmacy;
      case SafeZoneCategory.shelter:
        return Icons.home;
      case SafeZoneCategory.trustedBusiness:
        return Icons.storefront;
    }
  }

  Color _colorFor(SafeZoneCategory c) {
    switch (c) {
      case SafeZoneCategory.police:
        return AppTheme.electricCyan;
      case SafeZoneCategory.hospital:
        return AppTheme.signalRed;
      case SafeZoneCategory.pharmacy:
        return AppTheme.signalGreen;
      case SafeZoneCategory.shelter:
        return AppTheme.violet;
      case SafeZoneCategory.trustedBusiness:
        return AppTheme.signalAmber;
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(safeZonesControllerProvider);
    return Scaffold(
      appBar: const CustomAppBar(title: 'Safe Zones', showBackButton: true),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AegisSpacing.space4),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ChoiceChip(
                    label: const Text('All'),
                    selected: _filter == null,
                    onSelected: (_) => setState(() => _filter = null),
                  ),
                  const SizedBox(width: AegisSpacing.space2),
                  for (final c in SafeZoneCategory.values) ...[
                    ChoiceChip(
                      label: Text(c.name),
                      selected: _filter == c,
                      onSelected: (_) => setState(() => _filter = c),
                    ),
                    const SizedBox(width: AegisSpacing.space2),
                  ],
                ],
              ),
            ),
          ),
          Expanded(
            child: state.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(
                child: Text('Error: $e', style: const TextStyle(color: AppTheme.signalRed)),
              ),
              data: (zones) {
                final filtered = _filter == null
                    ? zones
                    : zones.where((z) => z.category == _filter).toList();
                if (filtered.isEmpty) {
                  return const Center(
                    child: Text('No safe zones in this category.',
                        style: TextStyle(color: AppTheme.textSecondary)),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(AegisSpacing.space4),
                  itemCount: filtered.length,
                  itemBuilder: (_, i) {
                    final z = filtered[i];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: AegisSpacing.space3),
                      child: GlassCard(
                        child: Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _colorFor(z.category).withValues(alpha: 0.2),
                                border: Border.all(color: _colorFor(z.category)),
                              ),
                              alignment: Alignment.center,
                              child: Icon(_iconFor(z.category), color: _colorFor(z.category)),
                            ),
                            const SizedBox(width: AegisSpacing.space4),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    z.name,
                                    style: const TextStyle(
                                      color: AppTheme.textPrimary,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    z.categoryLabel,
                                    style: TextStyle(
                                      color: _colorFor(z.category),
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    z.address,
                                    style: const TextStyle(
                                      color: AppTheme.textSecondary,
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      const Icon(Icons.directions_walk,
                                          size: 12, color: AppTheme.textSecondary),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${z.distanceKm.toStringAsFixed(1)} km',
                                        style: const TextStyle(
                                          color: AppTheme.textSecondary,
                                          fontSize: 11,
                                        ),
                                      ),
                                      if (z.rating != null) ...[
                                        const SizedBox(width: AegisSpacing.space3),
                                        const Icon(Icons.star,
                                            size: 12, color: AppTheme.signalAmber),
                                        const SizedBox(width: 4),
                                        Text(
                                          z.rating!.toStringAsFixed(1),
                                          style: const TextStyle(
                                            color: AppTheme.textSecondary,
                                            fontSize: 11,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ],
                              ),
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
    );
  }
}
