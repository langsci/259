# hpsg-handbook
The very cool open access handbook for HPSG that will end all handbook attempts.

Tested with texlive 2019 (ghostscript 9.27) and texlive 2020. If externalization of tikz figures causes problems, comment out the command \tikzexternalize by adding a % before it.

Please compile check-hpsg.tex after commenting in your chapter and maybe chapters you cite.

xelatex check-hpsg.tex; biber check-hpsg

If you are just interested in single chapters, you can go to the directory "chapters" and compile them standalone:

xelatex order; biber order


You can compile the whole book by calling:

xelatex main; biber main

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

We are working on externalization of the graphics. With externalization it my work again. Sorry for this. You are part of a huge project. =:-)



## Contributors

This project exists thanks to <a href="https://github.com/langsci/hpsg-handbook/graphs/contributors">all the people who contributed</a>. Some contributed via github directly, work of others was checked in by Stefan Müller.


<!-- img src="https://opencollective.com/shields/contributors.svg?width=890" />