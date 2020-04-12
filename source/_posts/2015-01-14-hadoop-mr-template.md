title: 我的Hadoop MapReduce模板

tags: [haActionop,dict,大数据]

date: 2015-01-14



---



行走江湖，有一套自己顺手的模板是很重要的，可以在很多时候提高开发效率，减少重复劳动力。



<!--more-->



```

import java.io.IOException;

import java.text.ParseException;

import java.text.SimpleDateFormat;

import java.util.ArrayList;

import java.util.Date;

import java.util.HashMap;

import java.util.List;



import org.apache.hadoop.conf.Configuration;

import org.apache.hadoop.fs.FileSystem;

import org.apache.hadoop.fs.Path;

import org.apache.hadoop.io.IntWritable;

import org.apache.hadoop.io.LongWritable;

import org.apache.hadoop.io.NullWritable;

import org.apache.hadoop.io.Text;

import org.apache.hadoop.mapreduce.Job;

import org.apache.hadoop.mapreduce.Mapper;

import org.apache.hadoop.mapreduce.Reducer;

import org.apache.hadoop.mapreduce.lib.input.FileInputFormat;

import org.apache.hadoop.mapreduce.lib.output.FileOutputFormat;

import org.apache.hadoop.util.GenericOptionsParser;



/**

 * @author Marvin

 * # 调用方法

 * hadoop jar

 * ## 必填参数 

 * (1) Jar_Filename.jar 

 * (2) Class_Name(include main() function)

 * ## 自带参数 可选

 * (3) -Djobgroup=test -Dmapred.job.priority=VERY_HIGH

 * ## 用户参数 

 * (4) 来源文件(夹) [!支持通配符] 

 * (5) 目标文件夹

 */



public class Template_Hadoop

{

	// Map START

    public static class Map

    		extends Mapper // Output Type

    {

    	/**

    	 * 在任务开始时调用一次

    	 */

    	@Override

    	public void setup(Context context) throws IOException, InterruptedException 

    	{

    		try 

    		{

    			Configuration conf = context.getConfiguration();

    			String user_conf = conf.get("user_conf", ""); // get conf value from main()

    		} 

    		catch (Exception e) 

    		{ System.err.println("Error in setup, " + e.getMessage()); }

    	} // setup()



        public void map(LongWritable key, Text value,

                        Context context)

                        throws IOException, InterruptedException

    	{

            context.write(new Text("Mapper's output Key"),

                          new LongWritable(0));



        } // map()



    	/**

    	 * 任务运行结束调用函数

    	 */

        @Override

    	public void cleanup(Context context) 

    				throws IOException, InterruptedException 

    	{ }

    } // class Map



    // Reduce START

    public static class Reduce

            extends Reducer  // Reducer's Output

    {    	

    	@Override

    	public void setup(Context context) throws IOException, InterruptedException 

    	{ } // setup()



        public void reduce(Text key,						           // key

                           Iterable values_raw_iterable, // value

                           Context context)

        				   throws IOException, InterruptedException

        {

        	Long sum = 0l;

            for(LongWritable long_w: values_raw_iterable)

            {

            	Long value = long_w.get();

            	sum += value;

            }

            // Ouptut

            context.write(new IntWritable(0), new Text("Reducer's Output"));            

        }



    	/**

    	 * 任务运行结束调用函数

    	 */

        @Override

    	public void cleanup(Context context) 

    				throws IOException, InterruptedException 

    	{ } // cleanup()



    } // class Reduce



    // main START

    public static void main(String[] args) throws Exception

    {

		Configuration conf = new Configuration();        



        // 取得-D*** 之后的 用户自定义参数

		String[] otherArgs = new GenericOptionsParser(conf, args).getRemainingArgs();

		String inputDir    = otherArgs[0];

		String outputDir   = otherArgs[1];



		// 设置configure配置变量

		conf.set("user_conf", "Hello_World!");



		// Set Job.

		Job job = new Job(conf);

		job.setJarByClass(Template_Hadoop.class);

		job.setMapperClass(Map.class);		

		job.setReducerClass(Reduce.class);



		// Map output

		job.setMapOutputKeyClass(Text.class);

		job.setMapOutputValueClass(LongWritable.class);



		// Reduce Output

		job.setOutputKeyClass(Text.class);

		job.setOutputValueClass(NullWritable.class);



		// Input/Output Path Setting

		FileInputFormat.setInputPaths(job,  new Path(inputDir)); // inputDir 支持通配符

		FileOutputFormat.setOutputPath(job, new Path(outputDir)); 

		//main_job.setOutputFormatClass(MidMultipleTextOutputFormat.class);



		// 输入输出确认

		FileSystem fs = FileSystem.get(conf);		

		// 判断输入是否存在，不存在则退出

		// [Warnning!] 在路径使用通配符的情况下，这中检测方法不适用

		/*

		if (!fs.exists(new Path(inputDir))) 

		{

			System.err.println("Input dir doesn't exist.");

			return;

		} 

		*/



		// 判断输出目录是否存在，存在则删除

		if (fs.exists(new Path(outputDir))) 

		{ fs.delete(new Path(outputDir), true); }



		// MapReduce Start

		System.exit(job.waitForCompletion(true) ? 0 : 1);

    }

}

```



运行时，命令如下



```

hadoop jar \

     Template_hadoop.jar \              # MR jar包

     Template_hadoop \			           # Main Class

     -Dmapred.job.priority=VERY_HIGH \  # 优先级

     /usr/input/*.txt \                 # 自定义参数1-输入文件夹

     /usr/output/                       # 自定义参数2-输出文件夹

```



BTW,

版本信息：

Hadoop 1.2.1

Java 1.6

