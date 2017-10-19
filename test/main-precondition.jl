using JLD
using Plots
using StatsBase
using Match
include("../src/StochOpt.jl")
## Basic parameters
maxiter=10^8;
max_time = 350;
max_epocs = 6;
printiters = true;
exacterror =true; repeat = false;
tol = 10.0^(-6.0);
skip_error_calculation =0.0;   precondition = false;# number of iterations where error is not calculated (to save time!)
options = MyOptions(tol,Inf,maxiter,skip_error_calculation,max_time,max_epocs,printiters,exacterror,0,"normalized",0.0,precondition,false)
options.batchsize =10;
## load problem
datapath = ""# "/local/rgower/libsvmdata/"
probname = "rcv1_train";# gisette_scale     madelon
 # a9a  phishing  covtype mushrooms  rcv1_train  liver-disorders_scale
prob =  load_logistic(probname,datapath,options);  # Loads logisitc
# SAG problems: protei, quantum, rcv1, sido, alpha
## Running methods
OUTPUTS = [];
method_name = "SVRG";
output= minimizeFunc_grid_stepsize(prob, method_name, options,repeat);
OUTPUTS = [OUTPUTS ; output];
# #
method_name = "SVRG2D";
output3= minimizeFunc_grid_stepsize(prob, method_name, options,repeat);
OUTPUTS = [OUTPUTS ; output3];
#
method_name = "SVRG2sec";
output3= minimizeFunc_grid_stepsize(prob, method_name, options,repeat);
OUTPUTS = [OUTPUTS ; output3];
# # #
options.precondition = true; # turn on preconditioning
method_name = "SVRG2D";
output3= minimizeFunc_grid_stepsize(prob, method_name, options,repeat);
OUTPUTS = [OUTPUTS ; output3];
#
method_name = "SVRG2sec";
output3= minimizeFunc_grid_stepsize(prob, method_name, options,repeat);
OUTPUTS = [OUTPUTS ; output3];

# method_name = "embed";
# output3= minimizeFunc_grid_stepsize(prob, method_name, options,repeat);
# OUTPUTS = [OUTPUTS ; output3];
#
default_path = "./data/";   savename= replace(prob.name, r"[\/]", "-");
save("$(default_path)$(savename).jld", "OUTPUTS",OUTPUTS);
 #PyPlot PGFPlots Plotly GR
pgfplots()# gr() pyplot() # pgfplots() #plotly()
prob.name = string(prob.name,"-precon")
plot_outputs_Plots(OUTPUTS,prob,20)