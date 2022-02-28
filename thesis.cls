\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{thesis}[2022/02/28]

\DeclareOption{singleside}{
  \setlength\textwidth{145mm}
  \setlength\textheight{247mm}
  \setlength\oddsidemargin{15mm}
  \setlength\evensidemargin{15mm}
  \setlength\topmargin{0mm}
  \setlength\headsep{0mm}
  \setlength\headheight{0mm}
  \let\openright=\clearpage %make the following text appear on a right-hand page
}
\DeclareOption{doubleside}{
  \PassOptionsToClass{twoside, openright}{report}
  \setlength\textwidth{145mm}
  \setlength\textheight{247mm}
  \setlength\oddsidemargin{14.2mm}
  \setlength\evensidemargin{0mm}
  \setlength\topmargin{0mm}
  \setlength\headsep{0mm}
  \setlength\headheight{0mm}
  \let\openright=\cleardoublepage
}
\ProcessOptions\relax
\LoadClass[12pt,a4paper]{report}

%% Vytváříme PDF/A-2u
\RequirePackage[a-2u]{pdfx}

%% Přepneme na českou sazbu a fonty Latin Modern
\RequirePackage[czech]{babel}
\RequirePackage{lmodern}
\RequirePackage[T1]{fontenc}
\RequirePackage{textcomp}

%% Použité kódování znaků: obvykle latin2, cp1250 nebo utf8:
\RequirePackage[utf8]{inputenc}

\RequirePackage{graphicx}       % vkládání obrázků
\RequirePackage{indentfirst}    % zavede odsazení 1. odstavce kapitoly
\RequirePackage{natbib}         % zajištuje možnost odkazovat na literaturu
			    % stylem AUTOR (ROK), resp. AUTOR [ČÍSLO]
\RequirePackage[nottoc]{tocbibind} % zajistí přidání seznamu literatury,
                            % obrázků a tabulek do obsahu
\RequirePackage{xcolor}         % barevná sazba

% Tato makra přesvědčují mírně ošklivým trikem LaTeX, aby hlavičky kapitol
% sázel příčetněji a nevynechával nad nimi spoustu místa. Směle ignorujte.
\makeatletter
\def\@makechapterhead#1{
  {\parindent \z@ \raggedright \normalfont
   \Huge\bfseries \thechapter. #1
   \par\nobreak
   \vskip 20\p@
}}
\def\@makeschapterhead#1{
  {\parindent \z@ \raggedright \normalfont
   \Huge\bfseries #1
   \par\nobreak
   \vskip 20\p@
}}
\makeatother


\def\chapwithtoc#1{
\chapter*{#1}
\addcontentsline{toc}{chapter}{#1}
}
