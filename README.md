# hpsg-handbook
The very cool open access handbook for HPSG that will end all handbook attempts.


Tested with texlive 2020. 

The project uses memoize, a new package for externalizing figures Sašo Živanović. 

https://github.com/sasozivanovic/memoize

If you run into problems with memoize, please change the line `\usepackage{.styles/memoize}` in
localpackages.tex to `\usepackage{./styles/nomemoize}`.


Since the book is in the hot phase now, we decided not to maintain styles and chapters/styles any longer as two identical

The project uses memoize, a new package for externalizing figures. Since the book is in the hot
phase now, we decided not to maintain styles and chapters/styles any longer as two identical
copies. We use a symbolic link now. If you use Windows or any other operating system that does not
deal with symbolic links, please copy all files from styles to chapter/styles manually.


Please compile check-hpsg.tex after commenting in your chapter and maybe chapters you cite.

xelatex check-hpsg.tex; biber check-hpsg

If you are just interested in single chapters, you can go to the directory "chapters" and compile them standalone:

xelatex order; biber order


You can compile the whole book by calling:

xelatex main; biber main

The command

make main.pdf

compiles the book several times and creates the reference and indices.

You may not be able to compile the whole book due to memory limitations.

-------------------------------
Edit your texmf.cnf file. This file can be found at e.g. /usr/local/texlive/2017/texmf.cnf (for TeXLive/MacTeX 2017). Change its contents to contain something like:

<code>
main_memory=8000000<br>
extra_mem_top=5000000<br>
font_mem_bot=4000000<br>
</code>


Afterwards, call texhash to update the LaTeX format files.
------------------------------- 




## Contributors

This project exists thanks to <a href="https://github.com/langsci/hpsg-handbook/graphs/contributors">all the people who contributed</a>. Some contributed via github directly, work of others was checked in by Stefan Müller.


<!-- img src="https://opencollective.com/shields/contributors.svg?width=890" />




## Externalization

Externalization works by compiling the chapters or main.tex with the -shell-escape directive. A much fast way is to use a python script. To do this, you need to install python3 and a python module for manipulating PDFs:

brew cask install python

and you have to install the pdfrw module:

python3 -m pip install pdfrw

python3 -m pip install pyparsing

After having done this, you can call the script like this (assuming that you xelatexed main.tex once):

python3 ./styles/memoize/memomanager.py split main.mmz
