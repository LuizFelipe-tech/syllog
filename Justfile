# Copyright (c) 2026 Luiz Felipe do Nascimento Melos
# SPDX-License-Identifier: Apache-2.0
# System: Syllog Logic Engine | Driven by High-Performance Engineering

# Justfile for orchestrating local development tasks in syllog.

# Configure shell to fail immediately if any command in a recipe returns a non-zero exit status.
set windows-shell := ["powershell.exe", "-NoProfile", "-Command"]
set shell := ["bash", "-uc"]

# Lists all available development tasks.
default:
    @just --list

# Formats all Rust source files. This requires the nightly toolchain
# due to unstable formatting options configured in rustfmt.toml.
fmt:
    cargo +nightly fmt

# Verifies that all source files conform to formatting standards without modifying them.
fmt-check:
    cargo +nightly fmt --check

# Runs a permissive clippy configuration suitable for rapid local development.
lint-dev:
    cargo clippy --all-targets --all-features

# Runs strict clippy analysis, treating all linter warnings as compiler errors.
lint:
    cargo clippy --all-targets --all-features -- -D warnings

# Audits dependencies for known security vulnerabilities. Requires 'cargo-audit'.
audit:
    cargo audit

# Generates a quick text-based code coverage report. Requires 'cargo-llvm-cov'.
cov:
    cargo llvm-cov --all-features --workspace --summary-only

# Generates an interactive HTML code coverage report. Requires 'cargo-llvm-cov'.
cov-html:
    cargo llvm-cov --all-features --workspace --html
    @echo "Interactive report available at: target/llvm-cov/html/index.html"

# Runs Vale to check documentation prose and grammar against style policies.
spell:
    vale src/ docs/ README.md

# Executes the complete test suite.
test:
    cargo test --all-features

# Simulates GitHub Actions workflows locally using act. Requires Docker.
ci-local:
    act pull_request

# Cleans build artifacts and intermediate files.
clean:
    cargo clean

# Performs a comprehensive verification check prior to committing or pushing code.
check-all: fmt-check lint audit spell test cov
    @echo "All verification checks passed successfully. Code meets professional standards."