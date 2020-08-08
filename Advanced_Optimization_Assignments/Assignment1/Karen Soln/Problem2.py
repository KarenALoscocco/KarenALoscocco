#Karen Loscocco
#ISYE 4133 Assignment 1

#Problem 2

from gurobipy import *

def printOptimal(m):
    if m.Status == GRB.OPTIMAL:
        print('Variable Values:')
        for v in m.getVars():
            print(v.VarName, v.X)

        print('\nObjective Value: {}\n'.format(str(m.objVal)))


print('\n\nPROBLEM #2')

################################################################################

print('\n====================================================')
print('2a - Original Linear Program')
print('====================================================')

m = Model()

X = m.addVars([1,2], name = 'X')

m.addConstr(X[1] + X[2] >= 10)
m.addConstr(2*X[1] + 5*X[2] <= 40)

m.setObjective(X[1] + 2*X[2], GRB.MINIMIZE)

print('\n')
m.optimize()
print("\n")

printOptimal(m)

print('\n====================================================')
print('2a - Standardized Linear Program')
print('====================================================')

m = Model()

X = m.addVars([1,2], name = 'X')
S = m.addVars([1,2], name = 'S')

m.addConstr(X[1] + X[2] - S[1] == 10)
m.addConstr(2*X[1] + 5*X[2] + S[2] == 40)

m.setObjective(X[1] + 2*X[2], GRB.MINIMIZE)

print('\n')
m.optimize()
print("\n")

printOptimal(m)


################################################################################

print('\n====================================================')
print('2b - Original Linear Program')
print('====================================================')

m = Model()

X = m.addVars([1,2], name = 'X', lb = -1*GRB.INFINITY)

m.addConstr(X[1] + X[2] <= 4)
m.addConstr(2*X[1] + 5*X[2] == 30)
m.addConstr(X[1] <= 0)

m.setObjective(X[1] - X[2], GRB.MAXIMIZE)

print('\n')
m.optimize()
print("\n")

printOptimal(m)

print('\n====================================================')
print('2b - Standardized Linear Program')
print('====================================================')

m = Model()

X = m.addVars([1,2], name = 'X')
S = m.addVar(name = 'S')

m.addConstr(-X[1] + X[2] + S == 4)
m.addConstr(-2*X[1] + 5*X[2] == 30)

m.setObjective(X[2] + X[1], GRB.MINIMIZE)

print('\n')
m.optimize()
print("\n")

printOptimal(m)
