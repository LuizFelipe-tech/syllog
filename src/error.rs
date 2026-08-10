// Copyright (c) 2026 Luiz Felipe do Nascimento Melos
// SPDX-License-Identifier: Apache-2.0
// System: Syllog

use thiserror::Error;

#[derive(Error, Debug)]
pub enum SyllogError {
    #[error("Unexpected token '{0}'")]
    UnexpectedToken(char),
}

pub type Result<T> = std::result::Result<T, SyllogError>;
