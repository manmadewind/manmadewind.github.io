date: 2012-07-22 12:44:09+00:00
title: '[C#]问题及解决方案汇总'
tags: [C#, 解决方案]

---

该笔记最没技术含量，但是却非常实用。



## 1.未能找到类型或命名空间名称

有些时候，你明明已经添加了某个引用到你的项目中，敲代码的时候也能弹地出来，但就是过不了编，仔细一看会发现一个小警告，警告大意如下：


> 未能解析引用的程序集“... , Version= ... , Culture=... ... ”，因为它对不在当前目标框架“.NETFramework,Version=v4.0,Profile=Client”中的“System.Design, Version=4.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a”具有依赖关系。请删除对不在目标框架中的程序集的引用，或考虑重新确定项目的目标。


****.**解决方法：**

工程属性 -> 应用程序 ->目标框架，把.NetFramework 4.0 Client Profile修改为NetFramework 4.0 即可
<!--more-->


## 2.在分析完成前就遇到流结尾


> 在分析完成前就遇到流结尾


碰到这种问题可能有几种情况——

(1)较为常见的未及时把流的指针归零，解决方法是在需要时归零流指针即可。

    
    MemoryStream ms = new MemoryStream();
    byte[] bitTemp= ... ...;
    ms.Write(bitTemp, 0, bitTemp.Length);
    ms.Position = 0;// ！归零一次流的位置 ！
    BinaryFormatter b = new BinaryFormatter();
    ObjectTry objectTry  = (ObjectTry)b.Deserialize(ms);


(2)而我今天碰到的这种错误更加低级，其实是在序列化文件(Serialize)时已经出现了错误，而我当时没能注意到，所以反序列化时自然会出现问题。在**序列化出现错误时仍然可能会生成序列化文件**，这点容易使人误以为序列化成功了。所以，要解决这个问题要从序列化上进行排查。而我今天的情况是，忘了给需要序列化的类型加上[Serializable]标签了。



## 3.设置ComboBox为只读（即不能被用户任意修改其值

只要将combobox的属性DropDownStyle的值选为DropDownList便可


## 4.DateTime.Now.ToString()取时间码

	System.DateTime.Now.ToString("yy**MM**ddhhmmss");//表示月的**MM**一定要大写,不然会出问题


## 5.StreamReader 中文乱码

	StreamReader reader = new StreamReader(fStream,Encoding.Default);

打开oracle连接报错
System.Data.OracleClient 需要 Oracle 客户端软件 8.1.7 或更高版本
