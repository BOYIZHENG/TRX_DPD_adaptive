function out = interpNRZ(in,uprate)

out1=zeros(1,uprate*length(in));
for i=1:uprate
    out1(i:uprate:end)=in;
end
%out=out1(1:length(in));
out=out1;
end

