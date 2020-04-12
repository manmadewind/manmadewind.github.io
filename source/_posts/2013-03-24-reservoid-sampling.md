title: '蓄水池抽样(reservoid sampling)'

tags: [工程算法, 抽样]

date: 2013-03-24

---







缘起一道算法题目：有一个很大很大的输入流，大到没有存储器可以将其存储下来，而且只输入一次，如何从这个输入流中随机取得m个记录？（n未知）



花了点时间，终于搞清楚了这个问题的正确解法以及证明方法，而我觉得**目前为止网络上的许多证明都是错的！** 所以我才想重新写写。



让我们先从头开始——



## 1.开胃小菜，从m = 1开始说起



有一个数据流持续输入，在不知道流具体大小的情况下，怎么样才可以保证从流中公平地（即保证每一个元素被选中的概率是等可能的）获取一个样本？





### 1.1 算法大意



为方便起见，假设下标是从1开始的

假设流数据为： stream[1], stream[2], stream[3], ..., stream[n] （n在程序运行地过程中并不知道）

单凭直观感觉，这题并不难解，

首先在第1个元素到来的时候我们先暂定目标元素result = stream[1]；

当第2个元素到来的时候，我们以1/2的概率来决定，result 是否要剔除原先的stream[1]换成stream[2]；

当第3个元素到来的时候，我们以1/3的概率来决定result是否要被替换成stream[3]；

同理，当第i个元素到来的时候，我们以1/i的概率来决定result是否要被替换成stream[i]；



<!--more-->



### 1.2 形象一点



让我们来计算一下使用上文这种直觉方法时，取到每个元素的概率是多少：

假设有流stream = [a, b, c]; 在不知道这个流长度的情况下，从中公平地抽取一个作为样本。

则根据上文中的解法，明显

最终选取stream[1]的概率 = p(抽中了stream[1]) * p(没有抽中stream[1]之后的所有元素),既：

$$P(result = stream[1]) = P(result = a) = \frac{1}{1} \times (1 - \frac{1}{2}) \times (1 - \frac{1}{3}) = \frac{1}{3}$$



同理，可得

$$P(result = stream[2]) = P(result = b) = \frac{1}{2} \times (1 - \frac{1}{3}) = \frac{1}{3}$$



$$P(result = stream[3]) = P(result = c) = \frac{1}{3}$$



果然不出我们所料，$P(result = a) = P(result = b) = P(result = c) = 1/3$





### 1.3 抽象一点

问题：

对于n(n >= 1)， 如果每次以概率1/i来决定是否替换之前选中的元素(i为当前序号)，那么证明最终每个元素被选中的概率均等，等于1/n。



证明：

假设元素stream[i]最终被选为the one，则必须需要满足以下两个条件：



(1)它在序号为i时被选中了（得到了命运之神的眷顾）；

显然，这个概率

$$p1 = \frac{1}{i}$$



(2)所有在它之后的元素都没有被选中（后无来者）；

容易得知，这个概率

$$\begin{aligned}
p2 = (1 - \frac{1}{i + 1}) \times (1 - \frac{1}{i + 2}) \times ... \times (1 - \frac{1}{n}) \\
= \frac{i}{i+1} \times \frac{i+1}{i+2} \times ... \times \frac{n-1}{n} \\
= \frac{i}{n}
\end{aligned}$$



因此， 

$$p = p1 \times p2 = \frac{1}{n}$$



### 1.4 代码大意



```

'''reservoir sampling(number of sample = 1)'''

def getSample(stream):

    i = 0    

    while stream.exist(i): #流还没结束

        r = random.randrange(0, i)

        if r == 1: # P(result = stream[i]) = 1/i

            result = stream[i]

        i++



    return result

```



## 2. 言归正传，当m > 1时



当m > 1时，情况就开始变得复杂了起来。解决方案说来简单，就是传说中的蓄水池抽样（reservoid sampling）。主要思想就是保持一个集合（这个集合中的每个数字出现），作为蓄水池，依次遍历所有数据的时候以一定概率替换这个蓄水池中的数字。但是在实际的理解过程中非常容易出错。



### 2.1 算法大意



（0）结果集:results[]; 流数组:stream[]; 采样数:m; 计数变量:i;

（1）当i <= m时，results[i] = stream[i];

（2）当i > m 时（如果stream[i]不存在时，表示流结束，则整个程序完成），取一个随机数r，r的值域[1, i]，如果 r > i， 则执行i++，接着重复步骤（2），否则跳至步骤（3）

（3）赋值result[r] = stream[i]；i++；跳回步骤（2）



### 2.2 形象一点



假设有流stream = [a, b, c, d]， 随机抽样数m = 2，

如果c存在于最后的结果集中，那么它的概率p(c)：



p(c) = p(c被选中) * (p(d未被选中) + p(d被选中，但是替换的不是c))，即



$$p(c) = \frac{2}{3} \times [(1 - \frac{2}{4}) + \frac{2}{4} \times \frac{1}{2}] = \frac{1}{2}$$



如果a存在于最后的结果集中，则对应的概率p(a) = p(a被选中) * p(a之后的元素(序号i>2的)都没被选中 OR 元素被选上但是并没有把a替换掉)，即：

p(a) = p(a被选中) * (p(c未被选中) + p(c被选中了，但是替换了池中的另一个元素，此时为b)) * (p(c未被选中) + p(d被选中了，但是替换了池中的另一个元素))，



$$p(a) = 1 \times [(1 - \frac{2}{3}) + \frac{2}{3} \times \frac{1}{2}] \times [(1 - \frac{2}{4}) + \frac{2}{4} \times \frac{1}{2}] = \frac{1}{2}$$



### 2.3 抽象一点



这里稍微吐槽一句，网络上大部分流传的证明大部分是错误的，居然最后证明的结论是选取每个元素的概率是1/(i+1)实在让我无力吐槽...



#### 问题：

对于未知的n(n >= 1)， 随机抽取m个样本，每个样本以m/i的可能性被选入，那么证明每个元素被最终选中的概率均等，等于1/n。



#### 证明：

假设元素a[i]最终被选为上，则必须需要满足以下两个条件：

当 i > m时：

(1)它在序号为i时被选中了（被命运之神所眷顾）；

显然，这个概率

$$p1 = \frac{m}{i} $$

(2)在它之后的所有元素都没有被选中 OR 被选中了，但是a[i]却没有被替换掉（后无来者 或 后来者取代了其他人）

容易得知，这个概率



$$\begin{aligned}
p2 = [(1 - \frac{m}{i+1}) + \frac{m}{i + 1} \times \frac{m-1}{m}] \times [(1 - \frac{m}{i+2}) + \frac{m}{i + 2} \times \frac{m-1}{m}] \times ... \times [(1 - \frac{m}{n}) + \frac{m}{n} \times \frac{m-1}{m}] \\
= \frac{i}{i+1} \times \frac{i+1}{i+2} \times ... \times \frac{n-1}{n} \\
= \frac{i}{n}\end{aligned}$$




因此， $$p(i) = p1 \times p2 = \frac{m}{n}$$



当i <= m时情况类似不再累述。



### 2.4 代码大意



```

import random



def getSample(stream, m):

    results = []

    for i in range(0, m-1):

        results[i] = stream[i]

    # out of for



    i = m

    while stream[i].available(): # 当前stream[i]有效，流还未完结

        r = random.randrange(0, i)

        if r < m:

            results[r] = stream[i]



        i++

    # out of while

    

	return results

```



参考资料：

http://www.cnblogs.com/HappyAngel/archive/2011/02/07/1949762.html

http://en.wikipedia.org/wiki/Reservoir_sampling


