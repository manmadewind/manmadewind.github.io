title: 'python爬虫'
tags: [python, 爬虫]
date: 2016-04-17

---

众所周知，许多网站为了尽可能屏蔽爬虫，在页面上布置了许多的Ajax动态请求，使得最常使用的urlopen很难再抓取到对应的信息，而干我们这一行的很多时候又有很大的数据需求，手工搜集数据实在是在浪费生命，于是，一种需要一种能够对抗Ajax的爬虫。如果对性能要求不是很高的话可以通过一些工具模拟浏览器，这样就和正常人进行访问的结果没什么区别，待页面正常渲染之后再行抓取。

<!--more-->

如果你会写C#的话，C#中的WebBrowser控件就可以轻松实现这个功能。

Python的话需要借助于PhantomJS,selenium进行，再配合BeautifulSoup,应该足以应对日常情况了。

selenium可以使用`pip install selenium`直接安装;
PhantomJS的安装方法见官方网站，不同平台的安装方法不同。

这里附上一段demo代码

```
from bs4 import BeautifulSoup
from selenium import webdriver
from selenium import *

driver = webdriver.PhantomJS(executable_path='/usr/local/lib/node_modules/phantomjs/lib/phantom/bin/phantomjs')

def main():
    url = 'http://XXXXXX.com'
    driver.set_window_size(1200,800)
    driver.get(url)
    driver.save_screenshot('step1.png') # 保存当前页面截图
    driver.find_element_by_xpath(".//*[@id='comment_tab']//div[1]").click(); # 模拟鼠标点击某一个id下的第一个div进入具体页面
    print 'Now heading to detail page...'
    print driver.title

    soup = BeautifulSoup(driver.page_source) # 得到的页面用BeautifulSoup进行接下来的操作
    
    ...
    
    print 'Done'
```    
