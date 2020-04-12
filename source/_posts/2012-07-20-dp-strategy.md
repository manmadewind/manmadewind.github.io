title: '[读书笔记]策略模式'

tags: [设计模式, 读书笔记]

date: 2012-07-20

---



_《HeadFirst设计模式》读书笔记系列_



## 看起来美好的面向对象

学过面向对象的都知道继承可以重用父类中的一些方法，从而减少很多劳动量：



现有场景如下：



> 玩具工厂生产各种鸭子，有优雅鸭子(ElegantDuck)，爵士鸭子(DukeDuck)，霸王鸭子(KingDuck)，均继承自超类鸭子(Duck)，他们都是可以飞行的，并且在飞行时执行统一的方法 Fly() —— 喊叫"I'm flying." 于是优雅、爵士和霸王顺理成章地继承了超类的飞行方法。
<!--more-->


```

void Fly() 

{  

    Console.WriteLine("I'm flying."); 

}

```

于是整体的代码大致如下：



```

class Duck//超类 

{  

    public void Fly()  

    {         

　　　　Console.WriteLine("I'm flying");  

    } 

}//class Duck 



class ElegantDuck: Duck{} 

class DukeDuck: Duck{} 

class KingDuck: Duck{}

```



应用了面向对象之后一切看起来都是那么的优美，没有重复的代码，整洁如新。

不久之后，为了适应低龄儿童，玩具工厂决定加入新的花样——橡皮鸭子(RubberDuck)，但是这种橡皮鸭子是不能飞行的，当被调用方法Fly()时会输出"I can't fly!"



于是顺理成章地我们可以重写(override)超类中的Fly()方法，于是有橡皮鸭子：

 

```

class RubberDuck: Duck 

{  

    public void override Fly()//重写超类中的Fly()  

    {  

        Console.WriteLine("WOW!I can't fly!");  

    } 

}

```



到这里为止，一切都是循规蹈矩顺理成章，也没有什么值得争论的东西。



可是最后，出现了一件可怕的事情。



## 噩梦的开始



自玩具工厂推出面向低龄儿童的玩具之后收到社会各界的广泛好评，销售量大增，于是高层决定打铁成热推出几款新的产品——木头鸭子(WoodDuck), 塑料鸭子(PlasticDuck)，这两款鸭子都不能飞行，将和橡皮鸭子执行同样的飞行方法。



问题出现了：难道这时我必须重写这3个不会飞的鸭子类中的Fly()方法？？？这三只鸭子的飞行方法也都是一样的，却仍然要写三次？天哪，这样太不优美了吧！！！光是想起来就让人觉得丑陋啊！

 

## 解决方案：

不再将飞行行为Fly()看作是Duck的方法，而是将整个飞行作为Duck的属性。光看文字太抽象了，别急，慢慢来，这句话用代码表示大概就是这样：

 

```

class Duck

{

    FlyBehavior flyBehavior;//属性FlyBehavoir是飞行行为的接口,子类可以在各自的构造函数或者其他地方指定对应的飞行行为

    public void Fly()

    {

        flyBehavior.Fly();//属性的具体表现方式

    }

}

```



这样就将FlyBehavior和Duck组合在了一起。

于是全新的鸭子系列闪亮出炉了！

 

 ```

    //飞行行为：

    interface IFlyBehavoir

    {

        void Fly();

    }

    class Flyable : IFlyBehavoir//能飞的

    {

        void IFlyBehavoir.Fly()

        {

            Console.WriteLine("I'm flying");

        }

    }

    class UnFlyable:IFlyBehavoir//不能飞的

    {

        void IFlyBehavoir.Fly()

        {

            Console.WriteLine("WOW!I can't fly!");

        }

    }



    //鸭子系类

    class Duck//超类

    {

        protected IFlyBehavoir flyBehavoir;

        public void Fly()

        {

            flyBehavoir.Fly();

        }

    }//class Duck



    class ElegantDuck : Duck

    {

        public ElegantDuck()

        {

            //绑定具体的飞行行为

            this.flyBehavoir = new Flyable();//其实这里我一直搞不懂到底是该用base还是this...

        }

    }

    class DukeDuck : Duck

    {

        public DukeDuck()

        {

            this.flyBehavoir = new Flyable();

        }

    }

    class KingDuck : Duck

    {

        public KingDuck()

        {

            this.flyBehavoir = new Flyable();

        }

    }



    class RubberDuck : Duck

    {

        public RubberDuck()

        {

            this.flyBehavoir = new UnFlyable();

        }

    }



    class WoodDuck : Duck

    {

        public WoodDuck()

        {

            this.flyBehavoir = new UnFlyable();

        }

    }



    class PlasticDuck : Duck

    {

        public PlasticDuck()

        {

            this.flyBehavoir = new UnFlyable();

        }

    }

```

    

虽然多了不少的代码，但是减少了重复的代码，使得代码更容易被修改。

整体类图如下：

 

![](\img\2012-07-20-dp-strategy-01.jpg) 

 

鸭子的行为不是继承来的，而是和适当的行为对象**“组合”**而来的。



## 总结：

策略模式的书本定义：定义了算法族，让它们之间可以相互替换，此模式让算法的变化独立于使用算法的客户。

 

我对这句话的理解是：此模式可以针对不同客户对功能的需求不同，从策略集中取出相应的执行方法，因此得名“策略模式”。

看图说话如下：



![](\img\2012-07-20-dp-strategy-02.jpg) 

