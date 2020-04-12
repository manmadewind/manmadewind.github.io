title: 我的LaTeX中文模板

tags: [template, LaTeX]

date: 2012-10-07 01:16:44

---

常言道，手有模板，心中不慌。以下就是我提炼出来的$LaTeX$中文模板。



<!--more-->



```

\documentclass{article}

\usepackage[english]{babel}

\usepackage{amsmath,amsthm,amsfonts,amssymb}%数学公式|数学符号blablabl

\usepackage{CJK} %这个包需要下载，中文支持包

\usepackage{listings} %这个包需要下载，是用来支持在LaTeX中插入程序代码的

\usepackage{indentfirst}%缩进

\usepackage[top=0.8in, bottom=0.8in, left=1.1in, right=1.1in]{geometry}%定义页边Margin

\usepackage{graphicx}%在文档中插入图片用的。不用另外下载包

\setlength{\baselineskip}{30pt}

\setlength{\parindent}{2em}

\begin{CJK*}{UTF8}{song} %有时可能是{CJK*}{UTF8}{gsbn}

\title{文档标题}

\author{作者信息}

\begin{document}%文档开始

\maketitle %输出(1)标题(2)作者信息(3)当天日期。如果不需要输出日期，需要手动将\date{}置空

\section{4-1}

\subsection{1} %{}必不可少，否则报莫名其妙的错

\textbf{加粗字体} %加粗文字

\newline\par

%行内数学公式,等价于

$ \frac{分子}{分母} $

%行间数学公式

$$ \sum_{i=1}^{100}=5050 $$

%常用符号：

%\times(乘号), \div(除号), \pm(加减号), \circ(小圆圈)

%插入图片

\includegraphics[width=160mm]{FileName.Extension}%0.7\columnwidth

%插入程序代码段

\begin{lstlisting}[language={C++}]

class Node

{

char element;

int weight;

Node leftChild,rightChild;

}

\end{lstlisting}

\end{document}

\end{CJK*}

 

其他：

1.大块注释：

usepackage{comment} %使用包comment

\begin{comment}

需要注释的部分...

...

\end{comment}

```

