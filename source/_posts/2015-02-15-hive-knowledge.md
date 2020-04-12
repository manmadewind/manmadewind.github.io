title: Hive相关知识

tags: [hive,dict,大数据]

date: 2015-02-15



---





## 1. 手工添加分区

(1) hadoop fs 拷入文件

(2) 还需要在hive中 add partition，分区才可以被hive承认；否则，找不到对应分区。



## 2. 复制表结构



```

CREATE TABLE target_table  LIKE source_table

```

	

## 3. 给Hive表加锁，防删除或防查询



	ALTER TABLE tableName ENABLE/DISABLE NO_DROP/OFFLINE

	

<!--more-->



## 4. 动态分区插入

可以不用指定插入到具体的哪一个分区中，分区参数可以由select的最后几列数据自动填充。



```

  INSERT OVERWRITE TABLE tableName PARTITION(key1, key2, ...)

  SELECT ... ...,                         value1, value2, ...

  FROM ...;

```



需要设置属性:



```

  hive.exec.dynamic.partition=true; 

  hive.exec.dynamic.partition=nonstrict;

```

一次插入多个分区表的数据



```

  FROM tableName

  INSERT OVERWRITE TABLE tableName PARTITION (partition1) SELECT * ...

  INSERT OVERWRITE TABLE tableName PARTITION (partition2) SELECT * ...

  INSERT OVERWRITE TABLE tableName PARTITION (partition3) SELECT * ...

```

  

## 5. 导出数据

(1) 格式符合要求，直接拷贝文件（夹）即可



	hadoop fs -cp source_path target_path

	

(2) INSERT ... DIRECTORY ...



	INSERT OVERWRITE LOCAL DIRECTORY 'target_path' SELECT * ...

	

提高聚合函数性能的方法



	hive> SET hive.map.aggr=true; // 可以提高聚合函数的性能，但是，缺点：需要耗费更多的内存。

	

## 6. 驱动表

驱动表，通俗的讲就是先从哪个表开始检索

例如：



```

select * from a,b where a.id = b.id and a.name = '...' and b.gender = '...';

```



在a,b表同等数量级的情况下，显然用a表做为驱动表比较好，因为姓名相对于性别来说可以过滤掉更多的数据

[疑问]我目前还不确定Hive会不会对HQL查询进行优化，做到自己选择合适的检索顺序，有待我有空的时候实验一下。

浮点数比较

IEEE浮点数编码的经典问题，在Hive中，当需要以float或double类型的列作为条件进行比较筛选的时候，需要对条件浮点数进行类型转换，例如：



	SELECT * FROM tableName WHERE percent > 0.2;

	

这条语句可能会和期望表现不同，需要修改为：



	SELECT * FROM tableName WHERE percent > CAST(0.2 AS FLOAT/DOUBLE);

	

## 7. 外部表

外部表和普通表的重要区别在于，Hive并不认为自己完全拥有其数据，因此删除外部表时不会删掉数据源。



```

## 修改HIVE表列类型 属性

ALTER TABLE t_od_light_event_path_parsed CHANGE pv pv bigint;

## 修改Mysql列类型 属性

ALTER TABLE t_md_light_event_path_parsed MODIFY pv_link int(20);

## 增加列

ALTER TABLE test1 ADD COLUMNS (access_count1 int);

```

