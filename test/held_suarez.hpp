#pragma once

#include <string>
#include <vector>

namespace held_suarez {

constexpr double efoldf = 1.0;  // efolding time for wind dissipation
constexpr double efolda = 40.0; // efolding time for T dissipation
constexpr double efolds = 4.0;  // efolding time for T dissipation
constexpr double sigmab = 0.7;  // threshold sigma level
constexpr double t00 = 200.0;   // minimum reference temperature
constexpr double kf =
    1.0 / (86400.0 * efoldf); // 1./efolding_time for wind dissipation

constexpr double onemsig = 1.0 - sigmab; // 1. - sigma_reference

constexpr double ka =
    1.0 / (86400.0 * efolda); // 1./efolding_time for temperature diss.
constexpr double ks =
    1.0 / (86400.0 * efolds); // 1./efolding_time for temperature diss.

double pref = 0.0; // Surface pressure, reset in init call

void held_suarez_1994_init(double pref_in, std::string &errmsg, int &errflg);

void held_suarez_1994_run(int pver, int ncol, const std::vector<double>& pref_mid_norm, 
                          const std::vector<double>& clat, const std::vector<std::vector<double>>& cappa, 
                          const std::vector<std::vector<double>>& cpair, const std::vector<std::vector<double>>& pmid, 
                          const std::vector<std::vector<double>>& uwnd, const std::vector<std::vector<double>>& vwnd, 
                          const std::vector<std::vector<double>>& temp, std::vector<std::vector<double>>& du, 
                          std::vector<std::vector<double>>& dv, std::vector<std::vector<double>>& ds, 
                          std::string& scheme_name, std::string& errmsg, int& errflg);

} // namespace held_suarez