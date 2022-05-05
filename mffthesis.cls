\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{mffthesis}[2022/02/28]

\LoadClass[12pt, a4paper]{report}

%%%%%%%%%%%
% balicky %
%%%%%%%%%%%

% nahraje xcolor a hyperref automaticky
\RequirePackage[a-2u]{pdfx}
\RequirePackage{xcolor}
\RequirePackage{hyperref}
\hypersetup{unicode, breaklinks=true}

% kodovani a cestina
\RequirePackage[utf8]{inputenc}
\RequirePackage[english, czech]{babel}

% bibliografie
\RequirePackage{csquotes}

% fonty nefungují řů s lualatexem
%\RequirePackage[T1]{fontenc}
%\RequirePackage{lmodern}

% graphicx kvulli logu, zbytek styl
\RequirePackage{graphicx}
\RequirePackage{indentfirst}
\RequirePackage{icomma}


\setlength\textwidth{145mm}
\setlength\textheight{247mm}
\setlength\oddsidemargin{15mm}
\setlength\evensidemargin{15mm}
\setlength\topmargin{0mm}
\setlength\headsep{0mm}
\setlength\headheight{0mm}


%%%%%%%%%%%%%%%%%%%%%
% cislovani stranek %
%%%%%%%%%%%%%%%%%%%%%

\newcommand{\frontmatter}{\pagenumbering{roman}}
\newcommand{\mainmatter}{\pagenumbering{arabic}}

%%%%%%%%%%%%%%%%%%%%%%%%
% sazeni nazvu kapitol %
%%%%%%%%%%%%%%%%%%%%%%%%

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

%%%%%%%%%%%%
% metadata %
%%%%%%%%%%%%

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

%%%%%%%%%%%%%%%%%%
% uvodni stranky %
%%%%%%%%%%%%%%%%%%

\renewcommand{\maketitle}{
  \begin{titlepage}
    \centering

      \makebox[\columnwidth]{\includegraphics[width=166mm]{\@logopath}}

    \vspace{-8mm}
    \vfill

      {\bfseries\Large \@thesistype}

    \vfill

      {\LARGE\@author}

    \vspace{15mm}

      {\LARGE\bfseries\@titleCS}

    \vfill

      \@departmentCS

    \vfill

      \begin{tabular}{rl}
        Vedoucí diplomové práce:&\@supervisor \\
        Studijní program:&\@studyprogramme \\
        Studijní obor:&\@studybranch
      \end{tabular}

    \vfill

      Praha \@yearsubmitted
  \end{titlepage}
}

\newcommand{\makedeclaration}{
  \vglue 0pt plus 1fill

  \noindent
  Prohlašuji, že jsem tuto diplomovou práci vypracoval(a) samostatně a výhradně
  s~použitím citovaných pramenů, literatury a dalších odborných zdrojů.
  Tato práce nebyla využita k získání jiného nebo stejného titulu.

  \medskip\noindent
  Beru na~vědomí, že se na moji práci vztahují práva a povinnosti vyplývající
  ze zákona č. 121/2000 Sb., autorského zákona v~platném znění, zejména skutečnost,
  že Univerzita Karlova má právo na~uzavření licenční smlouvy o~užití této
  práce jako školního díla podle §60 odst. 1 autorského zákona.

  \vspace{10mm}

    \hbox{\hbox to 0.5\hsize{%
    V \hbox to 6em{\dotfill} dne \hbox to 6em{\dotfill}
    \hss}\hbox to 0.5\hsize{\dotfill\quad}}
    \smallskip
    \hbox{\hbox to 0.5\hsize{}\hbox to 0.5\hsize{\hfil Podpis autora\hfil}}

  \vspace{20mm}
  \clearpage
}

\newcommand{\makededication}{
  \noindent
  \@dedication
  \clearpage
}

\newcommand{\makemetapage}{
{%\vbox to 0.5\vsize{
  \setlength\parindent{0mm}
  \setlength\parskip{5mm}

  Název práce:
  \@titleCS

  Autor:
  \@author

  Katedra:
  \@departmentCS

  Vedoucí diplomové práce:
  \@supervisor, \@supervisordepartmentCS

  \vspace{3mm}

  Abstrakt:
  \@abstractCS

  Klíčová slova:
  \@keywordsCS

  %\vss}\nobreak\vbox to 0.49\vsize{
  %\setlength\parindent{0mm}
  %\setlength\parskip{5mm}

}
  %\vss}
  \clearpage

{%\vbox to 0.5\vsize{
  \setlength\parindent{0mm}
  \setlength\parskip{5mm}

  Title:
  \@titleEN

  Author:
  \@author

  Department:
  \@departmentEN

  Supervisor:
  \@supervisor, \@supervisordepartmentEN

  \vspace{3mm}

  Abstract:
  \@abstractEN

  Keywords:
  \@keywordsEN
}

\clearpage
}

