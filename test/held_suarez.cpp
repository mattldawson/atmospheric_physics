#include <held_suarez.hpp>
#include <algorithm>
#include <cmath>

namespace held_suarez {

void held_suarez_1994_init(double pref_in, std::string &errmsg, int &errflg) {
    // Initialize output arguments
    errmsg = " ";
    errflg = 0;

    // Set the global variable
    pref = pref_in;
}

void held_suarez_1994_run(int pver, int ncol, const std::vector<double>& pref_mid_norm, 
                          const std::vector<double>& clat, const std::vector<std::vector<double>>& cappa, 
                          const std::vector<std::vector<double>>& cpair, const std::vector<std::vector<double>>& pmid, 
                          const std::vector<std::vector<double>>& uwnd, const std::vector<std::vector<double>>& vwnd, 
                          const std::vector<std::vector<double>>& temp, std::vector<std::vector<double>>& du, 
                          std::vector<std::vector<double>>& dv, std::vector<std::vector<double>>& ds, 
                          std::string& scheme_name, std::string& errmsg, int& errflg) {

    // Initialize output arguments
    errmsg = " ";
    errflg = 0;
    scheme_name = "HELD_SUAREZ";

    // Local workspace
    std::vector<double> coslat(ncol);
    std::vector<double> sinsq(ncol);
    std::vector<double> cossq(ncol);
    std::vector<double> cossqsq(ncol);

    // Compute trigonometric values
    for (int i = 0; i < ncol; ++i) {
        coslat[i] = std::cos(clat[i]);
        sinsq[i] = std::sin(clat[i]) * std::sin(clat[i]);
        cossq[i] = coslat[i] * coslat[i];
        cossqsq[i] = cossq[i] * cossq[i];
    }

    // Compute idealized radiative heating rates (as dry static energy)
    for (int k = 0; k < pver; ++k) {
        if (pref_mid_norm[k] > sigmab) {
            for (int i = 0; i < ncol; ++i) {
                double kt = ka + (ks - ka) * cossqsq[i] * (pref_mid_norm[k] - sigmab) / onemsig;
                double trefc = 315.0 - (60.0 * sinsq[i]);
                double trefa = (trefc - 10.0 * cossq[i] * std::log(pmid[i][k] / pref)) * std::pow(pmid[i][k] / pref, cappa[i][k]);
                trefa = std::max(t00, trefa);
                ds[i][k] = (trefa - temp[i][k]) * kt * cpair[i][k];
            }
        } else {
            for (int i = 0; i < ncol; ++i) {
                double trefc = 315.0 - 60.0 * sinsq[i];
                double trefa = (trefc - 10.0 * cossq[i] * std::log(pmid[i][k] / pref)) * std::pow(pmid[i][k] / pref, cappa[i][k]);
                trefa = std::max(t00, trefa);
                ds[i][k] = (trefa - temp[i][k]) * ka * cpair[i][k];
            }
        }
    }

    // Add diffusion near the surface for the wind fields
    for (int i = 0; i < ncol; ++i) {
        std::fill(du[i].begin(), du[i].end(), 0.0);
        std::fill(dv[i].begin(), dv[i].end(), 0.0);
    }

    for (int k = 0; k < pver; ++k) {
        if (pref_mid_norm[k] > sigmab) {
            double kv = kf * (pref_mid_norm[k] - sigmab) / onemsig;
            for (int i = 0; i < ncol; ++i) {
                du[i][k] = -kv * uwnd[i][k];
                dv[i][k] = -kv * vwnd[i][k];
            }
        }
    }
}

}