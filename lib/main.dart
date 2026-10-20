// pubspec.yaml -> dependencies: flutter_animate: ^4.5.0
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

// ─────────────────────────────────────────────────────────────
// ENTRY — swap GuideConfig.farm / GuideConfig.festival
// ─────────────────────────────────────────────────────────────
void main() => runApp(GuideApp(config: GuideConfig.farm));

// ─────────────────────────────────────────────────────────────
// DOMAIN / CONFIG
// ─────────────────────────────────────────────────────────────
enum CanvasKind { farm, festival }

class ChipItem {
  final String label;
  final IconData icon;
  const ChipItem(this.label, this.icon);
}

class MapMarker {
  final double x, y; // -1..1 alignment inside canvas
  final Widget child;
  final bool pulse;
  const MapMarker(this.x, this.y, this.child, {this.pulse = false});
}

class GuideConfig {
  final String title, subtitle, zoneTitle;
  final IconData subtitleIcon, zoneIcon;
  final Color background, accent, ink;
  final List<ChipItem> tabs;
  final int activeTab;
  final List<String> subPills;
  final List<ChipItem> nav;
  final int activeNav;
  final CanvasKind canvas;
  final List<MapMarker> markers;

  const GuideConfig({
    required this.title,
    required this.subtitle,
    required this.subtitleIcon,
    required this.zoneTitle,
    required this.zoneIcon,
    required this.background,
    required this.accent,
    required this.ink,
    required this.tabs,
    required this.activeTab,
    required this.subPills,
    required this.nav,
    required this.activeNav,
    required this.canvas,
    required this.markers,
  });

  static const farm = GuideConfig(
    title: 'My Farm',
    subtitle: 'Green Valley Farm - 12.5 ha',
    subtitleIcon: Icons.location_on_outlined,
    zoneTitle: 'Animal Area',
    zoneIcon: Icons.pets_outlined,
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
      MapMarker(-0.1, -0.45, Text('🐄', style: TextStyle(fontSize: 26))),
      MapMarker(0.45, -0.25, Text('🐄', style: TextStyle(fontSize: 26))),
      MapMarker(0.1, 0.1, Text('🐄', style: TextStyle(fontSize: 26))),
      MapMarker(0.6, 0.4, Text('🐄', style: TextStyle(fontSize: 26))),
      MapMarker(-0.05, 0.55, Text('🐄', style: TextStyle(fontSize: 26))),
    ],
  );

  static final festival = GuideConfig(
    title: 'Festival Guide',
    subtitle: 'Sunset Fields - 3 Stages',
    subtitleIcon: Icons.location_on_outlined,
    zoneTitle: 'Dance Tent',
    zoneIcon: Icons.graphic_eq,
    background: const Color(0xFFEEF0F3),
    accent: const Color(0xFF3B2F8F),
    ink: const Color(0xFF1E2230),
    tabs: const [
      ChipItem('Main Stage', Icons.mic_external_on_outlined),
      ChipItem('Dance Tent', Icons.graphic_eq),
      ChipItem('Food Court', Icons.restaurant_outlined),
    ],
    activeTab: 1,
    subPills: const ['Lineup', 'Crowd', 'Next set'],
    nav: const [
      ChipItem('Home', Icons.home_outlined),
      ChipItem('Map', Icons.map_outlined),
      ChipItem('Lineup', Icons.queue_music_outlined),
      ChipItem('Tickets', Icons.confirmation_number_outlined),
      ChipItem('Profile', Icons.person_outline),
    ],
    activeNav: 1,
    canvas: CanvasKind.festival,
    markers: const [
      MapMarker(-0.55, -0.45, _GlowNode(Icons.mic, Color(0xFF7C6CFF)), pulse: true),
      MapMarker(0.5, -0.4, _GlowNode(Icons.speaker, Color(0xFFFF6FA5)), pulse: true),
      MapMarker(0.0, 0.05, _GlowNode(Icons.graphic_eq, Color(0xFF3B2F8F)), pulse: true),
      MapMarker(-0.6, 0.5, _GlowNode(Icons.restaurant, Color(0xFFFFB347)), pulse: true),
      MapMarker(0.6, 0.5, _GlowNode(Icons.wc, Color(0xFF3CC8A0)), pulse: true),
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
                  FarmCanvasMap(key: ValueKey(_tab), config: c),
                  const SizedBox(height: 16),
                  FarmContextSheet(config: c, zone: c.tabs[_tab].label),
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
  const FarmCanvasMap({super.key, required this.config});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 340,
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
            CustomPaint(painter: _CanvasPainter(config.canvas, config.accent)),
            for (var i = 0; i < config.markers.length; i++)
              Align(
                alignment: Alignment(config.markers[i].x, config.markers[i].y),
                child: _animatedMarker(config.markers[i], i),
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

  Widget _animatedMarker(MapMarker m, int i) {
    final a = m.child.animate(
      delay: (350 + i * 120).ms,
      onPlay: (c) => c.repeat(reverse: true),
    );
    return m.pulse
        ? a.scale(
            begin: const Offset(1, 1),
            end: const Offset(1.18, 1.18),
            duration: 1200.ms,
            curve: Curves.easeInOut,
          )
        : a.slideX(begin: -.15, end: .15, duration: (2200 + i * 300).ms, curve: Curves.easeInOut);
  }
}

class _CanvasPainter extends CustomPainter {
  final CanvasKind kind;
  final Color accent;
  _CanvasPainter(this.kind, this.accent);

  @override
  void paint(Canvas canvas, Size s) {
    kind == CanvasKind.farm ? _farm(canvas, s) : _festival(canvas, s);
  }

  void _dashed(Canvas c, Path p, Paint paint, {double dash = 7, double gap = 5}) {
    for (final m in p.computeMetrics()) {
      double d = 0;
      while (d < m.length) {
        c.drawPath(m.extractPath(d, d + dash), paint);
        d += dash + gap;
      }
    }
  }

  void _farm(Canvas c, Size s) {
    c.drawRect(Offset.zero & s, Paint()..color = const Color(0xFFDCE6C4));

    // pasture area + grid
    final pasture = Rect.fromLTWH(s.width * .30, s.height * .10, s.width * .64, s.height * .80);
    c.drawRRect(
      RRect.fromRectAndRadius(pasture, const Radius.circular(14)),
      Paint()..color = const Color(0xFFC9DBA8),
    );
    final grid = Paint()
      ..color = Colors.white.withOpacity(.4)
      ..strokeWidth = 1;
    for (double x = pasture.left; x <= pasture.right; x += 30) {
      c.drawLine(Offset(x, pasture.top), Offset(x, pasture.bottom), grid);
    }
    for (double y = pasture.top; y <= pasture.bottom; y += 30) {
      c.drawLine(Offset(pasture.left, y), Offset(pasture.right, y), grid);
    }

    // fence
    _dashed(
      c,
      Path()..addRRect(RRect.fromRectAndRadius(pasture, const Radius.circular(14))),
      Paint()
        ..color = const Color(0xFF8A6B45)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3,
    );

    // path from barn to gate
    final path = Paint()
      ..color = const Color(0xFFEBDDBB)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 14
      ..strokeCap = StrokeCap.round;
    c.drawPath(
      Path()
        ..moveTo(s.width * .16, s.height * .62)
        ..quadraticBezierTo(s.width * .2, s.height * .85, s.width * .3, s.height * .8),
      path,
    );

    // barn
    final bx = s.width * .04, by = s.height * .34;
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
    c.drawLine(
      Offset(bx + 24, by + 24),
      Offset(bx + 46, by + 56),
      Paint()
        ..color = const Color(0xFFC0392B)
        ..strokeWidth = 2,
    );
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

    // paths
    final road = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;
    c.drawPath(
      Path()
        ..moveTo(s.width * .2, s.height * .3)
        ..quadraticBezierTo(s.width * .5, s.height * .5, s.width * .8, s.height * .3)
        ..moveTo(s.width * .2, s.height * .75)
        ..quadraticBezierTo(s.width * .5, s.height * .5, s.width * .8, s.height * .75),
      road,
    );

    // stages
    final stage = Paint()..color = accent.withOpacity(.18);
    final stroke = Paint()
      ..color = accent.withOpacity(.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    for (final r in [
      Rect.fromLTWH(s.width * .08, s.height * .1, s.width * .3, s.height * .2),
      Rect.fromLTWH(s.width * .62, s.height * .1, s.width * .3, s.height * .2),
      Rect.fromCenter(center: Offset(s.width * .5, s.height * .5), width: s.width * .34, height: s.height * .22),
    ]) {
      final rr = RRect.fromRectAndRadius(r, const Radius.circular(12));
      c.drawRRect(rr, stage);
      _dashed(c, Path()..addRRect(rr), stroke);
    }
  }

  @override
  bool shouldRepaint(covariant _CanvasPainter old) => old.kind != kind || old.accent != accent;
}

// ─────────────────────────────────────────────────────────────
// CONTEXT SHEET
// ─────────────────────────────────────────────────────────────
class FarmContextSheet extends StatefulWidget {
  final GuideConfig config;
  final String zone;
  const FarmContextSheet({super.key, required this.config, required this.zone});

  @override
  State<FarmContextSheet> createState() => _FarmContextSheetState();
}

class _FarmContextSheetState extends State<FarmContextSheet> {
  int _sub = 0;

  @override
  Widget build(BuildContext context) {
    final c = widget.config;
    return Container(
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
                  child: Text(
                    widget.zone,
                    key: ValueKey(widget.zone),
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
                child: Icon(c.zoneIcon, size: 20, color: c.accent),
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
