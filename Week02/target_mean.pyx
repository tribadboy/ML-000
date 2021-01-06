# distutils: language=c++
import numpy as np
cimport numpy as np
import cython
cimport cython
from libcpp.unordered_map cimport unordered_map

cdef extern from "target_mean.h":
    void get_mean_target(long*, const long, const long, double*)
    void get_mean_target_v2(const long, long*, long*, double*)

def target_mean_v1(data, y_name, x_name):
    result = np.zeros(data.shape[0])
    for i in range(data.shape[0]):
        groupby_result = data[data.index != i].groupby([x_name], as_index=False).agg(['mean', 'count'])
        result[i] = groupby_result.loc[groupby_result.index == data.loc[i, x_name], (y_name, 'mean')]
    return result

def target_mean_v2(data, y_name, x_name):
    result = np.zeros(data.shape[0])
    value_dict = dict()
    count_dict = dict()
    for i in range(data.shape[0]):
        if data.loc[i, x_name] not in value_dict.keys():
            value_dict[data.loc[i, x_name]] = data.loc[i, y_name]
            count_dict[data.loc[i, x_name]] = 1
        else:
            value_dict[data.loc[i, x_name]] += data.loc[i, y_name]
            count_dict[data.loc[i, x_name]] += 1
    for i in range(data.shape[0]):
        result[i] = (value_dict[data.loc[i, x_name]] - data.loc[i, y_name]) / (count_dict[data.loc[i, x_name]] - 1)
    return result

def target_mean_v3(data, y_name, x_name):
    result = np.zeros(data.shape[0])
    value_dict = dict()
    count_dict = dict()
    for i in range(data.shape[0]):
        x_value, y_value = str(data.loc[i, x_name]), data.loc[i, y_name]
        if not value_dict.__contains__(x_value):
            value_dict[x_value] = y_value
            count_dict[x_value] = 1
        else:
            value_dict[x_value] += y_value
            count_dict[x_value] += 1
    for i in range(data.shape[0]):
        x_value, y_value = str(data.loc[i, x_name]), data.loc[i, y_name]
        if count_dict[x_value] == 1:
            result[i] == np.nan
        else:
            result[i] = (value_dict[x_value] - y_value) / (count_dict[x_value] - 1)
    return result

@cython.boundscheck(False)
@cython.wraparound(False)
cpdef double[:] _target_mean_v4(int length, long[:] col_y, long[:] col_x):
    cdef double[:] result = np.zeros(length)
    cdef unordered_map[long, long] value_dict
    cdef unordered_map[long, long] count_dict
    for i in range(length):
        x_value, y_value = col_x[i], col_y[i]
        if not value_dict.count(x_value):
            value_dict[x_value] = y_value
            count_dict[x_value] = 1
        else:
            value_dict[x_value] += y_value
            count_dict[x_value] += 1
    for i in range(length):
        x_value, y_value = col_x[i], col_y[i]
        if count_dict[x_value] == 1:
            result[i] = 0.0
        else:
            result[i] = (value_dict[x_value] - y_value) / (count_dict[x_value] - 1)
    return result

def target_mean_v4(data, y, x):
    return _target_mean_v4(data.shape[0], data[y].values, data[x].values)


def target_mean_v5(data, y, x):
    matrix = data[[y, x]].values
    result_ = np.zeros(matrix.shape[0], dtype=np.double)
    cdef np.ndarray[double, ndim=1, mode="c"] result = np.ascontiguousarray(result_, dtype=np.double)
    cdef np.ndarray[long, ndim=2, mode='c'] arg = np.ascontiguousarray(matrix, dtype=np.long)
    get_mean_target(&arg[0, 0], matrix.shape[0], matrix.shape[1], &result[0])
    return result

def target_mean_v6(data, y, x):
    cdef np.ndarray[double, ndim=1, mode='c'] result = np.ascontiguousarray(np.zeros(data.shape[0], dtype=np.double), dtype=np.double)
    cdef np.ndarray[long, ndim=1, mode='c'] xcol = np.ascontiguousarray(data[x].values, dtype=np.long)
    cdef np.ndarray[long, ndim=1, mode='c'] ycol = np.ascontiguousarray(data[y].values, dtype=np.long)
    get_mean_target_v2(data.shape[0], &xcol[0], &ycol[0], &result[0])
    return result