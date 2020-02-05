#!/usr/bin/python3

import glob
import re

lgs=open("locallanguages.txt").read().split('\n')
terms=open("localsubjectterms.txt").read().split('\n')[::-1]#reverse to avoid double indexing
print("found %i language names for autoindexing" % len(lgs))
print("found %i subject terms for autoindexing" % len(terms))

files = glob.glob('chapters/*tex')

SUBJECTP = re.compile
for f in files:
  print("indexing %s" % f)
  #strip preamble of edited volume chapters to avoid indexing there
  a = open(f).read().split(r"\begin{document}")  
  content = a[-1]
  preamble = ''
  joiner = ''
  if len(a) == 2:
    preamble = a[0]
    joiner = r"\begin{document}"
  lines = content.split('\n')
  excluders = ("section","caption","chapter")
  newlines = []
  for line in lines: 
    included = True
    for excluder in excluders: 
      if "%s{"%excluder in line:
	included = False
	print line
    if included:
      for lg in lgs: 
	lg = lg.strip()
	if lg == '':
	  continue 
	line = re.sub('(?<!ili{)%s(?![\w}])'%lg, '\ili{%s}'%lg, line)
      for term in terms:
	term = term.strip() 
	if term == '':
	  continue
	line = re.sub('(?<!isi{|...[A-Za-z])%s(?![-_\w}])'%term, '\isi{%s}'%term, line) 
    newlines.append(line)
  content = "\n".join(newlines)  
  nlg = len(re.findall('\\ili{',content))
  nt = len(re.findall('\\isi{',content))
  outfile = open(f.replace('chapters','indexed'), 'w')
  outfile.write(preamble)
  outfile.write(joiner)
  outfile.write(content)
  outfile.close()
  print(" %s now contains %i indexed languages and %i indexed subject terms"%(f.split('/')[-1],nlg,nt))
  
print("indexed files are in the folder 'indexed'")
  
  
  
