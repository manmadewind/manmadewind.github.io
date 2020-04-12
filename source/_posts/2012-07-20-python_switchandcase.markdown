title: '[Python]switch,case和深浅拷贝'
date: 2012-07-20 08:03:22+00:00
tags: [Python, dict]

---

## switch & case

Python没有switch…case的语法，不过可以用Dictionary的特性来写出同样功能的代码，甚至还可以写出更猛的代码

等价的Python代码：
    
    
    def f1():
        print 'f1'
    
    def f2():
        print 'f2'
    
    switcher = 
    {
      1: f1,
      2: f2,
    }
    
    #调用时
    switcher[1]() # 将输出 f1
    switcher[2]() # 将输出 f2

<!--more-->

当需要调用有参数的函数时，如下：
    
    def f1(name):
        print 'f1 %s' % name
    
    def f2(name):
        print 'f2 %s' % name
    
    switcher = 
    {
      1: f1,
      2: f2,
    }
    
    #调用时
    switcher[1]('Mar') # 将输出 f1 Mar
    switcher[2]('Vin') # 将输出 f2 Vin


也可以用lambda来实现一些简单的功能

    
    result = 
    {
      'a': lambda x: x * 5,
      'b': lambda x: x + 7,
      'c': lambda x: x - 2
    }[value](x)


用try…catch来实现带Default的情况，不过这个形式就感觉差些了：
    
    try:
        {
         'option1': func1,
         'option2': func2,
         'option3': func3
        }[value]()
    except KeyError:
        # default action


## 拷贝对象（浅拷贝&深拷贝）

    
    import copy
    array = [1, 2, 3, 4, ['a', 'b']] #原始对象
    
    ref          = a #赋值，传对象的引用
    shallow_copy = copy.copy(array)     #对象拷贝，浅拷贝(只拷贝父对象，不会拷贝对象的内部的子对象)
    deep_copy    = copy.deepcopy(array) #对象拷贝，深拷贝(拷贝对象及其子对象)
    
    array.append(5)  # 直接修改源对象的值类型
    array[4].append('c') # 修改源对象中的引用类型——数组['a', 'b']
    
    print 'array = ',        a
    print 'ref   = ',        ref
    print 'shallow_copy = ', shallow_copy
    print 'deep_copy = ',    deep_copy


最后得到结果：


	array = [1, 2, 3, 4, 5, ['a', 'b', 'c']]
	
	ref = [1, 2, 3, 4, 5, ['a', 'b', 'c']] # 完全同源对象

	shallow_copy = [1, 2, 3, 4, ['a', 'b', 'c']] # 与源对象公用内部的引用类型(数组)

	deep_copy = [1, 2, 3, 4, ['a', 'b']] # 完全独立与源对象




