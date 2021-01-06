#pragma once
#include <vector>
#include <cmath>
#include <iostream>


template<typename T, bool col_major=false>
class MatrixView{
public:
    T* data_pointer;
    const long nrow;
    const long ncol;

    MatrixView(T *data_pointer, const long nrow, const long ncol) : data_pointer(data_pointer), nrow(nrow),
                                                                    ncol(ncol) {}

    T &operator()(const int row, const int col) {
        if (col_major) {
            return data_pointer[row + col * nrow];
        } else {
            return data_pointer[col + row * ncol];
        }
    }

    T operator()(const int row, const int col) const {
        if (col_major) {
            return data_pointer[row + col * nrow];
        } else {
            return data_pointer[col + row * ncol];

        }
    }
};


void get_mean_target(long *data, const long nrow, const long ncol, double *result) {

    long* value_dict = new long[nrow]();
    long* count_dict = new long[nrow]();
    const MatrixView<long, false> data_view(data, nrow, ncol);

    for (auto i = 0; i < nrow; i++) {
        long y_value = data_view(i, 0);
        long x_value = data_view(i, 1);
        value_dict[x_value] += y_value;
        count_dict[x_value] += 1;
    }
    for (auto i = 0; i < nrow; i++) {
        long y_value = data_view(i, 0);
        long x_value = data_view(i, 1);
        if (count_dict[x_value] == 1) {
            result[i] = 0.0;
        } else {
            result[i] = (value_dict[x_value] - y_value) * 1.0 / (count_dict[x_value] - 1);
        }
    }
    delete[] value_dict;
    delete[] count_dict;
}

void get_mean_target_v2(const long nrow, long *xcol, long *ycol, double *result) {

    long* value_dict = new long[nrow]();
    long* count_dict = new long[nrow]();

    for (auto i = 0; i < nrow; i++) {
        long y_value = ycol[i];
        long x_value = xcol[i];
        value_dict[x_value] += y_value;
        count_dict[x_value] += 1;
    }
    for (auto i = 0; i < nrow; i++) {
        long y_value = ycol[i];
        long x_value = xcol[i];
        if (count_dict[x_value] == 1) {
            result[i] = 0.0;
        } else {
            result[i] = (value_dict[x_value] - y_value) * 1.0 / (count_dict[x_value] - 1);
        }
    }
    delete[] value_dict;
    delete[] count_dict;
}
