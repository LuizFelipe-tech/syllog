# Copyright (c) 2026 Luiz Felipe do Nascimento Melos
# SPDX-License-Identifier: Apache-2.0
# System: Syllog Logic Engine | Driven by High-Performance Engineering

set windows-shell := ["powershell.exe", "-NoProfile", "-Command"]
set shell := ["bash", "-uc"]

CARGO_FLAGS := "--all-targets --all-features"

default:
    @just --list

# ==============================================================================
# Aliases para Execução Rápida
# ==============================================================================

alias c := check-all
alias t := test
alias l := lint-dev
alias f := fmt

# ==============================================================================
# Ambientes & Ferramental (DX)
# ==============================================================================

[group('setup')]
bootstrap:
    cargo install cargo-audit cargo-llvm-cov --locked
    @echo "💡 Certifique-se de ter o 'vale' instalado no sistema (winget, brew, apt)."

# ==============================================================================
# Qualidade de Código & Prosa
# ==============================================================================

[group('quality')]
fmt:
    cargo fmt

[group('quality')]
fmt-check:
    cargo fmt --check

[group('quality')]
spell:
    vale src README.md

# ==============================================================================
# Análise Estática & Segurança
# ==============================================================================

[group('linting')]
lint-dev:
    cargo clippy {{ CARGO_FLAGS }}

[group('linting')]
lint-strict:
    cargo clippy {{ CARGO_FLAGS }} -- -D warnings

[group('security')]
audit:
    cargo audit

# ==============================================================================
# Testes & Cobertura
# ==============================================================================

[group('testing')]
test:
    cargo test {{ CARGO_FLAGS }}

[group('testing')]
cov:
    cargo llvm-cov --all-features --workspace --summary-only

[group('testing')]
cov-html:
    cargo llvm-cov --all-features --workspace --html
    @echo "📊 Report interativo gerado em: target/llvm-cov/html/index.html"

# ==============================================================================
# CI & Manutenção
# ==============================================================================

[group('ci')]
ci-local:
    act pull_request

[group('utility')]
clean:
    cargo clean

[group('ci')]
check-all: fmt-check lint-dev audit spell test
    @echo "🚀 Checks locais aprovados! Lembre-se: O CI aplicará o lint-strict na nuvem."