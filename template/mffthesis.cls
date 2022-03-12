\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{mffthesis}[2022/02/28]



\LoadClass[12pt, a4paper]{report}

\RequirePackage[a-2u]{pdfx} %loads hyperref and xcolor automatically
\hypersetup{unicode, breaklinks=true}

\RequirePackage[english, czech]{babel}
\RequirePackage{lmodern}
\RequirePackage[T1]{fontenc}
\RequirePackage[utf8]{inputenc}

\RequirePackage[square,numbers]{natbib}
\RequirePackage[nottoc]{tocbibind}
\bibliographystyle{unsrtnat}
\addto{\captionsczech}{\renewcommand{\bibname}{Seznam použité literatury}}

\RequirePackage{graphicx}
\RequirePackage{indentfirst}
\RequirePackage{icomma}

\RequirePackage{siunitx}
\RequirePackage{amsmath}
\RequirePackage{amssymb}
\RequirePackage{tikz}
\RequirePackage{booktabs}

%%% metadata
\newcommand{\thesistype}[1]{\renewcommand{\@thesistype}{#1}}\newcommand{\@thesistype}{}
\newcommand{\titleCS}[1]{\renewcommand{\@titleCS}{#1}}\newcommand{\@titleCS}{}
\newcommand{\titleEN}[1]{\renewcommand{\@titleEN}{#1}}\newcommand{\@titleEN}{}
\newcommand{\yearsubmitted}[1]{\renewcommand{\@yearsubmitted}{#1}}\newcommand{\@yearsubmitted}{}
\newcommand{\departmentCS}[1]{\renewcommand{\@departmentCS}{#1}}\newcommand{\@departmentCS}{}
\newcommand{\departmentEN}[1]{\renewcommand{\@departmentEN}{#1}}\newcommand{\@departmentEN}{}
\newcommand{\studyprogramme}[1]{\renewcommand{\@studyprogramme}{#1}}\newcommand{\@studyprogramme}{}
\newcommand{\studybranch}[1]{\renewcommand{\@studybranch}{#1}}\newcommand{\@studybranch}{}

\newcommand{\supervisor}[1]{\renewcommand{\@supervisor}{#1}}\newcommand{\@supervisor}{}
\newcommand{\supervisordepartmentCS}[1]{\renewcommand{\@supervisordepartmentCS}{#1}}\newcommand{\@supervisordepartmentCS}{}
\newcommand{\supervisordepartmentEN}[1]{\renewcommand{\@supervisordepartmentEN}{#1}}\newcommand{\@supervisordepartmentEN}{}

\newcommand{\dedication}[1]{\renewcommand{\@dedication}{#1}}\newcommand{\@dedication}{}
\newcommand{\abstractCS}[1]{\renewcommand{\@abstractCS}{#1}}\newcommand{\@abstractCS}{}
\newcommand{\abstractEN}[1]{\renewcommand{\@abstractEN}{#1}}\newcommand{\@abstractEN}{}
\newcommand{\keywordsCS}[1]{\renewcommand{\@keywordsCS}{#1}}\newcommand{\@keywordsCS}{}
\newcommand{\keywordsEN}[1]{\renewcommand{\@keywordsEN}{#1}}\newcommand{\@keywordsEN}{}

\newcommand{\logopath}[1]{\renewcommand{\@logopath}{#1}}\newcommand{\@logopath}{./img/static/logo.pdf}

%%% different page numbering
\newcommand{\frontmatter}{\pagenumbering{roman}}
\newcommand{\mainmatter}{\pagenumbering{arabic}}

%%% title, declaration, dedication, metadata
\input{frontmatter.def}

%%% chapter names typesetting
\renewcommand{\@makechapterhead}[1]{
  {\parindent \z@ \raggedright \normalfont
   \Huge\bfseries \thechapter. #1
   \par\nobreak
   \vskip 20\p@
}}
\renewcommand{\@makeschapterhead}[1]{
  {\parindent \z@ \raggedright \normalfont
   \Huge\bfseries #1
   \par\nobreak
   \vskip 20\p@
}}

%%% automatic figure centering
\g@addto@macro\@floatboxreset\centering
