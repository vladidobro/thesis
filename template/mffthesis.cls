\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{mffthesis}[2022/02/28]


\LoadClass{report}

\RequirePackage[a-2u]{pdfx}

\RequirePackage[czech]{babel}
\RequirePackage[T1]{fontenc}
\RequirePackage{lmodern}
\RequirePackage[utf8]{inputenc}

\RequirePackage{graphicx}


%%% different page numbering
\newcommand{\frontmatter}{
  \pagenumbering{roman}
}
\newcommand{\mainmatter}{
  \pagenumbering{arabic}
  %\setcounter{page}{1}
}

%%% front matter pages
\renewcommand{\maketitle}{
  \begin{titlepage}
    \centering
    \@title, \@author
  \end{titlepage}
}
\newcommand{\makedeclaration}{}
\newcommand{\makededication}{}
\newcommand{\makemetapage}{}


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
