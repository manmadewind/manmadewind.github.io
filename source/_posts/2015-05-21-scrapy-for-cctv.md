title: Python爬虫抓取新闻联播内容

tags: [Python, scrapy, Action, 爬虫]

date: 2015-05-21 



---

近日澎湃新闻刊登了一则新闻，内容是有招商证券分析团队通过分析新闻联播的关键字判断股市涨跌，在整个5月中准确率高到爆棚，于是我就先写了一个爬虫打算有空时用到，现在先把代码送给你们吧——一个用Python Scrapy写的一个新闻联播文字版的爬虫：）



<!--more-->





```

#!/usr/bin/env python

#-*- coding:utf-8 -*-

__author__ = 'marvin'



import re

from twisted.internet import reactor

from scrapy.crawler import Crawler

from scrapy.settings import Settings

from scrapy import log, signals

from scrapy.contrib.spiders import CrawlSpider, Rule

from scrapy.contrib.linkextractors import LinkExtractor



class MySpider(CrawlSpider):

    # property

    name            = 'CCTV'

    allowed_domains = ['cntv.cn']

    start_urls      = 'http://news.cntv.cn/2015/05/16/VIDE1431774720266542.shtml'

    rules = (

        Rule(LinkExtractor(restrict_xpaths='//ul[re:test(@class, "title?")]'), callback='parse_item'),

    )



    @classmethod

    def parse_item(self, response):

    '''处理具体的内容页面'''

        try:

            title       = response.xpath('//title/text()').extract()[0].split('_')[0]

            content_raw = response.xpath('//div[@id="content_body"]/p/text()').extract()

            date        = re.compile('(?<=news.cntv.cn/)\d{4}/\d{2}/\d{2}').findall(response.url)[0]



            content = ''

            for row in content_raw:

                content += row.strip() + '\n'



            log.msg('parsed %s,%s,%s' % (title, date, content))



            if (title == '' or content == '' or date == ''):

                return



        except Exception as e:

            log.msg(str(e))

            print '\tMessage:%s' % str(e)

            return

        return



    @classmethod

    def stoppp(self):

    '''爬虫运行结束后的回调'''

        log.msg('committing...')

        self.conn.commit()

        log.msg('commited')

# END OF CLASS





def main():

    spider = MySpider(CrawlSpider)

    crawler = Crawler(Settings())



	# 绑定spider_closed的回调函数

    crawler.signals.connect(spider.stoppp, signal=signals.spider_closed)   



    # 绑定engine_stopped的回调函数，否则reactor.run()会一直阻塞

    crawler.signals.connect(reactor.stop, signal=signals.engine_stopped) 



    crawler.configure()

    crawler.crawl(spider)

    crawler.start()

    log.start()

    reactor.run() # Spider 正式开始工作

    log.msg('--Finished!--')





if __name__ == '__main__':

    main()

```

