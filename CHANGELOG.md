# Changelog

## 3.0.0 (2026-03-17)

### Breaking
- Removed duplicate plugins: `github-operations` (use `github`), `systematic-debugging` (use `systematic-debugger`)

### Added
- 12 new plugins since v2.0: api-docs-generator, ci-cd-helper, code-reviewer, commit-message-generator, error-explainer, manage-smithery-deployment, performance-optimizer, pr-analyzer, refactor-assistant, security-scanner, tdd-workflow, test-writer
- GitHub issue templates and PR template
- Changelog
- Beginner-friendly installation guide with visual diagrams
- Claude 4.5/4.6 model compatibility documentation
- Full hook events reference (22 events)
- Plugin component types documentation (7 types)

### Fixed
- All plugin counts corrected (53 plugins, was incorrectly showing 41)
- Badge counts updated to match actual plugin count
- marketplace.json categories fixed for multi-type plugins
- All plugin.json files standardized to consistent schema
- Statistics table corrected

### Changed
- README completely rewritten with step-by-step beginner guide
- marketplace.json version bumped to 3.0.0
- Added model compatibility info (Opus 4.6, Sonnet 4.6, Haiku 4.5)

## 2.0.0 (2026-03-16)

### Added
- Initial marketplace with 41 plugins
- Install script with OS detection
- Mermaid architecture diagrams
- Cross-device sync documentation

## 1.0.0 (2026-03-16)

### Added
- Initial repository structure
- Plugin marketplace concept
