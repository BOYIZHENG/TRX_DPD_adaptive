function fin_new=coherent_in(fin,fc,fs,samplen)
frf=fin+fc;
f_bin=floor(frf*samplen/fs);
while (isprime(f_bin)==0 && f_bin~=1)
    f_bin=f_bin+1;
end
frf_new=(f_bin)*fs/samplen;
fin_new=frf_new-fc;

end