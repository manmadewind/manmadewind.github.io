title: Hadoop中的常用命令

tags: [haActionop, cmd, dict, 大数据]

date: 2015-04-28



---



总结了一些我平时常用的Hadoop命令





主参数	|次参数	|作用	|例子--------|-------|-------|-----fs	|-get	|复制文件到本地路径下	|hadoop fs -get /user/hadoop/file localfilefs	|-put	|像目标目录推送文件	|hadoop fs -put localfile /user/hadoop/hadoopfilefs	|-cp	|复制，参数-f,-p	|hadoop fs -cp /user/hadoop/file1 /user/hadoop/file2fs	|-mv	|移动，秒级完成	|hadoop fs -mv /user/hadoop/file1 /user/hadoop/file2fs	|-count	|得到文件/目录等数目追加参数-q, -h有不同的意义	|hadoop fs -count -q hdfs://nn1.example.com/file1fs	|-du	|得到指定文件的大小	|hadoop fs -du /test/hadoopfs	|-ls	|显示文件	|hadoop fs -ls /user/hadoop/file1fs	|-lsr	|ls -R	|hadoop fs ls -Rfs	|-rm	|删除文件	|hadoop fs -rm hdfs://nn.example.com/file /user/hadoop/emptydirfs	|-rmr	|删除文件夹（linux: rm -r）	| hadoop fs -rmr /usr/db/filedir/fs	|-tail	|输出文件的最后1千字节	|hadoop fs -tail pathnamefs	|-test	|检查文件	|hadoop fs -test -e filenamefs	|-touchz	|创建空文件	|hadoop fs -touchz pathnamefs	|-appendToFile	|将一个或者多个本地文件追加到目的文件	|hadoop fs -appendToFile localfile /user/hadoop/hadoopfilefs	|-mkdir	|创建目录，-p创建多层目录	|hadoop fs -mkdir /user/hadoop/dir1 /user/hadoop/dir2fs	|-mv	|移动文件	|hadoop fs -mv /user/hadoop/file1 /user/hadoop/file2job	|-set-priority	|设置作业优先级	|hadoop job -set-priority jobid-0000-0000 VERY_HIGHjob	|-kill	|杀掉作业	|hadoop job -kill jobid-0000-0000

