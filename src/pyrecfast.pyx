import numpy as np
from numpy cimport ndarray

cdef extern:
    void recfast_c(double *Omega_b,
                   double *Omega_c,
                   double *Omega_L,
                   double *H0,
                   double *T_CMB,
                   double *Yp,
                   int *H_switch,
                   int *He_switch,
                   int *cubicswitch,
                   double *z_initial,
                   double *z_final,
                   double *tol,
                   int *Nz,
                   double *z_array,
                   double *x_array,
                   int *flag_array)

def recfast(double Omega_b,
            double Omega_c,
            double Omega_L,
            double H0,
            double T_CMB,
            double Yp,
            int H_switch=1,
            int He_switch=6,
            int cubicswitch=0,
            double z_initial=10000,
            double z_final=0,
            double tol=1e-5,
            int Nz=1000):
    """
    Recfast: Integrator for Cosmic Recombination of Hydrogen and Helium.

    Calculate ionised fraction as a function of redshift. Solves for H and He
    simultaneously, and includes H "fudge factor" for low z effect, as well as
    HeI fudge factor.


    Parameters
    ----------
        Omega_b: float
            Baryon density parameter.

        Omega_c: float
            Cold dark matter density parameter.

        Omega_L: float
            Dark energy density parameter.

        H0: float
            Hubble parameter in km/s/Mpc.

        T_CMB: float
            Present-day CMB temperature in K.

        Yp: float
            Present-day Helium fraction.

        H_switch: int
            Integer switch for modifying the H recombination.
                (0) no change from old Recfast, fudge factor `fu=1.14`
                (1) include correction,         fudge factor `fu=1.125`
            default: 1

        He_switch: int
            Integer switch for modifying the HeI recombination.
                (0) use Peebles coeff. for He
                    (no change from old Recfast)
                (1) for Heswitch > (0) use Sobolev escape probability for singlet 1P-1S transition
                (2) include Heswitch (1) and use fitting formula for continuum opacity of H on HeI
                    (based on fitting formula by Kholupenko, Ivanchik & Varshalovich, 2007)
                (3) include Heswitch (1) and include triplet effects
                (4) include Heswitch (1) and (3) and include H continuum effects
                (5) include Heswitch (1) to (3)
                (6) include Heswitch (1) to (4)
            default: 6
        
        cubicswitch: int
            Integer switch for toggling cubic initial condition.
                (0) no
                (1) yes for 3500 < z < 5000 only
                (2) yes for z < 5000 and y(2) > 0.99
            default: 0

        z_initial: float
            Initial redshift value.
            default: 10000

        z_final: float
            Final redshift value.
            default: 0 (today)

        tol: float
            Tolerance for numerical integrator.
            default: 1e-5

        Nz: int
            Number or redshift bins between `zinitial` and `zfinal`.
            Determines the size of the returned arrays.
            default: 1000


    Returns
    -------
        z_array: np.ndarray
            Array of redshift values `z`.
            Same shape as `x_array`.

        x_array: np.ndarray
            Array of ionisation fraction `x_e(z)`.
            Same shape as `z_array`.
        
        flag_array: np.ndarray
            Array of flags for each z in recfast
            Same shape as `z_array`
    """
    cdef:
        ndarray[double, mode="c"] z_array = np.empty(Nz, dtype=np.double)
        ndarray[double, mode="c"] x_array = np.empty(Nz, dtype=np.double)
        ndarray[int, mode="c"] flag_array = np.empty(Nz, dtype=np.int32)
    recfast_c(&Omega_b,
              &Omega_c,
              &Omega_L,
              &H0,
              &T_CMB,
              &Yp,
              &H_switch,
              &He_switch,
              &cubicswitch,
              &z_initial,
              &z_final,
              &tol,
              &Nz,
              &z_array[0],
              &x_array[0],
              &flag_array[0])
    return z_array, x_array, flag_array
