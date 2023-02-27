function [cicDecimationFactor_DL,FilterNumerator_DL,UpsampleRate]=FilteringParameterMaker(Fs_Master,Fs_Secondary)


%% |H(f)|=|sin(pi*F*R*M)/sin(pi*F)|^N ==> the first zero ==> F = 1/RM ==> but for compensation ==> F = 1/4RM ==> W_B/2 = F_S/(8*R); 

cicDecimationFactor_DL = (Fs_Master/Fs_Secondary)/5; 


cicDifferentialDelay = 2;
cicNumSections = 6;



cicdec = dsp.CICDecimator(cicDecimationFactor_DL,cicDifferentialDelay,cicNumSections); 
cicdec.FixedPointDataType = 'Full precision'; 




cicCompensatorStopbandFrequency = (Fs_Secondary/2);
cicCompensatorInputSampleRate = Fs_Master/cicDecimationFactor_DL;
cicCompensatorPassbandFrequency = cicCompensatorStopbandFrequency - 0.1*cicCompensatorStopbandFrequency;

CICCompDecim = dsp.CICCompensationDecimator(cicdec,'PassbandFrequency',cicCompensatorPassbandFrequency,...
                                                   'SampleRate',cicCompensatorInputSampleRate,...
                                                   'StopbandFrequency',cicCompensatorStopbandFrequency);
FC = CICCompDecim.coeffs;
FilterNumerator_DL = FC.Numerator;

UpsampleRate = Fs_Master/cicDecimationFactor_DL/Fs_Secondary;
end