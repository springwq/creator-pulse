# CreatorPulse

![CI Status](https://github.com/springwq/creator-pulse/actions/workflows/ci.yml/badge.svg)
![Code Coverage](https://codecov.io/gh/springwq/creator-pulse/branch/main/graph/badge.svg)
![Security](https://img.shields.io/badge/Security-Brakeman%20%7C%20Bundler%20Audit-brightgreen?logo=security)
![Ruby Version](https://img.shields.io/badge/Ruby-4.0-red?logo=ruby&logoColor=white)
![Rails Version](https://img.shields.io/badge/Rails-8.1-red?logo=rubyonrails&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-14+-blue?logo=postgresql&logoColor=white)
![Maintenance](https://img.shields.io/badge/Maintained-yes-green)

A creative content management dashboard. Manage influencer creators and their social media content across Instagram, TikTok, and YouTube.

## Features

### Required Features
- **Creators List (Homepage)** — Browse all creators with name, email, and content count
- **Creator Detail Page** — View creator info with paginated content list and provider filtering
- **Content Management** — Create, edit, and delete content with full form validation and inline error display
- **Service Object** — `Contents::Create` service with success/failure result pattern
- **Unit Tests** — RSpec tests covering model validations and service object (29 specs)

### Optional Features
- **Stats Dashboard** — Overview cards showing total creators, contents, and per-provider counts
- **Search** — Filter creators by name (case-insensitive, PostgreSQL ILIKE)
- **Seed Data** — 7 creators with 27 content items distributed across all providers

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Framework | Ruby on Rails 8.1 |
| Language | Ruby 4.0 |
| Database | PostgreSQL |
| Frontend | Tailwind CSS 4 (utility-only, no custom CSS) |
| Testing | RSpec + FactoryBot + Shoulda Matchers |
| Pagination | Kaminari |
| Deployment | Kamal 2 (Docker-based) |

## Getting Started

### Prerequisites

- Ruby 4.0+
- PostgreSQL 14+
- Node.js (for asset pipeline)

### Installation

```bash
# Clone the repository
git clone https://github.com/springwq/creator-pulse.git
cd creator-pulse

# Install dependencies
bundle install

# Create and set up the database
bin/rails db:create db:migrate db:seed

# Start the development server
bin/dev
```

Visit `http://localhost:3000` to see the app.

### Running Tests

```bash
bundle exec rspec

# With documentation format
bundle exec rspec --format documentation
```

## Design Decisions

### Service Object Pattern
Content creation logic is extracted into `Contents::Create` to keep controllers thin and enable independent testing. The service returns a `BaseResult` object with `success?`/`failure?` methods, providing a clean interface for handling outcomes.

### Enum for Social Media Provider
`social_media_provider` uses a Rails integer enum (`instagram: 0, tiktok: 1, youtube: 2`) for type-safe provider handling, database-efficient storage, and built-in scope generation.

### Validation Strategy
Validations are layered at both the database level (NOT NULL, UNIQUE constraints) and the model level (presence, format, uniqueness). This ensures data integrity even if validations are bypassed.

### Content Count Optimization
The `with_content_count` scope uses `LEFT OUTER JOIN` with `GROUP BY` to load content counts in a single query, avoiding N+1 issues on the creators index page.

### Tailwind CSS Only
All styling uses Tailwind CSS utility classes directly in templates. No custom CSS files are created, following the MR-3 requirement. Repeated patterns are extracted into Rails partials rather than using `@apply`.

## Project Structure

```
app/
├── controllers/
│   ├── creators_controller.rb    # Index (with search/stats), Show (with filter)
│   └── contents_controller.rb    # CRUD using service object
├── models/
│   ├── creator.rb                # Validations, scopes, associations
│   └── content.rb                # Validations, enum, associations
├── services/
│   ├── base_result.rb            # Success/failure result object
│   └── contents/
│       └── create.rb             # Content creation service
└── views/
    ├── layouts/application.html.erb
    ├── creators/                  # Index + Show
    ├── contents/                  # Form + New + Edit
    └── kaminari/                  # Tailwind pagination theme
spec/
├── models/                        # Creator + Content specs
├── services/contents/             # Create service spec
└── factories/                     # FactoryBot definitions
```

## AI Tools Used

This project was built with the assistance of:

- **Claude Code (CLI)** — Anthropic's AI coding assistant, used for code generation, project scaffolding, and implementation of models, controllers, views, services, and tests
- **OpenAI Codex CLI** — Used for automated code review of pull requests, providing feedback on code quality and potential issues

Both tools were used as pair-programming aids. All generated code was reviewed and validated before committing.
