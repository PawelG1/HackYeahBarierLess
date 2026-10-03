import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/design_system/design_system.dart';
import '../viewmodels/route_setup_vm.dart';
import 'route_setup_screen.dart';
import '../widgets/a11y_actions.dart';

class Attraction {
  final String id;
  final String name;
  final IconData icon;
  final String imageUrl;

  const Attraction(this.id, this.name, this.icon, this.imageUrl);
}

const attractions = [
  Attraction('p-teatr-slowackiego', 'Teatr im. Juliusza Słowackiego', Icons.theater_comedy, 'assets/images/attractions/teatr_slowackiego.jpg'),
  Attraction('p-wawel', 'Zamek Królewski na Wawelu', Icons.castle, 'assets/images/attractions/wawel.jpg'),
  Attraction('p-sukiennice', 'Sukiennice', Icons.museum, 'assets/images/attractions/sukiennice.jpg'),
  Attraction('p-brama-florianska', 'Brama Floriańska i Mury Miejskie', Icons.fort, 'assets/images/attractions/brama_florianska.jpg'),
  Attraction('p-barbakan', 'Barbakan Krakowski', Icons.shield, 'assets/images/attractions/barbakan.jpg'),
  Attraction('p-bunkier-sztuki', 'Bunkier Sztuki', Icons.palette, 'assets/images/attractions/bunkier_sztuki.jpg'),
  Attraction('p-galeria-krakowska', 'Galeria Krakowska', Icons.shopping_bag, 'assets/images/attractions/galeria_krakowska.jpg'),
];

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Odkryj Kraków',
          style: context.typography.titleLarge,
        ),
        actions: const [A11yActions()],
      ),
      body: SafeArea(
        child: Padding(
          padding: context.spacing.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Gdzie chcesz się dzisiaj wybrać?',
                style: context.typography.titleLarge,
              ),
              SizedBox(height: context.spacing.sm),
              Text(
                'Wybierz cel, a my wyznaczymy dla Ciebie bezpieczną i przystępną trasę, omijając bariery architektoniczne.',
                style: context.typography.bodyLarge.copyWith(
                  color: context.colors.textSecondary,
                ),
              ),
              SizedBox(height: context.spacing.xl),
              Expanded(
                child: ListView.separated(
                  itemCount: attractions.length,
                  separatorBuilder: (context, index) => SizedBox(height: context.spacing.md),
                  itemBuilder: (context, index) {
                    final attraction = attractions[index];
                    return Semantics(
                      label: 'Atrakcja: ${attraction.name}',
                      button: true,
                      child: AppCard(
                        child: InkWell(
                          onTap: () {
                            // Select destination in VM and navigate
                            ref.read(routeSetupVmProvider.notifier).selectDestinationPlace(attraction.id);
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => const RouteSetupScreen(),
                              ),
                            );
                          },
                          borderRadius: context.radii.card,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.vertical(top: context.radii.card.topLeft),
                                child: Image.asset(
                                  attraction.imageUrl,
                                  height: 120,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      height: 120,
                                      color: context.colors.surfaceContainerHighest,
                                      child: Icon(
                                        attraction.icon,
                                        size: 48,
                                        color: context.colors.textMuted,
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Padding(
                                padding: context.spacing.cardPadding,
                                child: Row(
                                  children: [
                                    Container(
                                      padding: context.spacing.inputContentPadding,
                                      decoration: BoxDecoration(
                                        color: context.colors.primary.withAlpha(25),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        attraction.icon,
                                        size: context.dimensions.iconLarge,
                                        color: context.colors.primary,
                                      ),
                                    ),
                                    SizedBox(width: context.spacing.lg),
                                    Expanded(
                                      child: Text(
                                        attraction.name,
                                        style: context.typography.titleMedium,
                                      ),
                                    ),
                                    Icon(
                                      Icons.chevron_right,
                                      color: context.colors.textMuted,
                                      size: context.dimensions.iconLarge,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
