% Ëýé-Ìýññè xor
rounds = 13;
src = '0xC5C3043BC3D40C08';
x1 = hexToBinaryVector(src,64);
s = cell(8,1);
s{1} = '0x7C3F2AE6085B4D91';s{2} = '0xE4C597FABD613820';
s{3} = '0x3AF0514896BDEC72';s{4} = '0x87C2B51F0A463ED9';
s{5} = '0xD950B278AE4F3C61';s{6} = '0xCE47AD0B3126F985';
s{7} = '0x8A0EB79312FD5C64';s{8} = '0xDB28C56307F9E41A';
pt = [31 15 32 14 7 8 1 26 3 24 11 2 20 30 23 13 27 10 29 4 18 5 25 28 17 6 12 9 22 21 16 19];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  ROUND KEYs GENERATION   %  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
textKey = '0x974D76E1F4F733A0';
binaryKey = hexToBinaryVector(textKey,64);
keySet = cell(rounds,1);
%keySet{1} = binaryKey;
%tmp = binaryVectorToHex(keySet{1});
for i = 1:rounds

    if( mod(i,4) == mod(0,4) || mod(i,4) == mod(1,4)) 
        keySet{i} = binaryKey(1:32); 
    else 
        keySet{i} = binaryKey(33:64); 
    end
   
%keySet{i} = hexToBinaryVector(dec2hex(mod(7+sym(hex2dec(binaryVectorToHex(keySet{i-1})))^2,2^32)),32);
end

% for i=1:rounds
%    binaryVectorToHex(keySet{i}) 
% end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%        ENCRYPTION        %  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
left = x1(1:32);
right = x1(33:64);
for i = 1:rounds
    
    xorLeftRight = xor(left, right);
    
    tmp = num2str( binaryVectorToHex(xor(xorLeftRight, keySet{i})));
    for j=1:length(tmp)
        tmp(j) = s{j}(hex2dec(tmp(j))+1+2);
    end
    tmp = hexToBinaryVector(tmp,32);
    % P - substitution
    temp = tmp;
    for j=1:length(tmp)
        tmp(j) = temp(pt(j));
    end
    
    tmpR = right;
    right = xor(tmpR,tmp);
    
    tmpL = left;
    left = xor(tmpL,tmp);
   
end

encrypted(1:32) = left;
encrypted(33:64) = right;
binaryVectorToHex(encrypted)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%        DECRYPTION        %  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% left1 = encrypted(1:32);
% right1 = encrypted(33:64);
 left1 = x1(1:32);
 right1 = x1(33:64);
for i = 1:rounds
    
    xorLeftRight1 = xor(left1, right1);
    
    tmp = num2str( binaryVectorToHex(xor(xorLeftRight1, keySet{rounds-i+1})));
    for j=1:length(tmp)
        tmp(j) = s{j}(hex2dec(tmp(j))+1+2);
    end
    tmp = hexToBinaryVector(tmp,32);
    % P - substitution
    temp = tmp;
    for j=1:length(tmp)
        tmp(j) = temp(pt(j));
    end
    
    tmpR = right1;
    right1 = xor(tmpR,tmp);
    
    tmpL = left1;
    left1 = xor(tmpL,tmp);  
   
end
decrypted(1:32) = left1;
decrypted(33:64) = right1;
binaryVectorToHex(decrypted)
