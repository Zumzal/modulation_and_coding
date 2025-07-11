function [r_corrected,est_time_error] = gardner(r,K,OSF)
    
    % NB : the downsampling is done at the same time
    
    y_eps = zeros(1,length(r)/OSF);
    est_time_error = zeros(1,length(r)/OSF);
    y_eps(1)=r(1);
    
    for n = 1:floor((length(r)-2)/OSF)     % 
        x_vector=((n-1)*OSF+1:OSF*n+2);
        symbols = r(x_vector);
        n_err = n*OSF+1-est_time_error(n);
        n_mid_err = n*OSF+1-OSF/2 -est_time_error(n);
        y_eps(n+1) = interp1(x_vector,symbols,n_err,'linear');  % => y[n]
        y_mid = interp1(x_vector,symbols,n_mid_err,'linear');   % => y[n-1/2]
        
        est_time_error(n+1)=est_time_error(n)+2*K*real(y_mid*(conj(y_eps(n+1))-conj(y_eps(n))));
        
    end
    est_time_error=est_time_error/OSF;
    r_corrected = y_eps;
end
