# 分类

- `convert.ipynb`用来将特征选择之后数据转化为weka可以导入的`.csv`文件；

- `data`存放分别在三种特征集（L、NL、L+NL）上，使用特征选择方法（none、CFS+GSW、InfoGain、Relief）得出的12种数据集；

- `classify_info`存放在weka软件上分别对12种数据集进行正则化，然后使用三种分类器（NB、LR、KNN）进行训练和评估的信息，包含分类的准确率；

- `visualization.ipynb`用来将分类准确率进行可视化，方便比较。


使用特征选择方法：
- none（不进行特征选择）
- CFS+GSW
- InfoGain
- Relief

得出的12种数据集；

- `feature_extraction`目录进行特征提取操作；

- `feature_select`目录进行特征选择操作；

- `classify`进行分类操作。

分别在：
- 线性特征集（L）
- 非线性特征集（NL）
- 组合特征集（L+NL, all）

使用特征选择方法：
- none（不进行特征选择）
- CFS+GSW
- InfoGain
- Relief

得出的12种数据集上，使用以下分类器：
- NB（朴素贝叶斯）
- LR（Logistic回归）
- KNN

共得出36种结果，进行准确率的比较（单位：%）。

linear|None|CFS+GSW|InfoGain|Relief
:--:|:--:|:--:|:--:|:--:
NB|59.0227|51.1853|48.089|51.4756
LR|82.3416|63.5704|60.0387|60.2806
KNN|**92.598**|68.5535|72.7625|68.2632


nonlinear|None|CFS+GSW|InfoGain|Relief
:--:|:--:|:--:|:--:|:--:
NB|61.0063|60.0387|61.1998|52.3464
LR|74.0203|64.5864|60.9579|56.4586
KNN|88.4857|71.6981|60.4741|55.7813

all|None|CFS+GSW|InfoGain|Relief
:--:|:--:|:--:|:--:|:--:
NB|62.119|54.5235|49.0082|53.6043
LR|<font color='red'>Timeout</font>|69.7146|66.8602|62.1674
KNN|91.582|76.0039|68.8437|65.7475

可以看出，**在线性特征集上，不进行特征选择，使用KNN分类器**进行分类效果最好，准确率达到了**92.598%**。