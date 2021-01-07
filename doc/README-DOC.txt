# -*- mode:org -*-
#Author: Giovanni Giorgi

Here is provided latest documentation in texinfo format taken from

http://ftp.lambda.moo.mud.org/pub/MOO/ProgrammersManual.texinfo

To generate html, txt, info format please install
https://www.gnu.org/software/texinfo/

Install makeinfo with
 sudo apt install texinfo

then produce the output with the following script
#+begin_src sh
makeinfo --html ProgrammersManual.texinfo
#+end_src
Also you can use texi2html, but I think makeinfo is better
