title: '单件模式(Singleton Pattern)'

tags: [设计模式, 读书笔记]

date: 2012-07-17



---

这是设计模式中最简单的一种模式



有的时候，你可能会希望有这样一个类，它只能允许最多有一个实例存在于这个世界上，这个实例，是独一无二的存在。

这个时候，单件模式(singleton pattern)便应运而生

<!--more-->

要完成这一切最重要的一环，其实就是将这个类的构造方法设为私有。

 

代码大意如下：



## 单件类：



```

    class SingleOnly

    {

        private static SingleOnly instance; //用来存放该类的实例



        private SingleOnly() //被设为私有的构造函数，不能被外部调用只能被内部方法调用。在这里唯一的创造点就是GetInstance()方法

        {

        }



        public static SingleOnly GetInstance() //获得SingleOnly的实例只有这一个方法，这个方法就是该类型唯一的创造点。

        {

            if (SingleOnly.instance == null)

            {

                SingleOnly.instance = new SingleOnly(); //此方法虽然是static的，但是可以调用非static的构造方法.

                Console.WriteLine("我被赋予了独一无二的生命!!!");

            }

            else

            {

                Console.WriteLine("我又被召唤了出来");

            }

            return SingleOnly.instance;

        }        

    }

``` 



<!--more-->    



## 主体类



```

    class Program

    {

        static void Main(string[] args)

        {            

            SingleOnly instance1 = SingleOnly.GetInstance(); //想获取SingleOnly的实例，只有这一条路

            SingleOnly instance2 = SingleOnly.GetInstance();



            if( instance1 == instance2)

            {

                Console.WriteLine("相同实例");

            }

        }

    }

```

    

最后输出的结果为：

我被赋予了独一无二的生命!!!

我又被召唤了出来

相同实例

 

!值得注意的是，如果将上面的这种方法直接用在多线程的环境中显然是不安全的，这时候就需要添加一些互斥独占方法的标识符。

 

**Tips**

这里有一个小技巧可以分享一下，还有一种情况也可以将构造函数设置为private。

当一个类中所有的方法都是静态的时候，此时这个类的实例将失去价值，那么就可以将其构造方法设置为private以免被他人误初始化。
