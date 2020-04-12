date: 2012-07-20 07:35:53+00:00
title: '[Python]列表排序 & 字典排序'
tags: [Python, base]

---

## List Sort

``` Python
    l = [3,1,2]
    sorted(l)
    sorted(l, reverse=True)
```

<!--more-->
## Dictionary Sort


主要是借助sorted()方法以及lambda表达式

    
    d = {'Belly':50, 'Adam':90, 'Cindy':10}
    
    sorted(d.items(), key = lambda (k,v): k, reverse = True / False) # by key
    
    sorted(d.items(), key = lambda (k,v): v, reverse = True / False) # by value


参数 reverse用于决定是否逆序,即reverse = True时，结果从大到小(desc)； reverse = False时，结果从小到大(asc)， 此参数默认为正序



## Example

	>>> d = {'mark':60, 'jimmy':80, 'tommy':70}　　　　　　　　　　
	>>> for key, value in sorted(d.iteritems(), key=lambda (k,v) : v ) :
	　　...     print key, value　　　　　　　　　　　　　　　　　　　　　
	　　... 　　　　　　　　　　　　　　　　　　　　　　　　　　　　　
	　　mark 60 　　　　　　　　　　　　　　　　　　　　　　　　　　
	　　tommy 70 　　　　　　　　　　　　　　　　　　　　　　　　　
	　　jimmy 80 　　　　　　　　　　　　　　　　　　　　　　　　　

	>>> for key, value in sorted(d.iteritems(),key = lambda (k,v): k):
	...     print key,value 　　　　　　　　　　　　　　　　　　　　
	... 　　　　　　　　　　　　　　　　　　　　　　　　　　　　　
	jimmy 80 　　　　　　　　　　　　　　　　　　　　　　　　　　
	mark 60 　　　　　　　　　　　　　　　　　　　　　　　　　　
	tommy 70



## Other. Sort List with dict

	dict= [ {'id':0, 'value':9}, {'id':1, 'value':100}, {'id':5, 'value':99}]
	
	d.sort(key=lambda x:x['id']) #sort by id

	d.sort(key=lambda x:x['value']) #sort by value

