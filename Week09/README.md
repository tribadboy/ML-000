学习笔记

> 作业内容：
>
> 找到至少 1 个能够提升模型效果的衍生变量（以 lightgbm 为基础模型）

<br>

调参方式： 统一采用 K-fold 的 hyperopt 调参， 使用”分类错误率“衡量结果

| 测试 | 调整方式                              | 训练集  | 测试集  |
| ---- | ------------------------------------- | ------- | ------- |
| 1    | 使用原始数据，无任何衍生变量          | 0.07920 | 0.08176 |
| 2    | 构造衍生变量（kfold target encoding） | 0.07884 | 0.08166 |
| 3    | 保持衍生变量，调参减少过拟合          | 0.07916 | 0.08148 |

<br>
<br>



第一次测试： （使用原始数据，无任何衍生变量)

    参数：
    `{'bagging_fraction': 0.9379122665132016,
     'boosting': 'goss',
     'device_type': 'cpu',
     'drop_rate': 0.0003757191912043406,
     'extra_trees': True,
     'feature_fraction': 0.7837989424839368,
     'lambda_l1': 2.4791237795383174,
     'lambda_l2': 5.423097004780251,
     'learning_rate': 0.027638820456068754,
     'metric': 'binary',
     'min_data_in_bin': 20,
     'min_gain_to_split': 0.9418873172596369,
     'num_leaves': 64,
     'num_round': 2000,
     'num_thread': 6,
     'objective': 'binary',
     'uniform_drop': False}`
    训练数据结果： Kfold 错误率：[0.0719, 0.0814, 0.0829, 0.0822, 0.0776]  错误率均值：0.07920
    测试集效果：  0.08176

第二次测试：  构造衍生变量（kfold target encoding）

     `{'bagging_fraction': 0.8820761355932795,
     'boosting': 'gbdt',
     'device_type': 'cpu',
     'drop_rate': 0.15221361387442056,
     'extra_trees': True,
     'feature_fraction': 0.7966085155023439,
     'lambda_l1': 9.05999616675501,
     'lambda_l2': 2.514529861096307,
     'learning_rate': 0.09924903847628047,
     'metric': 'binary',
     'min_data_in_bin': 5,
     'min_gain_to_split': 0.06684328574175302,
     'num_leaves': 8,
     'num_round': 2000,
     'num_thread': 6,
     'objective': 'binary',
     'uniform_drop': False}`
    训练数据结果： Kfold 错误率：[0.0706, 0.0803, 0.0827, 0.0828, 0.0778]   错误率均值：0.07884
    测试集效果：  0.08166


第三次测试：  保持衍生变量，调参减少过拟合

     `{'bagging_fraction': 0.8470798531544796,
     'boosting': 'goss',
     'device_type': 'cpu',
     'drop_rate': 0.04362493523196063,
     'extra_trees': True,
     'feature_fraction': 0.8416459394914348,
     'lambda_l1': 5.246746455101715,
     'lambda_l2': 5.4885609875994685,
     'learning_rate': 0.0361569056025585,
     'metric': 'binary',
     'min_data_in_bin': 30,
     'min_gain_to_split': 0.265040733262803,
     'num_leaves': 24,
     'num_round': 2000,
     'num_thread': 6,
     'objective': 'binary',
     'uniform_drop': True}`
    训练数据结果： Kfold 错误率：[0.0709, 0.0791, 0.0829, 0.084, 0.0789]  错误率均值：0.07916
    测试集效果：  0.08148


