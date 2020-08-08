#Karen Loscocco
#ISYE 4133 Assignment 1

#Problem 4 Graphs

import numpy as np
import matplotlib.pyplot as plt
import ast

def process_data(d):
    for k, v in d.items():
        d[k] = str(np.round(np.mean(d[k]),3))

    new_dict = {value: key for key, value in d.items()}

    for k, v in new_dict.items():
        new_dict[k] = np.sum(ast.literal_eval(new_dict[k]))

    new_dict2 = {value: key for key, value in new_dict.items()}

    for k, v in new_dict2.items():
        new_dict2[k] = float(new_dict2[k])

    return new_dict2

def get_x_y(data):

    lists = sorted(data.items()) # sorted by key, return a list of tuples
    x, y = zip(*lists) # unpack a list of pairs into two tuples

    return x,y


def plot(X,Y,xlab,ylab,savefig):
    plt.scatter(X,Y)

    plt.xlabel(xlab,fontsize = 14)
    plt.ylabel(ylab, fontsize = 14)

    plt.savefig('{}.jpeg'.format(savefig))
    plt.close()


avg_obj_integer = process_data(ast.literal_eval(open('AVG_VAL_integer.txt', 'r').read()))
run_time_integer = process_data(ast.literal_eval(open('RUN_TIME_integer.txt', 'r').read()))

avg_obj = process_data(ast.literal_eval(open('AVG_VAL_OUTPUT_not_integer.txt', 'r').read()))
run_time = process_data(ast.literal_eval(open('RUN_TIME_OUTPUT_not_integer.txt', 'r').read()))


#RUN_TIME
x_rt_integer, y_rt_integer = get_x_y(run_time_integer)
x_rt, y_rt = get_x_y(run_time)

plot(x_rt_integer,y_rt_integer,'M+N','Run Time','run_time_integer')
plot(x_rt,y_rt,'M+N','Run Time','run_time')


#OBJECTIVE VALUE
x_obj_integer, y_obj_integer = get_x_y(avg_obj_integer)
x_obj, y_obj = get_x_y(avg_obj)

plot(x_obj_integer,y_obj_integer,'M+N','Average Objective Value','avg_obj_integer')
plot(x_obj,y_obj,'M+N','Average Objective Value','avg_obj')
