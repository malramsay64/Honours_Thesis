#!/usr/local/bin/python

import bibtexparser as btp

shorten = {}
lengthen = {}

for line in open('journals.txt'):
    if line.strip():
        long, short = line.split('=')
        short = short.strip()
        long = long.strip();
        #print short, "=", long
        shorten[long.lower()] = short
        lengthen[short.lower()] = long

with open('crystal.bib') as bibtex_file:
    bibtex_database = btp.load(bibtex_file)

for entry in bibtex_database.entries:
    if entry.get('journal'):
        j = entry.get('journal')
        entry['journal'] = lengthen.get(shorten.get(j.lower(),j),j)

with open('bibtex.bib', 'w') as bibtex_file:
    btp.dump(bibtex_database, bibtex_file)
bibtex_database.write(open('fixed.bib', 'w'))

print "Test\n"
j_list = ['Journal of Chemical Physics', 'Physical Review E', 'Acta Crystallographica Section B']
for j in j_list:
    print shorten.get(j.lower())

#for entry in bibtex_database.entries:
#    print entry.get('journal')
