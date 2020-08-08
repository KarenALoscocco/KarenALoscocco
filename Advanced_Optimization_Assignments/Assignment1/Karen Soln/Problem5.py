#Karen Loscocco
#ISYE 4133 Assignment 1

#Problem 5

from gurobipy import *

def printOptimal(m):
    if m.Status == GRB.OPTIMAL:
        print('Variable Values:')
        for v in m.getVars():
            print(v.VarName, v.X)

        print('\nObjective Value: {}\n'.format(str(m.objVal)))

print('\n\nPROBLEM #5\n')
################################################################################

m = Model()

X = m.addVars([1,2], name = 'X') #, vtype = GRB.INTEGER)

m.setObjective(30*X[1] + 45*X[2], GRB.MAXIMIZE)

m.addConstr(1.2*X[1] + 1.4*X[2] <= 800)
m.addConstr(72*X[1] + 120*X[2] <= 60000)

print('\n')
m.optimize()
print("\n")

printOptimal(m)
