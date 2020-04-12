title: 'Python的熊猫们(pandas)'
tags: [python, pandas]
date: 2016-03-10

---
```
import pandas as pd
```

<!--more-->

## 大文件只读取部分(Get subset from BigFile)

```
import pandas as pd

(start, end) = (0, 100) # 跳过数据的第0行-第100行
need_rows = 55 # 需要获取共55条数据

df = pd.read_csv(filename, header=0, skiprows=range(start+1,end+1), nrows=need_rows) # Big File    
```