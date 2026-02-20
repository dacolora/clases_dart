import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Col en Ruta - Purchase Confirmation Screen (Azarosa Edition)
/// - Confetti animation (no packages)
/// - Animated sections reveal
/// - Trip summary, passengers, itinerary timeline, payment breakdown
/// - Tickets cards + QR placeholder
/// - Premium-ish UI: gradients, glass, shadows, micro-interactions
///
/// Drop this file into your project and use:
/// Navigator.push(context, MaterialPageRoute(builder: (_) => PurchaseConfirmationScreen.demo()));
///
/// You can wire real data by using PurchaseConfirmationArgs model.
class PurchaseConfirmationScreen extends StatefulWidget {
  final PurchaseConfirmationArgs args;

  const PurchaseConfirmationScreen({super.key, required this.args});

  factory PurchaseConfirmationScreen.demo() {
    return PurchaseConfirmationScreen(
      args: PurchaseConfirmationArgs(
        orderId: 'CR-2026-0219-8F3A',
        purchaseDate: DateTime.now(),
        status: PurchaseStatus.confirmed,
        totalCOP: 489000,
        currency: 'COP',
        paymentMethod: PaymentMethod(
          type: PaymentType.card,
          label: 'Visa •••• 1284',
          installmentInfo: '1 cuota',
          paidAt: DateTime.now(),
        ),
        contactEmail: 'daniel@example.com',
        contactPhone: '+57 300 000 0000',
        trip: TripSummary(
          title: 'Medellín → Jardín (Ruta Café & Miradores)',
          subtitle: 'Transporte + Guía + Paradas top',
          heroTag: 'JARDIN_TRIP',
          coverGradient: const LinearGradient(
            colors: [Color(0xFF0B1220), Color(0xFF0C2E4A), Color(0xFF0B1220)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          dates: TripDates(
            start: DateTime.now().add(const Duration(days: 2, hours: 7)),
            end: DateTime.now().add(const Duration(days: 2, hours: 18)),
          ),
          origin: 'Medellín',
          destination: 'Jardín',
          meetingPoint: 'Estación Poblado - Salida principal',
          providerName: 'Col en Ruta • Tours',
          providerBadge: 'RNT Verificado',
          vehicleInfo: 'Van turística (A/C) • 12 pasajeros',
          groupSizeMax: 12,
          language: 'Español',
          difficulty: 'Suave',
          included: const [
            'Transporte ida y vuelta',
            'Guía local',
            'Seguro de viaje',
            'Parada en mirador',
            'Tiempo libre en el pueblo',
          ],
          notIncluded: const [
            'Almuerzo (opcional)',
            'Compras personales',
          ],
          notes:
              'Llega 15 minutos antes. Lleva bloqueador y chaqueta ligera. Si llueve, se ajustan algunas paradas.',
          itinerary: [
            ItineraryStop(
              timeLabel: '07:00',
              title: 'Encuentro',
              description: 'Check-in + asignación de asientos',
              location: 'Estación Poblado',
              icon: Icons.location_on_rounded,
            ),
            ItineraryStop(
              timeLabel: '07:30',
              title: 'Salida',
              description: 'Ruta panorámica con música suave',
              location: 'Medellín',
              icon: Icons.directions_bus_rounded,
            ),
            ItineraryStop(
              timeLabel: '09:30',
              title: 'Mirador',
              description: 'Fotos épicas + café',
              location: 'Mirador',
              icon: Icons.photo_camera_rounded,
            ),
            ItineraryStop(
              timeLabel: '11:30',
              title: 'Jardín',
              description: 'Recorrido guiado + plaza',
              location: 'Parque principal',
              icon: Icons.park_rounded,
            ),
            ItineraryStop(
              timeLabel: '14:00',
              title: 'Tiempo libre',
              description: 'Almuerzo + callejear',
              location: 'Jardín',
              icon: Icons.restaurant_rounded,
            ),
            ItineraryStop(
              timeLabel: '16:00',
              title: 'Regreso',
              description: 'Salida hacia Medellín',
              location: 'Jardín',
              icon: Icons.route_rounded,
            ),
            ItineraryStop(
              timeLabel: '18:00',
              title: 'Llegada',
              description: 'Fin del tour',
              location: 'Medellín',
              icon: Icons.flag_rounded,
            ),
          ],
        ),
        passengers: [
          Passenger(
            fullName: 'Daniel Alejandro Colorado',
            documentType: 'CC',
            documentNumber: '1.234.567.890',
            phone: '+57 300 111 2233',
            seat: '3A',
            ticketType: 'Adulto',
            specialNotes: 'Sin restricciones',
          ),
          Passenger(
            fullName: 'Daniela',
            documentType: 'CC',
            documentNumber: '9.876.543.210',
            phone: '+57 300 999 8888',
            seat: '3B',
            ticketType: 'Adulto',
            specialNotes: 'Vegetariana',
          ),
        ],
        pricing: PricingBreakdown(
          items: [
            PricingLine(label: 'Ticket Adulto x2', amountCOP: 420000),
            PricingLine(label: 'Fee plataforma', amountCOP: 29000),
            PricingLine(label: 'Seguro', amountCOP: 40000),
          ],
          discount: PricingLine(label: 'Descuento promo', amountCOP: -0),
          taxes: PricingLine(label: 'IVA', amountCOP: 0),
        ),
        policies: const [
          'Cancelación gratis hasta 24h antes.',
          'Reprogramación sujeta a cupos.',
          'Presenta tu QR al abordar.',
        ],
        achievements: const [
          PurchaseAchievement(
            title: 'Primera Ruta Confirmada',
            subtitle: '+120 XP viajero',
            icon: Icons.auto_awesome_rounded,
          ),
          PurchaseAchievement(
            title: 'Explorador Activo',
            subtitle: 'Badge desbloqueado',
            icon: Icons.emoji_events_rounded,
          ),
        ],
      ),
    );
  }

  @override
  State<PurchaseConfirmationScreen> createState() => _PurchaseConfirmationScreenState();
}

class _PurchaseConfirmationScreenState extends State<PurchaseConfirmationScreen>
    with TickerProviderStateMixin {
  late final AnimationController _intro;
  late final AnimationController _confetti;
  late final AnimationController _pulse;
  late final ScrollController _scroll;

  late final List<SectionRevealController> _sections;

  bool _showTopBadge = true;

  @override
  void initState() {
    super.initState();
    _scroll = ScrollController();

    _intro = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _confetti = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    );

    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _sections = List.generate(7, (_) => SectionRevealController());

    _scroll.addListener(_onScroll);

    // Start animations
    _intro.forward();
    _pulse.repeat(reverse: true);
    _confetti.forward();

    // Stagger reveal sections
    _staggerReveal();
  }

  void _onScroll() {
    final offset = _scroll.offset;
    final nextShow = offset < 50;
    if (nextShow != _showTopBadge) {
      setState(() => _showTopBadge = nextShow);
    }
  }

  Future<void> _staggerReveal() async {
    // Small staged reveals to feel "premium"
    for (int i = 0; i < _sections.length; i++) {
      await Future<void>.delayed(Duration(milliseconds: 140 + (i * 90)));
      if (!mounted) return;
      _sections[i].reveal();
    }
  }

  @override
  void dispose() {
    _intro.dispose();
    _confetti.dispose();
    _pulse.dispose();
    _scroll.dispose();
    for (final s in _sections) {
      s.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final args = widget.args;
    final theme = Theme.of(context);

    return Theme(
      data: theme.copyWith(
        scaffoldBackgroundColor: const Color(0xFF070B12),
        textTheme: theme.textTheme.apply(
          bodyColor: const Color(0xFFEAF1FF),
          displayColor: const Color(0xFFEAF1FF),
        ),
      ),
      child: Scaffold(
        body: Stack(
          children: [
            // Background gradient + noise-ish overlay
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: args.trip.coverGradient,
                ),
              ),
            ),
            Positioned.fill(
              child: IgnorePointer(
                child: Opacity(
                  opacity: 0.06,
                  child: CustomPaint(
                    painter: _NoisePainter(seed: args.orderId.hashCode),
                  ),
                ),
              ),
            ),

            // Confetti overlay
            Positioned.fill(
              child: IgnorePointer(
                child: AnimatedBuilder(
                  animation: _confetti,
                  builder: (context, _) {
                    return CustomPaint(
                      painter: ConfettiPainter(
                        progress: _confetti.value,
                        seed: args.orderId.hashCode,
                        // Optional: reduce density if you want
                        density: 1.0,
                      ),
                    );
                  },
                ),
              ),
            ),

            // Content
            CustomScrollView(
              controller: _scroll,
              physics: const BouncingScrollPhysics(),
              slivers: [
                _buildSliverAppBar(context, args),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
                    child: Column(
                      children: [
                        SectionReveal(
                          controller: _sections[0],
                          child: _HeroSuccessHeader(
                            args: args,
                            intro: _intro,
                            pulse: _pulse,
                          ),
                        ),
                        const SizedBox(height: 14),

                        SectionReveal(
                          controller: _sections[1],
                          child: _TripSummaryCard(args: args),
                        ),
                        const SizedBox(height: 14),

                        SectionReveal(
                          controller: _sections[2],
                          child: _TicketsCard(args: args),
                        ),
                        const SizedBox(height: 14),

                        SectionReveal(
                          controller: _sections[3],
                          child: _PassengersCard(args: args),
                        ),
                        const SizedBox(height: 14),

                        SectionReveal(
                          controller: _sections[4],
                          child: _ItineraryTimelineCard(args: args),
                        ),
                        const SizedBox(height: 14),

                        SectionReveal(
                          controller: _sections[5],
                          child: _PaymentBreakdownCard(args: args),
                        ),
                        const SizedBox(height: 14),

                        SectionReveal(
                          controller: _sections[6],
                          child: _PostActionsAndPolicies(args: args),
                        ),

                        const SizedBox(height: 28),
                        _BottomSafeAreaSpacer(),
                      ],
                    ),
                  ),
                )
              ],
            ),

            // Top floating badge (order id + status)
            Positioned(
              top: MediaQuery.of(context).padding.top + 10,
              left: 12,
              right: 12,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 220),
                opacity: _showTopBadge ? 1 : 0,
                child: _TopFloatingBadge(args: args),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context, PurchaseConfirmationArgs args) {
    return SliverAppBar(
      pinned: true,
      expandedHeight: 150,
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: _GlassIconButton(
        icon: Icons.arrow_back_rounded,
        onTap: () => Navigator.maybePop(context),
      ),
      actions: [
        _GlassIconButton(
          icon: Icons.help_outline_rounded,
          onTap: () => _showHelp(context, args),
        ),
        const SizedBox(width: 10),
      ],
      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {
          final t = ((constraints.biggest.height - kToolbarHeight) / (150 - kToolbarHeight))
              .clamp(0.0, 1.0);
          return FlexibleSpaceBar(
            titlePadding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 12),
            title: Opacity(
              opacity: 0.65 + (0.35 * (1 - t)),
              child: Text(
                'Compra confirmada',
                style: const TextStyle(
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.2,
                ),
              ),
            ),
            background: Padding(
              padding: const EdgeInsets.fromLTRB(16, 60, 16, 16),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: AnimatedBuilder(
                  animation: _intro,
                  builder: (context, _) {
                    final p = Curves.easeOutCubic.transform(_intro.value);
                    return Transform.translate(
                      offset: Offset(0, (1 - p) * 12),
                      child: Opacity(
                        opacity: p,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            _StatusPill(status: args.status),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                args.trip.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _showHelp(BuildContext context, PurchaseConfirmationArgs args) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) {
        return _GlassSheet(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _SheetHandle(),
                const SizedBox(height: 8),
                const Text(
                  'Ayuda rápida',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 10),
                _HelpRow(
                  icon: Icons.qr_code_2_rounded,
                  title: 'Tu QR',
                  subtitle: 'Lo presentas al abordar. También lo enviamos a tu correo.',
                ),
                _HelpRow(
                  icon: Icons.edit_calendar_rounded,
                  title: 'Cambios',
                  subtitle: 'Reprogramación sujeta a cupos. Revisa las políticas.',
                ),
                _HelpRow(
                  icon: Icons.support_agent_rounded,
                  title: 'Soporte',
                  subtitle: 'Escríbenos por WhatsApp o chat interno de Col en Ruta.',
                ),
                const SizedBox(height: 14),
                _PrimaryButton(
                  label: 'Entendido',
                  icon: Icons.check_rounded,
                  onTap: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// ==========================
/// MODELS
/// ==========================
class PurchaseConfirmationArgs {
  final String orderId;
  final DateTime purchaseDate;
  final PurchaseStatus status;

  final TripSummary trip;
  final List<Passenger> passengers;

  final PricingBreakdown pricing;
  final int totalCOP;
  final String currency;

  final PaymentMethod paymentMethod;
  final String contactEmail;
  final String contactPhone;

  final List<String> policies;
  final List<PurchaseAchievement> achievements;

  PurchaseConfirmationArgs({
    required this.orderId,
    required this.purchaseDate,
    required this.status,
    required this.trip,
    required this.passengers,
    required this.pricing,
    required this.totalCOP,
    required this.currency,
    required this.paymentMethod,
    required this.contactEmail,
    required this.contactPhone,
    required this.policies,
    required this.achievements,
  });
}

enum PurchaseStatus { confirmed, pending, failed }

class TripSummary {
  final String title;
  final String subtitle;
  final String heroTag;
  final Gradient coverGradient;

  final TripDates dates;
  final String origin;
  final String destination;
  final String meetingPoint;

  final String providerName;
  final String providerBadge;

  final String vehicleInfo;
  final int groupSizeMax;
  final String language;
  final String difficulty;

  final List<String> included;
  final List<String> notIncluded;
  final String notes;

  final List<ItineraryStop> itinerary;

  TripSummary({
    required this.title,
    required this.subtitle,
    required this.heroTag,
    required this.coverGradient,
    required this.dates,
    required this.origin,
    required this.destination,
    required this.meetingPoint,
    required this.providerName,
    required this.providerBadge,
    required this.vehicleInfo,
    required this.groupSizeMax,
    required this.language,
    required this.difficulty,
    required this.included,
    required this.notIncluded,
    required this.notes,
    required this.itinerary,
  });
}

class TripDates {
  final DateTime start;
  final DateTime end;
  TripDates({required this.start, required this.end});
}

class Passenger {
  final String fullName;
  final String documentType;
  final String documentNumber;
  final String phone;
  final String seat;
  final String ticketType;
  final String specialNotes;

  Passenger({
    required this.fullName,
    required this.documentType,
    required this.documentNumber,
    required this.phone,
    required this.seat,
    required this.ticketType,
    required this.specialNotes,
  });
}

class PricingBreakdown {
  final List<PricingLine> items;
  final PricingLine discount;
  final PricingLine taxes;

  PricingBreakdown({
    required this.items,
    required this.discount,
    required this.taxes,
  });
}

class PricingLine {
  final String label;
  final int amountCOP;
  PricingLine({required this.label, required this.amountCOP});
}

enum PaymentType { card, pse, cash, wallet }

class PaymentMethod {
  final PaymentType type;
  final String label;
  final String installmentInfo;
  final DateTime paidAt;

  PaymentMethod({
    required this.type,
    required this.label,
    required this.installmentInfo,
    required this.paidAt,
  });
}

class PurchaseAchievement {
  final String title;
  final String subtitle;
  final IconData icon;
  const PurchaseAchievement({
    required this.title,
    required this.subtitle,
    required this.icon,
  });
}

class ItineraryStop {
  final String timeLabel;
  final String title;
  final String description;
  final String location;
  final IconData icon;

  ItineraryStop({
    required this.timeLabel,
    required this.title,
    required this.description,
    required this.location,
    required this.icon,
  });
}

/// ==========================
/// TOP BADGE
/// ==========================
class _TopFloatingBadge extends StatelessWidget {
  final PurchaseConfirmationArgs args;
  const _TopFloatingBadge({required this.args});

  @override
  Widget build(BuildContext context) {
    return _GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      radius: 18,
      child: Row(
        children: [
          _StatusDot(status: args.status),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Orden: ${args.orderId}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
          const SizedBox(width: 10),
          _MiniChip(label: _formatDate(args.purchaseDate)),
        ],
      ),
    );
  }
}

/// ==========================
/// HERO HEADER
/// ==========================
class _HeroSuccessHeader extends StatelessWidget {
  final PurchaseConfirmationArgs args;
  final AnimationController intro;
  final AnimationController pulse;

  const _HeroSuccessHeader({
    required this.args,
    required this.intro,
    required this.pulse,
  });

  @override
  Widget build(BuildContext context) {
    final p = Curves.easeOutCubic.transform(intro.value);

    return _GlassCard(
      padding: const EdgeInsets.fromLTRB(14, 16, 14, 16),
      radius: 24,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AnimatedBuilder(
                animation: pulse,
                builder: (context, _) {
                  final s = 1.0 + (0.06 * Curves.easeInOut.transform(pulse.value));
                  return Transform.scale(
                    scale: s,
                    child: _SuccessMedal(status: args.status),
                  );
                },
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Transform.translate(
                  offset: Offset(0, (1 - p) * 6),
                  child: Opacity(
                    opacity: p,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '¡Qué chimba! Tu ruta está lista.',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            letterSpacing: -0.2,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Te mandamos el comprobante y los tickets al correo. '
                          'Solo muestra tu QR al abordar.',
                          style: TextStyle(
                            height: 1.25,
                            color: Colors.white.withOpacity(0.85),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _InfoPill(icon: Icons.mail_rounded, label: args.contactEmail),
              _InfoPill(icon: Icons.phone_rounded, label: args.contactPhone),
              _InfoPill(icon: Icons.verified_rounded, label: args.trip.providerBadge),
            ],
          ),
          const SizedBox(height: 14),
          _AchievementStrip(achievements: args.achievements),
        ],
      ),
    );
  }
}

class _SuccessMedal extends StatelessWidget {
  final PurchaseStatus status;
  const _SuccessMedal({required this.status});

  @override
  Widget build(BuildContext context) {
    final icon = switch (status) {
      PurchaseStatus.confirmed => Icons.check_circle_rounded,
      PurchaseStatus.pending => Icons.hourglass_top_rounded,
      PurchaseStatus.failed => Icons.error_rounded,
    };
    final glow = switch (status) {
      PurchaseStatus.confirmed => const Color(0xFF2EF2A6),
      PurchaseStatus.pending => const Color(0xFFFFD46A),
      PurchaseStatus.failed => const Color(0xFFFF6B6B),
    };

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            glow.withOpacity(0.95),
            glow.withOpacity(0.35),
            Colors.transparent,
          ],
          stops: const [0.0, 0.55, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: glow.withOpacity(0.28),
            blurRadius: 26,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Center(
        child: Icon(icon, size: 28, color: const Color(0xFF061018)),
      ),
    );
  }
}

class _AchievementStrip extends StatelessWidget {
  final List<PurchaseAchievement> achievements;
  const _AchievementStrip({required this.achievements});

  @override
  Widget build(BuildContext context) {
    if (achievements.isEmpty) return const SizedBox.shrink();

    return _GlassCard(
      radius: 18,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recompensas desbloqueadas',
            style: TextStyle(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 10),
          Column(
            children: achievements
                .map((a) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          _MiniIconBadge(icon: a.icon),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  a.title,
                                  style: const TextStyle(fontWeight: FontWeight.w900),
                                ),
                                Text(
                                  a.subtitle,
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.78),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ))
                .toList(),
          )
        ],
      ),
    );
  }
}

/// ==========================
/// TRIP SUMMARY CARD
/// ==========================
class _TripSummaryCard extends StatelessWidget {
  final PurchaseConfirmationArgs args;
  const _TripSummaryCard({required this.args});

  @override
  Widget build(BuildContext context) {
    final trip = args.trip;
    final dateRange = '${_formatShortDate(trip.dates.start)} • ${_formatHour(trip.dates.start)}'
        ' → ${_formatHour(trip.dates.end)}';

    return _GlassCard(
      radius: 24,
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  trip.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.1,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              _MiniChip(label: args.trip.difficulty),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            trip.subtitle,
            style: TextStyle(
              color: Colors.white.withOpacity(0.85),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          _KeyValueGrid(
            items: [
              _KV(icon: Icons.calendar_month_rounded, k: 'Fecha', v: dateRange),
              _KV(icon: Icons.route_rounded, k: 'Ruta', v: '${trip.origin} → ${trip.destination}'),
              _KV(icon: Icons.place_rounded, k: 'Punto', v: trip.meetingPoint),
              _KV(icon: Icons.directions_bus_rounded, k: 'Vehículo', v: trip.vehicleInfo),
              _KV(icon: Icons.groups_2_rounded, k: 'Grupo', v: 'Hasta ${trip.groupSizeMax}'),
              _KV(icon: Icons.translate_rounded, k: 'Idioma', v: trip.language),
            ],
          ),
          const SizedBox(height: 12),
          _ExpandableBlock(
            title: 'Incluye (${trip.included.length})',
            icon: Icons.checklist_rounded,
            initiallyExpanded: true,
            child: Column(
              children: trip.included
                  .map((s) => _BulletRow(icon: Icons.check_circle_rounded, text: s))
                  .toList(),
            ),
          ),
          const SizedBox(height: 10),
          _ExpandableBlock(
            title: 'No incluye (${trip.notIncluded.length})',
            icon: Icons.remove_circle_outline_rounded,
            initiallyExpanded: false,
            child: Column(
              children: trip.notIncluded
                  .map((s) => _BulletRow(icon: Icons.block_rounded, text: s))
                  .toList(),
            ),
          ),
          const SizedBox(height: 10),
          _ExpandableBlock(
            title: 'Notas del guía',
            icon: Icons.info_outline_rounded,
            initiallyExpanded: false,
            child: Text(
              trip.notes,
              style: TextStyle(
                height: 1.3,
                color: Colors.white.withOpacity(0.85),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// ==========================
/// TICKETS CARD
/// ==========================
class _TicketsCard extends StatelessWidget {
  final PurchaseConfirmationArgs args;
  const _TicketsCard({required this.args});

  @override
  Widget build(BuildContext context) {
    return _GlassCard(
      radius: 24,
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(
            icon: Icons.confirmation_number_rounded,
            title: 'Tickets',
            subtitle: 'Llévalos en el celu. También te llegaron al correo.',
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _TicketVisual(orderId: args.orderId, label: 'QR de abordaje')),
              const SizedBox(width: 12),
              Expanded(child: _TicketVisual(orderId: args.orderId, label: 'Comprobante')),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _PrimaryButton(
                  label: 'Ver QR grande',
                  icon: Icons.qr_code_2_rounded,
                  onTap: () => _showQrDialog(context, args.orderId),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _SecondaryButton(
                  label: 'Compartir',
                  icon: Icons.ios_share_rounded,
                  onTap: () => _toast(context, 'Aquí conectas share (ej: share_plus)'),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  void _showQrDialog(BuildContext context, String orderId) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.55),
      builder: (_) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(16),
          child: _GlassCard(
            radius: 26,
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Tu QR de abordaje',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 10),
                _QrPlaceholderBig(value: orderId),
                const SizedBox(height: 10),
                Text(
                  'Orden: $orderId',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.85),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 14),
                _PrimaryButton(
                  label: 'Listo',
                  icon: Icons.check_rounded,
                  onTap: () => Navigator.pop(context),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

class _TicketVisual extends StatelessWidget {
  final String orderId;
  final String label;
  const _TicketVisual({required this.orderId, required this.label});

  @override
  Widget build(BuildContext context) {
    return _GlassCard(
      radius: 22,
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.local_activity_rounded, size: 18),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(fontWeight: FontWeight.w900),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              )
            ],
          ),
          const SizedBox(height: 10),
          _QrPlaceholderSmall(value: orderId),
          const SizedBox(height: 10),
          _MiniChip(label: 'ID: ${_short(orderId)}'),
        ],
      ),
    );
  }
}

/// ==========================
/// PASSENGERS CARD
/// ==========================
class _PassengersCard extends StatelessWidget {
  final PurchaseConfirmationArgs args;
  const _PassengersCard({required this.args});

  @override
  Widget build(BuildContext context) {
    return _GlassCard(
      radius: 24,
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionTitle(
            icon: Icons.groups_2_rounded,
            title: 'Pasajeros (${args.passengers.length})',
            subtitle: 'Asientos, documentos y notas.',
          ),
          const SizedBox(height: 10),
          Column(
            children: args.passengers
                .asMap()
                .entries
                .map((e) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _PassengerCard(
                        passenger: e.value,
                        index: e.key,
                      ),
                    ))
                .toList(),
          ),
          const SizedBox(height: 2),
          Row(
            children: [
              Expanded(
                child: _SecondaryButton(
                  label: 'Editar datos',
                  icon: Icons.edit_rounded,
                  onTap: () => _toast(context, 'Conecta a flujo de edición de pasajeros'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _SecondaryButton(
                  label: 'Enviar a correo',
                  icon: Icons.mail_rounded,
                  onTap: () => _toast(context, 'Aquí disparas reenvío de tickets'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PassengerCard extends StatefulWidget {
  final Passenger passenger;
  final int index;
  const _PassengerCard({required this.passenger, required this.index});

  @override
  State<_PassengerCard> createState() => _PassengerCardState();
}

class _PassengerCardState extends State<_PassengerCard> with SingleTickerProviderStateMixin {
  late final AnimationController _tap;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _tap = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
      lowerBound: 0,
      upperBound: 1,
    );
    _scale = Tween<double>(begin: 1.0, end: 0.985).animate(
      CurvedAnimation(parent: _tap, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _tap.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.passenger;
    final badgeColor = _seatColor(widget.index);

    return GestureDetector(
      onTapDown: (_) => _tap.forward(),
      onTapCancel: () => _tap.reverse(),
      onTapUp: (_) => _tap.reverse(),
      onTap: () => _toast(context, 'Abrir detalle del pasajero (opcional)'),
      child: AnimatedBuilder(
        animation: _tap,
        builder: (context, _) {
          return Transform.scale(
            scale: _scale.value,
            child: _GlassCard(
              radius: 20,
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
              child: Column(
                children: [
                  Row(
                    children: [
                      _SeatBadge(seat: p.seat, color: badgeColor),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          p.fullName,
                          style: const TextStyle(fontWeight: FontWeight.w900),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      _MiniChip(label: p.ticketType),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _KeyValueGrid(
                    compact: true,
                    items: [
                      _KV(icon: Icons.badge_rounded, k: 'Doc', v: '${p.documentType} ${p.documentNumber}'),
                      _KV(icon: Icons.phone_rounded, k: 'Tel', v: p.phone),
                      _KV(icon: Icons.notes_rounded, k: 'Notas', v: p.specialNotes),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Color _seatColor(int i) {
    const palette = [
      Color(0xFF2EF2A6),
      Color(0xFF7AD7FF),
      Color(0xFFFFD46A),
      Color(0xFFFF6B6B),
      Color(0xFFB6A2FF),
    ];
    return palette[i % palette.length];
  }
}

class _SeatBadge extends StatelessWidget {
  final String seat;
  final Color color;
  const _SeatBadge({required this.seat, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: color.withOpacity(0.14),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.40)),
        boxShadow: [
          BoxShadow(color: color.withOpacity(0.14), blurRadius: 18, spreadRadius: 1),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.event_seat_rounded, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            seat,
            style: TextStyle(fontWeight: FontWeight.w900, color: color),
          ),
        ],
      ),
    );
  }
}

/// ==========================
/// ITINERARY TIMELINE CARD
/// ==========================
class _ItineraryTimelineCard extends StatelessWidget {
  final PurchaseConfirmationArgs args;
  const _ItineraryTimelineCard({required this.args});

  @override
  Widget build(BuildContext context) {
    final stops = args.trip.itinerary;
    return _GlassCard(
      radius: 24,
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(
            icon: Icons.timeline_rounded,
            title: 'Itinerario',
            subtitle: 'Timeline de la ruta (puede variar por clima).',
          ),
          const SizedBox(height: 10),
          ListView.separated(
            itemCount: stops.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, i) {
              final s = stops[i];
              final isLast = i == stops.length - 1;
              return _TimelineRow(stop: s, isLast: isLast, index: i);
            },
          ),
        ],
      ),
    );
  }
}

class _TimelineRow extends StatelessWidget {
  final ItineraryStop stop;
  final bool isLast;
  final int index;

  const _TimelineRow({
    required this.stop,
    required this.isLast,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final dotColor = _timelineColor(index);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 42,
          child: Column(
            children: [
              Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: dotColor.withOpacity(0.9),
                  boxShadow: [
                    BoxShadow(color: dotColor.withOpacity(0.26), blurRadius: 16),
                  ],
                ),
              ),
              if (!isLast)
                Container(
                  width: 2,
                  height: 50,
                  margin: const EdgeInsets.only(top: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
            ],
          ),
        ),
        Expanded(
          child: _GlassCard(
            radius: 18,
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _MiniIconBadge(icon: stop.icon),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(stop.timeLabel, style: const TextStyle(fontWeight: FontWeight.w900)),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              stop.title,
                              style: const TextStyle(fontWeight: FontWeight.w900),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        stop.description,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.82),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(Icons.place_rounded, size: 16, color: Colors.white.withOpacity(0.75)),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              stop.location,
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.75),
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Color _timelineColor(int i) {
    const palette = [
      Color(0xFF2EF2A6),
      Color(0xFF7AD7FF),
      Color(0xFFFFD46A),
      Color(0xFFB6A2FF),
    ];
    return palette[i % palette.length];
  }
}

/// ==========================
/// PAYMENT BREAKDOWN CARD
/// ==========================
class _PaymentBreakdownCard extends StatelessWidget {
  final PurchaseConfirmationArgs args;
  const _PaymentBreakdownCard({required this.args});

  @override
  Widget build(BuildContext context) {
    final total = args.totalCOP;
    final items = args.pricing.items;

    return _GlassCard(
      radius: 24,
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(
            icon: Icons.receipt_long_rounded,
            title: 'Pago',
            subtitle: 'Resumen de cobro y método.',
          ),
          const SizedBox(height: 10),
          _GlassCard(
            radius: 18,
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
            child: Row(
              children: [
                _PaymentIcon(type: args.paymentMethod.type),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        args.paymentMethod.label,
                        style: const TextStyle(fontWeight: FontWeight.w900),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '${args.paymentMethod.installmentInfo} • ${_formatDate(args.paymentMethod.paidAt)}',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.75),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                _MiniChip(label: args.currency),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Column(
            children: [
              for (final line in items) _PriceRow(label: line.label, amountCOP: line.amountCOP),
              const SizedBox(height: 6),
              if (args.pricing.discount.amountCOP != 0)
                _PriceRow(label: args.pricing.discount.label, amountCOP: args.pricing.discount.amountCOP),
              if (args.pricing.taxes.amountCOP != 0)
                _PriceRow(label: args.pricing.taxes.label, amountCOP: args.pricing.taxes.amountCOP),
              const SizedBox(height: 10),
              _DividerSoft(),
              const SizedBox(height: 10),
              _PriceRow(
                label: 'Total',
                amountCOP: total,
                isTotal: true,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _SecondaryButton(
                  label: 'Descargar comprobante',
                  icon: Icons.download_rounded,
                  onTap: () => _toast(context, 'Aquí conectas PDF/archivo'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _SecondaryButton(
                  label: 'Solicitar factura',
                  icon: Icons.request_quote_rounded,
                  onTap: () => _toast(context, 'Aquí conectas facturación'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PriceRow extends StatelessWidget {
  final String label;
  final int amountCOP;
  final bool isTotal;

  const _PriceRow({
    required this.label,
    required this.amountCOP,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    final amountStr = _moneyCOP(amountCOP);
    final color = amountCOP < 0 ? const Color(0xFF2EF2A6) : Colors.white.withOpacity(0.90);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontWeight: isTotal ? FontWeight.w900 : FontWeight.w700,
                color: Colors.white.withOpacity(isTotal ? 0.95 : 0.82),
              ),
            ),
          ),
          Text(
            amountStr,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.w900 : FontWeight.w800,
              color: isTotal ? Colors.white : color,
              fontSize: isTotal ? 16 : 14,
            ),
          ),
        ],
      ),
    );
  }
}

/// ==========================
/// POST ACTIONS & POLICIES
/// ==========================
class _PostActionsAndPolicies extends StatelessWidget {
  final PurchaseConfirmationArgs args;
  const _PostActionsAndPolicies({required this.args});

  @override
  Widget build(BuildContext context) {
    return _GlassCard(
      radius: 24,
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(
            icon: Icons.auto_awesome_rounded,
            title: '¿Qué sigue?',
            subtitle: 'Acciones rápidas y políticas.',
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _PrimaryButton(
                  label: 'Ver mi reserva',
                  icon: Icons.account_balance_wallet_rounded,
                  onTap: () => _toast(context, 'Navegar a Mis Reservas'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _SecondaryButton(
                  label: 'Agregar al calendario',
                  icon: Icons.event_available_rounded,
                  onTap: () => _toast(context, 'Conecta calendario (ics)'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _ExpandableBlock(
            title: 'Políticas',
            icon: Icons.policy_rounded,
            initiallyExpanded: true,
            child: Column(
              children: args.policies.map((p) => _BulletRow(icon: Icons.shield_rounded, text: p)).toList(),
            ),
          ),
          const SizedBox(height: 10),
          _ExpandableBlock(
            title: 'Soporte',
            icon: Icons.support_agent_rounded,
            initiallyExpanded: false,
            child: Column(
              children: [
                _ContactActionRow(
                  icon: Icons.chat_bubble_rounded,
                  title: 'Chat en Col en Ruta',
                  subtitle: 'Respuesta rápida (horario extendido)',
                  onTap: () => _toast(context, 'Abrir chat interno'),
                ),
                _ContactActionRow(
                  icon: Icons.whatsapp_rounded,
                  title: 'WhatsApp',
                  subtitle: 'Escríbenos con tu ID de orden',
                  onTap: () => _toast(context, 'Abrir WhatsApp deep link'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ContactActionRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ContactActionRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: _GlassCard(
          radius: 18,
          padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
          child: Row(
            children: [
              _MiniIconBadge(icon: icon),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.78),
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: Colors.white.withOpacity(0.75))
            ],
          ),
        ),
      ),
    );
  }
}

/// ==========================
/// REVEAL ANIMATION HELPERS
/// ==========================
class SectionRevealController {
  final ValueNotifier<bool> _shown = ValueNotifier(false);
  ValueListenable<bool> get shown => _shown;

  void reveal() => _shown.value = true;
  void dispose() => _shown.dispose();
}

class SectionReveal extends StatefulWidget {
  final SectionRevealController controller;
  final Widget child;

  const SectionReveal({super.key, required this.controller, required this.child});

  @override
  State<SectionReveal> createState() => _SectionRevealState();
}

class _SectionRevealState extends State<SectionReveal> with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  late final Animation<double> _fade;
  late final Animation<double> _slide;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 520));
    _fade = CurvedAnimation(parent: _c, curve: Curves.easeOutCubic);
    _slide = Tween<double>(begin: 14, end: 0).animate(CurvedAnimation(parent: _c, curve: Curves.easeOutCubic));

    widget.controller.shown.addListener(_onShown);
  }

  void _onShown() {
    if (widget.controller.shown.value) _c.forward();
  }

  @override
  void dispose() {
    widget.controller.shown.removeListener(_onShown);
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (context, _) {
        return Opacity(
          opacity: _fade.value,
          child: Transform.translate(
            offset: Offset(0, _slide.value),
            child: widget.child,
          ),
        );
      },
    );
  }
}

/// ==========================
/// UI PRIMITIVES
/// ==========================
class _GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final double radius;

  const _GlassCard({
    required this.child,
    required this.padding,
    required this.radius,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          color: Colors.white.withOpacity(0.08),
          border: Border.all(color: Colors.white.withOpacity(0.12)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.30),
              blurRadius: 20,
              offset: const Offset(0, 14),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}

class _GlassSheet extends StatelessWidget {
  final Widget child;
  const _GlassSheet({required this.child});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: _GlassCard(
          radius: 26,
          padding: EdgeInsets.zero,
          child: child,
        ),
      ),
    );
  }
}

class _SheetHandle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 56,
      height: 5,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.22),
        borderRadius: BorderRadius.circular(99),
      ),
    );
  }
}

class _GlassIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _GlassIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 6, top: 6, bottom: 6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              border: Border.all(color: Colors.white.withOpacity(0.14)),
            ),
            child: Icon(icon, color: Colors.white.withOpacity(0.95)),
          ),
        ),
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _PrimaryButton({required this.label, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: const LinearGradient(
            colors: [Color(0xFF2EF2A6), Color(0xFF7AD7FF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(color: const Color(0xFF2EF2A6).withOpacity(0.18), blurRadius: 18, offset: const Offset(0, 10)),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: const Color(0xFF041018)),
            const SizedBox(width: 10),
            Text(
              label,
              style: const TextStyle(
                color: Color(0xFF041018),
                fontWeight: FontWeight.w900,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _SecondaryButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _SecondaryButton({required this.label, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: Colors.white.withOpacity(0.08),
          border: Border.all(color: Colors.white.withOpacity(0.14)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white.withOpacity(0.92)),
            const SizedBox(width: 10),
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withOpacity(0.92),
                fontWeight: FontWeight.w900,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _SectionTitle({required this.icon, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _MiniIconBadge(icon: icon),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.78),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}

class _MiniIconBadge extends StatelessWidget {
  final IconData icon;
  const _MiniIconBadge({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: Colors.white.withOpacity(0.10),
        border: Border.all(color: Colors.white.withOpacity(0.14)),
      ),
      child: Icon(icon, size: 18, color: Colors.white.withOpacity(0.92)),
    );
  }
}

class _MiniChip extends StatelessWidget {
  final String label;
  const _MiniChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(99),
        border: Border.all(color: Colors.white.withOpacity(0.12)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.white.withOpacity(0.86),
          fontWeight: FontWeight.w800,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _InfoPill extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoPill({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(99),
        border: Border.all(color: Colors.white.withOpacity(0.12)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.white.withOpacity(0.88)),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.88),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _KeyValueGrid extends StatelessWidget {
  final List<_KV> items;
  final bool compact;

  const _KeyValueGrid({required this.items, this.compact = false});

  @override
  Widget build(BuildContext context) {
    final gap = compact ? 8.0 : 10.0;
    return Column(
      children: [
        for (int i = 0; i < items.length; i += 2)
          Padding(
            padding: EdgeInsets.only(bottom: gap),
            child: Row(
              children: [
                Expanded(child: _KeyValueTile(kv: items[i], compact: compact)),
                const SizedBox(width: 10),
                Expanded(
                  child: (i + 1 < items.length)
                      ? _KeyValueTile(kv: items[i + 1], compact: compact)
                      : const SizedBox.shrink(),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _KV {
  final IconData icon;
  final String k;
  final String v;
  _KV({required this.icon, required this.k, required this.v});
}

class _KeyValueTile extends StatelessWidget {
  final _KV kv;
  final bool compact;
  const _KeyValueTile({required this.kv, required this.compact});

  @override
  Widget build(BuildContext context) {
    return _GlassCard(
      radius: 18,
      padding: EdgeInsets.fromLTRB(12, compact ? 10 : 12, 12, compact ? 10 : 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(kv.icon, size: 18, color: Colors.white.withOpacity(0.85)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  kv.k,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.70),
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  kv.v,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.92),
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ExpandableBlock extends StatefulWidget {
  final String title;
  final IconData icon;
  final bool initiallyExpanded;
  final Widget child;

  const _ExpandableBlock({
    required this.title,
    required this.icon,
    required this.initiallyExpanded,
    required this.child,
  });

  @override
  State<_ExpandableBlock> createState() => _ExpandableBlockState();
}

class _ExpandableBlockState extends State<_ExpandableBlock> with SingleTickerProviderStateMixin {
  late bool _expanded;
  late final AnimationController _c;
  late final Animation<double> _a;

  @override
  void initState() {
    super.initState();
    _expanded = widget.initiallyExpanded;
    _c = AnimationController(vsync: this, duration: const Duration(milliseconds: 240));
    _a = CurvedAnimation(parent: _c, curve: Curves.easeOutCubic);
    if (_expanded) _c.value = 1;
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() => _expanded = !_expanded);
    if (_expanded) {
      _c.forward();
    } else {
      _c.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return _GlassCard(
      radius: 20,
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      child: Column(
        children: [
          InkWell(
            onTap: _toggle,
            borderRadius: BorderRadius.circular(16),
            child: Row(
              children: [
                _MiniIconBadge(icon: widget.icon),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    widget.title,
                    style: const TextStyle(fontWeight: FontWeight.w900),
                  ),
                ),
                AnimatedRotation(
                  turns: _expanded ? 0.5 : 0.0,
                  duration: const Duration(milliseconds: 220),
                  child: Icon(Icons.expand_more_rounded, color: Colors.white.withOpacity(0.9)),
                ),
              ],
            ),
          ),
          SizeTransition(
            sizeFactor: _a,
            axisAlignment: -1,
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: widget.child,
            ),
          ),
        ],
      ),
    );
  }
}

class _BulletRow extends StatelessWidget {
  final IconData icon;
  final String text;
  const _BulletRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: Colors.white.withOpacity(0.85)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                height: 1.25,
                color: Colors.white.withOpacity(0.86),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DividerSoft extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.transparent,
            Colors.white.withOpacity(0.22),
            Colors.transparent,
          ],
        ),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final PurchaseStatus status;
  const _StatusPill({required this.status});

  @override
  Widget build(BuildContext context) {
    final (label, c) = switch (status) {
      PurchaseStatus.confirmed => ('Confirmada', const Color(0xFF2EF2A6)),
      PurchaseStatus.pending => ('Pendiente', const Color(0xFFFFD46A)),
      PurchaseStatus.failed => ('Fallida', const Color(0xFFFF6B6B)),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: c.withOpacity(0.16),
        borderRadius: BorderRadius.circular(99),
        border: Border.all(color: c.withOpacity(0.40)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: c,
          fontWeight: FontWeight.w900,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _StatusDot extends StatelessWidget {
  final PurchaseStatus status;
  const _StatusDot({required this.status});

  @override
  Widget build(BuildContext context) {
    final c = switch (status) {
      PurchaseStatus.confirmed => const Color(0xFF2EF2A6),
      PurchaseStatus.pending => const Color(0xFFFFD46A),
      PurchaseStatus.failed => const Color(0xFFFF6B6B),
    };

    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: c,
        boxShadow: [
          BoxShadow(color: c.withOpacity(0.25), blurRadius: 14),
        ],
      ),
    );
  }
}

class _PaymentIcon extends StatelessWidget {
  final PaymentType type;
  const _PaymentIcon({required this.type});

  @override
  Widget build(BuildContext context) {
    final (icon, c) = switch (type) {
      PaymentType.card => (Icons.credit_card_rounded, const Color(0xFF7AD7FF)),
      PaymentType.pse => (Icons.account_balance_rounded, const Color(0xFF2EF2A6)),
      PaymentType.cash => (Icons.payments_rounded, const Color(0xFFFFD46A)),
      PaymentType.wallet => (Icons.account_balance_wallet_rounded, const Color(0xFFB6A2FF)),
    };

    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: c.withOpacity(0.12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: c.withOpacity(0.35)),
      ),
      child: Icon(icon, color: c),
    );
  }
}

class _QrPlaceholderSmall extends StatelessWidget {
  final String value;
  const _QrPlaceholderSmall({required this.value});

  @override
  Widget build(BuildContext context) {
    // Placeholder "fake QR" using custom painter
    return AspectRatio(
      aspectRatio: 1,
      child: CustomPaint(
        painter: _FakeQrPainter(seed: value.hashCode, blocks: 23),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _QrPlaceholderBig extends StatelessWidget {
  final String value;
  const _QrPlaceholderBig({required this.value});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.92),
          ),
          child: CustomPaint(
            painter: _FakeQrPainter(seed: value.hashCode, blocks: 33, dark: const Color(0xFF061018)),
            child: const SizedBox.expand(),
          ),
        ),
      ),
    );
  }
}

class _HelpRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _HelpRow({required this.icon, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        children: [
          _MiniIconBadge(icon: icon),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.78),
                    fontWeight: FontWeight.w600,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomSafeAreaSpacer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final b = MediaQuery.of(context).padding.bottom;
    return SizedBox(height: math.max(0, b - 4));
  }
}

/// ==========================
/// CONFETTI
/// ==========================
class ConfettiPainter extends CustomPainter {
  final double progress;
  final int seed;
  final double density;

  ConfettiPainter({
    required this.progress,
    required this.seed,
    required this.density,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rnd = _SeededRandom(seed);
    final count = (120 * density).round();
    final t = Curves.easeOutCubic.transform(progress);

    for (int i = 0; i < count; i++) {
      final baseX = rnd.nextDouble();
      final speed = 0.35 + rnd.nextDouble() * 1.25;
      final drift = (rnd.nextDouble() - 0.5) * 0.35;

      final x = (baseX + drift * t) * size.width;
      final y = (-0.15 + t * speed) * size.height;

      final rot = (rnd.nextDouble() * math.pi * 2) + t * (rnd.nextDouble() * 6);
      final w = 4 + rnd.nextDouble() * 8;
      final h = 2 + rnd.nextDouble() * 10;

      final color = _confettiColor(i);
      final paint = Paint()..color = color.withOpacity(0.75);

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(rot);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset.zero, width: w, height: h),
          const Radius.circular(2),
        ),
        paint,
      );
      canvas.restore();
    }
  }

  Color _confettiColor(int i) {
    const palette = [
      Color(0xFF2EF2A6),
      Color(0xFF7AD7FF),
      Color(0xFFFFD46A),
      Color(0xFFFF6B6B),
      Color(0xFFB6A2FF),
      Color(0xFFFFFFFF),
    ];
    return palette[i % palette.length];
  }

  @override
  bool shouldRepaint(covariant ConfettiPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.seed != seed || oldDelegate.density != density;
  }
}

/// ==========================
/// FAKE QR PAINTER
/// ==========================
class _FakeQrPainter extends CustomPainter {
  final int seed;
  final int blocks;
  final Color dark;

  _FakeQrPainter({
    required this.seed,
    required this.blocks,
    this.dark = const Color(0xFFFFFFFF),
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rnd = _SeededRandom(seed);
    final cell = size.width / blocks;
    final paint = Paint()..color = dark;

    // draw finder patterns
    void finder(double x, double y) {
      final r = Rect.fromLTWH(x * cell, y * cell, cell * 7, cell * 7);
      final p1 = Paint()..color = dark;
      final p2 = Paint()..color = Colors.transparent;
      canvas.drawRect(r, p1);
      canvas.drawRect(Rect.fromLTWH(r.left + cell, r.top + cell, r.width - 2 * cell, r.height - 2 * cell), p2);
      canvas.drawRect(Rect.fromLTWH(r.left + 2 * cell, r.top + 2 * cell, r.width - 4 * cell, r.height - 4 * cell), p1);
    }

    finder(1, 1);
    finder(blocks - 8, 1);
    finder(1, blocks - 8);

    // Random modules (avoid finder zones)
    bool inFinder(int x, int y) {
      final inA = x >= 1 && x <= 7 && y >= 1 && y <= 7;
      final inB = x >= blocks - 8 && x <= blocks - 2 && y >= 1 && y <= 7;
      final inC = x >= 1 && x <= 7 && y >= blocks - 8 && y <= blocks - 2;
      return inA || inB || inC;
    }

    for (int y = 0; y < blocks; y++) {
      for (int x = 0; x < blocks; x++) {
        if (inFinder(x, y)) continue;
        // bias to look QR-ish
        final v = rnd.nextDouble();
        if (v > 0.68) {
          canvas.drawRect(Rect.fromLTWH(x * cell, y * cell, cell, cell), paint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _FakeQrPainter oldDelegate) {
    return oldDelegate.seed != seed || oldDelegate.blocks != blocks || oldDelegate.dark != dark;
  }
}

/// ==========================
/// NOISE
/// ==========================
class _NoisePainter extends CustomPainter {
  final int seed;
  _NoisePainter({required this.seed});

  @override
  void paint(Canvas canvas, Size size) {
    final rnd = _SeededRandom(seed);
    final paint = Paint()..color = Colors.white;

    // sparse dots
    const dots = 1800;
    for (int i = 0; i < dots; i++) {
      final x = rnd.nextDouble() * size.width;
      final y = rnd.nextDouble() * size.height;
      final r = rnd.nextDouble() * 1.1;
      paint.color = Colors.white.withOpacity(0.015 + rnd.nextDouble() * 0.02);
      canvas.drawCircle(Offset(x, y), r, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _NoisePainter oldDelegate) => oldDelegate.seed != seed;
}

/// ==========================
/// RANDOM
/// ==========================
class _SeededRandom {
  int _state;
  _SeededRandom(int seed) : _state = seed ^ 0xA5A5A5A5;

  double nextDouble() {
    // xorshift32
    int x = _state;
    x ^= (x << 13);
    x ^= (x >> 17);
    x ^= (x << 5);
    _state = x;
    // Convert to 0..1
    final v = (x & 0x7fffffff) / 0x7fffffff;
    return v.isNaN ? 0.5 : v;
  }
}

/// ==========================
/// HELPERS
/// ==========================
String _short(String s) => s.length <= 6 ? s : s.substring(s.length - 6);

String _formatHour(DateTime dt) {
  final h = dt.hour.toString().padLeft(2, '0');
  final m = dt.minute.toString().padLeft(2, '0');
  return '$h:$m';
}

String _formatShortDate(DateTime dt) {
  // Simple: 19 Feb 2026
  const months = ['Ene', 'Feb', 'Mar', 'Abr', 'May', 'Jun', 'Jul', 'Ago', 'Sep', 'Oct', 'Nov', 'Dic'];
  return '${dt.day} ${months[dt.month - 1]} ${dt.year}';
}

String _formatDate(DateTime dt) {
  // 19/02/2026 14:03
  final d = dt.day.toString().padLeft(2, '0');
  final mo = dt.month.toString().padLeft(2, '0');
  final y = dt.year.toString();
  return '$d/$mo/$y ${_formatHour(dt)}';
}

String _moneyCOP(int value) {
  // Simple formatting without intl
  final neg = value < 0;
  final abs = value.abs();
  final s = abs.toString();
  final buf = StringBuffer();
  for (int i = 0; i < s.length; i++) {
    final idx = s.length - i;
    buf.write(s[i]);
    if (idx > 1 && idx % 3 == 1) buf.write('.');
  }
  return '${neg ? '-' : ''}\$${buf.toString()}';
}

void _toast(BuildContext context, String msg) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(msg),
      backgroundColor: const Color(0xFF0B1220),
      behavior: SnackBarBehavior.floating,
    ),
  );
}

/// ==========================
/// SMALL MISSING ICON (WhatsApp) fallback
/// ==========================
extension _WhatsIcon on Icons {
  static IconData get whatsapp_rounded => Icons.message_rounded;
}