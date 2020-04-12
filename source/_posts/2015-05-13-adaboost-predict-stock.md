title: 使用AdaBoost对股票的涨跌进行预测

tags: [AdaBoost,机器学习,分类,Action]

date: 2015-05-13

---



近期股市大热，一些朋友们估计已经蠢蠢欲动想要做些什么了吧！我这里先抛砖引玉，丢出一个使用sklearn对个股次日涨跌进行预测的简单方法。



## AdaBoost作为分类模型



AdaBoost是我个人很喜欢的分类器，在参数合适的情况下它的预测效果往往能带带来不错的效果。



而Adaboost的训练方法其实是一种迭代算法，其核心思想是针对同一个训练集训练不同的分类器(弱分类器)，然后把这些弱分类器集合起来，构成一个更强的最终分类器(强分类器)。



该算法其实是一个简单的弱分类算法提升过程，这个过程通过不断的训练，可以提高对数据的分类能力。



大致过程叙述如下：



1. 其算法本身是通过改变数据分布来实现的，它根据每次训练集之中每个样本的分类是否正确，以及上次的总体分类的准确率，来确定每个样本的权值。



2. 将修改过权值的新数据集送给下层分类器进行训练，最后将每次训练得到的分类器最后融合起来，作为最后的决策分类器。



具体过程可参看[维基百科](https://zh.wikipedia.org/wiki/AdaBoost)此处不再类属。



<!--more-->



## 数据的来源

我的数据全部来自于雅虎财经网站，它提供的接口可以直接把股票历史数据导成Excel，很是方便。格式如下：



	http://table.finance.yahoo.com/table.csv?s=股票代码



上证股票是股票代码后面加上.ss，深证股票是股票代码后面加上.sz

深市数据链接：http://table.finance.yahoo.com/table.csv?s=000001.sz



上市数据链接：http://table.finance.yahoo.com/table.csv?s=600000.ss



另外，上证综指代码：000001.ss，深证成指代码：399001.SZ，沪深300代码：000300.ss



例如查询中国石油的历史数据，直接在浏览器中输入：http://table.finance.yahoo.com/table.csv?s=601857.ss

网站自动返回一个csv格式的文件，保存到本地即可。可以直接用Excel打开分析，也可以导入SAS、SPSS等软件进行分析。

得到的文件包括如下几个字段：


日期|开盘价|最高价|最低价|收盘价|收盘价|成交量|复权收盘价 
--|--|--|--|--|--|--|
Date|Open|High|Low|Close|Volume|Adj|Close



## 预测的思路

一次只预测一只个股，以它以今年4月份之前的所有数据作为训练样本，而4月至今的数据作为测试集，以判断过去数据对近来走势的预测能力。



我在接下来的程序中，只采用了最最最简单的方法，



- 输入参数 X: 原始数据中的前5列，即(1)日期(2)开盘价(3)最高价(4)最低价(5)收盘价

- 输出参数 Y: 次日股票的涨跌(次日的收盘价-次日的开盘价)，涨为1,跌为0





## 程序的编写



准备工作，需要安装Python的科学计算包——numpy，以及机器学习包——sklearn，接着就可以开始动手了。



```

#!/usr/bin/env python

#-*- coding:utf-8 -*-

__author__ = 'marvin'



import numpy

import sklearn



def main():

    # 实例化一个AdaBoost的分类器,设置弱分类器个数为80

    adaBoost_clf = sklearn.AdaBoostClassifier(n_estimators=80)



    # 得到训练数据集和测试数据集

    train_data, train_result = get_arrays_fromfile('/data/train.txt')

    test_data , test_result  = get_arrays_fromfile('/data/test.txt')



    # 使用AdaBoost进行训练 + 预测，得到预测结果列表

    predict_result = adaBoost_clf.fit(train_data, train_result).predict(test_data)



    wrong    = (test_result != predict_result).sum() # 比较预测结果和测试结果，得到预测错误的结果数

    accurate = 1- wrong*1.0/len(test_result)         # 准确率



    print '预测准确率为:%f%' % (accurate*100) # 输出







def get_result_npArray(source_array):

    """

    根据数据集，返回个股次日的涨跌情况数组作为结果集

    """

    result_list = []

    for index, item in enumerate(source_array):

        if index == 0:

            # 因为是以 第(index-1)天 的数据来预测 第index天的个股涨跌，因此不考虑index=0的涨跌情况，只从index=1开始

            continue



        closing_price = item[1] # 第1列收盘价

        opening_price = item[3] # 第3列开盘价



        if (closing_price-opening_price) > 0:

            # 当天股票上涨，结果为1

            result_list.append(1)

        else:

            # 当天股票下跌，结果置为0

            result_list.append(0)



    return numpy.array(result_list)



def get_arrays_fromfile(path):

    """

    从指定路径得到 <输入数据列表,结果列表>

    """



    # 从指定路径读取个股的数据 数据共5列

    source_npArray = numpy.genfromtxt(path, delimiter=',', usecols=[1,2,3,4,5])



    # 根据原始数据，生成对应的结果集

    result_npArray = get_result_npArray(source_npArray)



    # 由于最后一天的输入数据无效（不知道次日涨跌情况），所以不输出

    return source_npArray[:-1], result_npArray





if __name__ == '__main__':

    main()



```



顺祝财运亨通~
