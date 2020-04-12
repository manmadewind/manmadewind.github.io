---
date: 2012-07-22 12:38:58+00:00
title: '[C#]有关WebBrowser'
tags: [C#, WebBrowser, 解决方案]

---


## WebBrowser窗口自动滚动

this.webBrowser.Document.Window.ScrollTo(0, webBrowser1.Document.Body.ScrollRectangle.Height);

<!--more-->

## WebBrowser的脚本出错信息

当页面上的脚本出错时，一般情况下会弹出脚本出错提示，如果在用WB写爬虫一类的时候，这类提示可能会导致系统不能工作，解决的发是：

(1)设置属性ScriptErrorsSurpressed = true;

(2)打开IE的设置 "Internet选项" - "高级" - 勾选"禁用脚本调试"

## WebBrowser的内存释放

WB的内存开销很大，当连续打开很多网页时这个问题将会非常明显，甚至耗尽内存，解决的方我在MSDN论坛上找到(来源：[http://social.msdn.microsoft.com/Forums/en-US/ieextensiondevelopment/thread/88c21427-e765-46e8-833d-6021ef79e0c8/](http://social.msdn.microsoft.com/Forums/en-US/ieextensiondevelopment/thread/88c21427-e765-46e8-833d-6021ef79e0c8/))，具体内容如下：

> 
> This solution worked for me!!
Thank you so much mike_t2e!!!!!!!-----------------------------------------------------------------------Is the memory released when you minimize the app ? If so, try this:-- in class definition[DllImport("KERNEL32.DLL", EntryPoint = "SetProcessWorkingSetSize", SetLastError = true, CallingConvention = CallingConvention.StdCall)]
internal static extern bool SetProcessWorkingSetSize(IntPtr pProcess, int dwMinimumWorkingSetSize, int dwMaximumWorkingSetSize);[DllImport("KERNEL32.DLL", EntryPoint = "GetCurrentProcess", SetLastError = true, CallingConvention = CallingConvention.StdCall)]
internal static extern IntPtr GetCurrentProcess();

> -- code to call when you want to reduce the memory

> IntPtr pHandle = GetCurrentProcess();
> SetProcessWorkingSetSize(pHandle, -1, -1);


