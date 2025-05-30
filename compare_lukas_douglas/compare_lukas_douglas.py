from pyrecfast import recfast_fudgetest as recfast1pt5
import numpy as np
import os

DIR = "./data_recfast_1pt4_comparison"
TMPIN = os.path.join(DIR, "tmp_recfast.in")
TMPOUT = os.path.join(DIR, "tmp_recfast.out")
RECFASTBIN = "./recfast_tm"

def setup():
    if not os.path.exists(DIR):
        os.system(f"mkdir {DIR}")

    if not os.path.exists(f"{RECFASTBIN}"):
        assert(os.path.exists("./recfast_tm.f90"))
        os.system(f"gfortran -o {RECFASTBIN} recfast_tm.f90")


def takedown():
    os.system(f"rm -r {DIR}")

def recfast1pt4(Omega_B, Omega_DM, Omega_vac, H_0, T_0, Y_p, He_switch=6):
    with open(TMPIN, "x") as f:
        f.write(f"{TMPOUT}\n")
        f.write(f"{Omega_B} {Omega_DM} {Omega_vac}\n")
        f.write(f"{H_0} {T_0} {Y_p}\n")
        f.write(f"{He_switch}")
    os.system(f"{RECFASTBIN} < {TMPIN}")
    os.remove(TMPIN)

    array = np.genfromtxt(TMPOUT)
    z = array[1:,0]
    x_e = array[1:,1]
    os.remove(TMPOUT)
    return z, x_e

Omega_B, Omega_DM, Omega_vac = 0.04, 0.20, 0.76
H_0, T_0, Y_p = 70, 2.725, 0.25

lukas_H = [0,1]
lukas_He = range(0,7)

# no H option in 1.4 version recfast (Douglas' version)
douglas_He = range(0,7)


### lukas
Z = [0]
desc = 'z'
X_E = []

for h in lukas_H:
    for he in lukas_He:
        Z[0], x_e = recfast1pt5(Omega_B, Omega_DM, Omega_vac, H_0, T_0, Y_p, H_switch=h, He_switch=he)
        X_E.append(x_e)
        desc += '    h'+str(h)+'he'+str(he)

A = np.stack(Z + X_E, axis=1)
print('###################')
print(A.shape)
print('###################')
np.savetxt('recfast1.5_lukas.out', A, header=desc)


### douglas
setup()
Z = [0]
desc = 'z'
X_E = []

for he in douglas_He:
    Z[0], x_e = recfast1pt4(Omega_B, Omega_DM, Omega_vac, H_0, T_0, Y_p, He_switch=he)
    X_E.append(x_e)
    desc += '    he'+str(he)

A = np.stack(Z + X_E, axis=1)
np.savetxt('recfast1.4_douglas.out', A, header=desc)

takedown()