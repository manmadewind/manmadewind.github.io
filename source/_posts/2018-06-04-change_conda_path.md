 

title: '修改anaconda/conda的路径'
tags: 
date: 2018-06-04

---

假设旧路径为`/home/OLD/anaconda3/`，新路径为`/home/NEW/anaconda3/`

1. 移动anaconda文件到新的路径下

   `mv /home/OLD/anaconda3 /home/NEW/anaconda3`

2. 修改Anaconda的环境变量

   (1) 打开`.bashrc` (`vim ~/.bashrc`)

   (2) 修改新PATH为 `export PATH="/home/NEW/anaconda3/bin:$PATH"`

3. 修改conda的路径
  (1) 打开conda配置文件`vim /home/NEW/anaconda3/bin/conda`

  (2) 修改文件头的python路径
  ```python
  从原有的
  #!/home/OLD/anaconda3/bin/python 
  修改为
  #!/home/NEW/anaconda3/bin/python

  ```

4. 更新一下conda配置

   如果不更新，conda命令虽然可以运行，但是会找不到.condarc文件，还是会有问题，更新方式为：`conda update conda`

   ​

