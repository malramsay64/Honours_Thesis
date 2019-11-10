#!/usr/bin/env python3

import bibtexparser as btp
import sys
import codecs
import string


def my_strip(s):
    for c in string.punctuation + string.whitespace:
        s = s.replace(c,'')
    return s.lower()

if __name__ == '__main__':
    shorten = {}
    lengthen = {}

    for line in open('journals.txt'):
        if line.strip():
            long, short = line.split('=')
            short = short.strip()
            long = long.strip();
            shorten[my_strip(long)] = short
            lengthen[my_strip(short)] = long

    parser = btp.bparser.BibTexParser()
    parser.ignore_nonstandard_types = False
    parser.homogenise_fields = False
    with open('crystal.bib') as bibtex_file:
        bibtex_database = btp.load(bibtex_file, parser)

    for entry in bibtex_database.entries:
        if entry.get('journal'):
            j = entry.get('journal')
            entry['journal'] = lengthen.get(my_strip(shorten.get(my_strip(j),j)),j)
            if my_strip(j) not in shorten and my_strip(j) not in lengthen:
                print(j, my_strip(j))

    if len(sys.argv) > 1 and sys.argv[1] == 'true':
        for entry in bibtex_database.entries:
            if entry.get('journal'):
                j = entry.get('journal')
                entry['journal'] = shorten.get(my_strip(j),j)

    with codecs.open('crystal.bib', 'w', 'utf-8') as bibtex_file:
        btp.dump(bibtex_database, bibtex_file)

