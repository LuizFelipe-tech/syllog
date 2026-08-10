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
# Environment Setup (DX)
# ==============================================================================

# Installs all required CLI tools for local development. Run this once after cloning.
[group('setup')]
bootstrap:
    cargo install cargo-audit cargo-llvm-cov
    @echo "Note: Ensure 'vale' is installed via your system package manager (brew, apt, winget)."

# ==============================================================================
# Code Formatting & Prose
# ==============================================================================

# Formats all Rust source files (uses Nightly toolchain from rust-toolchain.toml).
[group('quality')]
fmt:
    cargo fmt

# Verifies that all source files conform to formatting standards without modifying them.
[group('quality')]
fmt-check:
    cargo fmt --check

# Runs Vale to check documentation prose and grammar against style policies.
[group('quality')]
spell:
    vale src/ docs/ README.md

# ==============================================================================
# Static Analysis & Security
# ==============================================================================

# Runs a permissive clippy configuration suitable for rapid local development.
[group('linting')]
lint-dev:
    cargo clippy {{ CARGO_FLAGS }}

# Runs strict clippy analysis, treating all linter warnings as compiler errors.
[group('linting')]
lint:
    cargo clippy {{ CARGO_FLAGS }} -- -D warnings

# Audits dependencies for known security vulnerabilities. Requires 'cargo-audit'.
[group('security')]
audit:
    cargo audit

# ==============================================================================
# Testing & Code Coverage
# ==============================================================================

# Executes the complete test suite.
[group('testing')]
test:
    cargo test --all-features

# Generates a quick text-based code coverage report. Requires 'cargo-llvm-cov'.
[group('testing')]
cov:
    cargo llvm-cov --all-features --workspace --summary-only

# Generates an interactive HTML code coverage report. Requires 'cargo-llvm-cov'.
[group('testing')]
cov-html:
    cargo llvm-cov --all-features --workspace --html
    @echo "Interactive report available at: target/llvm-cov/html/index.html"

# ==============================================================================
# CI Workflow & Maintenance
# ==============================================================================

# Simulates GitHub Actions workflows locally using act. Requires Docker.
[group('ci')]
ci-local:
    act pull_request

# Cleans build artifacts and intermediate files.
[group('utility')]
clean:
    cargo clean

# Performs a comprehensive verification check prior to committing or pushing code.
[group('ci')]
check-all: fmt-check lint audit spell test cov
    @echo "All verification checks passed successfully. Code meets professional standards."
