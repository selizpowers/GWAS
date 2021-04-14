#!/usr/bin/env python3

import sys
import argparse
from datetime import datetime
from itertools import product
from collections import OrderedDict

def parse_arguments():
    """Parse arguments passed to script"""
    parser = argparse.ArgumentParser(description=
            "Read a rubric file and generate individual files \
                    \nbased upon a custom set of variables. \
                    \n\nUsage: python {0} -r rubric_file -d variable,list \n".format(sys.argv[0]),
                    formatter_class = argparse.RawDescriptionHelpFormatter)
    requiredNamed = parser.add_argument_group('required arguments')
    requiredNamed.add_argument("-r", "--rubric", type=str, required=True,\
            help="input rubric file. Contains variables in <> such as <NUM>", action="store")
    parser.add_argument("-d", "--dict", type=str, required=False,\
            help="variable to be changed and the values to be substituted. \
            \n\n(-d NUMBER,[1:20] --> replaces NUMBER with the range of 1-20) \
            \n(-d CHARACTER,[A,B,C] --> replaces CHARACTER with each value) \
            \n(-d NUMBER,[1:20]/CHARACTER,[A,B,C]) --> will create all permutations", 
            action="store")
    parser.add_argument("-f", "--file", type=str, required=False,
            help="file of key-value pairs to change \
                  \nuseful when all permutations are not necessary.\
                  \nFile format: VARIABLE_A,VALUE_A/VARIABLE_B,VALUE_B",
            action="store")
    return parser


def check_dictionaries(dictionaries):
    commands = OrderedDict()
    split_dictionaries = dictionaries.split("/")
    for dictionary in split_dictionaries:
        variable = dictionary.split(",")[0]
        substitutions = dictionary.split("[")[1].replace("]","")
        if ":" in substitutions:
            split_sub = substitutions.split(":")
            start = int(split_sub[0])
            stop  = int(split_sub[1])
            commands[variable] = list(range(start, stop))
        elif "," in substitutions:
            split_sub = substitutions.split(",")
            commands[variable] = split_sub
        else:
            commands[variable] = [substitutions]
    return commands


def write_files(rubric_name, commands):
    split_name = rubric_name.split(".")
    with open(rubric_name) as f:
        rubric = f.read()
    keys = commands.keys()
    sys.stderr.write("Values to be substituted: {0}\n".format(commands))
    all_products = list(product(*list(commands.values())))
    for value in all_products:
        str_value = [str(j) for j in value]
        rubric_addition = ".".join(["_".join(i) for i in zip(keys, str_value)])
        edited_rubric = rubric
        for x, i in enumerate(value):
            key = list(keys)[x]
            edited_rubric = edited_rubric.replace("<{0}>".format(key), str(i))
        output = split_name[0] + "." + rubric_addition + "." + split_name[-1]
        with open(output, 'w') as f:
            f.write(edited_rubric)


def write_from_file(rubric_name, filename):
    split_name = rubric_name.split(".")
    with open(rubric_name) as f:
        rubric = f.read()
    with open(filename) as f:
        for line in f.read().splitlines():
            split_line_by_variables = line.split("/")
            rubric_addition = "_".join(split_line_by_variables).replace(",", "_")
            edited_rubric = rubric
            for variable in split_line_by_variables:
                split_by_variable = variable.split(",")
                key, value = split_by_variable
                edited_rubric = edited_rubric.replace("<{0}>".format(key), value)
            output = split_name[0] + "." + rubric_addition + "." + split_name[-1]
            with open(output, 'w') as f:
                f.write(edited_rubric)


if __name__ == "__main__":
    start = datetime.now()
    parser = parse_arguments()
    args = parser.parse_args()
    if not (args.file or args.dict):
        parser.error("multiSubmit.py -h")
    elif args.file:
        write_from_file(args.rubric, args.file)
        sys.stderr.write("Executed: python {0} -r {1} -f {2}\n".format(sys.argv[0],
            args.rubric, args.file))
    else:
        commands = check_dictionaries(args.dict)
        write_files(args.rubric, commands)
        sys.stderr.write("Executed: python {0} -r {1} -d {2}\n".format(sys.argv[0],
            args.rubric, args.dict))

