# Copyright (c) 2026 Luiz Felipe do Nascimento Melos
# SPDX-License-Identifier: Apache-2.0
# System: Syllog Logic Engine | Driven by High-Performance Engineering

# Configure shell to fail immediately if any command in a recipe returns a non-zero exit status.
set windows-shell := ["powershell.exe", "-NoProfile", "-Command"]
set shell := ["bash", "-uc"]

# Global Cargo flags for uniform execution across lint and test tasks.
CARGO_FLAGS := "--all-targets --all-features"

# Lists all available development tasks.
default:
    @just --list

# ==============================================================================
# Aliases for Rapid Execution
# ==============================================================================

alias c := check-all
alias t := test
alias l := lint

# ==============================================================================
# Code Formatting & Prose
# ==============================================================================

[group('quality')]
# Formats all Rust source files (uses Nightly toolchain from rust-toolchain.toml).
fmt:
    cargo fmt

[group('quality')]
# Verifies that all source files conform to formatting standards without modifying them.
fmt-check:
    cargo fmt --check

[group('quality')]
# Runs Vale to check documentation prose and grammar against style policies.
spell:
    vale src/ docs/ README.md

# ==============================================================================
# Static Analysis & Security
# ==============================================================================

[group('linting')]
# Runs a permissive clippy configuration suitable for rapid local development.
lint-dev:
    cargo clippy {{ CARGO_FLAGS }}

[group('linting')]
# Runs strict clippy analysis, treating all linter warnings as compiler errors.
lint:
    cargo clippy {{ CARGO_FLAGS }} -- -D warnings

[group('security')]
# Audits dependencies for known security vulnerabilities. Requires 'cargo-audit'.
audit:
    cargo audit

# ==============================================================================
# Testing & Code Coverage
# ==============================================================================

[group('testing')]
# Executes the complete test suite.
test:
    cargo test --all-features

[group('testing')]
# Generates a quick text-based code coverage report. Requires 'cargo-llvm-cov'.
cov:
    cargo llvm-cov --all-features --workspace --summary-only

[group('testing')]
# Generates an interactive HTML code coverage report. Requires 'cargo-llvm-cov'.
cov-html:
    cargo llvm-cov --all-features --workspace --html
    @echo "Interactive report available at: target/llvm-cov/html/index.html"

# ==============================================================================
# CI Workflow & Maintenance
# ==============================================================================

[group('ci')]
# Simulates GitHub Actions workflows locally using act. Requires Docker.
ci-local:
    act pull_request

[group('utility')]
# Cleans build artifacts and intermediate files.
clean:
    cargo clean

[group('ci')]
# Performs a comprehensive verification check prior to committing or pushing code.
check-all: fmt-check lint audit spell test cov
    @echo "All verification checks passed successfully. Code meets professional standards."