# Tech Stack

## Context

Global tech stack defaults for Agent OS projects, overridable in project-specific `.agent-os/product/tech-stack.md`.

- App Framework: Ruby on Rails 8.0+
- Language: Ruby 3.2+
- Primary Database: PostgreSQL 17+
- ORM: Active Record
- JavaScript Framework: React latest stable
- Build Tool: Vite
- Import Strategy: Node.js modules
- Package Manager: npm
- Node Version: 22 LTS
- CSS Framework: TailwindCSS 4.0+
- UI Components: Instrumental Components latest
- UI Installation: Via development gems group
- Font Provider: Google Fonts
- Font Loading: Self-hosted for performance
- Icons: Lucide React components
- Application Hosting: Digital Ocean App Platform/Droplets
- Hosting Region: Primary region based on user base
- Database Hosting: Digital Ocean Managed PostgreSQL
- Database Backups: Daily automated
- Asset Storage: Amazon S3
- CDN: CloudFront
- Asset Access: Private with signed URLs
- CI/CD Platform: GitHub Actions
- CI/CD Trigger: Push to master/dev/staging branches
- Tests: Run before deployment
- Production Environment: master branch
- Beta Environment: dev branch
- Staging Environment: staging branch

## Multi-Plateform Development

- Multi-Plateform Framework: Flutter latest stable
- Dart SDK: 3.6+
- State Management: GetX 5.0+
- Backend Service: Supabase
- Authentication: Supabase Auth
- Database: Supabase (PostgreSQL)
- UI Animations: flutter_animate
- Fonts: Google Fonts
- Environment Variables: flutter_dotenv
- Code Generation: freezed, build_runner
- Logging: talker, logging
- Testing Framework: flutter_test, glados, mockito
- Linting: flutter_lints
- Platform Support: iOS, Android, Web, Linux, macOS, Windows
