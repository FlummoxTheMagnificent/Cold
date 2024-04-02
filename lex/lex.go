package lex

import (
	"fmt"
	"os"
	"regexp"
	"strconv"
)

type Token struct {
	Key string
}

func Lex(txt string) ([][]any, []int) {
	refloat := regexp.MustCompile(`^(\d+\.\d*)(?:\b|$)`)
	reint := regexp.MustCompile(`^(\d+)(?:\b|$)`)
	restr := regexp.MustCompile(`^"([^"]*)"`)
	reid := regexp.MustCompile(`^([a-zA-Z]\w*|(?:\(|\)|\+|-|\*|/|=|:|\.|,))`)
	recmnt := regexp.MustCompile(`^(#[^\n]*|^'[^']*'|\s+)`)
	retabs := regexp.MustCompile(`\t*`)

	values := make([][]any, 1)
	indents := []int{len(retabs.FindStringSubmatch(txt)[0])}
	i := 0
	for len(txt) > 0 {
		match := refloat.FindStringSubmatch(txt)
		if match != nil {
			item, _ := strconv.ParseFloat(match[1], 64)
			values[i] = append(values[i], item)
			txt = txt[len(match[1]):]
		} else {
			match = reint.FindStringSubmatch(txt)
			if match != nil {
				item, _ := strconv.Atoi(match[1])
				values[i] = append(values[i], item)
				txt = txt[len(match[1]):]
			} else {
				match = restr.FindStringSubmatch(txt)
				if match != nil {
					values[i] = append(values[i], match[1])
					txt = txt[len(match[1])+2:]
				} else {
					match = reid.FindStringSubmatch(txt)
					if match != nil {
						values[i] = append(values[i], Token{match[1]})
						txt = txt[len(match[1]):]
					} else {
						if txt[0] == '\n' {
							txt = txt[1:]
							i++
							values = append(values, make([]any, 0))
							indents = append(indents, len(retabs.FindStringSubmatch(txt)[0]))
						} else {
							match = recmnt.FindStringSubmatch(txt)
							if match != nil {
								txt = txt[len(match[1]):]
							} else {
								token := regexp.MustCompile(`^\w+`).FindStringSubmatch(txt)
								if len(token[0]) > 0 {
									fmt.Println("Lex error: unrecognized '" + token[0] + "'")
								} else {
									fmt.Println("Lex error: unrecognized '" + string(txt[0]) + "'")
								}
								os.Exit(1)
							}
						}
					}
				}
			}
		}
	}
	return values, indents
}
