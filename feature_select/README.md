# 特征选择

- `linear`存放可以导入weka的线性数据的`.csv`文件，以及线性数据在weka上进行三种特征选择的信息；

- `nonlinear`存放可以导入weka的非线性数据的`.csv`文件，以及非线性数据在weka上进行三种特征选择的信息。

## 将特征提取后的线性和非线性数据转化为weka可以导入的`.csv`文件

```python
# 导入库
import scipy.io
import numpy as np
import pandas as pd

# 载入提取线性特征的数据
linear_data_path = 'C:/Users/lijia/Desktop/BigProject/feature_extraction/linear/finalFeatures.mat'
mat_data = scipy.io.loadmat(linear_data_path)
linear_data = mat_data['finalFeatures']

# 载入提取非线性特征的数据
nonlinear_data_path = 'C:/Users/lijia/Desktop/BigProject/feature_extraction/nonlinear/finalFeatures.mat'
mat_data = scipy.io.loadmat(nonlinear_data_path)
nonlinear_data = mat_data['finalFeatures']

# 删除不需要的特征，即第一列
linear_data = linear_data[:, 1:]
nonlinear_data = nonlinear_data[:, 1:]

# 标签信息，前24*39个样本标签为'MDD'，后29*39个样本标签为 'HC'
labels = np.vstack((np.full((24*39, 1), 'MDD'), np.full((29*39, 1), 'HC')))

# 查看数据信息
print(f'linear_data     样本个数: {linear_data.shape[0]}, 特征维度: {linear_data.shape[1]}')
print(f'nonlinear_data  样本个数: {nonlinear_data.shape[0]}, 特征维度: {nonlinear_data.shape[1]}')

# 查看标签信息
flat_labels = labels.flatten()
unique_labels, counts = np.unique(flat_labels, return_counts=True)
for label, count in zip(unique_labels, counts):
    print(f"{label}: {count}")

# 将标签添加到数据的最后一列
linear_data_with_labels = np.hstack((linear_data, labels))
nonlinear_data_with_labels = np.hstack((nonlinear_data, labels))

# 创建属性名
linear_columns = [f'A{i}' for i in range(128)] + ['label']
nonlinear_columns = [f'A{i}' for i in range(96)] + ['label']

# 将 NumPy 数组转换为 Pandas DataFrame
linear_df = pd.DataFrame(linear_data_with_labels, columns=linear_columns)
nonlinear_df = pd.DataFrame(nonlinear_data_with_labels, columns=nonlinear_columns)

# 导出为 CSV 文件
linear_csv_path = 'C:/Users/lijia/Desktop/BigProject/feature_select/nlinear/linear_data.csv'
nonlinear_csv_path = 'C:/Users/lijia/Desktop/BigProject/feature_select/nonlinear/linear_data.csv'
linear_df.to_csv(linear_csv_path, index=False, header=True)
nonlinear_df.to_csv(nonlinear_csv_path, index=False, header=True)

print(f'导出成功：{linear_csv_path}')
print(f'导出成功：{nonlinear_csv_path}')
```

## 在weka软件上分别对线性和非线性数据进行三种特征选择算法

选择出的特征如下，具体信息保存在`linear`和`nonlinear`文件夹下。

**线性数据**：

- CFS+GSW: 5,35,37,45,47,49,61,69,89,90,95,109,121

- InfoGain: 69,37,90,92,91,96,89,45

- Relief: 69,109,45,77,92,89,5,85


**非线性数据**：

- CFS+GSW: 1,6,15,18,25,27,28,36,47,49,53,54,62,65,71,73,76,77,79,84,88,95

- InfoGain: 53,27,25,71,77,28,79,49,65

- Relief: 53,59,71,35,83,65,47,89,77