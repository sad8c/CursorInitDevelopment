---
name: testing-policy
description: 'Defines pragmatic testing expectations for {{PROJECT_NAME}}, including coverage decisions, mocking patterns, and refactor-first testability guidance. Use when implementing or refactoring code.'
---

# Testing Policy

Use this skill when changing implementation code in the project.

{{#IF_TYPESCRIPT}}

## Preferred Test Structure

- Keep tests close to the seam under change:
  - pure logic/helpers/services: `*.test.ts`
  - hooks/components/pages: `*.test.tsx`
  - routes: `src/app/api/**/route.test.ts` (or equivalent for your framework)
- Keep route tests focused on transport/auth/validation/ownership behavior.
- Move non-HTTP business logic into services/helpers and cover it with direct unit tests.
- Use fake timers for polling/time-based behavior.

## Mocking Patterns

- Auth wrappers: mock auth outcomes explicitly (authenticated, unauthenticated, forbidden).
- Database/ORM: mock DB calls at the repository/service boundary; avoid live DB in unit/route suites.
- Background jobs / queues: mock event dispatch/scheduling; assert payload contract and call intent.
- External API providers: stub provider responses and error paths; assert normalization/fallback behavior.
- Model/LLM calls: mock model client and return deterministic fixtures for success/failure/invalid output branches.
  {{/IF_TYPESCRIPT}}

{{#IF_PYTHON}}

## Preferred Test Structure

- Keep tests close to the seam under change:
  - pure logic/helpers/services: `test_*.py` or `*_test.py`
  - API routes: `test_routes_*.py`
  - integrations: `test_*_integration.py`
- Keep route tests focused on transport/auth/validation behavior.
- Move non-HTTP business logic into services/helpers and cover with direct unit tests.
- Use `pytest.fixture` for reusable setup; prefer factory functions over complex fixture chains.

## Mocking Patterns

- Auth: mock auth middleware/dependencies explicitly (authenticated, unauthenticated, forbidden).
- Database/ORM: use test database or mock DB calls at the repository/service boundary.
- Background jobs / queues: mock task dispatch; assert payload contract and call intent.
- External API providers: use `responses` or `httpx_mock` for HTTP stubs; assert normalization/fallback.
- Model/LLM calls: mock client and return deterministic fixtures.
  {{/IF_PYTHON}}

{{#IF_GO}}

## Preferred Test Structure

- Keep tests in `*_test.go` alongside production code.
- Use table-driven tests for functions with multiple input/output combinations.
- Keep handler tests focused on HTTP contract (status, headers, body shape).
- Move business logic out of handlers into service packages.

## Mocking Patterns

- Use interfaces for dependencies and provide test doubles.
- Auth: provide mock auth middleware returning test principals.
- Database: use mock repositories or test containers for integration tests.
- External services: use `httptest.NewServer` for HTTP-based dependencies.
  {{/IF_GO}}

{{#IF_RUST}}

## Preferred Test Structure

- Unit tests in `#[cfg(test)] mod tests` within the source file.
- Integration tests in `tests/` directory.
- Use `#[test]` and `#[tokio::test]` for async tests.

## Mocking Patterns

- Use trait-based dependency injection for testable interfaces.
- Mock external services with `mockall` or custom trait implementations.
- Use `wiremock` for HTTP-based dependency stubs.
  {{/IF_RUST}}

## Coverage Selection Matrix

- Unit tests: pure logic, parsers, formatters, validators, service helpers, repository helpers.
- Route/handler tests: transport contracts (happy path, auth, validation, ownership, error mapping).
- Component/hook tests: user-visible state and interactions (where applicable).
- E2E smoke: only critical end-to-end workflows; keep external providers stubbed.

## Refactor For Testability First

Before adding broad coverage in legacy areas:

1. Add characterization tests for current behavior.
2. Extract business logic out of handlers/controllers into services/helpers.
3. Isolate provider calls behind small adapters/interfaces.
4. Keep route handlers thin (`request parse -> auth -> validation -> service -> response mapping`).
5. Add focused tests at each seam instead of one heavy integration test.
