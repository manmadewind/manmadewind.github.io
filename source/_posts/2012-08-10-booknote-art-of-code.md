title: '[读书笔记]The Art of Readble Code'

tags: [读书笔记, Action]

date: 2012-08-10



---



![](http://marvin-space.info/blog/wp-content/uploads/2012/08/readble_Code.jpg)



一旦开始实际编码，最重要的能力往往不是使用华丽、复杂的技巧去解决问题，而是如何写出可读性高的代码。



记得有个牛人有过如下感慨：



> 我曾在年轻的时候自以为编码水平了得，以写出复杂的递推加上满屏乱飞的goto语句为荣，以写出别人看不懂的代码为傲。若干年后回首才发现当年真是肤浅脑残，如今终于领悟真谛 —— “只要是个人就可以写出可以让计算机理解的代码，而如何写出能够让人类可以理解的代码才是最难的事”。



初写代码的人多少会有这种感悟，当代码长度超过500行之后，一周过去很容易就搞不清楚自己原来写的代码是做什么用的。自己都看不懂自己的代码更何况他人？

《The Art of Readble Code》就是一本讲述如何写可读性高代码的书。这其实只是一本轻量级的教人如何写出好代码的书，可以算是本小《代码大全》。





现在我就稍微总结如何写出好代码的一些小小技巧，内容并不仅限于此书，还有我个人这些年的一些感悟。



## 0.总结放在前面

其实我在这篇文章中说的这些东西对于外人来说基本没有什么实际意义。对于编程入门者来说，这篇的内容显得空泛、抽象。就算勉强看懂了回头可能很快也就都忘光了。对于老手而言，我写的这些浅显的东西恐怕也就是嗤之以鼻一笑而过。



其实写出可读性高的代码并没有太多高深、复杂的技巧，而且上文提到的这些技巧也没有必要生拉硬拽中脑中再死记硬背下来，唯一要做的不过就是培养起一个好的意识 —— 要做到让一个刚接触这个项目的人能够毫不费力地看懂这些摆在面前的代码！ 一旦脑海中有这个意识，下手时代码的质量自然会有所提高。



<!--more-->



## 1.关于变量命名

变量命名一定要具体，不能太抽象(Don't be abstract, be concreate!)。

要有统一的命名风格，这里我就顺带提一下我的命名习惯。



- 类命

	驼峰(CamelCase) ，首字母大写，如Student普通变量名：(1)首字母小写的驼峰，如userName;(2)我称之为小下划线（lower_seperated），首字母小写，用下划线隔开,如user_name



- 特殊的变量名：例如全局变量名之类的，变量名的性质_具体的名字，如g_VISIT_COUNT(这里的g代表它是全局变量)、s_STUDENT_COUNT(s代表静态变量static)或c_LIMITED_DISPLAY(c代表常量)等等。采用这种方式可以大大减少程序中的一些由于程序员一时疏忽所引起的错误。



- 函数/方法名

  还是以驼峰命名的方式，不过这里我有2套方案：(1)在使用C体系的语言进行书写时，首字母大写；(2)使用Java语言时，首字母小写。不过我个人更偏向于使用C系列的首字母大写方式来命名函数。

  

一些需要特别引起注意的变量名:比如说有的变量的字符编码非常特别，为了避免今后使用出错，需要进行特别的说明(Attach important details)，我的个人经验是变量名__注意事项。例如：text__utf8, image__bytes, 等等。



关于名字的长度问题，名字并非越长越好，需要视具体情况而言，这里的具体情况一般就是指使用此变量的代码段的长度。这道理很浅显：如果一个变量只存在于不超过10行的函数体中，那么这个函数体中肯定不会有太多的变量，只要给它一个象征性的，能让人一眼看懂个大概的名字即可。如果一个函数体中的代码超过了1000(这只是一种夸张的说法，正常的函数体中的代码量个人不建议超过100行)，其中有几十个变量穿插其中，那么自然需要给他们取些清清楚楚明明白白的名字，就算长点也在所不惜，关键要提高他们的辨识度，要使这些变量有别于其他变量从而使得他们容易被肉眼跟踪。

 

## 2.减少嵌套的层数！



除非不可避免的多层循环，否则当嵌套层超>=3层时，读起来就很费劲了，每次阅读都像是在挑战人类大脑的堆栈处理能力。



方法(1).尽早地做推出判断——如果没必要继续下去，尽早return。这样的代码写起来需要多写几行的注释来说明问题。



方法(2).想方设法减少内循环

 

## 3.把那个大块头给我卸了！

代码过多的函数体吓人害己，我们需要做的是将它拆解成不同的功能模块，个人认为可以把那些能够看做独立功能的，超过n行的有碍观张的代码都给提出来作为子程序调用。这种做法的好处不言自明吧——(1)代码整洁可读性强；(2)容易维护。

 

## 4.千万不要在程序中出现神秘数字！



```

if(userType == 0) {... }

if(userType == 1) {... }

if(userType == 2) {... }

```

这些神秘的0、1、2都是不应该出现的！硬编码数字到具体的代码中害人害己，是很多错误的罪魁祸首，而且一旦需要修改，后果将会是非常严重的！解决方法就是写一个公用的类，里面专门存放这样的常量，以备其他各处调用。如果可以，尽量把常量组织成枚举的形式，这样整个程序才会像个样子。



```

if (userType == TypeOfUser.Visitor) {...}

if (userType == TypeOfUser.VIP)     {...}

if (userType == TypeOfUser.Admin)   {...}

```



## 5.解决复杂的条件判断



### (1)借助变量来简化判断，假设有如下代码：

//(1)当前用户名必须和作者名相同; (2)当前用户必须授权用户;(3)本篇文章还在3个月的修改期内 OR 当前用户为管理员



```

if(user.userName == article.authorName && user.userType == Type.Authorized && DateTime.Now < article.Date.Month.Add(3)

   || userType == Type.Admin)

{

    ... ...

}

```



但是这一行长长长长的代码瞬间就让人倒了胃口，谁有时间来重新看这种比长寿面还要长的条件判断呢。而且这种代码中一旦出了错误都不容易被发现，实在是毒药啊。解决的方法可以是多借助几个bool变量，如下：



```

bool isAuthor        = (user.userName == authorName);               //是否作者本人

bool isAuthorized    = (user.userType == Type.Authorized);          //是否为授权用户

bool isInValidPeriod = (DateTime.Now < article.Date.Month.Add(3));  //是否在有效期内



//判断是否允许用户修改

bool isAllowUserModify = isCurrentAuthor && isAuthorized && isModifyAvailable;



//判断是否为管理员

bool isAdmin = (user.userType == Type.Admin);



//判断用户是否有权修改或者是否为管理员

if(isAllowUserModify || isAdmin)

{

    ... ...

}

```



将原先的if判断拆解之后，可读性大大增强，这样以后这个部分就不再容易错了。



### (2)利用表驱动法还你一片清爽的天地.

 

表驱动法适合于任何if/switch的地方。使用了表驱动法之后，整个世界都清净了。

想想有如下情景：需要你根据用户选择的月份数返回与该月对应的天数(先不考虑闰年的情况)：



```

int GetDaysOfMonth (int month)

{

    if(month == 1) return 31;

    if(month == 2) return 28;

    if(month == 3) return 31;

    ... 

    ...

}



int days = GetDaysOfMonth(month);

```

 

或者使用switch case 来代替上面的if()部分。

不过这样写出来的程序让人看着都觉得毛躁。

所谓表驱动法不过是将数据整理成表的形式：



```

    int[]  tableOfDays = {31, 28, 31, 30, 31, ... ..., 31};

    int days = tableOfDays[month-1];

```

    

以上只是表驱动法的一个小小的例子，实际的情况中会发现它那强大的威力。



## 6.注意排版

要学会用空白和换行进行版面的控制。

比如<The Art of Readble Code>书中提到的一个例子，有些函数可能只是名称不太相同，但是参数列表比较复杂却非常相似。它给出的书写代码以及注释的方法让我觉得十分推荐！现分享如下：



```

public class PerformanceTester {

// TcpConnectionSimulator(throughput, latency, jitter, packet_loss)

//                        [Kbps]   [ms]    [ms]   [percent]

public static final TcpConnectionSimulator wifi =

new TcpConnectionSimulator(500,    80,     200,    1);

public static final TcpConnectionSimulator t3_fiber =

new TcpConnectionSimulator(45000,  10,     0,      0);

public static final TcpConnectionSimulator cell =

new TcpConnectionSimulator(100,    400,    250,    5);

}

```



