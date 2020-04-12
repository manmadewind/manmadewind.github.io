date: 2012-08-06 04:53:09+00:00
title: '[设计模式]简单工厂模式(Simply Factory Pattern)'
tags: [设计模式,读书笔记]

---

简单工厂模式Simply Factory Pattern
_《HeadFirst设计模式》读书笔记_

我们时常能在初学者写的大几百行甚至几千行的程序代码中看到如下片段的身影：

    
        class AnimalShow
        {
            //根据不同的动物名称显示对应的动物
            public void DisplayAnimal(String animalName)
            {
                Animal animal;
    
                if(animalName == "dog")
                {
                    animal = new Dog();
                }
                if (animalName == "cat")
                {
                    animal = new Cat();
                }
    
                animal.Display();
            }
        }

<!--more-->

类实例化的代码和string类型硬编码，紧紧地绑在了一起。看上去显得特别业余。
高级一点专业一点的就会用上枚举类型，如下：

    
    class AnimalShow
        {
            enum animalType { dog, cat};
    
            public void DisplayAnimal(animalType type)
            {
                Animal animal;
    
                switch(type)
                {
                    case animalType.dog
                        animal = new Dog();
                        break;
    
                    case userType.cat:
                        animal = new Cat();
                        break;
                }
    
                animal.Display();
            }
        }


这种代码的可读性可可维护性就要比第一种高出许多，而且也不易错。但是，在实际的项目中，这样的代码也许仍然会有一些缺点。

我们都知道，在实际的开发中，唯一不变的就是变化！

特别是第一段程序中的if{}部分，还有第二段程序中的switch{}部分，都是三天两头就有可能被要求修改的，今天增加一个新的类型Bird,明天可能就要求你把Dog给删掉。而在实际的项目中，像这样的主体类中可能会有成百上千行代码，这些if/switch到时只会被淹没在茫茫的代码海中，每次修改都要在茫茫码海中找到它们，并且再作出修改，这种事情做多了久而久之很消人士气。

还有一点需要值得强调的是 —— 这样的代码一点都不适合复用，如果一个项目中有多个地方都需要根据具体的类型生成实例，那么每次都要重新将这段代码copy一次，而每次需求变更时都要挨个修改过去，哎哟哟，想想都让人觉得头疼。

解决这类问题的方法就是使用**简单工厂模式(Simply Factory Pattern)**，它可以使使类和类之间解耦。它将容易改变的实例化类的部分提取出来，构建成一个生产实例的工厂 —— 即用户丢入需求，工厂则依照用户的需求返回相应的实例。
运用简单工厂修改后的代码如下：

(1)工厂类：

    
        //Animal工厂，专门负责生产各种动物
        class AnimalFactory
        {
            //根据不同的用户需求返回相应的实例。（今后若出现animal方面的变更，只要修改此处即可）
            public static Animal ProduceAnimal(animalType type)
            {
                Animal animal;
    
                switch(type)
                {
                    case animalType.dog
                        animal = new Dog();
                        break;
    
                    case userType.cat:
                        animal = new Cat();
                        break;
                }
    
                animal.Display();
            }
        }


(2)主题类：

    
        class AnimalShow
        {
            public void DisplayAnimal(animalType type)
            {
                Animal animal = AnimalFactory.ProduceAnimal(type);//只要在这里告诉工厂你需要的东西，工厂便会制造出来送给你。
                animal.Display();
            }
        }


也许有人要说了，我原来好端端地一个类，你楞要拆成两个，这不是增加了代码维护的难度么？
表面上看起来好像是这样，其实不然，这多出的一个类使得原先的主体类变得更加的清晰整洁，增加了代码的可读性，而且将所有容易改变的部分都提取出来之后，使得今后对代码的维护只要对这几个类进行就好了，代码少、逻辑清晰，实在是方便修改。如此一来就保证了主题类的整洁，而肮脏的东西都放到了工厂类中，今后碰到需求变更，只要简单的修改工厂类中相应的方法即可，而完全不必牵涉到主题类。

而且更重要的是，这样一来，这样的代码变得可以重用，一劳永逸。

这其实还涉及到设计模式的另外一个重要思想——“依赖倒置”

