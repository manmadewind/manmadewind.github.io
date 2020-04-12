title: Transform of Hive Streaming

tags: [hive,streaming, 大数据]

date: 2015-02-15



---



我这大半年来大多数时候是在用Hadoop或者Hive对数据进行处理，而在处理hive数据时，有的功能用Hive很难实现或者不能够实现，这个时候就可以引入脚本来帮忙处理，以下整理出我在工作中总结出的一些东西。



Streaming可以让我在Hive上直接运行python脚本，优点是开发快捷，缺点是效率偏低。



要使用Streaming进行开发，需要对输出进行转换——使用TRANSFORM()，将默认的输出转换成字符串，该字符串具有如下特点：



(1) 列之间的分隔符为\t;

(2) 行之间的分隔符为\n;

(3) 表中为空的数据将显示成为\N;



## 语法

1. 标准MapReduce



```

FROM (

    FROM src

    SELECT TRANSFORM(src.c1, src.c1) USING ‘map_script’

    AS cc1, cc2

    CLUSTER BY cc1

) map_output 



INSERT OVERWRITE TABLE pv_users_reduced

SELECT TRANSFORM(map_output.cc1, map_output.cc2) 

USING ‘reduce_script’ AS c_reduced1, c_reduced2;

```



<!--more-->

    

2. 只有Map



```

FROM (

  FROM src

  SELECT TRANSFORM(src.key, src.value)

) tmap

INSERT OVERWRITE TABLE dest1 

SELECT tkey, tvalue;

```

  

3. 只看脚本输出，不要插入库



```

FROM src

SELECT TRANSFORM(stuff) USING ‘script’ 

AS (thing1 int, thing2 string) 

# 最后还cast了输出的类型

```



4. 升级版：对原始数据表使用Where条件进行筛选



```

FROM (

    SELECT TRANSFORM(…) USING ‘map_script’ AS …

    FROM (SELECT * FROM src WHERE …) src_filtered

) map_output

INSERT OVERWRITE TABLE …

SELECT TRANSFORM(…) USING ‘reduce_script’

AS …;

```

## 一些参数



1. stream.num.map.output.key.fields：指定map task输出记录中key所占的域数目

2. stream.reduce.input.field.separator/stream.reduce.output.field.separator：reduce task输入/输出数据的分隔符，默认均为\t。

3. stream.num.reduce.output.key.fields：指定reduce task输出记录中key所占的域数目





## 典型错误

### 1. Error20003



> Failed: [Error 20003]: An error occurred when trying to close the Operator running your custom script. at… …



可能原因：脚本没上传到Hive，导致Hive不认识脚本。上传一下脚本到Hive就好了。



```

add file script

或者

add files script1 script2 …

```



### 2. ParseException

> FAILED: ParseException line ?:? required (…)+ loop did not match anything at input ‘OVERWRITE’ in statement



可能原因：Map结果没取别名



```

FROM (

    FROM t1

    SELECT TRANSFORM(t1.c1, t1.c2) USING ‘map_script’

    AS tc1, tc2

    CLUSTER BY dt) map_output #Map结果别名，这里不能少！否则报错！

INSERT OVERWRITE TABLE t2

SELECT TRANSFORM(map\_output.dt, map\_output.uid) USING ‘reduce_script’

AS date, count;

```



### 3. can’t recognize input near

> FAILED: can’t recognize input near ‘’ … …



可能是由于语句没写完整，例如缺少对应的从句。



### 4. Broken pipe

> FAILED: java.io.IOException: Broken pipe 

或 

> [Error 20001]: An error occurred while reading or writing to your custom script. It may have crashed with an error.



脚本跑崩了，非常可能的原因是得到了脏输入，在可能出现问题的地方用try将它们紧紧包住就好。

