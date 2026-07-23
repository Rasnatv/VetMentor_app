import 'package:flutter/material.dart';
const _blue = Color(0xFF185FA5);
const _blueBg = Color(0xFFE6F1FB);
const _teal = Color(0xFF0F6E56);
const _tealBg = Color(0xFFE1F5EE);
const _purple = Color(0xFF534AB7);
const _purpleBg = Color(0xFFEEEDFE);
const _coral = Color(0xFF993C1D);
const _coralBg = Color(0xFFFAECE7);

const double _kNodeColumnWidth = 52;

class CareerPath {
  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
  final String category;
  final Color accent;
  final Color accentBg;

  /// Longer summary shown at the top of the detail screen.
  final String description;

  /// Who is eligible / entry requirement.
  final String eligibility;

  /// Typical salary range, shown as a highlighted stat on the detail screen.
  final String salaryRange;

  /// Step-by-step path to get into this career.
  final List<String> roadmap;

  /// Key skills / exams / certifications useful for this path.
  final List<String> skills;

  /// Quick pros / highlights, shown as chips.
  final List<String> highlights;

  const CareerPath({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.category,
    required this.accent,
    required this.accentBg,
    required this.description,
    required this.eligibility,
    required this.salaryRange,
    required this.roadmap,
    required this.skills,
    required this.highlights,
  });
}

class CareerData {
  static const List<CareerPath> paths = [
    CareerPath(
      id: '1',
      title: 'Govt Vet Officer / LDO',
      subtitle: 'State PSC · ₹50,000–80,000/mo',
      icon: Icons.account_balance_outlined,
      category: 'Public service',
      accent: _blue,
      accentBg: _blueBg,
      description:
      'Work as a Veterinary Officer or Livestock Development Officer under the '
          'state Animal Husbandry Department, managing veterinary hospitals, '
          'disease control programs and farmer outreach.',
      eligibility: 'B.V.Sc & A.H degree, registered with State/Indian Veterinary Council',
      salaryRange: '₹50,000 – ₹80,000 / month (pay scale + allowances)',
      roadmap: [
        'Complete B.V.Sc & A.H and register with the Veterinary Council',
        'Apply for State PSC Veterinary Officer / LDO notifications',
        'Clear the written exam and interview',
        'Join as Veterinary Officer / LDO under the Animal Husbandry Dept.',
        'Promotions to Assistant Director / Deputy Director over time',
      ],
      skills: ['State PSC exam prep', 'Animal husbandry schemes', 'Public health basics'],
      highlights: ['Job security', 'Pension benefits', 'Rural service'],
    ),
    CareerPath(
      id: '2',
      title: 'Private Pet Practice',
      subtitle: 'Clinics & Hospitals · ₹40,000–1L/mo',
      icon: Icons.favorite_border_rounded,
      category: 'Animal care',
      accent: _teal,
      accentBg: _tealBg,
      description:
      'Practice as a small-animal / companion-animal veterinarian in private '
          'clinics, pet hospitals, or by starting your own practice, focusing on '
          'diagnostics, surgery, and preventive pet care.',
      eligibility: 'B.V.Sc & A.H degree; internship experience preferred',
      salaryRange: '₹40,000 – ₹1,00,000+ / month (higher with own practice)',
      roadmap: [
        'Finish internship with hands-on clinical rotations',
        'Join an established pet clinic or hospital as an associate vet',
        'Build surgical & diagnostic experience over 2–3 years',
        'Optionally open your own clinic or specialise (dermatology, ortho, etc.)',
      ],
      skills: ['Small animal surgery', 'Client communication', 'Diagnostic imaging'],
      highlights: ['High growth potential', 'Entrepreneurship option', 'Urban demand'],
    ),
    CareerPath(
      id: '3',
      title: 'Dairy, Poultry & Food Safety',
      subtitle: 'Industry & Pharma · FSSAI roles',
      icon: Icons.factory_outlined,
      category: 'Industry & research',
      accent: _purple,
      accentBg: _purpleBg,
      description:
      'Work with dairy cooperatives, poultry integrators, feed & pharma '
          'companies, or food safety regulators (FSSAI) on quality control, '
          'production management and compliance.',
      eligibility: 'B.V.Sc & A.H; additional certification in food safety is a plus',
      salaryRange: '₹35,000 – ₹90,000 / month depending on employer',
      roadmap: [
        'Gain exposure to dairy/poultry operations during internship',
        'Apply to companies like Amul, dairy cooperatives, or poultry integrators',
        'Consider FSSAI Food Safety Officer exams for regulatory roles',
        'Move into quality assurance / production management roles',
      ],
      skills: ['Food safety standards', 'Quality control', 'Supply chain basics'],
      highlights: ['Corporate roles', 'Steady demand', 'Regulatory path available'],
    ),
    CareerPath(
      id: '4',
      title: 'Wildlife, Zoo & Animal Welfare',
      subtitle: 'NGOs · Conservation organisations',
      icon: Icons.park_outlined,
      category: 'Animal care',
      accent: _coral,
      accentBg: _coralBg,
      description:
      'Work with zoos, wildlife rescue centres, and animal welfare NGOs on '
          'conservation, rehabilitation, and field veterinary care for wild and '
          'shelter animals.',
      eligibility: 'B.V.Sc & A.H; wildlife handling training recommended',
      salaryRange: '₹25,000 – ₹60,000 / month (varies widely by organisation)',
      roadmap: [
        'Volunteer or intern with a wildlife rescue centre or NGO',
        'Build experience in wildlife/exotic animal handling',
        'Apply to zoos, forest departments, or conservation NGOs',
        'Pursue further training in wildlife medicine if interested',
      ],
      skills: ['Wildlife handling', 'Field work readiness', 'Conservation awareness'],
      highlights: ['Meaningful impact', 'Fieldwork', 'Global NGO opportunities'],
    ),
    CareerPath(
      id: '5',
      title: 'Research / M.V.Sc / PhD',
      subtitle: 'ICAR, Universities · Stipend + growth',
      icon: Icons.science_outlined,
      category: 'Industry & research',
      accent: _blue,
      accentBg: _blueBg,
      description:
      'Pursue postgraduate specialisation (M.V.Sc) and doctoral research '
          'through ICAR institutes or veterinary universities, working on animal '
          'science research and teaching.',
      eligibility: 'B.V.Sc & A.H with a good academic record; ICAR-JRF/NET qualifying score',
      salaryRange: 'Stipend ₹31,000–37,000/mo during study; faculty roles pay more later',
      roadmap: [
        'Prepare for and clear ICAR-JRF / NET entrance exam',
        'Join an M.V.Sc program in your area of interest',
        'Publish research and consider a PhD',
        'Move into research scientist or university faculty roles',
      ],
      skills: ['Research methodology', 'Academic writing', 'Lab techniques'],
      highlights: ['Specialisation', 'Academic career', 'International research links'],
    ),
    CareerPath(
      id: '6',
      title: 'UPSC IFS / ICAR / State PSC',
      subtitle: 'Civil services · Govt research roles',
      icon: Icons.workspace_premium_outlined,
      category: 'Public service',
      accent: _teal,
      accentBg: _tealBg,
      description:
      'Compete for premier civil services (Indian Forest Service) or ICAR '
          'scientist positions, combining veterinary knowledge with policy, '
          'administration or applied research at a national level.',
      eligibility: 'B.V.Sc & A.H (eligible degree) + UPSC/ICAR exam qualification',
      salaryRange: 'Govt pay scale (₹56,100+ starting, IFS) plus allowances',
      roadmap: [
        'Prepare for UPSC IFS or ICAR-ASRB exams alongside/after graduation',
        'Clear prelims, mains and interview stages',
        'Undergo service-specific training (e.g. IFS academy)',
        'Serve in forest/administrative or national research postings',
      ],
      skills: ['Competitive exam prep', 'Policy awareness', 'Leadership'],
      highlights: ['Prestige', 'National postings', 'Long-term career growth'],
    ),
    CareerPath(
      id: '7',
      title: 'Startups in Pet Care & Tech',
      subtitle: 'Nutrition, health tech · Equity growth',
      icon: Icons.rocket_launch_outlined,
      category: 'Global & growth',
      accent: _purple,
      accentBg: _purpleBg,
      description:
      'Join or found startups building pet nutrition products, telehealth '
          'platforms, diagnostics tech, or pet-care marketplaces — blending '
          'veterinary expertise with business and product skills.',
      eligibility: 'B.V.Sc & A.H; interest in business/tech is a strong plus',
      salaryRange: '₹30,000–₹80,000/mo + equity (varies widely by stage)',
      roadmap: [
        'Build domain expertise through clinical or industry experience',
        'Network within pet-tech / animal health startup communities',
        'Join as a veterinary consultant, product advisor, or co-founder',
        'Grow with the company or launch your own venture',
      ],
      skills: ['Product thinking', 'Business basics', 'Communication'],
      highlights: ['High upside', 'Fast-paced', 'Innovation-driven'],
    ),
    CareerPath(
      id: '8',
      title: 'USA/Canada — NAVLE / ECFVG',
      subtitle: 'International licensing path',
      icon: Icons.public_outlined,
      category: 'Global & growth',
      accent: _coral,
      accentBg: _coralBg,
      description:
      'Get licensed to practice veterinary medicine in the US or Canada via '
          'the ECFVG/PAVE certification and NAVLE exam, opening the door to '
          'international clinical careers.',
      eligibility: 'B.V.Sc & A.H; strong English proficiency (TOEFL/IELTS)',
      salaryRange: 'USD 70,000–1,20,000+/yr once licensed (US/Canada market)',
      roadmap: [
        'Get your degree evaluated via ECFVG or PAVE',
        'Complete required clinical proficiency exams',
        'Clear the NAVLE (North American Veterinary Licensing Exam)',
        'Apply for state licensure and start practicing in the US/Canada',
      ],
      skills: ['NAVLE exam prep', 'English proficiency', 'US clinical standards'],
      highlights: ['Global mobility', 'Higher earning potential', 'Long-term relocation'],
    ),
  ];
}
