// Copyright (c) 2026 Luiz Felipe do Nascimento Melos
// SPDX-License-Identifier: Apache-2.0
// System: Syllog

use std::str::CharIndices;

use crate::error::{Result, SyllogError};

enum Token {
    TrueValue,
    FalseValue,
    OrOperator,
    AndOperator,
}

struct Lexer<'a> {
    input: &'a str,
    current_character: Option<(usize, char)>,
    charac: CharIndices<'a>,
}

impl<'a> Lexer<'a> {
    fn new(input: &'a str) -> Self {
        let mut charac = input.char_indices();
        Lexer {
            input,
            current_character: charac.next(),
            charac: input.char_indices(),
        }
    }

    fn next(&mut self) {
        self.current_character = self.charac.next();
    }

    fn define_token(&mut self) -> Result<Vec<Token>> {
        let mut tokens: Vec<Token> = Vec::new();
        let mut init_idx: usize = 0;
        let mut end_idx: usize = 0;
        while let Some((idx, mut c)) = self.current_character {
            init_idx = idx;
            while c.is_alphanumeric() {
                (end_idx, c) = self.current_character.unwrap();
                self.next();
            }

            match &self.input[init_idx..end_idx] {
                "true" => tokens.push(Token::TrueValue),
                "false" => tokens.push(Token::FalseValue),
                "or" => tokens.push(Token::OrOperator),
                "and" => tokens.push(Token::AndOperator),
                " " => self.next(),
                _ => return Err(SyllogError::UnexpectedToken(c)),
            }
        }
        Ok(tokens)
    }
}
