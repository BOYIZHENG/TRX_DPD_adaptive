function out=fir_my(in,coeff)
% a simple fir filter
    out             = zeros(1,length(in));
    tap             = length(coeff);
    out(1:tap)      = in(1:tap);
    for i=tap+1:length(in)
        out(i)  = in(i-tap+1:i)*coeff';
    end

end