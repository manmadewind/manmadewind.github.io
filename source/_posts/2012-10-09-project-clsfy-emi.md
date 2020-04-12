title: '[Project]单标签文本分类(基于EMI)'
tags: [分类,标签,机器学习,项目]
date: 2012-10-09

---

这是上学期自然语言处理课程(宗成庆老师的课哟)的期末项目([详细的实验报告可以点我!](https://docs.google.com/open?id=0B-oFtMtAOV_YeHhiWFIzdDBhM1E))

## 1.实现思路
在训练样本中,先用特征选择算法提取出文档的特征,再在初始特征集上求其子集,最后依靠所求得的特征值对新文档进行计算求其分类。

## 2.实现方法
本实验采用**EMI(Expect Mutual Information, 期望互信息)**算法对训练语料进行特征选择,并使用它作为评判文档分类的依据,EMI 的形式化定义如下:

**Excepted Mutual Information:**


{% math %} I(T, C) = 
\sum_{e_t\subset{\{1,0\}}} 
\sum_{e_c\subset{\{1,0\}}} 
P(T = e_t, C = e_c) \log_{2} \frac{P(T = e_t, C = e_c)} 
{P(T = e_t)P(C = e_c)} {% endmath %}

其中T是一个二值随机变量，当文档包含词项t时，$e_t = 1$，否则$e_t = 0$;

C亦是一个二值随机变量，当文档属于类别c是$e_c = 1$，否则$e_c = 0$;


EMI在判断某个词项与文档是否相关方面有很好的表现,而传统的朴素贝叶斯方式在计算特征值方面却显得有些单薄,因为文档中可能会存在某些很少出现,但是归属性特别强的特征,比如有文档中有单词'Tibet',这个单词虽然在文档集中不常出现,但如果一旦出现就必然是和属性CHINA类相关,而朴素贝叶斯却不会注意这种小众特征。 以EMI的方式来确认词项的特征值,它的好处是能够突出某个典型却不常出现词项的特征值。

不过单纯使用EMI方法只能判断单词和类别之间的相关度,但是并不能判断是正相关还是负相关,比如我们的文档集中有2个文档


```
	d1 = {”Chinese”, China}
	d2 = {”Japanese”, Japan}
```

根据EMI算法中各项的对称性,会得出I(T = Chinese, C = China) = I (T = Chinese, C = Japan) = 1,



而明显可以看出词项"Chinese"和类别Japan应该是负相关的,因此需要借助于传统的**互信息(Mutual Information)**来判断词项和类别的正负相关性。只留下正相关的特征,而负相关的特征丢弃。MI的形式定义如下:

**Mutual Information:**

$$I(t,c) = P(t,c)log_2 \frac{P(t,c)}{P(t)P(c)}$$



求得初始特征集后,采用BIF(Best Individual Features)算法求出最优特征,这样整个训练过程就结束了。

## 3.过程纲要

### I.训练过程:



1.首先遍历所有训练样本,将所遇到的单词存入一个词典中,同时计算这个单词出现的文档频率(document frequency, df)

2.根据EMI算法每个单词和每种类别的关联程度,如果关联程度大于之前设定的一个阈值,则再计算这个单词和这个属性是正相关还是负相关,最后只留下正相关的加入原始特征集中。

3.用BIF求出几个最显著的特征作为对应分类的最终特征(即简单选取n个特征值最高的特征最为最终的特征，其他舍去)。



### II.分类过程
1.依次读入文章中的单词(重复的单词不加入计算,直接跳过),将出现的特征单词依次记下并累加。

2.扫描完成后对几个分类中的特征值累加和进行比较,取最大的作为该文章的分类。

## 4.意外收获

在做特征选择的过程中,我偶然发现可以将EMI方法用于自动挖掘停用词(Stop words),当单词的EMI值低于某个阈值的时候,便可以考虑将它看作停用词。

## 5.参考资料

主要来自于:

1. Christopher D. M Prabhakar Raghavan and Hinrich Schutze. Introduction to Information Retrieval. Cambridge University Press 2008.

2. Battiti, R.: Using Mutual Information for Selecting Features in Supervised Neural Net Learning. IEEE Trans. Neural Networds 5(1994) 537-550.


