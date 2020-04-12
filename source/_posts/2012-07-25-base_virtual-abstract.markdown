date: 2012-07-25 14:21:43+00:00
title: '[基础知识]Virtual & Abstract'
tags: [base]

---

Virtual

虚函数是多态的前提和保证

被标注为virtual的函数可以被继承类重写(override)，**并且可以在运行时动态调用相应的方法**（多态）。

没有标注为virtual的非虚方法，在继承类中虽然不能通过override重写方法，但是也**可以**声明一个**同名方法**的，不过不具备多态的性质！

    
        public class SuperClass
        {
            public void Display()//not virtual
            {
                Console.WriteLine("I'm super");
            }
    
            public virtual void Vdisplay()
            {
                Console.WriteLine("I'm superVVV!!!");
            }
        }
    
        public class LowerClass : SuperClass
        {
            public void Display()//new public void Display();和父类中的方法同名，却不具备多态的性质
            {
                Console.WriteLine("i'm lower");
            }
            public override void Vdisplay()//重写了父类中的方法
            {
                Console.WriteLine("I'm lowerVVV");
            }
        }




Abstract

abstract抽象方法则更像是一个接口(Interface)方法

被标注为abstract的方法不能有具体的实现！

而且如果有方法被标注为abstract, 则这个类需要被标注为abstract

详情
具体关于virtual 和 abstract的区别可以参看：[http://www.cnblogs.com/MayGarden/archive/2010/04/04/1704279.html](http://www.cnblogs.com/MayGarden/archive/2010/04/04/1704279.html)
