// pubspec.yaml -> dependencies: flutter_animate: ^4.5.0
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

// ─────────────────────────────────────────────────────────────
// ENTRY — swap GuideConfig.festival / GuideConfig.farm
// ─────────────────────────────────────────────────────────────
void main() => runApp(const GuideApp(config: GuideConfig.festival));

// ─────────────────────────────────────────────────────────────
// DOMAIN / CONFIG
// ─────────────────────────────────────────────────────────────
enum CanvasKind { farm, festival }

class ChipItem {
  final String label;
  final IconData icon;
  const ChipItem(this.label, this.icon);
}

class InfoRow {
  final IconData icon;
  final String title, subtitle, trailing;
  const InfoRow(this.icon, this.title, this.subtitle, this.trailing);
}

class MapMarker {
  final int zone;
  final double x, y; // -1..1 alignment inside canvas
  final Widget child;
  final bool pulse;
  const MapMarker(this.zone, this.x, this.y, this.child, {this.pulse = false});
}

class GuideConfig {
  final String title, subtitle;
  final IconData subtitleIcon;
  final Color background, accent, ink;
  final List<ChipItem> tabs; // one per zone
  final int activeTab;
  final List<String> subPills; // 3 sub tabs
  final List<List<List<InfoRow>>> info; // info[zone][subPill] -> rows
  final List<ChipItem> nav;
  final int activeNav;
  final CanvasKind canvas;
  final List<MapMarker> markers;

  const GuideConfig({
    required this.title,
    required this.subtitle,
    required this.subtitleIcon,
    required this.background,
    required this.accent,
    required this.ink,
    required this.tabs,
    required this.activeTab,
    required this.subPills,
    required this.info,
    required this.nav,
    required this.activeNav,
    required this.canvas,
    required this.markers,
  });

  // ── Festival (sample data — edit freely) ───────────────────
  static const festival = GuideConfig(
    title: 'Festival Guide',
    subtitle: 'Sunset Fields - 3 Stages',
    subtitleIcon: Icons.location_on_outlined,
    background: Color(0xFFEEF0F3),
    accent: Color(0xFF3B2F8F),
    ink: Color(0xFF1E2230),
    tabs: [
      ChipItem('Main Stage', Icons.mic_external_on_outlined),
      ChipItem('Dance Tent', Icons.graphic_eq),
      ChipItem('Food Court', Icons.restaurant_outlined),
    ],
    activeTab: 1,
    subPills: ['Lineup', 'Crowd', 'Next set'],
    info: [
      // Main Stage
      [
        [
          InfoRow(Icons.mic, 'Neon Harbor', 'Indie pop', '6:00 PM'),
          InfoRow(Icons.mic, 'Velvet Static', 'Alt rock', '7:30 PM'),
          InfoRow(Icons.star_outline, 'The Midnight Orchard', 'Headliner', '9:15 PM'),
        ],
        [
          InfoRow(Icons.people_outline, 'Crowd level', 'About 4,200 people', 'Moderate'),
          InfoRow(Icons.timer_outlined, 'Entry wait', 'Main gate to pit', '5 min'),
          InfoRow(Icons.visibility_outlined, 'Best view', 'Left of soundboard', 'Open'),
        ],
        [
          InfoRow(Icons.schedule, 'Velvet Static', 'Starts soon', 'in 25 min'),
          InfoRow(Icons.swap_horiz, 'Changeover', 'Crew resetting stage', '15 min'),
        ],
      ],
      // Dance Tent
      [
        [
          InfoRow(Icons.headphones, 'DJ Solstice', 'House', '5:00 PM'),
          InfoRow(Icons.headphones, 'Bassline Club', 'Drum and bass', '7:00 PM'),
          InfoRow(Icons.star_outline, 'Aurora Collective', 'Closing set', '10:00 PM'),
        ],
        [
          InfoRow(Icons.people_outline, 'Crowd level', 'About 1,800 people', 'Busy'),
          InfoRow(Icons.timer_outlined, 'Entry wait', 'Tent entrance', '12 min'),
          InfoRow(Icons.air, 'Cooler air', 'Near the back', 'Tip'),
        ],
        [
          InfoRow(Icons.schedule, 'Bassline Club', 'Starts soon', 'in 40 min'),
          InfoRow(Icons.swap_horiz, 'Changeover', 'Sound check', '10 min'),
        ],
      ],
      // Food Court
      [
        [
          InfoRow(Icons.restaurant, 'Taco Tribe', 'Street tacos', 'Open'),
          InfoRow(Icons.ramen_dining, 'Noodle Bar', 'Hot noodles', 'Open'),
          InfoRow(Icons.eco_outlined, 'Green Bowl', 'Vegan bowls', 'Open'),
        ],
        [
          InfoRow(Icons.timer_outlined, 'Queue time', 'Average across stalls', '15 min'),
          InfoRow(Icons.event_seat_outlined, 'Seating', 'Tables free', '40%'),
          InfoRow(Icons.bolt, 'Shortest line', 'Green Bowl', '4 min'),
        ],
        [
          InfoRow(Icons.local_bar_outlined, 'Happy hour', 'Drinks half price', '5:00 PM'),
          InfoRow(Icons.soup_kitchen_outlined, 'Chef pop-up', 'Limited menu', '7:00 PM'),
        ],
      ],
    ],
    nav: [
      ChipItem('Home', Icons.home_outlined),
      ChipItem('Map', Icons.map_outlined),
      ChipItem('Lineup', Icons.queue_music_outlined),
      ChipItem('Tickets', Icons.confirmation_number_outlined),
      ChipItem('Profile', Icons.person_outline),
    ],
    activeNav: 1,
    canvas: CanvasKind.festival,
    markers: [
      // Main Stage
      MapMarker(0, 0.0, -0.62, _GlowNode(Icons.mic, Color(0xFF7C6CFF)), pulse: true),
      MapMarker(0, -0.5, -0.5, _GlowNode(Icons.speaker, Color(0xFFFF6FA5)), pulse: true),
      MapMarker(0, 0.5, -0.5, _GlowNode(Icons.speaker, Color(0xFFFF6FA5)), pulse: true),
      MapMarker(0, 0.0, -0.8, _GlowNode(Icons.lightbulb_outline, Color(0xFFFFB347)), pulse: true),
      // Dance Tent
      MapMarker(1, -0.5, 0.1, _GlowNode(Icons.graphic_eq, Color(0xFF3B2F8F)), pulse: true),
      MapMarker(1, -0.7, 0.3, _GlowNode(Icons.headphones, Color(0xFFFF6FA5)), pulse: true),
      MapMarker(1, -0.3, 0.28, _GlowNode(Icons.album, Color(0xFF7C6CFF)), pulse: true),
      // Food Court
      MapMarker(2, 0.3, 0.3, _GlowNode(Icons.restaurant, Color(0xFFFFB347)), pulse: true),
      MapMarker(2, 0.65, 0.5, _GlowNode(Icons.local_cafe, Color(0xFF3CC8A0)), pulse: true),
      MapMarker(2, 0.45, 0.62, _GlowNode(Icons.icecream_outlined, Color(0xFFFF6FA5)), pulse: true),
      MapMarker(2, 0.72, 0.25, _GlowNode(Icons.wc, Color(0xFF3CC8A0)), pulse: true),
    ],
  );

  // ── Farm ───────────────────────────────────────────────────
  static const farm = GuideConfig(
    title: 'My Farm',
    subtitle: 'Green Valley Farm - 12.5 ha',
    subtitleIcon: Icons.location_on_outlined,
    background: Color(0xFFF5F4EE),
    accent: Color(0xFF1F4D36),
    ink: Color(0xFF1B2B22),
    tabs: [
      ChipItem('Corn Field', Icons.grass),
      ChipItem('Animal Area', Icons.pets),
      ChipItem('Water Tank', Icons.water_drop_outlined),
    ],
    activeTab: 1,
    subPills: ['Animals', 'Health', 'Next feed'],
    info: [
      // Corn Field
      [
        [
          InfoRow(Icons.pest_control_outlined, 'Wildlife seen', 'Deer near east edge', '2'),
          InfoRow(Icons.grass, 'Crop stage', 'Tasseling', 'Week 9'),
        ],
        [
          InfoRow(Icons.favorite_border, 'Crop health', 'Satellite index', 'Good'),
          InfoRow(Icons.water_drop_outlined, 'Irrigation', 'Last run 6:00 AM', 'Done'),
        ],
        [
          InfoRow(Icons.science_outlined, 'Fertilizer', 'Nitrogen top-up', 'Fri 7 AM'),
        ],
      ],
      // Animal Area
      [
        [
          InfoRow(Icons.pets, 'Cows', 'In pasture', '24'),
          InfoRow(Icons.child_care, 'Calves', 'With herd', '6'),
        ],
        [
          InfoRow(Icons.medical_services_outlined, 'Vaccinations', 'Up to date', 'Good'),
          InfoRow(Icons.visibility_outlined, 'Under observation', 'Tag 0417', '1'),
        ],
        [
          InfoRow(Icons.schedule, 'Evening feed', 'Hay and grain', '5:00 PM'),
          InfoRow(Icons.inventory_2_outlined, 'Hay stock', 'Bales left', '18'),
        ],
      ],
      // Water Tank
      [
        [
          InfoRow(Icons.pets, 'Drinking now', 'Animals at trough', '12'),
        ],
        [
          InfoRow(Icons.opacity, 'Water level', 'Tank capacity', '82%'),
          InfoRow(Icons.science_outlined, 'Quality', 'pH reading', '7.2'),
        ],
        [
          InfoRow(Icons.local_shipping_outlined, 'Next refill', 'Scheduled', 'Sat'),
        ],
      ],
    ],
    nav: [
      ChipItem('Home', Icons.home_outlined),
      ChipItem('Farm', Icons.agriculture_outlined),
      ChipItem('Analytics', Icons.bar_chart_rounded),
      ChipItem('Harvest', Icons.eco_outlined),
      ChipItem('Profile', Icons.person_outline),
    ],
    activeNav: 1,
    canvas: CanvasKind.farm,
    markers: [
      // Corn
      MapMarker(0, -0.15, -0.65, Text('🌽', style: TextStyle(fontSize: 24))),
      MapMarker(0, 0.25, -0.55, Text('🌽', style: TextStyle(fontSize: 24))),
      MapMarker(0, 0.6, -0.65, Text('🌽', style: TextStyle(fontSize: 24))),
      MapMarker(0, 0.05, -0.45, Text('🌽', style: TextStyle(fontSize: 24))),
      // Animals
      MapMarker(1, -0.1, -0.1, Text('🐄', style: TextStyle(fontSize: 26))),
      MapMarker(1, 0.3, 0.1, Text('🐄', style: TextStyle(fontSize: 26))),
      MapMarker(1, 0.65, -0.05, Text('🐄', style: TextStyle(fontSize: 26))),
      MapMarker(1, 0.05, 0.22, Text('🐄', style: TextStyle(fontSize: 26))),
      // Water
      MapMarker(2, 0.1, 0.65, Text('💧', style: TextStyle(fontSize: 24)), pulse: true),
      MapMarker(2, 0.5, 0.6, Text('💧', style: TextStyle(fontSize: 24)), pulse: true),
      MapMarker(2, 0.75, 0.72, Text('💧', style: TextStyle(fontSize: 24)), pulse: true),
    ],
  );
}

class _GlowNode extends StatelessWidget {
  final IconData icon;
  final Color color;
  const _GlowNode(this.icon, this.color);

  @override
  Widget build(BuildContext context) => Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(color: color.withOpacity(.55), blurRadius: 16, spreadRadius: 3)],
        ),
        child: Icon(icon, size: 18, color: Colors.white),
      );
}

Widget _leftLayout(Widget? current, List<Widget> previous) => Stack(
      alignment: Alignment.topLeft,
      children: [...previous, if (current != null) current],
    );

// ─────────────────────────────────────────────────────────────
// APP + SCREEN
// ─────────────────────────────────────────────────────────────
class GuideApp extends StatelessWidget {
  final GuideConfig config;
  const GuideApp({super.key, required this.config});

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: config.accent),
          scaffoldBackgroundColor: config.background,
        ),
        builder: (context, child) => ColoredBox(
          color: config.background,
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 430),
              child: child,
            ),
          ),
        ),
        home: FarmScreen(config: config),
      );
}

class FarmScreen extends StatefulWidget {
  final GuideConfig config;
  const FarmScreen({super.key, required this.config});

  @override
  State<FarmScreen> createState() => _FarmScreenState();
}

class _FarmScreenState extends State<FarmScreen> {
  late int _tab = widget.config.activeTab;
  late int _nav = widget.config.activeNav;

  @override
  Widget build(BuildContext context) {
    final c = widget.config;
    return Scaffold(
      backgroundColor: c.background,
      body: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  FarmHeader(config: c),
                  const SizedBox(height: 20),
                  FarmCategoryTabs(
                    config: c,
                    selected: _tab,
                    onSelected: (i) => setState(() => _tab = i),
                  ),
                  const SizedBox(height: 16),
                  FarmCanvasMap(config: c, focus: _tab),
                  const SizedBox(height: 16),
                  FarmContextSheet(config: c, zone: _tab),
                ],
              ),
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: MediaQuery.of(context).padding.bottom + 12,
              child: FarmBottomNavigation(
                config: c,
                selected: _nav,
                onSelected: (i) => setState(() => _nav = i),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// HEADER
// ─────────────────────────────────────────────────────────────
class FarmHeader extends StatelessWidget {
  final GuideConfig config;
  const FarmHeader({super.key, required this.config});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                config.title,
                style: TextStyle(
                  fontFamily: 'Georgia',
                  fontFamilyFallback: const ['serif'],
                  fontSize: 34,
                  fontWeight: FontWeight.w700,
                  color: config.accent,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Icon(config.subtitleIcon, size: 16, color: config.ink.withOpacity(.6)),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      config.subtitle,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 14, color: config.ink.withOpacity(.6)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: config.ink.withOpacity(.25), width: 1.4),
          ),
          child: Icon(Icons.person_outline, color: config.ink),
        ),
      ],
    )
        .animate()
        .fadeIn(duration: 400.ms)
        .slideY(begin: -.2, end: 0, curve: Curves.easeOutCubic);
  }
}

// ─────────────────────────────────────────────────────────────
// CATEGORY TABS
// ─────────────────────────────────────────────────────────────
class FarmCategoryTabs extends StatelessWidget {
  final GuideConfig config;
  final int selected;
  final ValueChanged<int> onSelected;
  const FarmCategoryTabs({
    super.key,
    required this.config,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: config.tabs.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (_, i) {
          final item = config.tabs[i];
          final on = i == selected;
          return GestureDetector(
            onTap: () => onSelected(i),
            child: AnimatedContainer(
              duration: 250.ms,
              curve: Curves.easeOut,
              padding: const EdgeInsets.symmetric(horizontal: 18),
              decoration: BoxDecoration(
                color: on ? config.accent : Colors.white.withOpacity(.7),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: on ? config.accent : config.ink.withOpacity(.12),
                ),
              ),
              child: Row(
                children: [
                  Icon(item.icon, size: 18, color: on ? Colors.white : config.ink),
                  const SizedBox(width: 8),
                  Text(
                    item.label,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: on ? Colors.white : config.ink,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    ).animate().fadeIn(delay: 100.ms, duration: 400.ms).slideX(begin: .1, end: 0);
  }
}

// ─────────────────────────────────────────────────────────────
// CANVAS MAP
// ─────────────────────────────────────────────────────────────
class FarmCanvasMap extends StatelessWidget {
  final GuideConfig config;
  final int focus;
  const FarmCanvasMap({super.key, required this.config, required this.focus});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 290,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(.06), blurRadius: 20, offset: const Offset(0, 8)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          fit: StackFit.expand,
          children: [
            CustomPaint(
              painter: _CanvasPainter(
                kind: config.canvas,
                accent: config.accent,
                ink: config.ink,
                focus: focus,
                labels: config.tabs.map((t) => t.label).toList(),
              ),
            ),
            for (var i = 0; i < config.markers.length; i++)
              Align(
                alignment: Alignment(config.markers[i].x, config.markers[i].y),
                child: _marker(config.markers[i], i, config.markers[i].zone == focus),
              ),
            Positioned(
              top: 12,
              right: 12,
              child: Material(
                color: Colors.white,
                shape: const CircleBorder(),
                elevation: 2,
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () {},
                  child: const Padding(
                    padding: EdgeInsets.all(9),
                    child: Icon(Icons.open_in_full_rounded, size: 18),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 200.ms, duration: 450.ms).scale(
          begin: const Offset(.96, .96),
          end: const Offset(1, 1),
          curve: Curves.easeOutBack,
        );
  }

  Widget _marker(MapMarker m, int i, bool focused) {
    // Only the focused zone's markers animate; the rest fade back.
    final Widget inner = focused
        ? (m.pulse
            ? m.child
                .animate(delay: (i * 90).ms, onPlay: (c) => c.repeat(reverse: true))
                .scale(
                  begin: const Offset(1, 1),
                  end: const Offset(1.18, 1.18),
                  duration: 1200.ms,
                  curve: Curves.easeInOut,
                )
            : m.child
                .animate(delay: (i * 90).ms, onPlay: (c) => c.repeat(reverse: true))
                .slideX(begin: -.15, end: .15, duration: (2200 + i * 200).ms, curve: Curves.easeInOut))
        : m.child;
    return AnimatedOpacity(
      duration: 300.ms,
      opacity: focused ? 1 : .3,
      child: inner,
    );
  }
}

class _CanvasPainter extends CustomPainter {
  final CanvasKind kind;
  final Color accent, ink;
  final int focus;
  final List<String> labels;
  _CanvasPainter({
    required this.kind,
    required this.accent,
    required this.ink,
    required this.focus,
    required this.labels,
  });

  // Zone rectangles as fractions of the canvas
  static const _farmZones = [
    Rect.fromLTRB(.32, .06, .94, .34),
    Rect.fromLTRB(.32, .38, .94, .66),
    Rect.fromLTRB(.32, .70, .94, .94),
  ];
  static const _festZones = [
    Rect.fromLTRB(.20, .06, .80, .30),
    Rect.fromLTRB(.06, .40, .46, .70),
    Rect.fromLTRB(.54, .52, .94, .90),
  ];

  Rect _px(Rect f, Size s) =>
      Rect.fromLTRB(f.left * s.width, f.top * s.height, f.right * s.width, f.bottom * s.height);

  void _dashed(Canvas c, Path p, Paint paint, {double dash = 7, double gap = 5}) {
    for (final m in p.computeMetrics()) {
      double d = 0;
      while (d < m.length) {
        c.drawPath(m.extractPath(d, d + dash), paint);
        d += dash + gap;
      }
    }
  }

  void _label(Canvas c, String t, Offset o, bool on) {
    final tp = TextPainter(
      text: TextSpan(
        text: t,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: ink.withOpacity(on ? .85 : .4),
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(c, o);
  }

  @override
  void paint(Canvas canvas, Size s) {
    kind == CanvasKind.farm ? _farm(canvas, s) : _festival(canvas, s);
  }

  void _farm(Canvas c, Size s) {
    const base = Color(0xFFDCE6C4);
    c.drawRect(Offset.zero & s, Paint()..color = base);

    // dirt path beside the fields
    final pathPaint = Paint()
      ..color = const Color(0xFFEBDDBB)
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;
    c.drawLine(Offset(s.width * .27, s.height * .1), Offset(s.width * .27, s.height * .9), pathPaint);

    // barn
    final bx = s.width * .04, by = s.height * .40;
    c.drawLine(Offset(bx + 35, by + 58), Offset(s.width * .27, by + 58), pathPaint);
    c.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(bx, by, 70, 56), const Radius.circular(4)),
      Paint()..color = const Color(0xFFC0392B),
    );
    c.drawPath(
      Path()
        ..moveTo(bx - 6, by + 4)
        ..lineTo(bx + 35, by - 24)
        ..lineTo(bx + 76, by + 4)
        ..close(),
      Paint()..color = const Color(0xFF8E2A20),
    );
    c.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(bx + 24, by + 24, 22, 32), const Radius.circular(3)),
      Paint()..color = Colors.white,
    );

    for (var i = 0; i < 3; i++) {
      final r = _px(_farmZones[i], s);
      final rr = RRect.fromRectAndRadius(r, const Radius.circular(14));
      final on = i == focus;

      c.save();
      c.clipRRect(rr);
      if (i == 0) {
        c.drawRect(r, Paint()..color = const Color(0xFFE9E3A6));
        final stripe = Paint()
          ..color = const Color(0xFFC9B94A).withOpacity(.6)
          ..strokeWidth = 3;
        for (double x = r.left + 6; x < r.right; x += 14) {
          c.drawLine(Offset(x, r.top), Offset(x, r.bottom), stripe);
        }
      } else if (i == 1) {
        c.drawRect(r, Paint()..color = const Color(0xFFC9DBA8));
        final grid = Paint()
          ..color = Colors.white.withOpacity(.45)
          ..strokeWidth = 1;
        for (double x = r.left; x <= r.right; x += 26) {
          c.drawLine(Offset(x, r.top), Offset(x, r.bottom), grid);
        }
        for (double y = r.top; y <= r.bottom; y += 26) {
          c.drawLine(Offset(r.left, y), Offset(r.right, y), grid);
        }
      } else {
        c.drawRect(r, Paint()..color = const Color(0xFFBFDDF0));
        final ring = Paint()
          ..color = Colors.white.withOpacity(.7)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2;
        for (var k = 1; k <= 3; k++) {
          c.drawOval(
            Rect.fromCenter(center: r.center, width: r.width * .22 * k, height: r.height * .26 * k),
            ring,
          );
        }
      }
      c.restore();

      _dashed(
        c,
        Path()..addRRect(rr),
        Paint()
          ..color = const Color(0xFF8A6B45)
          ..style = PaintingStyle.stroke
          ..strokeWidth = on ? 3 : 1.5,
      );
      if (!on) c.drawRRect(rr, Paint()..color = base.withOpacity(.55));
      _label(c, labels[i], r.topLeft + const Offset(10, 8), on);
    }
  }

  void _festival(Canvas c, Size s) {
    c.drawRect(Offset.zero & s, Paint()..color = const Color(0xFFDDE1EC));
    final grid = Paint()
      ..color = Colors.white.withOpacity(.55)
      ..strokeWidth = 1;
    for (double x = 0; x < s.width; x += 28) {
      c.drawLine(Offset(x, 0), Offset(x, s.height), grid);
    }
    for (double y = 0; y < s.height; y += 28) {
      c.drawLine(Offset(0, y), Offset(s.width, y), grid);
    }

    final ctr = _festZones.map((f) => _px(f, s).center).toList();
    c.drawPath(
      Path()
        ..moveTo(ctr[0].dx, ctr[0].dy)
        ..quadraticBezierTo(ctr[1].dx, ctr[0].dy, ctr[1].dx, ctr[1].dy)
        ..moveTo(ctr[0].dx, ctr[0].dy)
        ..quadraticBezierTo(ctr[2].dx, ctr[0].dy, ctr[2].dx, ctr[2].dy)
        ..moveTo(ctr[1].dx, ctr[1].dy)
        ..quadraticBezierTo(ctr[1].dx, ctr[2].dy, ctr[2].dx, ctr[2].dy),
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 12
        ..strokeCap = StrokeCap.round,
    );

    for (var i = 0; i < 3; i++) {
      final r = _px(_festZones[i], s);
      final rr = RRect.fromRectAndRadius(r, const Radius.circular(14));
      final on = i == focus;
      c.drawRRect(rr, Paint()..color = accent.withOpacity(on ? .28 : .10));
      _dashed(
        c,
        Path()..addRRect(rr),
        Paint()
          ..color = accent.withOpacity(on ? .9 : .35)
          ..style = PaintingStyle.stroke
          ..strokeWidth = on ? 2.5 : 1.5,
      );
      _label(c, labels[i], r.topLeft + const Offset(10, 8), on);
    }
  }

  @override
  bool shouldRepaint(covariant _CanvasPainter old) =>
      old.kind != kind || old.accent != accent || old.focus != focus;
}

// ─────────────────────────────────────────────────────────────
// CONTEXT SHEET
// ─────────────────────────────────────────────────────────────
class FarmContextSheet extends StatefulWidget {
  final GuideConfig config;
  final int zone;
  const FarmContextSheet({super.key, required this.config, required this.zone});

  @override
  State<FarmContextSheet> createState() => _FarmContextSheetState();
}

class _FarmContextSheetState extends State<FarmContextSheet> {
  int _sub = 0;

  @override
  void didUpdateWidget(covariant FarmContextSheet old) {
    super.didUpdateWidget(old);
    if (old.zone != widget.zone) _sub = 0;
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.config;
    final tab = c.tabs[widget.zone];
    final rows = c.info[widget.zone][_sub];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(.05), blurRadius: 16, offset: const Offset(0, 6)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: AnimatedSwitcher(
                  duration: 250.ms,
                  layoutBuilder: _leftLayout,
                  child: Text(
                    tab.label,
                    key: ValueKey(tab.label),
                    style: TextStyle(
                      fontFamily: 'Georgia',
                      fontFamilyFallback: const ['serif'],
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: c.ink,
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(9),
                decoration: BoxDecoration(
                  color: c.accent.withOpacity(.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(tab.icon, size: 20, color: c.accent),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (var i = 0; i < c.subPills.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () => setState(() => _sub = i),
                      child: AnimatedContainer(
                        duration: 200.ms,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
                        decoration: BoxDecoration(
                          color: i == _sub ? c.accent.withOpacity(.12) : c.background,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          c.subPills[i],
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: i == _sub ? c.accent : c.ink.withOpacity(.7),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          AnimatedSwitcher(
            duration: 250.ms,
            layoutBuilder: _leftLayout,
            child: SizedBox(
              key: ValueKey('${widget.zone}-$_sub'),
              width: double.infinity,
              child: Column(
                children: [
                  for (var i = 0; i < rows.length; i++)
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: c.accent.withOpacity(.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(rows[i].icon, size: 19, color: c.accent),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  rows[i].title,
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                    color: c.ink,
                                  ),
                                ),
                                Text(
                                  rows[i].subtitle,
                                  style: TextStyle(fontSize: 12.5, color: c.ink.withOpacity(.55)),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            rows[i].trailing,
                            style: TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w700,
                              color: c.accent,
                            ),
                          ),
                        ],
                      )
                          .animate()
                          .fadeIn(delay: (i * 70).ms, duration: 250.ms)
                          .slideX(begin: .05, end: 0),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 300.ms, duration: 400.ms).slideY(begin: .15, end: 0);
  }
}

// ─────────────────────────────────────────────────────────────
// FLOATING BOTTOM NAV
// ─────────────────────────────────────────────────────────────
class FarmBottomNavigation extends StatelessWidget {
  final GuideConfig config;
  final int selected;
  final ValueChanged<int> onSelected;
  const FarmBottomNavigation({
    super.key,
    required this.config,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(.12), blurRadius: 24, offset: const Offset(0, 8)),
        ],
      ),
      child: Row(
        children: [
          for (var i = 0; i < config.nav.length; i++)
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => onSelected(i),
                child: AnimatedContainer(
                  duration: 250.ms,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  decoration: BoxDecoration(
                    color: i == selected ? config.accent.withOpacity(.12) : Colors.transparent,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        config.nav[i].icon,
                        size: 22,
                        color: i == selected ? config.accent : config.ink.withOpacity(.5),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        config.nav[i].label,
                        style: TextStyle(
                          fontSize: 10.5,
                          fontWeight: i == selected ? FontWeight.w700 : FontWeight.w500,
                          color: i == selected ? config.accent : config.ink.withOpacity(.5),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    ).animate().fadeIn(delay: 400.ms).slideY(begin: 1, end: 0, curve: Curves.easeOutCubic);
  }
}
