#include <held_suarez.hpp>

extern "C" {
    void held_suarez_1994_init_wrapper(double* pref_in, char* errmsg, int* errflg, int errmsg_len) {
        std::string errmsg_str(errmsg, errmsg_len);
        held_suarez::held_suarez_1994_init(*pref_in, errmsg_str, *errflg);
        std::copy(errmsg_str.begin(), errmsg_str.end(), errmsg);
    }
    void held_suarez_1994_run_wrapper(int* pver, int* ncol, double* pref_mid_norm, 
                                      double* clat, double* cappa, double* cpair, 
                                      double* pmid, double* uwnd, double* vwnd, 
                                      double* temp, double* du, double* dv, 
                                      double* ds, char* scheme_name, char* errmsg, 
                                      int* errflg, int scheme_name_len, int errmsg_len) {
        std::vector<double> pref_mid_norm_vec(pref_mid_norm, pref_mid_norm + *pver);
        std::vector<double> clat_vec(clat, clat + *ncol);
        std::vector<std::vector<double>> cappa_vec(*ncol, std::vector<double>(*pver));
        std::vector<std::vector<double>> cpair_vec(*ncol, std::vector<double>(*pver));
        std::vector<std::vector<double>> pmid_vec(*ncol, std::vector<double>(*pver));
        std::vector<std::vector<double>> uwnd_vec(*ncol, std::vector<double>(*pver));
        std::vector<std::vector<double>> vwnd_vec(*ncol, std::vector<double>(*pver));
        std::vector<std::vector<double>> temp_vec(*ncol, std::vector<double>(*pver));
        std::vector<std::vector<double>> du_vec(*ncol, std::vector<double>(*pver));
        std::vector<std::vector<double>> dv_vec(*ncol, std::vector<double>(*pver));
        std::vector<std::vector<double>> ds_vec(*ncol, std::vector<double>(*pver));

        for (int i = 0; i < *ncol; ++i) {
            for (int k = 0; k < *pver; ++k) {
                cappa_vec[i][k] = cappa[i * (*pver) + k];
                cpair_vec[i][k] = cpair[i * (*pver) + k];
                pmid_vec[i][k] = pmid[i * (*pver) + k];
                uwnd_vec[i][k] = uwnd[i * (*pver) + k];
                vwnd_vec[i][k] = vwnd[i * (*pver) + k];
                temp_vec[i][k] = temp[i * (*pver) + k];
                du_vec[i][k] = du[i * (*pver) + k];
                dv_vec[i][k] = dv[i * (*pver) + k];
                ds_vec[i][k] = ds[i * (*pver) + k];
            }
        }

        std::string scheme_name_str(scheme_name, scheme_name_len);
        std::string errmsg_str(errmsg, errmsg_len);

        held_suarez::held_suarez_1994_run(*pver, *ncol, pref_mid_norm_vec, clat_vec, cappa_vec, cpair_vec, pmid_vec, 
                                          uwnd_vec, vwnd_vec, temp_vec, du_vec, dv_vec, ds_vec, scheme_name_str, errmsg_str, *errflg);

        std::copy(scheme_name_str.begin(), scheme_name_str.end(), scheme_name);
        std::copy(errmsg_str.begin(), errmsg_str.end(), errmsg);
    }
}

