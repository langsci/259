# hpsg-handbook
The very cool open access handbook for HPSG that will end all handbook attempts.

Please compile check-hpsg.tex after commenting in your chapter and maybe chapters you cite.

xelatex check-hpsg.tex; biber check-hpsg

You may not be able to compile the whole book due to memory limitations.

-------------------------------
Edit your texmf.cnf file. This file can be found at e.g. /usr/local/texlive/2017/texmf.cnf (for TeXLive/MacTeX 2017). Change its contents to contain something like:

main_memory=5000000
extra_mem_bot=5000000
font_mem_size=5000000
pool_size=5000000
buf_size=5000000

Afterwards, call texhash to update the LaTeX format files.
------------------------------- 

We are working on externalization of the graphics. With externalization it my work again. Sorry for this. You are part of a huge project. =:-)


## Contributors

This project exists thanks to all the people who contribute. [[Contribute](CONTRIBUTING.md)].
<a href="https://github.com/badges/langsci/hpsg-handbook/contributors"><img src="https://opencollective.com/shields/contributors.svg?width=890" /></a>