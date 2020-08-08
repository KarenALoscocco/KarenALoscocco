#Karen Loscocco
#ISYE 4133 Assignment 1

#Problem 3

from gurobipy import *

def printOptimal(m):
    if m.Status == GRB.OPTIMAL:
        print('Variable Values:')
        for v in m.getVars():
            print(v.VarName, v.X)

        print('\nObjective Value: {}\n'.format(str(m.objVal)))

print('\n\nPROBLEM #3\n')

m = Model()

X = m.addVars(7, name = 'X')

m.setObjective(X[0] + X[1] + X[2] + X[3] + X[4] + X[5] + X[6] , GRB.MINIMIZE)

m.addConstr(X[1] - X[0] >= 3)
m.addConstr(X[2] - X[1] >= 2)
m.addConstr(X[3] - X[1] >= 2)
m.addConstr(X[4] - X[2] >= 3)
m.addConstr(X[5] - X[2] >= 4)
m.addConstr(X[6] - X[4] >= 1)
m.addConstr(X[6] - X[5] >= 1)

print('\n')
m.optimize()
print("\n")

printOptimal(m)



