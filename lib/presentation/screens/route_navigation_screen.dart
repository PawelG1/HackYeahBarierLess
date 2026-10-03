import 'package:flutter/material.dart';
import '../../core/design_system/design_system.dart';
import '../../domain/entities/route_node.dart';
import '../../domain/entities/route_result.dart';
import '../widgets/a11y_actions.dart';

class RouteNavigationScreen extends StatefulWidget {
  final RouteResult route;
  final List<RouteNode> allNodes;

  const RouteNavigationScreen({
    super.key,
    required this.route,
    required this.allNodes,
  });

  @override
  State<RouteNavigationScreen> createState() => _RouteNavigationScreenState();
}

class _RouteNavigationScreenState extends State<RouteNavigationScreen> {
  int _currentStepIndex = 0;

  void _nextStep() {
    if (_currentStepIndex < widget.route.steps.length - 1) {
      setState(() => _currentStepIndex++);
    }
  }

  void _prevStep() {
    if (_currentStepIndex > 0) {
      setState(() => _currentStepIndex--);
    }
  }

  void _finish() {
    Navigator.of(context).pop();
  }

  String _formatNodeName(String nodeId) {
    if (nodeId.startsWith('n-')) {
      final name = nodeId.substring(2).replaceAll('-', ' ');
      return name[0].toUpperCase() + name.substring(1);
    }
    return nodeId;
  }

  String _translateFeature(String feature) {
    switch (feature) {
      case 'flat_pavement':
        return 'Płaski chodnik';
      case 'stairs':
        return 'Schody';
      case 'asphalt_path':
        return 'Ścieżka asfaltowa';
      case 'crosswalk_no_signals':
        return 'Przejście bez świateł';
      case 'crosswalk_with_signals':
        return 'Przejście ze światłami';
      default:
        return feature;
    }
  }


  @override
  Widget build(BuildContext context) {
    final steps = widget.route.steps;
    final step = steps[_currentStepIndex];
    final progress = (_currentStepIndex + 1) / steps.length;

    final from = step.edge.from;
    final to = step.edge.to;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nawigacja'),
        actions: const [A11yActions()],
      ),
      body: SafeArea(
        child: Padding(
          padding: context.spacing.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Semantics(
                label: 'Postęp: Krok ${_currentStepIndex + 1} z ${steps.length}',
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: context.colors.surfaceContainerHighest,
                  color: context.colors.primary,
                ),
              ),
              SizedBox(height: context.spacing.base),
              Text(
                'Krok ${_currentStepIndex + 1} z ${steps.length}',
                style: context.typography.titleSmall.copyWith(
                  color: context.colors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: context.spacing.lg),
              Expanded(
                child: AppCard(
                  child: Padding(
                    padding: context.spacing.cardPadding,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.directions_walk,
                          size: 64, // Duży cel dla słabowidzących
                          color: context.colors.primary,
                        ),
                        SizedBox(height: context.spacing.md),
                        Text(
                          _translateFeature(step.edge.feature),
                          style: context.typography.titleLarge,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: context.spacing.md),
                        Text(
                          'Kieruj się od ${_formatNodeName(from)} do ${_formatNodeName(to)}',
                          style: context.typography.bodyLarge,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: context.spacing.md),
                        Text(
                          'Dystans: ${step.edge.distanceM} m',
                          style: context.typography.titleMedium.copyWith(
                            color: context.colors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: context.spacing.lg),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Semantics(
                    button: true,
                    label: 'Poprzedni krok',
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        padding: context.spacing.buttonDensePadding,
                        backgroundColor: context.colors.surfaceContainerHighest,
                        foregroundColor: context.colors.onSurface,
                      ),
                      onPressed: _currentStepIndex > 0 ? _prevStep : null,
                      icon: const Icon(Icons.arrow_back),
                      label: const Text('Poprzedni'),
                    ),
                  ),
                  if (_currentStepIndex < steps.length - 1)
                    Semantics(
                      button: true,
                      label: 'Następny krok',
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: context.colors.primary,
                          foregroundColor: context.colors.onPrimary,
                          padding: context.spacing.buttonDensePadding,
                        ),
                        onPressed: _nextStep,
                        icon: const Icon(Icons.arrow_forward),
                        label: const Text('Następny'),
                      ),
                    )
                  else
                    Semantics(
                      button: true,
                      label: 'Zakończ nawigację',
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: context.colors.statusConfirmedBg,
                          foregroundColor: context.colors.statusConfirmedFg,
                          padding: context.spacing.buttonDensePadding,
                        ),
                        onPressed: _finish,
                        icon: const Icon(Icons.check),
                        label: const Text('Zakończ'),
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
