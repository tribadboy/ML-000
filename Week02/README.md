学习笔记



> 作业内容：
>
> 用 `cython` 实现 target_encoding 代码，并比较执行时间    (详细执行结果可参见 test.ipynb）

| 方法           | 执行时间 | 方法简要说明                                |
| -------------- | -------- | ------------------------------------------- |
| target_mean_v1 | 15.8 s   | 原版代码                                    |
| target_mean_v2 | 241 ms   | python for 循环实现                         |
| target_mean_v3 | 145 ms   | python for 循环，提取重复变量               |
| target_mean_v4 | 977 µs   | cython 实现，使用 unordered_map             |
| target_mean_v5 | 441 µs   | cython 分配内存，c实现，传入二维 matrix     |
| target_mean_v6 | 42 µs    | cython 分配内存，c实现，直接传入列 x 和列 y |

