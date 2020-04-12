title: Python的中文判断,文件以及时间

tags: [Python, dict, Action]

date: 2012-08-29



---







接近3个月没用python，很多东西又还回去了。 硬盘被格了，原来的很多东西也都没了。



## 中文判断：



```

uchar = unicode(char, 'utf8') #普通字符 -&gt; utf8



def is_chinese(uchar):

        """判断一个unicode是否是汉字"""

        if uchar >= u'/u4e00' and uchar <= u'/u9fa5':

                 return True

         else:

                 return False def is_number(uchar):

         """判断一个unicode是否是数字"""

         if uchar >= u'/u0030' and uchar <= u'/u0039':

                 return True

         else:

                 return False def is_alphabet(uchar):

         """判断一个unicode是否是英文字母"""

         if (uchar >= u'/u0041' and uchar <= u'/u005a') or (uchar >= u'/u0061' and uchar <=u'/u007a'):

                return True

        else:

                return False



def is_other(uchar):

        """判断是否非汉字，数字和英文字符"""

        if not (is_chinese(uchar) or is_number(uchar) or is_alphabet(uchar)):

                return True

        else:

                return False

```

                

<!--more-->

                

## 文件读写：

参考Python自带的开发手册中的Tutorial中的Input and Output部分



### 一、打开文件

代码如下：



	f = open('./hello/world', "w")

	

说明：



- 第一个参数是文件名称，包括路径；

- 第二个参数是OpenMode：

	r：只读（缺省。如果文件不存在，则抛出错误）

	w：只写（如果文件不存在，则自动创建文件）

	a：附加到文件末尾

	r+：读写

	如果需要以二进制方式打开文件，需要在mode后面加上字符"b"，比如"rb""wb"等



### 二、读取内容



```

f.read(size) # 参数size表示读取的数量，可以省略。如果省略size参数，则表示读取文件所有内容。

f.readline() # 读取文件一行的内容

f.readlines() # 读取所有的行到数组里面[line1,line2,...lineN]。在避免将所有文件内容加载到内存中，这种方法常常使用，便于提高效率。

```



### 三、写入文件

f.write(text) 将一个字符串写入文件，如果写入结束，必须在字符串后面加上"/n"，



写完之后请不要忘记调用**.flush()**方法冲一下，最后再.close()关闭文件



**切记写完文件需要调用flush()冲刷，否则可能会出现意想不到的问题！**



要养成写完文件就冲一下的好习惯，这就好像上完厕所要冲水一样。以免得今后碰到大文件同步读写时出现了莫名其妙的错误。



### 四、文件中的内容定位



f.read()读取之后，文件指针到达文件的末尾，如果再来一次f.read()将会发现读取的是空内容，如果想再次读取全部内容，必须将定位指针移动到文件开始：

f.seek(0)



这个函数的格式如下（单位是bytes）：



	f.seek(offset, from_what)

	

offset表示开始读取的位置，offset表示从from_what再移动一定量的距离，比如f.seek(10, 3)表示定位到第三个字符并再后移10个字符。

from_what值为0时表示文件的开始，它也可以省略，缺省是0即文件开头。下面给出一个完整的例子：



```

f = open('/tmp/workfile', 'r+')

f.write('0123456789abcdef')

f.seek(5)     # Go to the 6th byte in the file

f.read(1)        

'5'

f.seek (-3, 2) # Go to the 3rd byte before the end

f.read(1)

```



### 五、关闭文件释放资源

文件操作完毕，一定要记得关闭文件f.close()，可以释放资源供其他程序使用





## 有关日期、时间的操作

先说说Time，需要引入包time

先上点实例：



``` 

import time 

# 把型如2012-8-31 10:25:56的字符串转成Python的时间类型，则：

timeFormat = '%Y-%m-%d %H:%M:%S'

timeFormat_Microsecond = '%Y-%m-%d %H:%M:%S:%f' #精确到微秒(！注意，此处是微秒不是常用的毫秒)

time_1 = time.strptime('2012-8-31 10:25:56', timeFormat)

time_2 = time.strptime('2012-8-31 11:25:56:654321', timeFormat_Microsecond)



# 比对两个时间之间的时间差，以秒为单位，则需要借助于time.mktime()方法，如下：

delta_sec = time.mktime(time_2) - time.mktime(time_1)

# int time.mktime()方法讲time类型的参数转换成其对应的秒数

```



这里需要说明的是mktime()这个方法，它只能用于计算两个时间的秒数差，只能精确到秒，如果时间是带有微秒的则将其舍去再做计算，既现在我有两个时间：

t1:2012-08-31 00:00:00:000111

t2:2012-08-31 00:00:00:999999

则计算mktime(t1) - mktime(t2) 的结果为 0

这就意味着如果我们算时间差的时候精确到毫秒或者微秒的话，微秒部分的计算需要自己再手工完成。

先说说Time类：

先摘几个常用的用于格式化时间串的参数，如需查看更多，例如UTC, TimeZone之类的情况请移驾python Doc 查看strftime() and strptime() Behavior相关



Directive	|	Meaning	Notes

-----------|---------------

%j	| 当前天数在一年中的天数，值域：[001,366].	

%Y	| Year（带世纪年份的，例如1999,2000），值域：[1900,????]	

%y	| Year(不带世纪，例如98,99,00)，值域：[00,99].	

%m	| Month[01,12].	

%d	| 显示当前日期在该月中的天数，值域：[01,31].	

%H	| Hour (24-hour clock)，[00,23].	

%I	| Hour (12-hour clock)，值域：[01,12].	

%p	| AM or PM.	(2)

%M	| Minute[00,59].	

%S	| Second，值域：[00,61].	(3)

%f	| 微秒(Microsecond)请注意和平时常用的毫秒(millisecond)区别开来！值域：[0,999999]（另：左侧填充0，比如1微秒则表示为000001）

