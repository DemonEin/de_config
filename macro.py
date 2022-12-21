#!/usr/bin/python3

import glob
from pathlib import Path
import sys
import re
import fileinput
import shlex

prefix_regex = re.compile(r'(.*)DEMACRO')
expression_regex = re.compile(r'DEMACRO\s*(.*)')


def evaluate_expression(expression):
    arguments = shlex.split(expression)
    file = arguments[0]
    with open(file, 'r') as file:
        # print(file.read(), file=sys.stderr)
        return file.read().format(*arguments[1:])


def make_macro_text_from_line(line):
    prefix = prefix_regex.match(line).group(1)
    expression = expression_regex.search(line).group(1)
    whitespace = len(line) - len(line.lstrip())
    whitespace = ' ' * whitespace
    macro_text = prefix + 'DEMACRO FILLED\n'
    for line in evaluate_expression(expression).splitlines():
        macro_text += whitespace + line + '\n'

    return macro_text


paths = [Path(file) for file in glob.glob(sys.argv[1] + '/**', recursive=True)]
paths = [path for path in paths if path.is_file()]

for path in paths:
    previous_line_was_macro = False
    for line in fileinput.input(path, inplace=True):
        if previous_line_was_macro:
            if 'DEMACRO FILLED' not in line:
                line = make_macro_text_from_line(previous_line) + line

            previous_line_was_macro = False
        elif 'DEMACRO' in line and 'DEMACRO FILLED' not in line:
            previous_line = line
            previous_line_was_macro = True

        print(line, end='')

    if previous_line_was_macro:
        with open(path, 'a') as file:
            file.writeline(make_macro_text_from_line(previous_line))
