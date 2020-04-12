title: 关于Logistics Regression

tags: [机器学习,LR,Regression,分类,回归]

date: 2015-06-28



---



## 1. 从模型开始



Logistic Regression(常被翻译做“逻辑回归”) 一种分类模型，由于算法的简单和高效，在实际中应用非常广泛，尤其是它具有出色地将众多变量糅杂在一起并最终输出一个可以当做概率的值(大熔炉即视感)，因此颇为常用。



### 1.1 先从S形函数开始(Sigmoid Function)



\\( f(t) = \frac{e^t}{1+e^t} = \frac{1}{1+e^{-t}} \\)



该函数的神奇之处在于，可以将原本线性无拘无束的t值困在[0,1]范围内，并变换出一条柔美的S型曲线(Sigmoid Curve)。



![Sigmoid Curve](https://upload.wikimedia.org/wikipedia/commons/thumb/8/88/Logistic-curve.svg/1280px-Logistic-curve.svg.png)


其实该函数还有另外一个名字——`Logistic Function`.




### 1.2 Logistic Regression Model

借助Logistic Function, 这里定义Logistic回归模型。


$$P(Y=1|X) = \frac{exp(wx+b)}{1+exp(wx+b)} $$
$$P(Y=0|X) = \frac{1}{1+exp(wx+b)}$$




其中， \\( x \in R^n \\)是输入， \\( Y \in \\) {0,1}是输出，\\( w,b \\)为参数(w-权值, b-偏置)



从上文的sigmoid function我们就可以观察到，Logistic回归模型可以将线性函数\\( (wx+b) \\)转换成概率P(Y=1|X)



<!--more-->



## 2. 举个栗子



假装我们有一个现成的广告模型



输入说明X | 训练得到的模型参数w
-|-
X0, bias(上文中的wx+b的b) | 0.1
X1, 广告和用户搜索关键字的相关度(以概率形式表示) | 0.8
X2, 用户性别(-1:男, 1:女) | 0.3
X3, 用户年龄(数字) | 0.2

此时来了一个用户，对应的输入\\( X=(x0,x1,x2,x3) = (1,0.9,1,20) \\)
其中x0无论何时均为1，因为x0对应的参数w0其实为b, x0w0=b,这样就可以把原先的\\(wx+b=w1x1+... w2x2 + ... + wnxn + b \\) 简单表示成为 \\( wx=w1x1+...+wnxn + w0x0\\)，用 \\(w0x0\\) 替代原先的\\(b\\)



则
$$ wx = w0x0+w1x1+w2x2+w3x3\\
 = 1 \times 0.1 + 0.9 \times 0.8 + 1 \times 0.3+20 \times 0.2 \\
 = 5.12 $$




所以最终的预测用户点击率为： 
$$ P(Y=1|X) = \frac{exp(wx)}{1+exp(wx)} = \frac{exp(5.12)}{1+exp(5.12)} = 0.994 $$



## 3. 参数训练

对于给定的训练集，可以采用`极大似然估计法`估计模型参数



* 似然函数



  $$ \prod_{i=1}^{N} P(Y=1|X_i)^{y_i} \times P(Y=0|X_i)^{y_i} $$



* 对数似然函数



  $$ L(w) = \sum_{i}^{N}[y_i(w x_i) - log(1+exp(w x_i))] $$



* 目标函数



  $$ w=\arg\max\_{x} L(w) = \sum_{i}^{N}[y_i(w x_i) - log(1+exp(w x_i))] $$

  





这个最优化问题可以通过梯度下降法或拟牛顿法来求解。



## 4. 扩展到多个分类



如果Y不止是2类问题，而是在K个类别中取值，这时问题就变为一个多分类问题。

有两种方式可以出处理该类问题——



1. 当K个类别不是互斥的时候

   我们对每个类别训练一个二元分类器（One-vs-all），然后对输入数据X依次使用每一个训练出来的二元分类器进行判断，大于阈值的结果就统统作为输入的分类。

   

2. 如果K个类别是互斥的，即 Y=k 的时候意味着Y不能取其他的值，这种情况下，假设Y的取值集合：\\( {1,2,\cdots,K} \\)


$$\begin{aligned}
P(Y=k|X) &= \frac{exp(w_{k}x + b)}{1+\sum_{i}^{K-1}exp(w_{i}x+b)},  k=1,2,\cdots,K-1 \\
P(y=K|X) &= \frac{1}{1+\sum_{i}^{K-1}exp(w_{i}x+b)}\end{aligned}$$




## 5. 应对非线性的分类

Logistic回归提出时用来解决线型分类问题，其分离面是一个线型超平面wx+b，如果将这个超平面改成非线性的，是否也可以正确分类呢，如果像SVM一样加入核扩展到高维是否也可行呢？



以下答案来自网络加上我自己的理解整理而成。



### 5.1 正统方法

回答是可以，只要使用kernel trick（kernel trick之前在SVM中提过，具体可以[点击查看](/2015-04-10-svm-abs/)）。



不过，通常使用的kernel都是隐式的，也就是找不到显式地把数据从低维映射到高维的函数，而只能计算高维空间中数据点的内积。在这种情况下，Logistic Regression模型就不能再表示成$wx+b$的形式(primal form)，而只能表示成 \\( \sum_i a_i \langle x_i,x \rangle +b \\) 的形式(dual form)。



忽略那个b的话，primal form的模型的参数只有w，只需要一个数据点那么多的存储量；而dual form的模型不仅要存储各个\\(a_i\\)，还要存储训练数据\\(x_i\\)本身，这个存储量就大了。



SVM也是具有上面两种形式的。不过，与Logistic Regression相比，它的dual form是稀疏的——只有支持向量的\\(a_i\\)才非零，才需要存储相应的\\(x_i\\)。所以，在非线性可分的情况下，SVM用得更多。



### 5.2 野路子

说句题外的，很多数据没有我们想象的那么复杂。



我在实际中发现用逻辑斯蒂回归直接硬搞，对非线性数据进行训练，也能得到一个还能接受的结果，所以有的时候先别急着上SVM或者加kernal trick，先试试暴力训练吧：）





## 6. 和高斯朴素贝叶斯(GNB)的关系

Gaussian Naive Bayes(GNB)是Naive Bayes的输入X为连续变量时的情况，并且假设所有的P(x|y)独立，且符合高斯分布，这种情况下有模型如下：


$$P(X=x|Y=k)=P(x_1,x_2,\cdots,x_n|Y=k) = \prod_{i} P(x_i|Y=k)$$

有些时候，GNB还有一些别的假设，(1) 方差与Y无关; (2)方差与X无关；在这两种假设成立的基础上，有


$$P(X|Y=k) = \sum_{i} P(x_i|Y=k) \\
P(x_i|Y=k) = \frac{1}{\sigma_i \sqrt{2 \pi}} e^{\frac{-(x_i -\mu_{ik})^2}{2\sigma_i^2}}$$

现在，根据以上的这种情况，可以推导出LR模型，过程如下：




$$\begin{aligned}
P(Y=1|X) &= \frac{P(Y=1)P(X|Y=1)}{P(Y=1)P(X|Y=1)+P(Y=0)P(X|Y=0)} \\
&= \frac{1} {1+\frac{P(Y=0)P(X|Y=0)} {P(Y=1)P(X|Y=1)} } \\
&= \frac{1}{1+exp(ln\frac{P(Y=0)P(X|Y=0)}{P(Y=1)P(X|Y=1)})} \\
&= \frac{1}{1+exp(ln \frac{P(Y=0)}{P(Y=1)} + ln \frac{P(X|Y=0)}{P(X|Y=1)})}  
\end{aligned}$$




根据上文中提到GNB满足的假设情况，上式中的 \\((ln\frac{P(Y=0)}{P(Y=1)} + ln \frac{P(X|Y=0)}{P(X|Y=1)})\\)可以展开如下：

$$\begin{aligned}
ln\frac{P(Y=0)}{P(Y=1)} + ln \frac{P(X|Y=0)}{P(X|Y=1)} 
&= ln\frac{P(Y=0)}{P(Y=1)} + \sum_{i} (ln \frac{\mu_{i0} -\mu_{i1} }{ \sigma_{i}^{2} } X_{i} + \frac{\mu_{i1}^{2} - \mu{i0}^2} {2\sigma_{i}^2} )\\ 
&= (ln\frac{P(Y=0)}{P(Y=1)} + \sum{i} ln \frac{\mu_{i1}^{2} - \mu{i0}^2} {2\sigma_{i}^2})+ \sum_{i} ln \frac{\mu_{i0} -\mu_{i1} }{ \sigma_{i}^{2} } X_{i}  \\
&= w_0 + \sum_i w_i x_i
\end{aligned}$$




因此，



$$P(Y=1|X) = \frac{1}{1+exp(w_0 + \sum_i w_i x_i)}$$

看，这就是Logistic Regression的模型呀！



可以看到，这个概率和Logistic回归中的形式是一样的。这种情况下GNB和LR会学习到同一个模型。据说，在更一般的假设（P(x|y)的分布属于指数分布族）下，都可以得到类似的结论，是不是有一种条条大路通罗马的感觉？



## 参考资料

1. CMU Machine Learning (10-701/15-781, Spring 2011)

2. 李航, 《统计学习方法》

3. 吴军, 《数学之美》


