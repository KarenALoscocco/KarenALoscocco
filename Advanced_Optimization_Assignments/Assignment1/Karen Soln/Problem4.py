#Karen Loscocco
#ISYE 4133 Assignment 1

#Problem 4

from gurobipy import *
import numpy as np
import time

start = time.time()

print('\n\nPROBLEM #4\n')

mlist = [10,20,50,100,500,1000,10000]
nlist = [10,20,50,100,1000,10000]

run_time = {}
avg_val = {}

for m in mlist:
    for n in nlist:

        A = np.random.uniform(low=0.0, high=1.0, size=(m,n))
        b = np.random.uniform(low=0.0, high=1000.0, size=(m,))
        c = np.random.uniform(low=0.0, high=1000.0, size=(n,))
        X = np.arange(n)

        model = Model()

        X = model.addVars(n, name = 'X')#, vtype = GRB.INTEGER)

        model.setObjective(np.dot(c,X.values()), GRB.MINIMIZE)

        for i in range(A.shape[0]):
            model.addConstr(np.dot(A[i,:],X.values()) >= b[i])

        obv = []
        rt = []

        model.update()

        for i in range(10):
            model = model.copy()

            model.setParam('OutputFlag', 0)
            model.setParam('TimeLimit', 120)

            model.optimize()

            obv.append(model.objVal)
            rt.append(model.Runtime)


        avg_val[str(A.shape)] = obv
        run_time[str(A.shape)] = rt

        print('M: {}\nN: {}\nAverage Objective Value: {}\nAverage Run Time: {}\n\n'.format(A.shape[0], A.shape[1], np.mean(obv), np.mean(rt)))

f = open("AVG_VAL_OUTPUT_not_integer.txt","w")
f.write( str(avg_val) )
f.close()

f = open("RUN_TIME_OUTPUT_not_integer.txt","w")
f.write( str(run_time) )
f.close()

model.write('MODEL_not_integer.LP')

print('Finished after ' + str(time.time() - start) + ' sec')

